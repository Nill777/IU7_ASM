#include <math.h>
#include "secant_method.h"
#include "stdio.h"
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
extern double result;
// метод хорд
bool secant_method(double* x2, double x0, double x1, double eps, double max_iter) {
    printf("%lf %lf %lf %lf %lf\n", *x2, x0, x1, eps, max_iter);
    for (int i = 0; i < (int) max_iter; ++i) {
        *x2 = calc_new_border(x0, x1);
        // printf("%lf %lf %lf %lf %zu %zu\n", *x2, func(*x2), fabs(func(*x2)), eps, max_iter, i);
        if (fabs(func(*x2)) < eps)  {
            printf("root %lf\n", *x2);
            result = *x2;
            return 1;
        }
        x0 = x1;
        x1 = *x2;
    }
    result = *x2;
    return 0;
}
