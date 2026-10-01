// GGUF 读取：元数据 + 张量清单 + mmap 数据区。自包含，不依赖任何外部库。
#pragma once
#include <cstdint>
#include <map>
#include <string>
#include <vector>

struct GgufTensor {
    std::string name;
    int type = 0;                      // GGML_TYPE_*
    std::vector<long long> dims;       // 与 GGUF 一致（最慢变化的维在前）
    long long off = 0;                 // 相对数据区起点
    long long nbytes = 0;
    long long nelem() const {
        long long n = 1;
        for (long long d : dims) n *= d;
        return n;
    }
};

struct Gguf {
    const uint8_t* map = nullptr;      // 整文件 mmap
    size_t map_size = 0;
    long long data_start = 0;
    int alignment = 32;
    std::vector<GgufTensor> tensors;
    std::map<std::string, int> index;
    std::map<std::string, std::string> meta_str;
    std::map<std::string, long long> meta_int;
    std::map<std::string, double> meta_num;

    bool open(const std::string& path);
    const GgufTensor* find(const std::string& name) const {
        auto it = index.find(name);
        return it == index.end() ? nullptr : &tensors[it->second];
    }
    // 张量在文件里的绝对偏移
    long long file_off(const GgufTensor& t) const { return data_start + t.off; }
    // 每种量化的块大小（元素数 / 字节数）；未知类型返回 false
    static bool type_block(int type, int* elems, int* bytes);
    static const char* type_name(int type);
};
