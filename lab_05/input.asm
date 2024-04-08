.386
PUBLIC INPUT
PUBLIC CLEAR
PUBLIC max_size
PUBLIC len
PUBLIC number
PUBLIC conv_number
PUBLIC neg_sign

EXTRN NEW_LINE: near
; for cleaning
EXTRN len_hex: byte
EXTRN snumber_hex: byte
EXTRN len_bin: byte
EXTRN buffer: byte
EXTRN snumber_bin: byte
EXTRN degree: byte
EXTRN rev_degree: byte


code SEGMENT para USE16 PUBLIC 'code'
    assume CS:code, DS:data

CLEAR proc near
    ; converting
    mov len_hex, 0

    mov AX, seg snumber_hex
    mov ES, AX
    mov DI, offset snumber_hex
    mov AL, '0'
    mov CX, 4
    rep stosb

    mov len_bin, 0

    mov AX, seg buffer
    mov ES, AX
    mov DI, offset buffer
    mov AL, '0'
    mov CX, 16
    rep stosb

    mov AX, seg snumber_bin
    mov ES, AX
    mov DI, offset snumber_bin
    mov AL, '0'
    mov CX, 8
    rep stosb

    ; min_degree
    mov degree, 0

    ; output
    mov rev_degree, 0
    ret
CLEAR endp

CLEAR_ALL proc near
    ; input
    mov len, 0

    mov AX, seg number
    mov ES, AX
    mov DI, offset number
    mov AL, "$"
    mov CX, 9
    rep stosb       ; заполнить массив

    mov conv_number, 0
    mov neg_sign, 0

    ; converting
    mov len_hex, 0

    mov AX, seg snumber_hex
    mov ES, AX
    mov DI, offset snumber_hex
    mov AL, '0'
    mov CX, 4
    rep stosb

    mov len_bin, 0

    mov AX, seg buffer
    mov ES, AX
    mov DI, offset buffer
    mov AL, '0'
    mov CX, 16
    rep stosb

    mov AX, seg snumber_bin
    mov ES, AX
    mov DI, offset snumber_bin
    mov AL, '0'
    mov CX, 8
    rep stosb

    ; min_degree
    mov degree, 0

    ; output
    mov rev_degree, 0
    ret
CLEAR_ALL endp

TO_NUMB proc near
    xor CX, CX
    mov CL, len
    dec CX          ; чтобы съесть переход на новую строку 
    ; чтобы loop сделал на 1 итерацию больше
    ; (0 - знак, последний - символ перехода)
    ; без знака нормально не отработает, знак обязателен!!!
    mov SI, CX

    mov BX, 1

    CONVERT:
        xor AX, AX
        mov AL, number[SI]
        sub AL, '0'
        mul BX
        add conv_number, AX

        mov AX, BX
        mov BX, 10
        mul BX
        mov BX, AX

        dec SI
        loop CONVERT

    cmp number, '-'
    jne POSITIVE
    mov neg_sign, 1
    ; add conv_number, AX
    ; mov BX, -1
    ; mov AX, conv_number
    ; mul BX
    ; mov conv_number, AX

    POSITIVE:
    ret
TO_NUMB endp

INPUT proc near
    call CLEAR_ALL

    mov AH, 09h
    mov DX, offset msg_input
    int 21h

    mov AH, 0Ah
    mov DX, offset max_size
    int 21h

    call TO_NUMB
	ret
INPUT endp

code ends

data SEGMENT byte USE16 PUBLIC 'data'
    max_size db 8
    len db 0
    number db 9 DUP ('$')
    conv_number dw 0
    neg_sign db 0
    msg_input db "Input number ([-32767; +32767] at 10 s/s): $" ; 2^15 - 1 (-32767, 32767)
data ends

END
