.386
comment @
Требуется составить программу на языке ассемблера, которая обеспечит ввод
матрицы, преобразования, вычесть из каждого элемента следующий
элемент в столбце, отрицательные числа
заменить на нули, и вывод изменённой
матрицы.
В программе должна быть выделена память под матрицу 9х9. Фактический размер
задаётся пользователем и не превышает 9х9.
Матрицу считать статической (как если бы в Си она была объявлена char a[9][9]) и
работать с ней соответствующим образом.
Тип “цифровая” означает, что элементом является цифра.
Для решения задачи можно вводить дополнительные переменные, в том числе
массивы.
@

EXTRN GET_WIDTH: near
EXTRN GET_HEIGHT: near
EXTRN SCANF_MATRIX: near
EXTRN PROCESS_MATRIX: near
EXTRN PRINT_MATRIX: near
EXTRN matrix: byte

code SEGMENT para USE16 PUBLIC 'code'
	assume CS:code, DS:data, SS:stack
main:
    mov ax, seg matrix
    mov ds, ax

    mov ah, 09h
    lea dx, msg_width
    int 21h
   
    call GET_WIDTH
    call new_line

    mov ah, 09h
    lea dx, msg_height
    int 21h
    
    call GET_HEIGHT
    call new_line

    mov ah, 09h
    lea dx, input
    int 21h

    call SCANF_MATRIX
    call PROCESS_MATRIX

    mov ah, 09h
    lea dx, result
    int 21h

    call PRINT_MATRIX
    call QUIT

QUIT proc near
    mov ax, 4c00h
    int 21h
QUIT endp

NEW_LINE proc near
    push ax
    push dx
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    pop dx
    pop ax
    ret
new_line endp

code ends

data SEGMENT byte USE16 PUBLIC 'data'
    msg_width db "Input width: $"
    msg_height db "Input height: $"
    input db "Input:", 0Dh, 0Ah, '$'
    result db "Result:", 0Dh, 0Ah, '$'
data ends
stack SEGMENT para USE16 STACK 'stack'
    db 100h DUP (?)
stack ends
END main
