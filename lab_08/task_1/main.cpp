#include <iostream>
#define ITERATIONS 1E4

#include "cout_time.hpp"
#include "operations_asm.hpp"
#include "operations_cpp.hpp"

template <typename T>
void table_time(T a, T b)
{
    std::cout << "ASM:";
    sum_asm(a, b);
    mul_asm(a, b);
    sub_asm(a, b);
    div_asm(a, b);
    std::cout << std::endl;

    std::cout << "CPP:";
    sum(a, b);
    mul(a, b);
    sub(a, b);
    div(a, b);
    std::cout << std::endl;
}

int main()
{
    float f1 = 4.6f;
    float f2 = 3.1f;
    std::cout << "-----FLOAT-----" << std::endl;
    table_time(f1, f2);

    double d1 = 7.2;
    double d2 = 1.6;
    std::cout << "-----DOUBLE-----" << std::endl;
    table_time(d1, d2);
}
