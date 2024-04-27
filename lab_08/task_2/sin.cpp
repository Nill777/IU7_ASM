#include "sin.hpp"

double copr_sin_pi() {
    double res = 0.0;
    asm(
        "fldpi\n"   //pi в регистр сопроцессора
        "fsin\n"    //вычисляется sin
        "fstp %0\n"     //пишем в result
        :"=m"(res)
    );
    return res;
}

double copr_sin_pi_2() {
    double res = 0.0;
    double divide = 2.0;
    asm(
        "fldpi\n"   //pi в регистр сопроцессора
        "fld %1\n"  //divide в регистр сопроцессора Команда FLD помещает операнд-источник в стек FPU
        "fdiv %%ST(1), %%ST(0)\n"   //делим pi на divider
        "fsin\n"
        "fstp %0\n"     //пишем в result
        : "=m"(res)
        : "m"(divide)
    );
    return res;
}
