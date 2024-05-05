#include "mainwindow.h"

#include <QApplication>
#include <iostream>

int main(int argc, char *argv[])
{
    std::cout.tie();
    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    return a.exec();
}
