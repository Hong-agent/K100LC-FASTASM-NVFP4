#include "gguf.h"
#include <cstdio>
#include <map>
int main(int argc, char** argv) {
    if (argc < 2) { printf("用法: gguf_test <model.gguf>\n"); return 1; }
    Gguf g;
    if (!g.open(argv[1])) return 1;
    std::map<int, int> hist; long long total = 0;
    for (auto& t : g.tensors) { hist[t.type]++; total += t.nbytes; }
    printf("张量 %zu，总体积 %.2f GB\n", g.tensors.size(), total / 1e9);
    for (auto& kv : hist)
        printf("   %-6s x%d\n", Gguf::type_name(kv.first), kv.second);
    const char* probes[] = {"output.weight", "token_embd.weight",
                            "blk.0.ffn_gate_exps.weight", "blk.40.nextn.eh_proj.weight",
                            "blk.40.ffn_gate_inp_shexp.weight"};
    for (const char* p : probes) {
        const GgufTensor* t = g.find(p);
        if (!t) { printf("   %-32s 缺失\n", p); continue; }
        printf("   %-32s %-5s off=%-12lld bytes=%-11lld dims=[", p,
               Gguf::type_name(t->type), t->off, t->nbytes);
        for (size_t i = 0; i < t->dims.size(); i++)
            printf("%s%lld", i ? "," : "", t->dims[i]);
        printf("]\n");
    }
    printf("   n_layers=%lld experts=%lld used=%lld hidden=%lld\n",
           g.meta_int.count("qwen35moe.block_count") ? g.meta_int["qwen35moe.block_count"] : -1,
           g.meta_int.count("qwen35moe.expert_count") ? g.meta_int["qwen35moe.expert_count"] : -1,
           g.meta_int.count("qwen35moe.expert_used_count") ? g.meta_int["qwen35moe.expert_used_count"] : -1,
           g.meta_int.count("qwen35moe.embedding_length") ? g.meta_int["qwen35moe.embedding_length"] : -1);
    return 0;
}
