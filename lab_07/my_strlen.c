#include "my_string.h"

size_t my_strlen(const char *str)
{
    size_t len = 0;
    const char *cur = str;

    __asm__(
        ".intel_syntax noprefix\n"
        "mov rcx, -1\n"
        "mov al, 0\n"
        "mov rdi, %1\n"
        "repne scasb\n"
        "neg rcx\n"
        "sub rcx, 2\n"
        "mov %0, rcx\n"
        : "=r"(len)
        : "r"(cur)
        : "%rax", "%rcx", "%rdi", "%al");

    return len;
}
