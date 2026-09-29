// Minimal HSA code-object loader for the K100_LC gfx926 runtime.
//
// This does not link against DTK's libgalaxyhip or libamd_comgr.  It uses only
// the driver-side HSA runtime from /opt/hyhal and a precompiled gfx926 code
// object (the .out extracted from a HIP fatbin).
//
// build:
//   gcc -O2 -I/opt/hyhal/include tools/hsa_min_loader.c \
//       -L/opt/hyhal/lib -Wl,-rpath,/opt/hyhal/lib -lhsa-runtime64 \
//       -o /tmp/hsa_min_loader
//
// run:
//   /tmp/hsa_min_loader build/isa_extract/rt-hipv4-amdgcn-amd-amdhsa--gfx926.out

#include <hsa/hsa.h>
#include <hsa/hsa_ext_amd.h>

#include <fcntl.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define CHECK(expr) do { \
    hsa_status_t st_ = (expr); \
    if (st_ != HSA_STATUS_SUCCESS) { \
        const char* s_ = NULL; \
        hsa_status_string(st_, &s_); \
        fprintf(stderr, "%s:%d: %s -> %s\n", __FILE__, __LINE__, #expr, s_ ? s_ : "?"); \
        exit(1); \
    } \
} while (0)

typedef struct {
    hsa_agent_t gpu;
    int found_gpu;
} agent_search_t;

typedef struct {
    hsa_amd_memory_pool_t kernarg_pool;
    hsa_amd_memory_pool_t data_pool;
    int found_kernarg;
    int found_data;
} pool_search_t;

static hsa_status_t find_gpu(hsa_agent_t agent, void* data) {
    agent_search_t* search = (agent_search_t*)data;
    hsa_device_type_t type;
    CHECK(hsa_agent_get_info(agent, HSA_AGENT_INFO_DEVICE, &type));
    if (type == HSA_DEVICE_TYPE_GPU) {
        search->gpu = agent;
        search->found_gpu = 1;
        return HSA_STATUS_INFO_BREAK;
    }
    return HSA_STATUS_SUCCESS;
}

static hsa_status_t find_kernarg_pool(hsa_amd_memory_pool_t pool, void* data) {
    pool_search_t* search = (pool_search_t*)data;
    hsa_amd_segment_t segment;
    CHECK(hsa_amd_memory_pool_get_info(pool, HSA_AMD_MEMORY_POOL_INFO_SEGMENT, &segment));
    if (segment != HSA_AMD_SEGMENT_GLOBAL) {
        return HSA_STATUS_SUCCESS;
    }
    uint32_t flags = 0;
    bool alloc_ok = false;
    CHECK(hsa_amd_memory_pool_get_info(pool, HSA_AMD_MEMORY_POOL_INFO_GLOBAL_FLAGS, &flags));
    CHECK(hsa_amd_memory_pool_get_info(pool,
        HSA_AMD_MEMORY_POOL_INFO_RUNTIME_ALLOC_ALLOWED, &alloc_ok));
    if (getenv("HSA_MIN_LOADER_VERBOSE")) {
        size_t pool_size = 0;
        CHECK(hsa_amd_memory_pool_get_info(pool, HSA_AMD_MEMORY_POOL_INFO_SIZE, &pool_size));
        fprintf(stderr, "pool: segment=%d flags=0x%x alloc=%d size=%zu\n",
                (int)segment, flags, (int)alloc_ok, pool_size);
    }
    if (alloc_ok) {
        if ((flags & HSA_AMD_MEMORY_POOL_GLOBAL_FLAG_KERNARG_INIT) && !search->found_kernarg) {
            search->kernarg_pool = pool;
            search->found_kernarg = 1;
        }
        if ((flags & HSA_AMD_MEMORY_POOL_GLOBAL_FLAG_FINE_GRAINED) && !search->found_kernarg) {
            search->kernarg_pool = pool;
            search->found_kernarg = 1;
        }
        if ((flags & HSA_AMD_MEMORY_POOL_GLOBAL_FLAG_COARSE_GRAINED) && !search->found_data) {
            search->data_pool = pool;
            search->found_data = 1;
        }
        if ((flags & HSA_AMD_MEMORY_POOL_GLOBAL_FLAG_KERNARG_INIT) && search->found_kernarg &&
            search->found_data) {
            return HSA_STATUS_INFO_BREAK;
        }
    }
    return HSA_STATUS_SUCCESS;
}

