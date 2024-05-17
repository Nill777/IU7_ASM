bits 64
global main

%define GTK_WIN_POS_CENTER 1
%define GTK_WIN_WIDTH 400
%define GTK_WIN_HEIGHT 300
%define GTK_ORIENTATION_VERTICAL 1
%define GTK_ORIENTATION_HORIZONTAL 2

extern exit
extern gtk_init
extern gtk_main
extern g_object_set
extern gtk_main_quit
extern gtk_window_new
extern gtk_widget_show_all
extern g_signal_connect
extern gtk_window_set_title
extern g_signal_connect_data
extern gtk_window_set_position
extern gtk_settings_get_default
extern gtk_window_set_default_size
extern gtk_box_new
extern gtk_entry_new
extern gtk_box_pack_start
extern gtk_entry_set_text
extern gtk_container_add
extern gtk_button_new_with_label
extern gtk_label_new
extern gtk_box_pack_end

extern gtk_grid_new
extern gtk_grid_attach

section .bss
    window: resq 1
    vbox: resq 1
    grid: resq 1

    lable_x0: resq 1
    lable_x1: resq 1
    lable_iter: resq 1

    entry_x0: resq 1
    entry_x1: resq 1
    entry_iter: resq 1

    button: resq 1
    label_x0_utf8: resq 1
    label_x1_utf8: resq 1
    label_iter_utf8: resq 1
section .rodata
    signal:
    .destroy:   db "destroy", 0
    title:      db "Lab_10", 0

    text_label_x0: db "x_0: ", 0
    text_label_x1: db "x_1: ", 0
    text_label_iter: db "iter: ", 0

    button_label: db "Вычислить корень", 0

