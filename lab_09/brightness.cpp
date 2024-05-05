#include <QImage>
#include <QColor>
#include <iostream>
// #include <emmintrin.h>  // для SSE
#include <smmintrin.h>  // для SSE
#include "brightness.h"
#include "select_func.h"

// #define SUM_CPP "sum cpp"
// #define SUM_ASM "sum asm"

// void form_data()
// void cout_time(clock_t time, int flag_func) {
//     char action[10] = "sum";
//     // switch (flag_func) {
//     // case INCREASE_CPP:
//     //     char action[8] = "sum cpp";
//     //     break;
//     // case INCREASE_ASM:
//     //     char action[8] = "sum asm";
//     //     break;
//     // case REDUCE_CPP:

//     //     break;
//     // case REDUCE_ASM:

//     //     break;
//     // }
//     printf("%s: %7.lf ms\n", action, (double)time);
// }

void increase_cpp(int& red, int& green, int& blue, int brightness) {
    // clock_t start_time, res_time = 0;
    // start_time = clock();

    red = std::min(255, red + brightness);
    green = std::min(255, green + brightness);
    blue = std::min(255, blue + brightness);

    // res_time += clock() - start_time;
    // return res_time;
}

void increase_asm(int& red, int& green, int& blue, int brightness) {
    // clock_t start_time, res_time = 0;
    // start_time = clock();

    brightness = std::min(brightness, 255);

    // загрузка исходных значений и яркости в 128 битные регистры SSE
    __m128i colors = _mm_setr_epi32(red, green, blue, 0);   // rgb и заглушки
    __m128i brightness_vec = _mm_set1_epi32(brightness);    // яркость во все четыре позиции

    // __m128i result = _mm_add_epi32(colors, brightness_vec);
    __m128i result;
    asm(
        "movdqa %[colors], %%xmm0\n"            //вектор colors в xmm0
        "movdqa %[brightness_vec], %%xmm1\n"    //вектор brightness_vec в xmm1
        "paddd %%xmm1, %%xmm0\n"                //cложение rgb и яркости (поэлементное сложение регистров xmm0 и xmm1 (сложение двойных слов))
        "movdqa %%xmm0, %[result]\n"            //результат в result
        : [result] "=x" (result)                //result на вход, "=x" писать в xmm
        : [colors] "x" (colors),                //colors и brightness_vec на выход, "x" грузить из xmm
          [brightness_vec] "x" (brightness_vec)
        : "xmm0", "xmm1"
        );

    // маска для ограничения (255)
    __m128i max_val = _mm_set1_epi32(255);
    result = _mm_min_epi32(result, max_val);

    red = _mm_extract_epi32(result, 0); // извлечение r
    green = _mm_extract_epi32(result, 1); // извлечение g
    blue = _mm_extract_epi32(result, 2); // извлечение b

    // res_time += clock() - start_time;
    // return res_time;
}

void reduce_cpp(int& red, int& green, int& blue, int brightness) {
    red = std::max(0, red - brightness);
    green = std::max(0, green - brightness);
    blue = std::max(0, blue - brightness);
}

void reduce_asm(int& red, int& green, int& blue, int brightness) {
    brightness = std::min(brightness, 255);

    // загрузка исходных значений и яркости в 128 битные регистры SSE
    __m128i colors = _mm_setr_epi32(red, green, blue, 0);   // rgb и заглушки
    __m128i brightness_vec = _mm_set1_epi32(brightness);    // яркость во все четыре позиции

    // __m128i result = _mm_sub_epi32(colors, brightness_vec);
    __m128i result;
    asm(
        "movdqa %[colors], %%xmm0\n"
        "movdqa %[brightness_vec], %%xmm1\n"
        "psubd %%xmm1, %%xmm0\n"                // вычитание из rgb яркости (не psubb %%xmm1, %%xmm0 (для 8 бит), а psubd!!!)
        "movdqa %%xmm0, %[result]\n"
        : [result] "=x" (result)
        : [colors] "x" (colors),
          [brightness_vec] "x" (brightness_vec)
        : "xmm0", "xmm1"
        );

    // иначе выскочу
    __m128i min_val = _mm_set1_epi32(0);
    result = _mm_max_epi32(result, min_val);

    red = _mm_extract_epi32(result, 0); // извлечение r
    green = _mm_extract_epi32(result, 1); // извлечение g
    blue = _mm_extract_epi32(result, 2); // извлечение b
}

QPixmap change_brightness(const QPixmap& pixmap, int brightness, int flag_func, clock_t& time) {
    QImage img = pixmap.toImage();
    uchar* line;
    clock_t start_time = clock();

    for(int y = 0; y < img.height(); ++y) {
        line = img.scanLine(y);
        for(int x = 0; x < img.width(); ++x) {
            int index = x * 4;

            int red = line[index];
            int green = line[index + 1];
            int blue = line[index + 2];

            switch (flag_func) {
            case INCREASE_CPP:
                increase_cpp(red, green, blue, brightness);
                break;
            case INCREASE_ASM:
                increase_asm(red, green, blue, brightness);
                break;
            case REDUCE_CPP:
                reduce_cpp(red, green, blue, brightness);
                break;
            case REDUCE_ASM:
                reduce_asm(red, green, blue, brightness);
                break;
            }
            line[index] = static_cast<uchar>(red);
            line[index + 1] = static_cast<uchar>(green);
            line[index + 2] = static_cast<uchar>(blue);
        }
    }

    time += clock() - start_time;

    // cout_time(res_time, flag_func);
    return QPixmap::fromImage(img);
}
