#include "mainwindow.h"
#include "./ui_mainwindow.h"

#include <QFileDialog>
#include <QMessageBox>
#include <iostream>
#include "brightness.h"
#include "select_func.h"

#define DATA_DIR "/home/andrey/SEM_04/mzap/IU7_ASM/lab_09/picture"
#define INCREASE 1
#define REDUCE 2

#define CHANGE_BRIGHTNESS 5
#define ITERATIONS 100

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    connect(ui->pushButton_increase_br, &QPushButton::clicked, this, &MainWindow::clicked_increase);
    connect(ui->pushButton_reduce_br, &QPushButton::clicked, this, &MainWindow::clicked_reduce);
    connect(ui->pushButton_cancel, &QPushButton::clicked, this, &MainWindow::clicked_cancel);
    connect(ui->pushButton_download, &QPushButton::clicked, this, &MainWindow::clicked_download);
    connect(ui->pushButton_save, &QPushButton::clicked, this, &MainWindow::clicked_save);
    connect(ui->pushButton_cmp_times, &QPushButton::clicked, this, &MainWindow::clicked_cmp_times);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::clicked_increase()
{
    if (pixmap.isNull())
        QMessageBox::critical(NULL, "Ошибка", "Необходимо загрузить исходное изображение");
    else if (!event_log.empty() && (event_log.back().action == REDUCE)) {
        pixmap = event_log.back().prev_pixmap;
        ui->output_img->setPixmap(pixmap);
        event_log.pop_back();
    }
    else {
        clock_t time;
        pixmap = change_brightness(pixmap, CHANGE_BRIGHTNESS, INCREASE_ASM, time);
        if (!pixmap.isNull()) {
            ui->output_img->setPixmap(pixmap);
            event_log.push_back({INCREASE, pixmap});
        }
    }
}

void MainWindow::clicked_reduce()
{
    if (pixmap.isNull())
        QMessageBox::critical(NULL, "Ошибка", "Необходимо загрузить исходное изображение");
    else if (!event_log.empty() && (event_log.back().action == INCREASE)) {
        pixmap = event_log.back().prev_pixmap;
        ui->output_img->setPixmap(pixmap);
        event_log.pop_back();
    }
    else {
        clock_t time;
        pixmap = change_brightness(pixmap, CHANGE_BRIGHTNESS, REDUCE_ASM, time);
        if (!pixmap.isNull()) {
            ui->output_img->setPixmap(pixmap);
            event_log.push_back({REDUCE, pixmap});
        }
    }
}

void MainWindow::clicked_cancel()
{
    if (!event_log.empty()) {
        pixmap = event_log.back().prev_pixmap;
        ui->output_img->setPixmap(pixmap);
        event_log.pop_back();
    }
    else
        QMessageBox::critical(NULL, "Ошибка", "Невозможно отменить действие\nЖурнал действий пуст");
}

void MainWindow::clicked_download()
{
    QString path = QFileDialog::getOpenFileName(this, "Открыть PNG изображение", DATA_DIR, "PNG файлы (*.png)");
    ui->path->setText(path.toUtf8().data());
    pixmap = QPixmap(path.toUtf8().data());

    if (!pixmap.isNull()) {
        ui->input_img->setPixmap(pixmap);
        ui->output_img->setPixmap(pixmap);
        // event_log.clear();
    }
}

void MainWindow::clicked_save()
{
    if (pixmap.isNull())
        QMessageBox::critical(NULL, "Ошибка", "Необходимо загрузить исходное изображение");
    else {
        QString path = QFileDialog::getSaveFileName(this, "Сохранить PNG изображение", DATA_DIR, "PNG файлы (*.png)");
        QFile file(path.toUtf8().data());
        file.open(QIODevice::WriteOnly);
        pixmap.save(&file, "PNG");
        file.close();
        QMessageBox::information(NULL, "Сохранение", "Изображение успешно сохранено");
    }
}

void MainWindow::clicked_cmp_times()
{
    clock_t time_sum_cpp = 0,
            time_sum_asm = 0,
            time_sub_cpp = 0,
            time_sub_asm = 0;
    if (pixmap.isNull()) {
        QMessageBox::critical(NULL, "Ошибка", "Необходимо загрузить исходное изображение");
        return;
    }
    time_pixmap = QPixmap(ui->path->text());
    for (int i = 0; i < ITERATIONS; ++i) {
        change_brightness(time_pixmap, CHANGE_BRIGHTNESS, INCREASE_CPP, time_sum_cpp);
        change_brightness(time_pixmap, CHANGE_BRIGHTNESS, INCREASE_ASM, time_sum_asm);
        change_brightness(time_pixmap, CHANGE_BRIGHTNESS, REDUCE_CPP, time_sub_cpp);
        change_brightness(time_pixmap, CHANGE_BRIGHTNESS, REDUCE_ASM, time_sub_asm);
    }
    time_sum_cpp /= ITERATIONS;
    time_sum_asm /= ITERATIONS;
    time_sub_cpp /= ITERATIONS;
    time_sub_asm /= ITERATIONS;

    QString message = "Замеры времён обработки:\n";
    message += "------------------------";
    message += QString("Sum cpp: %1 ms\n").arg((double) time_sum_cpp, 0, 'f', 0);
    message += QString("Sum asm: %1 ms\n").arg((double) time_sum_asm, 0, 'f', 0);
    message += QString("Sub cpp: %1 ms\n").arg((double) time_sub_cpp, 0, 'f', 0);
    message += QString("Sub asm: %1 ms\n").arg((double) time_sub_asm, 0, 'f', 0);

    QMessageBox::information(NULL, "Сравнение времён", message);
}
