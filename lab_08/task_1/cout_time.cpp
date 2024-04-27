#include "cout_time.hpp"

void cout_time(clock_t time, const char* action) {
    printf("%s: %7.lf ms|", action, (double)time);
}
