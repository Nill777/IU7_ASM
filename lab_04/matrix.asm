.386
PUBLIC GET_WIDTH
PUBLIC GET_HEIGHT
PUBLIC SCANF_MATRIX
PUBLIC PROCESS_MATRIX
PUBLIC PRINT_MATRIX
PUBLIC matrix

code SEGMENT para USE16 PUBLIC 'code'
	assume CS:code, DS:data, SS:stack

GET_WIDTH proc near
    push ax
    mov ah, 01h
    int 21h
    xor ah, ah
    sub ax, '0'
    mov wigth, ax
    pop ax
    ret
GET_WIDTH endp

GET_HEIGHT proc near
    push ax
    mov ah, 01h
    int 21h
    xor ah, ah
    sub ax, '0'
    mov height, ax
    pop ax
    ret
GET_HEIGHT endp

SCANF_MATRIX proc near
    pusha
    xor cx, cx
    xor dx, dx
    xor si, si
    scanf_values:
        mov ah, 01h
        int 21h
        sub al, '0'
        mov matrix[si], al

        mov bl, dl
        mov ah, 02h
        mov dl, ' '
        int 21h
        mov dl, bl

        inc si
        inc cx
        cmp cx, wigth
        jnz scanf_values

        mov bl, dl
        mov ah, 02h
        mov dl, 0Ah
        int 21h
        mov dl, bl

        mov bx, 9
        sub bx, wigth
        add si, bx
        xor cx, cx
        inc dx
        cmp dx, height
        jnz scanf_values
    popa
    ret
SCANF_MATRIX endp

process_matrix proc near
    pusha
    cmp height, 1
    je skip
    xor cx, cx  ; сдвиг индекса в текущей строке
    xor dx, dx  ; сдвиг для перехода по строкам
    xor si, si  ; накопительный сдвиг для самого индексирования

    process:
        mov bx, 9
        mov al, matrix[si+bx]
        sub matrix[si], al

        inc si
        inc cx
        cmp cx, wigth
        jnz process

        sub bx, wigth
        add si, bx
        xor cx, cx
        inc dx
        mov ax, height
        dec ax
        cmp dx, ax
        jnz process
    skip:
    popa
    ret
process_matrix endp

PRINT_MATRIX proc near
    pusha
    xor ax, ax
    xor cx, cx  ; сдвиг индекса в текущей строке
    xor dx, dx  ; сдвиг для перехода по строкам
    xor si, si  ; накопительный сдвиг для самого индексирования
    print:
        ; проверка если элемент меньше 0
        cmp matrix[si], 0
        jge not_negative    ; >=
        ; если меньше 0, сделать 0
        mov matrix[si], 0
        not_negative:
            mov bl, matrix[si]
            add bl, '0'

            mov bh, dl
            mov ah, 02h     ; в AL записывается номер записанного символа (прокляну)
            mov dl, bl
            int 21h
            mov dl, ' '
            int 21h
            mov dl, bh

            inc si
            inc cx
            cmp cx, wigth
            jnz print

        mov bh, dl
        mov ah, 02h
        mov dl, 0Ah
        int 21h
        mov dl, bh

        mov bx, 9
        sub bx, wigth
        add si, bx

        xor cx, cx
        inc dx
        cmp dx, height
        jnz print
    popa
    ret
PRINT_MATRIX endp
    
code ends
data SEGMENT byte USE16 PUBLIC 'data'
    matrix db 81 dup(0)
    wigth dw 0
    height dw 0
data ends
stack SEGMENT para USE16 STACK 'stack'
    db 100h DUP (?)
stack ends
END
