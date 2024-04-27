#include <iostream>
#include <ctime>
#include <cmath>

using namespace std;
#define ITERATIONS 1E4

void cout_time(clock_t time, const char* action) {
    printf("     %s: %7.lf ms", action, (double)time);
}

template <typename T>
void sum(T a, T b)
{
    T result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < ITERATIONS; i++)
    {
        start_time = clock();
        result = a + b;
        res_time += clock() - start_time;
    }
    cout_time(res_time, "Sum");
}

template <typename T>
void mul(T a, T b)
{
    T result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < ITERATIONS; i++)
    {
        start_time = clock();
        result = a * b;
        res_time += clock() - start_time;
    }
    cout_time(res_time, "Mul");
}

template <typename T>
void sub(T a, T b)
{
    T result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < ITERATIONS; i++)
    {
        start_time = clock();
        result = a - b;
        res_time += clock() - start_time;
    }
    cout_time(res_time, "Sub");
}

template <typename T>
void div(T a, T b)
{
    T result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < ITERATIONS; i++)
    {
        start_time = clock();
        result = a / b;
        res_time += clock() - start_time;
    }
    cout_time(res_time, "Div");
}

template <typename T>
T sum_asm(T a, T b)
{
    T result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < ITERATIONS; i++)
    {
        start_time = clock();
        asm(
            "fld %1\n"
            "fld %2\n"
            "faddp %%ST(1), %%ST(0)\n"
            "fstp %0\n"
            : "=m"(result)
            : "m"(a),
            "m"(b)
        );
        res_time += clock() - start_time;
    }
    cout_time(res_time, "Sum");

    return result;
}

template <typename T>
T mul_asm(T a, T b)
{
    T result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < ITERATIONS; i++)
    {
        start_time = clock();
        asm
        (
            "fld %1\n"
            "fld %2\n"
            "fmulp %%ST(1), %%ST(0)\n"
            "fstp %0\n"
            :"=m"(result)
            : "m"(a),
            "m"(b)
        );
        res_time += clock() - start_time;
    }
    cout_time(res_time, "Mul");

    return result;
}

template <typename T>
T sub_asm(T a, T b)
{
    T result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < ITERATIONS; i++)
    {
        start_time = clock();
        asm
        (
            "fld %1\n"
            "fld %2\n"
            "fsubp %%ST(1), %%ST(0)\n"
            "fstp %0\n"
            :"=m"(result)
            : "m"(a),
            "m"(b)
        );
        res_time += clock() - start_time;
    }
    cout_time(res_time, "Sub");

    return result;
}

template <typename T>
T div_asm(T a, T b)
{
    T result = 0;
    clock_t start_time, res_time = 0;

    for (int i = 0; i < ITERATIONS; i++)
    {
        start_time = clock();
        asm(
            "fld %1\n"
            "fld %2\n"
            "fdivp %%ST(1), %%ST(0)\n"
            "fstp %0\n"
            :"=m"(result)
            : "m"(a),
            "m"(b)
        );
        res_time += clock() - start_time;
    }
    cout_time(res_time, "Div");

    return result;
}

template <typename T>
void table_time(T a, T b)
{
    cout << "ASM:";
    sum_asm(a, b);
    mul_asm(a, b);
    sub_asm(a, b);
    div_asm(a, b);
    cout << endl;

    cout << "CPP:";
    sum(a, b);
    mul(a, b);
    sub(a, b);
    div(a, b);
    cout << endl;
}

int main()
{
    float f1 = 1.1f;
    float f2 = 2.3f;
    cout << "-----FLOAT-----" << endl;
    table_time(f1, f2);

    double d1 = 2.3;
    double d2 = 5.6;
    cout << "-----DOUBLE-----" << endl;
    table_time(d1, d2);
}