section .text
    _destroy_window:
        jmp gtk_main_quit

    main:
        push rbp
        mov rbp, rsp
        xor rdi, rdi
        xor rsi, rsi
        call gtk_init

        xor rdi, rdi
        call gtk_window_new
        mov qword [rel window], rax     ;rel - адрес vbox будет вычислен относительно текущего положения инструкции
        mov rdi, rax
        mov rsi, title
        call gtk_window_set_title

        mov rdi, qword [rel window]
        mov rsi, GTK_WIN_WIDTH
        mov rdx, GTK_WIN_HEIGHT
        call gtk_window_set_default_size

        mov rdi, qword [rel window]
        mov rsi, GTK_WIN_POS_CENTER
        call gtk_window_set_position


        ; ; Create a vertical box
        ; mov edi, 0x2
        ; xor rdi, rdi
        ; call gtk_box_new
        ; mov qword [rel vbox], rax ;rel - адрес vbox будет вычислен относительно текущего положения инструкции

        ; ; Attach the box to the window
        ; mov rdi, [window]
        ; mov rsi, [vbox]
        ; call gtk_container_add
        

        ; Создание вертикального контейнера
        mov rdi, GTK_ORIENTATION_VERTICAL
        call gtk_box_new
        mov qword [rel vbox], rax


        ; Создание grid
        call gtk_grid_new
        mov qword [rel grid], rax

        ; ; Добавление элементов в grid
        ; ; Строка 1
        ; mov rdi, text_label_x0
        ; call gtk_label_new
        ; mov rdi, qword [rel grid]
        ; mov rsi, rax
        ; mov rdx, 0  ; row
        ; mov rcx, 0  ; column
        ; call gtk_grid_attach

        ; Добавление элементов в grid
        ; Строка 1
        mov rdi, text_label_x0
        call gtk_label_new
        mov qword [rel lable_x0], rax  ; Сохраняем адрес label в переменной
        mov rdi, qword [rel grid]
        mov rsi, qword [rel lable_x0]  ; Используем сохраненный адрес
        mov rdx, 0  ; row
        mov rcx, 0  ; column
        call gtk_grid_attach

        ; ; Строка 1
        ; mov rdi, text_label_x0
        ; mov rsi, -1
        ; mov rdx, 0
        ; call g_convert_to_instance
        ; mov qword [rel label_x0_utf8], rax
        ; mov rdi, rax
        ; call gtk_label_new
        ; mov qword [rel lable_x0], rax
        ; mov rdi, qword [rel grid]
        ; mov rsi, qword [rel lable_x0]
        ; mov rdx, 0  ; row
        ; mov rcx, 0  ; column
        ; call gtk_grid_attach

        ; mov rdi, entry_x0
        call gtk_entry_new
        mov qword [rel entry_x0], rax  ; Сохраняем адрес label в переменной
        mov rdi, qword [rel grid]
        mov rsi, qword [rel entry_x0]  ; Используем сохраненный адрес
        ; mov rdi, qword [rel grid]
        ; mov rsi, rax
        mov rdx, 0  ; row
        mov rcx, 1  ; column
        call gtk_grid_attach

        ; ; Строка 2
        ; mov rdi, text_label_x1
        ; call gtk_label_new
        ; mov rdi, qword [rel grid]
        ; mov rsi, rax
        ; mov rdx, 1  ; row
        ; mov rcx, 0  ; column
        ; call gtk_grid_attach

        ; ; mov rdi, entry_x1
        ; call gtk_entry_new
        ; mov rdi, qword [rel grid]
        ; mov rsi, rax
        ; mov rdx, 1  ; row
        ; mov rcx, 1  ; column
        ; call gtk_grid_attach

        ; ; Строка 3
        ; mov rdi, text_label_iter
        ; call gtk_label_new
        ; mov rdi, qword [rel grid]
        ; mov rsi, rax
        ; mov rdx, 2  ; row
        ; mov rcx, 0  ; column
        ; call gtk_grid_attach

        ; ; mov rdi, entry_iter
        ; call gtk_entry_new
        ; mov rdi, qword [rel grid]
        ; mov rsi, rax
        ; mov rdx, 2  ; row
        ; mov rcx, 1  ; column
        ; call gtk_grid_attach

        ; Добавление grid в вертикальный контейнер
        mov rdi, qword [rel vbox]
        mov rsi, qword [rel grid]
        call gtk_container_add

        ; ; Сетка (grid)
        ; mov rdi, grid
        ; call gtk_grid_new
        ; mov qword [rel grid], rax
        ; mov rdi, rax
        ; mov rsi, 2
        ; mov rdx, 2
        ; call gtk_grid_set_row_spacing
        ; call gtk_grid_set_column_spacing
        ; mov rdi, qword [rel main_box]
        ; mov rsi, rax
        ; call gtk_container_add

        ; ; Add label to grid
        ; mov rdi, label_x0
        ; call gtk_label_new
        ; mov rdi, qword [rel grid]
        ; mov rsi, rax
        ; mov rdx, 0
        ; mov rcx, 0
        ; mov r8d, 1
        ; mov r9d, 1
        ; call gtk_grid_attach


        ; Создание кнопки
        mov rdi, button_label
        call gtk_button_new_with_label
        mov qword [rel button], rax  ; Сохраняем адрес label в переменной
        mov rdi, qword [rel vbox]
        mov rsi, qword [rel button]  ; Используем сохраненный адрес
        ; mov rdi, qword [rel vbox]
        ; mov rsi, rax
        call gtk_container_add

        ; Добавление вертикального контейнера в окно
        mov rdi, qword [rel window]
        mov rsi, qword [rel vbox]
        call gtk_container_add
        ; ; Create and add the first entry
        ; xor rdi, rdi
        ; call gtk_entry_new
        ; mov qword [rel entry1], rax
        ; mov rdi, rax
        ; mov rsi, entry1_label
        ; call gtk_entry_set_text
        ; mov rdi, qword [rel vbox]
        ; mov rsi, rax
        ; call gtk_box_pack_start

        ; ; Create and add the second entry
        ; xor rdi, rdi
        ; call gtk_entry_new
        ; mov qword [rel entry2], rax
        ; mov rdi, rax
        ; mov rsi, entry2_label
        ; call gtk_entry_set_text
        ; mov rdi, qword [rel vbox]
        ; mov rsi, rax
        ; call gtk_box_pack_start

        ; ; Create and add the label
        ; xor rdi, rdi
        ; call gtk_label_new
        ; mov qword [rel label], rax
        ; mov rdi, rax
        ; mov rsi, label_text
        ; call g_object_set

        ; mov rdi, qword [rel vbox]
        ; mov rsi, rax
        ; call gtk_box_pack_start

        ; ; Create and add the button
        ; xor rdi, rdi
        ; mov rsi, button_label
        ; call gtk_button_new_with_label
        ; mov qword [rel button], rax
        ; mov rdi, qword [rel vbox]
        ; mov rsi, rax
        ; call gtk_box_pack_end

        ; mov rdi, qword [rel window]
        ; mov rsi, qword [rel vbox]
        ; call gtk_container_add


        mov rdi, qword [rel window]
        mov rsi, signal.destroy
        mov rdx, _destroy_window
        xor rcx, rcx
        xor r8d, r8d
        xor r9d, r9d
        call g_signal_connect_data

        mov rdi, qword [rel window]
        call gtk_widget_show_all
        call gtk_main
        ret
