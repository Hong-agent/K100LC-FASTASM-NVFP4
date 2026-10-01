// Qwen3.6-35B-A3B（qwen35moe）自研运行时入口。
// 独立于稠密 27B 那条路径（model.cpp），复用同一套 HSA 运行时与自研内核。
#pragma once

// 返回 0 表示正常结束；参数为引擎命令行（--gguf <path> ...）。
int run_moe35(int argc, char** argv);
