#ifndef SECANT_METHOD
#define SECANT_METHOD

#include <iostream>

double func(double x);
double calc_new_border(double x0, double x1);
int secant_method(double* x2, double x0, double x1, double eps, size_t max_iter);

#endif