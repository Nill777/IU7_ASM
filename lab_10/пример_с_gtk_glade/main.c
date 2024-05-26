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
