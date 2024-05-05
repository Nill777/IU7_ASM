#ifndef BRIGHTNESS_H
#define BRIGHTNESS_H

#include <QPixmap>
QPixmap change_brightness(const QPixmap& pixmap, int brightness, int flag_func, clock_t& time);

#endif // BRIGHTNESS_H
