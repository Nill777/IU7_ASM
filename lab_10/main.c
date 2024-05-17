#include <iostream>
#include "secant_method.hpp"

int main()
{
    double x0 = 0.5;  // Начальное приближение 1
    double x1 = 1.5;   // Начальное приближение 2
    double eps = 0.000001;  //Точность
    size_t max_iter = 100;  // Максимальное число итераций
    double root;
    
    if (secant_method(&root, x0, x1, eps, max_iter)) {
        printf("Корень функции cos(x^3 + 7): %.10f\n", root);
        printf("Проверка y = cos(root^3 + 7): %.10f\n", func(root));
    }
    else
        printf("Не удалось найти корень за %d итераций,",
            "с заданной точностью %lf\n", max_iter, eps);
    return 0;
}