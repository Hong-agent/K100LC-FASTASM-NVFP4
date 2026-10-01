// GGUF 读取实现：头部 KV + tensor info，数据区用 mmap（37 GB 的模型不能整份读进内存）。
#include "gguf.h"

#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

#include <cstdio>
#include <cstring>

namespace {

struct Rd {
    const uint8_t* p;
    size_t n, i = 0;
    bool need(size_t k) const { return i + k <= n; }
    uint32_t u32() { uint32_t v; memcpy(&v, p + i, 4); i += 4; return v; }
    uint64_t u64() { uint64_t v; memcpy(&v, p + i, 8); i += 8; return v; }
    std::string str() {
        uint64_t k = u64();
        std::string s((const char*)p + i, (size_t)k);
        i += k;
        return s;
    }
    double f64() { double v; memcpy(&v, p + i, 8); i += 8; return v; }
    int32_t i32() { int32_t v; memcpy(&v, p + i, 4); i += 4; return v; }
    int16_t i16() { int16_t v; memcpy(&v, p + i, 2); i += 2; return v; }
    int8_t i8() { return (int8_t)p[i++]; }
    uint8_t u8() { return p[i++]; }
    float f32() { float v; memcpy(&v, p + i, 4); i += 4; return v; }
    void skip(uint64_t k) { i += k; }
};

// 跳过（或记录）一个 KV 值；标量记进 meta_*，大数组只跳
void read_value(Rd& r, uint32_t t, const std::string& key, Gguf& g) {
    switch (t) {
        case 0: g.meta_int[key] = r.u8(); break;
        case 1: g.meta_int[key] = r.i8(); break;
        case 2: g.meta_int[key] = *(uint16_t*)(r.p + r.i); r.skip(2); break;
        case 3: g.meta_int[key] = r.i16(); break;
        case 4: g.meta_int[key] = r.u32(); break;
        case 5: g.meta_int[key] = r.i32(); break;
        case 6: g.meta_num[key] = r.f32(); break;
        case 7: g.meta_int[key] = r.u8() ? 1 : 0; break;
        case 8: g.meta_str[key] = r.str(); break;
        case 9: {                                  // array
            uint32_t et = r.u32();
            uint64_t n = r.u64();
            if (et == 8) {                         // 字符串数组（词表）
                for (uint64_t k = 0; k < n; k++) r.skip(r.u64());
                g.meta_int[key + ".count"] = (long long)n;
            } else {
                int sz = (et == 10 || et == 11 || et == 12) ? 8 :
                         (et == 2 || et == 3) ? 2 : (et == 0 || et == 1 || et == 7) ? 1 : 4;
                r.skip(n * sz);
                g.meta_int[key + ".count"] = (long long)n;
            }
            if (et != 8) {
                // 小的数值数组留几个值（rope sections 之类），大的只记个数
                if (n <= 8) {
                    Rd bak = r;
                    bak.i = r.i - n * ((et == 10 || et == 11 || et == 12) ? 8 :
                                       (et == 2 || et == 3) ? 2 : 1);
                    double first = 0;
                    if (et == 4) first = (double)*(uint32_t*)(bak.p + bak.i);
                    g.meta_num[key + ".first"] = first;
                }
            }
            break;
        }
        case 10: g.meta_int[key] = (long long)r.u64(); break;
        case 11: g.meta_int[key] = (long long)r.u64(); break;
        case 12: g.meta_num[key] = r.f64(); break;
        default: printf("GGUF: 未知 value type %u（key=%s）\n", t, key.c_str()); exit(1);
    }
}

}  // namespace

bool Gguf::type_block(int type, int* elems, int* bytes) {
    switch (type) {
        case 0:  *elems = 1;   *bytes = 4;   return true;   // F32
        case 1:  *elems = 1;   *bytes = 2;   return true;   // F16
        case 30: *elems = 1;   *bytes = 2;   return true;   // BF16
        case 8:  *elems = 32;  *bytes = 34;  return true;   // Q8_0
        case 2:  *elems = 32;  *bytes = 18;  return true;   // Q4_0
        case 3:  *elems = 32;  *bytes = 20;  return true;   // Q4_1
        case 6:  *elems = 32;  *bytes = 22;  return true;   // Q5_0
        case 7:  *elems = 32;  *bytes = 24;  return true;   // Q5_1
        case 10: *elems = 256; *bytes = 84;  return true;   // Q2_K
        case 11: *elems = 256; *bytes = 110; return true;   // Q3_K
        case 12: *elems = 256; *bytes = 144; return true;   // Q4_K
        case 13: *elems = 256; *bytes = 176; return true;   // Q5_K
        case 14: *elems = 256; *bytes = 210; return true;   // Q6_K
        case 20: *elems = 32;  *bytes = 18;  return true;   // IQ4_NL
        case 23: *elems = 256; *bytes = 136; return true;   // IQ4_XS
        default: return false;
    }
}

const char* Gguf::type_name(int t) {
    switch (t) {
        case 0: return "F32";   case 1: return "F16";   case 30: return "BF16";
        case 8: return "Q8_0";  case 2: return "Q4_0";  case 12: return "Q4_K";
        case 14: return "Q6_K"; case 20: return "IQ4_NL"; case 23: return "IQ4_XS";
        default: return "?";
    }
}

bool Gguf::open(const std::string& path) {
    int fd = ::open(path.c_str(), O_RDONLY);
    if (fd < 0) { printf("GGUF: 打不开 %s\n", path.c_str()); return false; }
    struct stat st {};
    fstat(fd, &st);
    map_size = (size_t)st.st_size;
    map = (const uint8_t*)mmap(nullptr, map_size, PROT_READ, MAP_PRIVATE, fd, 0);
    ::close(fd);
    if (map == MAP_FAILED) { printf("GGUF: mmap 失败\n"); return false; }

    Rd r{map, map_size};
    if (!r.need(4) || memcmp(r.p, "GGUF", 4)) { printf("GGUF: magic 不符\n"); return false; }
    r.skip(4);
    uint32_t ver = r.u32();
    uint64_t ntensor = r.u64(), nkv = r.u64();

    for (uint64_t k = 0; k < nkv; k++) {
        std::string key = r.str();
        uint32_t t = r.u32();
        read_value(r, t, key, *this);
    }
    alignment = (int)(meta_int.count("general.alignment") ? meta_int["general.alignment"] : 32);
    for (uint64_t k = 0; k < ntensor; k++) {
        GgufTensor t;
        t.name = r.str();
        uint32_t nd = r.u32();
        for (uint32_t d = 0; d < nd; d++) t.dims.push_back((long long)r.u64());
        t.type = (int)r.u32();
        t.off = (long long)r.u64();
        int be = 1, bb = 4;
        if (!type_block(t.type, &be, &bb)) {
            printf("GGUF: 张量 %s 的类型 %d 不认识\n", t.name.c_str(), t.type);
            return false;
        }
        t.nbytes = (t.nelem() + be - 1) / be * bb;
        index[t.name] = (int)tensors.size();
        tensors.push_back(t);
    }
    data_start = (long long)((r.i + alignment - 1) / alignment * alignment);
    printf("GGUF v%u：%zu 张量，%zu 元数据，数据起点 %lld（文件 %.2f GB）\n",
           ver, tensors.size(), meta_str.size() + meta_int.size() + meta_num.size(),
           data_start, map_size / 1e9);
    return true;
}
