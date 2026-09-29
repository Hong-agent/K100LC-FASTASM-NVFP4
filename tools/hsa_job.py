#!/usr/bin/env python3
"""Minimal no-DTK HSA runtime: dispatch a kernel from our own HSACO.

Generates a small C host program from the kernel's metadata, builds it against
the driver-side HSA runtime only, runs it, and returns the post-run buffers.
"""

from __future__ import annotations

import argparse
import json
import os
import struct
import subprocess
import sys
import tempfile
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
sys.path.insert(0, str(ROOT / "tools"))
from amdgpu_meta import read_metadata  # noqa: E402


# 内核参数表直接从本项目自己的 HSACO 元数据里读（自研汇编器产出的那一份），
# 因此这个 runner 不需要任何 DTK 产物。
ALL_HSACO = Path(os.environ.get("RT_HSACO", str(ROOT / "build/k100lc_all.hsaco")))
_META_CACHE: dict | None = None


def _metadata() -> dict:
    global _META_CACHE
    if _META_CACHE is None:
        _META_CACHE = read_metadata(ALL_HSACO.read_bytes())
    return _META_CACHE


DTYPES = {
    "u8": ("uint8_t", 1),
    "i8": ("int8_t", 1),
    "f32": ("float", 4),
    "i32": ("int32_t", 4),
    "u32": ("uint32_t", 4),
    "i64": ("int64_t", 8),
    "u64": ("uint64_t", 8),
    "u16": ("uint16_t", 2),
    "f16": ("uint16_t", 2),
}


def kernel_args(name: str) -> list[dict]:
    for kernel in _metadata().get("amdhsa.kernels", []):
        if kernel[".name"] == name:
            return kernel.get(".args", [])
    raise SystemExit(f"kernel {name} not found")


def encode_buffer(dtype: str, values: list) -> bytes:
    fmt = {"u8": "B", "i8": "b", "f32": "f", "i32": "i", "u32": "I",
           "i64": "q", "u64": "Q", "u16": "H", "f16": "e"}[dtype]
    return struct.pack("<" + fmt * len(values), *values)


def decode_buffer(dtype: str, blob: bytes) -> list:
    fmt = {"u8": "B", "i8": "b", "f32": "f", "i32": "i", "u32": "I",
           "i64": "q", "u64": "Q", "u16": "H", "f16": "e"}[dtype]
    n = len(blob) // struct.calcsize(fmt)
    return list(struct.unpack("<" + fmt * n, blob[:n * struct.calcsize(fmt)]))