static void* alloc_pool(hsa_amd_memory_pool_t pool, hsa_agent_t gpu, size_t size) {
    void* ptr = NULL;
    CHECK(hsa_amd_memory_pool_allocate(pool, size, 0, &ptr));
    CHECK(hsa_amd_agents_allow_access(1, &gpu, NULL, ptr));
    return ptr;
}

static void print_agent_name(hsa_agent_t agent) {
    char name[64] = {0};
    CHECK(hsa_agent_get_info(agent, HSA_AGENT_INFO_NAME, name));
    printf("HSA GPU agent: %s\n", name);
}

int main(int argc, char** argv) {
    setvbuf(stdout, NULL, _IONBF, 0);
    if (argc < 2) {
        fprintf(stderr, "usage: %s <gfx926-code-object.out> [kernel-symbol]\n", argv[0]);
        return 2;
    }
    const char* code_object_path = argv[1];
    const char* symbol_name = argc > 2 ? argv[2] : "_Z6fill_kPffx";

    CHECK(hsa_init());

    agent_search_t agent_search = {0};
    hsa_status_t iter_st = hsa_iterate_agents(find_gpu, &agent_search);
    if (iter_st != HSA_STATUS_SUCCESS && iter_st != HSA_STATUS_INFO_BREAK) {
        const char* s = NULL;
        hsa_status_string(iter_st, &s);
        fprintf(stderr, "hsa_iterate_agents: %s\n", s ? s : "?");
        return 1;
    }
    if (!agent_search.found_gpu) {
        fprintf(stderr, "no HSA GPU agent found\n");
        return 1;
    }
    hsa_agent_t gpu = agent_search.gpu;
    print_agent_name(gpu);

    pool_search_t pool_search = {0};
    iter_st = hsa_amd_agent_iterate_memory_pools(gpu, find_kernarg_pool, &pool_search);
    if (iter_st != HSA_STATUS_SUCCESS && iter_st != HSA_STATUS_INFO_BREAK) {
        const char* s = NULL;
        hsa_status_string(iter_st, &s);
        fprintf(stderr, "hsa_amd_agent_iterate_memory_pools: %s\n", s ? s : "?");
        return 1;
    }
    if (!pool_search.found_kernarg) {
        fprintf(stderr, "no kernarg memory pool found\n");
        return 1;
    }
    if (!pool_search.found_data) {
        pool_search.data_pool = pool_search.kernarg_pool;
        pool_search.found_data = 1;
    }
    hsa_executable_t executable = {0};
    CHECK(hsa_executable_create_alt(
        HSA_PROFILE_FULL,
        HSA_DEFAULT_FLOAT_ROUNDING_MODE_DEFAULT,
        NULL,
        &executable));

    int fd = open(code_object_path, O_RDONLY);
    if (fd < 0) {
        perror(code_object_path);
        return 1;
    }
    hsa_code_object_reader_t reader = {0};
    CHECK(hsa_code_object_reader_create_from_file(fd, &reader));
    hsa_loaded_code_object_t loaded = {0};
    CHECK(hsa_executable_load_agent_code_object(executable, gpu, reader, NULL, &loaded));
    CHECK(hsa_code_object_reader_destroy(reader));
    CHECK(hsa_executable_freeze(executable, NULL));

    hsa_executable_symbol_t symbol = {0};
    hsa_status_t sym_st = hsa_executable_get_symbol_by_name(executable, symbol_name, &gpu, &symbol);
    if (sym_st != HSA_STATUS_SUCCESS) {
        char amp_name[256];
        snprintf(amp_name, sizeof(amp_name), "&%s", symbol_name);
        sym_st = hsa_executable_get_symbol_by_name(executable, amp_name, &gpu, &symbol);
    }
    if (sym_st != HSA_STATUS_SUCCESS) {
        char kd_name[256];
        snprintf(kd_name, sizeof(kd_name), "%s.kd", symbol_name);
        sym_st = hsa_executable_get_symbol_by_name(executable, kd_name, &gpu, &symbol);
    }
    if (sym_st != HSA_STATUS_SUCCESS) {
        const char* s = NULL;
        hsa_status_string(sym_st, &s);
        fprintf(stderr, "symbol %s: %s\n", symbol_name, s ? s : "?");
        return 1;
    }

    uint64_t kernel_object = 0;
    uint32_t kernarg_size = 0;
    uint32_t group_size = 0;
    uint32_t private_size = 0;
    hsa_symbol_kind_t symbol_kind = (hsa_symbol_kind_t)0;
    CHECK(hsa_executable_symbol_get_info(symbol, HSA_EXECUTABLE_SYMBOL_INFO_TYPE, &symbol_kind));
    CHECK(hsa_executable_symbol_get_info(symbol, HSA_EXECUTABLE_SYMBOL_INFO_KERNEL_OBJECT, &kernel_object));
    CHECK(hsa_executable_symbol_get_info(symbol, HSA_EXECUTABLE_SYMBOL_INFO_KERNEL_KERNARG_SEGMENT_SIZE, &kernarg_size));
    CHECK(hsa_executable_symbol_get_info(symbol, HSA_EXECUTABLE_SYMBOL_INFO_KERNEL_GROUP_SEGMENT_SIZE, &group_size));
    CHECK(hsa_executable_symbol_get_info(symbol, HSA_EXECUTABLE_SYMBOL_INFO_KERNEL_PRIVATE_SEGMENT_SIZE, &private_size));
    printf("kernel=%s type=%d object=0x%" PRIx64 " kernarg=%u group=%u private=%u\n",
           symbol_name, (int)symbol_kind, kernel_object, kernarg_size, group_size, private_size);

    if (getenv("HSA_LOADER_RESOLVE_ONLY")) {
        printf("resolved\n");
        return 0;
    }

    const uint32_t n = 64;
    const size_t out_bytes = n * sizeof(float);
    void* out_dev = NULL;
    void* kernarg = NULL;
    out_dev = alloc_pool(pool_search.data_pool, gpu, out_bytes);
    void* host_init = calloc(1, out_bytes);
    if (!host_init) {
        perror("calloc");
        return 1;
    }
    if (getenv("HSA_LOADER_PREFILL")) {
        float prefill = strtof(getenv("HSA_LOADER_PREFILL"), NULL);
        for (uint32_t i = 0; i < n; i++) ((float*)host_init)[i] = prefill;
    }
    CHECK(hsa_memory_copy(out_dev, host_init, out_bytes));
    free(host_init);
    if (kernarg_size > 0) {
        kernarg = alloc_pool(pool_search.kernarg_pool, gpu, kernarg_size);
        void* zero_kernarg = calloc(1, kernarg_size);
        if (!zero_kernarg) {
            perror("calloc");
            return 1;
        }
        CHECK(hsa_memory_copy(kernarg, zero_kernarg, kernarg_size));
        free(zero_kernarg);
    }

    // fill_k(float* out, float value, long long n)
    float value = 3.25f;
    float expect = value;
    if (getenv("HSA_LOADER_VALUE")) {
        value = strtof(getenv("HSA_LOADER_VALUE"), NULL);
        expect = value;
    }
    if (getenv("HSA_LOADER_EXPECT")) {
        expect = strtof(getenv("HSA_LOADER_EXPECT"), NULL);
    }
    int64_t count = (int64_t)n;
    if (kernarg_size >= 8) {
        memcpy((char*)kernarg + 0, &out_dev, sizeof(out_dev));
    }
    if (kernarg_size >= 12) {
        memcpy((char*)kernarg + 8, &value, sizeof(value));
    }
    if (kernarg_size >= 24) {
        memcpy((char*)kernarg + 16, &count, sizeof(count));
    }
    if (kernarg_size >= 90) {
        // HIP/OpenCL hidden arguments.  The kernel reads hidden_group_size_x
        // to derive its grid stride, so these cannot be left at zero.
        uint32_t block_count[3] = {1, 1, 1};
        uint16_t hidden_group_size[3] = {64, 1, 1};
        uint16_t remainder[3] = {0, 0, 0};
        uint64_t global_offset[3] = {0, 0, 0};
        uint16_t grid_dims = 1;
        memcpy((char*)kernarg + 24, block_count, sizeof(block_count));
        memcpy((char*)kernarg + 36, hidden_group_size, sizeof(hidden_group_size));
        memcpy((char*)kernarg + 42, remainder, sizeof(remainder));
        memcpy((char*)kernarg + 64, global_offset, sizeof(global_offset));
        memcpy((char*)kernarg + 88, &grid_dims, sizeof(grid_dims));
    }

    hsa_signal_t completion;
    CHECK(hsa_signal_create(1, 0, NULL, &completion));

    uint32_t queue_size = 0;
    CHECK(hsa_agent_get_info(gpu, HSA_AGENT_INFO_QUEUE_MAX_SIZE, &queue_size));
    if (queue_size > 1024) queue_size = 1024;
    hsa_queue_type32_t queue_type = HSA_QUEUE_TYPE_SINGLE;
    CHECK(hsa_agent_get_info(gpu, HSA_AGENT_INFO_QUEUE_TYPE, &queue_type));
    printf("agent queue type=%u max_size=%u\n", queue_type, queue_size);
    hsa_queue_t* queue = NULL;
    CHECK(hsa_queue_create(gpu, queue_size, HSA_QUEUE_TYPE_SINGLE, NULL, NULL,
                           UINT32_MAX, UINT32_MAX, &queue));
    printf("queue type=%u features=0x%x size=%u doorbell_before=%" PRId64 "\n",
           queue->type, queue->features, queue->size,
           hsa_signal_load_relaxed(queue->doorbell_signal));

    uint64_t index = hsa_queue_load_write_index_relaxed(queue);
    hsa_kernel_dispatch_packet_t* packet =
        (hsa_kernel_dispatch_packet_t*)((char*)queue->base_address +
                                        (index % queue->size) * sizeof(*packet));
    memset(packet, 0, sizeof(*packet));
    packet->setup = 1;
    packet->workgroup_size_x = 64;
    packet->workgroup_size_y = 1;
    packet->workgroup_size_z = 1;
    packet->grid_size_x = 64;
    packet->grid_size_y = 1;
    packet->grid_size_z = 1;
    packet->private_segment_size = private_size;
    packet->group_segment_size = group_size;
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
    printf("doorbell_after=%" PRId64 " write_index=%" PRIu64 " read_index=%" PRIu64 "\n",
           hsa_signal_load_relaxed(queue->doorbell_signal),
           hsa_queue_load_write_index_scacquire(queue),
           hsa_queue_load_read_index_scacquire(queue));

    printf("dispatched, waiting...\n");
    hsa_signal_value_t wait_value = hsa_signal_wait_scacquire(
        completion, HSA_SIGNAL_CONDITION_LT, 1, 5ull * 1000 * 1000 * 1000,
        HSA_WAIT_STATE_ACTIVE);
    if (wait_value >= 1) {
        fprintf(stderr, "timeout waiting for completion; read_index=%" PRIu64 " write_index=%" PRIu64 "\n",
                hsa_queue_load_read_index_scacquire(queue),
                hsa_queue_load_write_index_scacquire(queue));
        return 1;
    }
    printf("completed\n");

    float host[n];
    CHECK(hsa_memory_copy(host, out_dev, out_bytes));
    uint32_t bad = 0;
    if (kernarg_size >= 24) {
        for (uint32_t i = 0; i < n; i++) {
            if (host[i] != expect) bad++;
        }
    }
    printf("value=%.3f expect=%.3f out[0]=%.3f out[%u]=%.3f bad=%u%s\n",
           value, expect, host[0], n - 1, host[n - 1], bad,
           kernarg_size >= 24 ? "" : " (no fill_k args; validation skipped)");

    CHECK(hsa_signal_destroy(completion));
    CHECK(hsa_queue_destroy(queue));
    if (kernarg) {
        CHECK(hsa_amd_memory_pool_free(kernarg));
    }
    CHECK(hsa_amd_memory_pool_free(out_dev));
    CHECK(hsa_executable_destroy(executable));
    CHECK(hsa_shut_down());
    close(fd);
    return bad == 0 ? 0 : 1;
}
