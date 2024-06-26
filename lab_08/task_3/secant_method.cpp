#include <cmath>
#include <math.h>
#include "secant_method.hpp"
// cos(x^3 + 7)
double func(double x) {
    double res;
    double add = 7;
    asm(
        "fld %1\n"           // x в ST(0)
        "fmul %1\n"          // x^2
        "fmul %1\n"          // x^3
        "fld %2\n"           // 7
        "faddp %%st(1), %%st(0)\n" // x^3 + 7 (сложение с извлечением из стека)
        "fcos\n"      
        "fstp %0\n"       
        : "=m"(res)  
        : "m"(x), "m"(add) 
    );
    return res;
}

double calc_new_border(double x0, double x1) {
    double x2;
    double f0 = func(x0);
    double f1 = func(x1);
    // printf("calc %lf %lf %lf %lf %lf\n", x2, x0, x1, func(x0), func(x1));
    // x2 = x1 - f1 * (x1 - x0) / (f1 - f0);
    asm(
        "movsd xmm1, %4\n" // xmm1 = f1
        "movsd xmm2, %2\n" // xmm2 = x1
        "subsd xmm2, %1\n" // xmm2 = x1 - x0
        "mulsd xmm1, xmm2\n" // xmm1 = f1 * (x1 - x0)
        "movsd xmm2, %4\n" // xmm2 = f1
        "subsd xmm2, %3\n" // xmm2 = f1 - f0
        "divsd xmm1, xmm2\n" // xmm1 = f1 * (x1 - x0) / (f1 - f0)
        "movsd xmm2, %2\n" // xmm2 = x1
        "subsd xmm2, xmm1\n" // xmm2 = x1 - f1 * (x1 - x0) / (f1 - f0)
        "movsd %0, xmm2\n" // x2 = xmm2
        : "=m"(x2)
        : "m"(x0), "m"(x1), "m"(f0), "m"(f1)
        : "xmm0", "xmm1", "xmm2"
    );
    return x2;
}
/*
// метод хорд
double* secant_method(double x0, double x1, const double eps, const size_t max_iter) {
    extern double x2,
        f0, f1;
    int success = 1;
    asm(
        "mov rcx, %4"
        "while:\n"
            "push %1\n"      // Помещаем аргумент (x0) в стек
            "call func\n"   // Вызываем функцию func
            "add esp, 8\n"    // Очищаем стек (8 байт)
            "mov %5, eax\n"   // Сохраняем результат из eax в f0
            
            "push %2\n"      // Помещаем аргумент (x1) в стек
            "call func\n"   // Вызываем функцию func
            "add esp, 8\n"    // Очищаем стек (8 байт)
            "mov %6, eax\n"   // Сохраняем результат из eax в f1

            // x2 = x1 - f1 * (x1 - x0) / (f1 - f0)
            "movsd xmm1, %6\n" // xmm1 = f1
            "movsd xmm2, %2\n" // xmm2 = x1
            "subsd xmm2, %1\n" // xmm2 = x1 - x0
            "mulsd xmm1, xmm2\n" // xmm1 = f1 * (x1 - x0)
            "movsd xmm2, %6\n" // xmm2 = f1
            "subsd xmm2, %5\n" // xmm2 = f1 - f0
            "divsd xmm1, xmm2\n" // xmm1 = f1 * (x1 - x0) / (f1 - f0)
            "movsd xmm2, %2\n" // xmm2 = x1
            "subsd xmm2, xmm1\n" // xmm2 = x1 - f1 * (x1 - x0) / (f1 - f0)
            "movsd %0, xmm2\n" // x2 = xmm2

            "push %0\n"      // Помещаем аргумент (x2) в стек
            "call func\n"   // Вызываем функцию func
            "add esp, 8\n"    // Очищаем стек (8 байт)
            "fld eax\n"
            "fabs\n"
            "fstp eax\n" 
            "cmp eax, %3\n"
            "jl return\n"

            "mov %1, %2\n"  // x0 = x1
            "mov %2, %0\n"  // x1 = x2

            "loop while\n"
            "xor %7, %7\n"
        "return:\n"
        : "=m"(x2)
        : "m"(x0), "m"(x1), "m"(eps), "m"(max_iter), "m"(f0), "m"(f1), "m" (success)
        : "rcx", "eax", "xmm0", "xmm1", "xmm2"
    );
    if (success)
        return &x2;
    else
        return nullptr;
}
*/
// метод хорд
int secant_method(double* x2, double x0, double x1, double eps, size_t max_iter) {
    for (size_t i = 0; i < max_iter; ++i) {
        *x2 = calc_new_border(x0, x1);
        // printf("%lf %lf %lf %lf %zu %zu\n", *x2, func(*x2), fabs(func(*x2)), eps, max_iter, i);
        if (fabs(func(*x2)) < eps)
            return 1;
        x0 = x1;
        x1 = *x2;
    }
    return 0;
}
