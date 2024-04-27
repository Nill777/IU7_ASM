#include <iostream>
#include <cmath>
#include "sin.hpp"

int main()
{
    printf("Сomparison calculation accuracy sin\n");
    printf("-----------------------------------\n");
    printf("std sin(M_PI): %+.20f    error: %+.20f\n", sin(M_PI), sin(M_PI));
    printf("sin(3.14):     %+.20f    error: %+.20f\n", sin(3.14), sin(3.14));
    printf("sin(3.141596): %+.20f    error: %+.20f\n", sin(3.141596), sin(3.141596));
    printf("copr sin(PI):  %+.20f    error: %+.20f\n", copr_sin_pi(), copr_sin_pi());
    printf("-----------------------------------\n");
    printf("std sin(M_PI_2):     %+.20f    error: %+.20f\n", sin(M_PI_2), 1 - sin(M_PI_2));
    printf("sin(3.14 / 2.0):     %+.20f    error: %+.20f\n", sin(3.14 / 2.0), 1 - sin(3.14 / 2.0));
    printf("sin(3.141596 / 2.0): %+.20f    error: %+.20f\n", sin(3.141596 / 2.0), 1 - sin(3.141596 / 2.0));
    printf("copr sin(PI / 2.0):  %+.20f    error: %+.20f\n", copr_sin_pi_2(), 1 - copr_sin_pi_2());
    printf("-----------------------------------\n");
    return 0;
}
