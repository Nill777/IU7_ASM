#ifndef EVENTS_LOG_H
#define EVENTS_LOG_H

#include <QPixmap>
struct log {
    int action;
    QPixmap prev_pixmap;
};
using log_t = struct log;

#endif // EVENTS_LOG_H
