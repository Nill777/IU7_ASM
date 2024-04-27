#ifndef OPERATIONS_CPP_HPP
#define OPERATIONS_CPP_HPP

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

#endif
