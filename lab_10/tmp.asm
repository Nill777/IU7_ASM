bits 64
global main
%define GTK_ORIENTATION_VERTICAL 1
%define GTK_ORIENTATION_HORIZONTAL 2
%define GTK_WIN_POS_CENTER 1
%define GTK_WIN_WIDTH 800
%define GTK_WIN_HEIGHT 600

extern exit
extern gtk_init
extern gtk_main
extern gtk_main_quit
extern gtk_window_new
extern gtk_widget_show_all
extern g_signal_connect_data
extern gtk_window_set_title
extern gtk_window_set_position
extern gtk_window_set_default_size
extern gtk_box_new
extern gtk_box_set_spacing
extern gtk_image_new_from_file
extern gtk_grid_new
extern gtk_grid_attach
extern gtk_label_new
extern gtk_container_add
extern gtk_grid_set_row_spacing
extern gtk_grid_set_column_spacing

section .bss
window:     resq 1
main_box:   resq 1
image_box:  resq 1
grid:       resq 1

section .rodata
signal:
    .destroy:   db "destroy", 0
title:          db "My GTK+ Window", 0
image_path:     db "../goose.jpg", 0

section .text
_destroy_window:
    jmp gtk_main_quit

main:
    push rbp
    mov rbp, rsp

    xor rdi, rdi
    xor rsi, rsi
    call gtk_init

    mov rdi, window
    call gtk_window_new
    mov qword [rel window], rax

    ; Main box
    mov rdi, GTK_ORIENTATION_VERTICAL
    call gtk_box_new
    mov qword [rel main_box], rax

    ; Image box
    mov rdi, GTK_ORIENTATION_HORIZONTAL
    call gtk_box_new
    mov qword [rel image_box], rax
    mov rdi, rax
    mov rsi, 1
    call gtk_box_set_spacing
    mov rdi, qword [rel main_box]
    mov rsi, rax
    call gtk_container_add

    ; Add images to image box
    mov rdi, image_path
    call gtk_image_new_from_file
    mov rdi, qword [rel image_box]
    mov rsi, rax
    call gtk_container_add

    mov rdi, image_path
    call gtk_image_new_from_file
    mov rdi, qword [rel image_box]
    mov rsi, rax
    call gtk_container_add

    mov rdi, image_path
    call gtk_image_new_from_file
    mov rdi, qword [rel image_box]
    mov rsi, rax
    call gtk_container_add

    mov rdi, image_path
    call gtk_image_new_from_file
    mov rdi, qword [rel image_box]
    mov rsi, rax
    call gtk_container_add

    mov rdi, image_path
    call gtk_image_new_from_file
    mov rdi, qword [rel image_box]
    mov rsi, rax
    call gtk_container_add

    ; Grid
    mov rdi, grid
    call gtk_grid_new
    mov qword [rel grid], rax
    mov rdi, rax
    mov rsi, 2
    mov rdx, 2
    call gtk_grid_set_row_spacing
    call gtk_grid_set_column_spacing
    mov rdi, qword [rel main_box]
    mov rsi, rax
    call gtk_container_add

    ; Add label to grid
    mov rdi, label_x0
    call gtk_label_new
    mov rdi, qword [rel grid]
    mov rsi, rax
    mov rdx, 0
    mov rcx, 0
    mov r8d, 1
    mov r9d, 1
    call gtk_grid_attach

    ; Set up window
    mov rdi, qword [rel window]
    mov rsi, title
    call gtk_window_set_title

    mov rdi, qword [rel window]
    mov rsi, GTK_WIN_WIDTH
    mov rdx, GTK_WIN_HEIGHT
    call gtk_window_set_default_size

    mov rdi, qword [rel window]
    mov rsi, GTK_WIN_POS_CENTER
    call gtk_window_set_position

    mov rdi, qword [rel window]
    mov rsi, signal.destroy
    mov rdx, _destroy_window
    xor rcx, rcx
    xor r8d, r8d
    xor r9d, r9d
    call g_signal_connect_data

    mov rdi, qword [rel main_box]
    mov rsi, 3
    call gtk_box_set_spacing

    mov rdi, qword [rel window]
    mov rsi, qword [rel main_box]
    call gtk_container_add

    mov rdi, qword [rel window]
    call gtk_widget_show_all

    call gtk_main

    leave
    ret

section .data
label_x0:   db "x_0", 0
