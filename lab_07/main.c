#include <stdio.h>
#include <string.h>
#define STRLEN 21

int main(void)
{
    setbuf(stdout, NULL);
    char my_str[] = "My new string";
    char my_str_copy[STRLEN];
    int len = 0;

    __asm__ (
        ".intel_syntax noprefix\n\t"
        "mov ecx, 32000\n\t"
        "mov al, 0\n\t"
        "lea rdi, [%1]\n\t"
        "repne scasb\n\t"
        "mov eax, 32000\n\t"
        "sub eax, ecx\n\t"
        "dec eax\n\t"
        "mov %0, eax\n\t"
        : "=r" (len)
        : "r" (my_str)
        : "ecx", "eax", "al", "rdi"
    );

    printf("C length: %d\nASM length: %d\n", strlen(my_str), len);
    // dst src len
    copy(len, my_str, my_str_copy);
    printf("Initial str: %s\nCopy str: %s", my_str, my_str_copy);
    return 0;
}