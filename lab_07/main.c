#include <stdio.h>
#include <string.h>
#include "my_string.h"

#define STRLEN 21

int main(void)
{
    setbuf(stdout, NULL);
    char str_copy[5];    //dst src с перекрытием
    // char str_copy[STRLEN];   //dst src без перекрытия
    char str[STRLEN] = "My new string";
    // char str_copy[STRLEN];   //src dst без перекрытия
    // char *str_copy = str;    //src == dst
    // char *str_copy = &str[5];   //src dst с перекрытием
    size_t len = my_strlen(str);
    
    printf("C length: %d\nASM length: %d\n", strlen(str), len);
    my_strncpy(str_copy, str, len);
    printf("Initial str: %s\nCopy str: %s\n", str, str_copy);
    return 0;
}
