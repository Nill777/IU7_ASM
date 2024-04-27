#ifndef SECANT_METHOD
#define SECANT_METHOD

#include <iostream>

double func(double x);
double* secant_method(double x0, double x1, double eps, size_t max_iter);

#endif