.386
comment @
Требуется составить программу, которая будет осуществлять:
● ввод 16-разрядного числа (знаковое в 10 с/с);
● вывод его беззнаковое в 16 с/с;
● усечённое до 8 разрядов значение (аналогично приведению типа int к char в
языке C) знаковое в 2 с/с;
● задание на применение команд побитовой обработки: 2-й вариант - минимальная степень
двойки, которая превышает введённое число в беззнаковой интерпретации.

Взаимодействие с пользователем должно строиться ͇н͇а͇ ͇о͇с͇н͇о͇в͇е͇ ͇м͇е͇н͇ю. Программа
должна содержать не менее ͇п͇я͇т͇и͇ ͇м͇о͇д͇у͇л͇е͇й͇. Главный модуль должен обеспечивать
͇в͇ы͇в͇о͇д͇ ͇м͇е͇н͇ю͇,͇ ͇а͇ ͇т͇а͇к͇ж͇е͇ ͇с͇о͇д͇е͇р͇ж͇а͇т͇ь͇ ͇м͇а͇с͇с͇и͇в͇ ͇у͇к͇а͇з͇а͇т͇е͇л͇е͇й͇ ͇н͇а͇ ͇п͇о͇д͇п͇р͇о͇г͇р͇а͇м͇м͇ы͇, выполняющие
действия, соответствующие пунктам меню. Обработчики действий должны быть
оформлены в виде подпрограмм, находящихся каждая в отдельном модуле. Вызов
необходимой функции требуется осуществлять с помощью адресации по массиву
индексом выбранного пункта меню.
@

EXTRN NEW_LINE: near
EXTRN INPUT: near
EXTRN OUTPUT_UNSIGNED_HEX: near
EXTRN OUTPUT_TRUNCATE_BIN: near
EXTRN OUTPUT_MIN_DEGREE_TWO: near
EXTRN number: byte

code SEGMENT para USE16 PUBLIC 'code'
    assume CS:code, DS:data, SS:stack
    ; ORG 100h
    START:
        mov DX, data
        mov DS, DX

        mov funcs_ptr[0], INPUT
        mov funcs_ptr[2], OUTPUT_UNSIGNED_HEX
        mov funcs_ptr[4], OUTPUT_TRUNCATE_BIN
        mov funcs_ptr[6], OUTPUT_MIN_DEGREE_TWO
        mov funcs_ptr[8], QUIT
        
        MENU:
            mov AH, 09h
            mov DX, offset my_menu
            int 21h

            mov AH, 01h
            int 21h

            mov AH, 0
            sub AL, '1'
            mov DL, 2
            mul DL
            mov BX, AX

            call NEW_LINE
            call funcs_ptr[BX]
            call NEW_LINE

        jmp MENU

QUIT proc near
    mov AX, 4c00h
    int 21h
QUIT endp

code ends

data SEGMENT byte USE16 PUBLIC 'data'
    my_menu db "1 - input of a 16-bit number, sign is required (signed at 10 s/s)", 0Dh, 0Ah,
            "2 - output an unsigned number (at 16 s/s)", 0Dh, 0Ah,
            "3 - output value truncated to 8-bit number (signed at 2 s/s)", 0Dh, 0Ah,
            "4 - find the minimum power of 2 > number (unsigned)", 0Dh, 0Ah,
            "5 - quit", 0Dh, 0Ah, '$'
    funcs_ptr dw 5 DUP (0)
data ends
stack SEGMENT para USE16 STACK 'stack'
    db 100h DUP (?)
stack ends

END START
