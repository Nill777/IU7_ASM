#ifndef OPERATIONS_ASM_HPP
#define OPERATIONS_ASM_HPP

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

#endif
