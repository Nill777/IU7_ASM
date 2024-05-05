#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <vector>
#include "events_log.h"

QT_BEGIN_NAMESPACE
namespace Ui {
class MainWindow;
}
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private:
    Ui::MainWindow *ui;
    QPixmap pixmap;
    std::vector<log_t> event_log;
    QPixmap time_pixmap;
    void clicked_increase();
    void clicked_reduce();
    void clicked_cancel();
    void clicked_download();
    void clicked_save();
    void clicked_cmp_times();
};
#endif // MAINWINDOW_H
