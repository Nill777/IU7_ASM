// #include <gtk/gtk.h>

// static void activate(GtkApplication *app, gpointer user_data) {
//     GtkWidget *window;
//     GtkWidget *button;
//     GtkWidget *box;

//     window = gtk_application_window_new(app);
//     gtk_window_set_title(GTK_WINDOW(window), "Мое GTK+ приложение");
//     gtk_window_set_default_size(GTK_WINDOW(window), 300, 200);

//     box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 5);
//     gtk_container_add(GTK_CONTAINER(window), box);

//     button = gtk_button_new_with_label("Нажми меня");
//     g_signal_connect(button, "clicked", G_CALLBACK(gtk_window_close), window);
//     gtk_box_pack_start(GTK_BOX(box), button, TRUE, TRUE, 0);

//     gtk_widget_show_all(window);
// }

// int main(int argc, char *argv[]) {
//     GtkApplication *app;
//     int status;

//     app = gtk_application_new(NULL, G_APPLICATION_DEFAULT_FLAGS);
//     g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);
//     status = g_application_run(G_APPLICATION(app), argc, argv);
//     g_object_unref(app);

//     return status;
// }



// #include <iostream>
// #include "secant_method.hpp"

// int main()
// {
//     double x0 = 0.5;  // Начальное приближение 1
//     double x1 = 1.5;   // Начальное приближение 2
//     double eps = 0.000001;  //Точность
//     size_t max_iter = 100;  // Максимальное число итераций
//     double root;
    
//     if (secant_method(&root, x0, x1, eps, max_iter)) {
//         printf("Корень функции cos(x^3 + 7): %.10f\n", root);
//         printf("Проверка y = cos(root^3 + 7): %.10f\n", func(root));
//     }
//     else
//         printf("Не удалось найти корень за %d итераций,",
//             "с заданной точностью %lf\n", max_iter, eps);
//     return 0;
// }

#include <gtk/gtk.h>

int main(int argc, char *argv[])
{
    GtkBuilder *builder;
    GtkWidget *window;

    gtk_init(&argc, &argv);

    // Загружаем интерфейс пользователя из файла
    builder = gtk_builder_new();
    if (gtk_builder_add_from_file(builder, "Test.glade", NULL) == 0)
    {
        fprintf(stderr, "Ошибка при загрузке файла GUI_gtk.glade\n");
        return -1;
    }

    // // Получаем главное окно из файла .glade
    window = GTK_WIDGET(gtk_builder_get_object(builder, "main_window"));
    if (window == NULL)
    {
        fprintf(stderr, "Не могу найти GtkWindow в файле glade\n");
        g_object_unref(builder);
        return -1;
    }

    g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);

    // Показываем главное окно
    gtk_widget_show(window);
    gtk_main();

    g_object_unref(builder);

    return 0;
}
