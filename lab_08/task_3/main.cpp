#include <iostream>
#include "secant_method.hpp"

int main()
{
    double x0 = -1.5;  // Начальное приближение 1
    double x1 = -1.0;   // Начальное приближение 2
    double eps = 0.000001;  //Точность
    printf("%ld %ld %ld\n", x0, x1, eps);
    size_t max_iter = 1000;  // Максимальное число итераций

    // printf("my %lf\n", func(2.0));
    printf("%ld %ld %ld\n", x0, func(x0), eps);
    double* root = secant_method(x0, x1, eps, max_iter);

    if (root) {
        printf("Корень функции cos(x^3 + 7): %.10f\n", *root);
        printf("Проверка y = cos(root^3 + 7): %.10f\n", func(*root));
    }
    else
        printf("Не удалось найти корень за %d итераций,",
            "с заданной точностью %lf\n", max_iter, eps);
    return 0;
}