def build_c(hsaco: Path, kernel: str, args: list, buffers: dict, grid: int, workgroup: int,
            grid_y: int = 1, extra_group: int = 0, grid_z: int = 1) -> str:
    meta_args = kernel_args(kernel)
    explicit_args = [
        a for a in meta_args
        if not str(a.get(".value_kind", "by_value")).startswith("hidden_")
    ]
    if len(explicit_args) != len(args):
        raise SystemExit(
            f"{kernel}: metadata has {len(explicit_args)} explicit args, job has {len(args)}"
        )

    decls, fills = [], []
    for spec, meta in zip(args, explicit_args):
        off = int(meta[".offset"])
        size = int(meta[".size"])
        kind = meta.get(".value_kind", "by_value")
        if "buffer" in spec:
            name = spec["buffer"]
            dtype, esize = DTYPES[buffers[name]["dtype"]]
            count = len(buffers[name]["values"])
            blob = encode_buffer(buffers[name]["dtype"], buffers[name]["values"])
            hexes = ",".join(f"0x{b:02x}" for b in blob)
            decls.append(f"static const unsigned char init_{name}[{len(blob)}] = {{{hexes}}};")
            fills.append(
                f"  void* {name} = alloc_pool(data_pool, gpu, {len(blob)});\n"
                f"  CHECK(hsa_memory_copy({name}, init_{name}, {len(blob)}));\n"
                f"  memcpy((char*)kernarg + {off}, &{name}, 8);"
            )
        elif spec.get("null"):
            fills.append(f"  {{ void* p = NULL; memcpy((char*)kernarg + {off}, &p, 8); }}")
        elif "scalar" in spec:
            dtype = spec["scalar"]["dtype"]
            ctype, _ = DTYPES[dtype]
            value = spec["scalar"]["value"]
            if dtype == "f32":
                fills.append(f"  {{ {ctype} v = {value!r}f; memcpy((char*)kernarg + {off}, &v, {size}); }}")
            else:
                fills.append(f"  {{ {ctype} v = {int(value)}; memcpy((char*)kernarg + {off}, &v, {size}); }}")
        else:
            raise SystemExit(f"unsupported arg {meta}")

    # Hidden HIP/OpenCL arguments are laid out per kernel; use their real
    # metadata offsets instead of a fixed guess (the explicit args may extend
    # past offset 24 for kernels with many parameters).
    nblocks = max(1, (grid + workgroup - 1) // workgroup)
    grid_dims = 3 if grid_z > 1 else (2 if grid_y > 1 else 1)
    hidden_values = {
        "hidden_block_count_x": ("uint32_t", nblocks),
        "hidden_block_count_y": ("uint32_t", max(1, grid_y)),
        "hidden_block_count_z": ("uint32_t", max(1, grid_z)),
        "hidden_group_size_x": ("uint16_t", workgroup),
        "hidden_group_size_y": ("uint16_t", 1),
        "hidden_group_size_z": ("uint16_t", 1),
        "hidden_remainder_x": ("uint16_t", 0),
        "hidden_remainder_y": ("uint16_t", 0),
        "hidden_remainder_z": ("uint16_t", 0),
        "hidden_global_offset_x": ("uint64_t", 0),
        "hidden_global_offset_y": ("uint64_t", 0),
        "hidden_global_offset_z": ("uint64_t", 0),
        "hidden_grid_dims": ("uint16_t", grid_dims),
    }
    for meta in meta_args:
        kind = str(meta.get(".value_kind", ""))
        if not kind.startswith("hidden_"):
            continue
        if kind not in hidden_values:
            continue
        ctype, value = hidden_values[kind]
        off = int(meta[".offset"])
        size = int(meta[".size"])
        fills.append(
            f"  {{ {ctype} v = {value}; memcpy((char*)kernarg + {off}, &v, {size}); }}"
        )

    outputs = []
    for name, buf in buffers.items():
        dtype = buf["dtype"]
        blob_len = len(encode_buffer(dtype, buf["values"]))
        outputs.append(
            f'  {{ unsigned char* h = (unsigned char*)malloc({blob_len});\n'
            f'    CHECK(hsa_memory_copy(h, {name}, {blob_len}));\n'
            f'    printf("BUF {name} ");\n'
            f'    for (size_t i = 0; i < {blob_len}; i++) printf("%02x", h[i]);\n'
            f'    printf("\\n"); free(h); }}'
        )

    return f"""// generated by tools/hsa_job.py
#include <hsa/hsa.h>
#include <hsa/hsa_ext_amd.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define CHECK(expr) do {{ hsa_status_t st_ = (expr); if (st_ != HSA_STATUS_SUCCESS) {{ \\
    const char* s_ = NULL; hsa_status_string(st_, &s_); \\
    fprintf(stderr, "%s:%d: %s -> %s\\n", __FILE__, __LINE__, #expr, s_ ? s_ : "?"); \\
    exit(1); }} }} while (0)

static hsa_agent_t gpu;
static hsa_amd_memory_pool_t data_pool, kernarg_pool;

static hsa_status_t find_gpu(hsa_agent_t agent, void* data) {{
    hsa_device_type_t type;
    CHECK(hsa_agent_get_info(agent, HSA_AGENT_INFO_DEVICE, &type));
    if (type == HSA_DEVICE_TYPE_GPU) {{ gpu = agent; return HSA_STATUS_INFO_BREAK; }}
    return HSA_STATUS_SUCCESS;
}}

static hsa_status_t find_pools(hsa_amd_memory_pool_t pool, void* data) {{
    hsa_amd_segment_t segment;
    CHECK(hsa_amd_memory_pool_get_info(pool, HSA_AMD_MEMORY_POOL_INFO_SEGMENT, &segment));
    if (segment != HSA_AMD_SEGMENT_GLOBAL) return HSA_STATUS_SUCCESS;
    uint32_t flags = 0; bool alloc_ok = false;
    CHECK(hsa_amd_memory_pool_get_info(pool, HSA_AMD_MEMORY_POOL_INFO_GLOBAL_FLAGS, &flags));
    CHECK(hsa_amd_memory_pool_get_info(pool, HSA_AMD_MEMORY_POOL_INFO_RUNTIME_ALLOC_ALLOWED, &alloc_ok));
    if (!alloc_ok) return HSA_STATUS_SUCCESS;
    static int have_kernarg = 0, have_data = 0;
    if (!have_kernarg && (flags & HSA_AMD_MEMORY_POOL_GLOBAL_FLAG_KERNARG_INIT)) {{
        kernarg_pool = pool; have_kernarg = 1;
    }}
    if (!have_kernarg && (flags & HSA_AMD_MEMORY_POOL_GLOBAL_FLAG_FINE_GRAINED)) {{
        kernarg_pool = pool; have_kernarg = 1;
    }}
    if (!have_data && (flags & HSA_AMD_MEMORY_POOL_GLOBAL_FLAG_COARSE_GRAINED)) {{
        data_pool = pool; have_data = 1;
    }}
    if (have_kernarg && have_data) return HSA_STATUS_INFO_BREAK;
    return HSA_STATUS_SUCCESS;
}}

static void* alloc_pool(hsa_amd_memory_pool_t pool, hsa_agent_t agent, size_t size) {{
    void* ptr = NULL;
    CHECK(hsa_amd_memory_pool_allocate(pool, size, 0, &ptr));
    CHECK(hsa_amd_agents_allow_access(1, &agent, NULL, ptr));
    return ptr;
}}

static hsa_status_t no_break(hsa_status_t st) {{
    return st == HSA_STATUS_INFO_BREAK ? HSA_STATUS_SUCCESS : st;
}}

static hsa_status_t get_symbol(hsa_executable_t executable, const char* base,
                               hsa_agent_t agent, hsa_executable_symbol_t* out) {{
    char name[512];
    hsa_status_t st = hsa_executable_get_symbol_by_name(executable, base, &agent, out);
    if (st == HSA_STATUS_SUCCESS) return st;
    snprintf(name, sizeof(name), "&%s", base);
    st = hsa_executable_get_symbol_by_name(executable, name, &agent, out);
    if (st == HSA_STATUS_SUCCESS) return st;
    snprintf(name, sizeof(name), "%s.kd", base);
    return hsa_executable_get_symbol_by_name(executable, name, &agent, out);
}}

{chr(10).join(decls)}

int main(void) {{
    CHECK(hsa_init());
    CHECK(no_break(hsa_iterate_agents(find_gpu, NULL)));
    CHECK(no_break(hsa_amd_agent_iterate_memory_pools(gpu, find_pools, NULL)));

    FILE* f = fopen("{hsaco}", "rb");
    if (!f) {{ perror("hsaco"); return 1; }}
    fseek(f, 0, SEEK_END); long sz = ftell(f); fseek(f, 0, SEEK_SET);
    void* image = malloc(sz); if (fread(image, 1, sz, f) != (size_t)sz) return 1; fclose(f);

    hsa_executable_t executable;
    CHECK(hsa_executable_create_alt(HSA_PROFILE_FULL, HSA_DEFAULT_FLOAT_ROUNDING_MODE_DEFAULT,
                                    NULL, &executable));
    hsa_code_object_reader_t reader;
    CHECK(hsa_code_object_reader_create_from_memory(image, sz, &reader));
    CHECK(hsa_executable_load_agent_code_object(executable, gpu, reader, NULL, NULL));
    CHECK(hsa_executable_freeze(executable, NULL));

    hsa_executable_symbol_t symbol;
    CHECK(get_symbol(executable, "{kernel}", gpu, &symbol));
    uint64_t kernel_object = 0; uint32_t kernarg_size = 0, group_size = 0, private_size = 0;
    CHECK(hsa_executable_symbol_get_info(symbol, HSA_EXECUTABLE_SYMBOL_INFO_KERNEL_OBJECT, &kernel_object));
    CHECK(hsa_executable_symbol_get_info(symbol, HSA_EXECUTABLE_SYMBOL_INFO_KERNEL_KERNARG_SEGMENT_SIZE, &kernarg_size));
    CHECK(hsa_executable_symbol_get_info(symbol, HSA_EXECUTABLE_SYMBOL_INFO_KERNEL_GROUP_SEGMENT_SIZE, &group_size));
    CHECK(hsa_executable_symbol_get_info(symbol, HSA_EXECUTABLE_SYMBOL_INFO_KERNEL_PRIVATE_SEGMENT_SIZE, &private_size));

    void* kernarg = alloc_pool(kernarg_pool, gpu, kernarg_size);
    void* zero = calloc(1, kernarg_size);
    CHECK(hsa_memory_copy(kernarg, zero, kernarg_size));
    free(zero);

{chr(10).join(fills)}

    hsa_signal_t completion;
    CHECK(hsa_signal_create(1, 0, NULL, &completion));
    uint32_t queue_size = 0;
    CHECK(hsa_agent_get_info(gpu, HSA_AGENT_INFO_QUEUE_MAX_SIZE, &queue_size));
    if (queue_size > 1024) queue_size = 1024;
    hsa_queue_t* queue = NULL;
    CHECK(hsa_queue_create(gpu, queue_size, HSA_QUEUE_TYPE_SINGLE, NULL, NULL,
                           UINT32_MAX, UINT32_MAX, &queue));
    uint64_t index = hsa_queue_load_write_index_relaxed(queue);
    hsa_kernel_dispatch_packet_t* packet =
        (hsa_kernel_dispatch_packet_t*)((char*)queue->base_address +
                                        (index % queue->size) * sizeof(*packet));
    memset(packet, 0, sizeof(*packet));
    packet->setup = {grid_dims};  /* low 2 bits = number of grid dimensions */
    packet->workgroup_size_x = {workgroup};
    packet->workgroup_size_y = 1;
    packet->workgroup_size_z = 1;
    packet->grid_size_x = {grid};
    packet->grid_size_y = {grid_y};
    packet->grid_size_z = {grid_z};
    packet->private_segment_size = private_size;
    packet->group_segment_size = group_size + {extra_group};
    packet->kernel_object = kernel_object;
    packet->kernarg_address = kernarg;
    packet->completion_signal = completion;
    uint16_t header = (uint16_t)(
        (HSA_PACKET_TYPE_KERNEL_DISPATCH << HSA_PACKET_HEADER_TYPE) |
        (HSA_FENCE_SCOPE_SYSTEM << HSA_PACKET_HEADER_SCACQUIRE_FENCE_SCOPE) |
        (HSA_FENCE_SCOPE_SYSTEM << HSA_PACKET_HEADER_SCRELEASE_FENCE_SCOPE));
    __atomic_store_n(&packet->header, header, __ATOMIC_RELEASE);
    hsa_queue_store_write_index_screlease(queue, index + 1);
    hsa_signal_store_screlease(queue->doorbell_signal, index);
    hsa_signal_wait_scacquire(completion, HSA_SIGNAL_CONDITION_LT, 1,
                              5ull * 1000 * 1000 * 1000, HSA_WAIT_STATE_ACTIVE);

{chr(10).join(outputs)}

    CHECK(hsa_signal_destroy(completion));
    CHECK(hsa_queue_destroy(queue));
    CHECK(hsa_shut_down());
    return 0;
}}
"""


def run_job(hsaco: Path, kernel: str, args: list, buffers: dict, grid: int = 64,
            workgroup: int = 64, keep: bool = False, return_raw: bool = False,
            grid_y: int = 1, extra_group: int = 0, grid_z: int = 1) -> dict:
    source = build_c(hsaco, kernel, args, buffers, grid, workgroup, grid_y, extra_group,
                     grid_z)
    td = Path(tempfile.mkdtemp(prefix="hsa_job_"))
    cpath = td / "job.c"
    cpath.write_text(source, encoding="utf-8")
    exe = td / "job"
    subprocess.run([
        "gcc", "-O2", "-I/opt/hyhal/include", str(cpath),
        "-L/opt/hyhal/lib", "-Wl,-rpath,/opt/hyhal/lib", "-lhsa-runtime64",
        "-o", str(exe),
    ], check=True)
    proc = subprocess.run([str(exe)], capture_output=True, text=True)
    if proc.returncode != 0:
        raise SystemExit(f"job failed:\n{proc.stdout}\n{proc.stderr}")
    out = {}
    for line in proc.stdout.splitlines():
        if line.startswith("BUF "):
            _, name, hexdata = line.split()
            out[name] = hexdata if return_raw else decode_buffer(
                buffers[name]["dtype"], bytes.fromhex(hexdata))
    if keep:
        print(f"kept {td}")
    else:
        import shutil
        shutil.rmtree(td, ignore_errors=True)
    return out


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("hsaco", type=Path)
    ap.add_argument("kernel")
    ap.add_argument("--grid", type=int, default=64)
    ap.add_argument("--workgroup", type=int, default=64)
    args = ap.parse_args()
    print(json.dumps(kernel_args(args.kernel), indent=1))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
