.386
PUBLIC TO_UNSIGNED_HEX
PUBLIC TO_TRUNCATE_BIN

PUBLIC len_hex
PUBLIC snumber_hex
PUBLIC len_bin
PUBLIC snumber_bin
PUBLIC buffer

EXTRN max_size: byte
EXTRN len: byte
EXTRN number: byte
EXTRN conv_number: word
EXTRN neg_sign: byte

code SEGMENT para USE16 PUBLIC 'code'
    assume CS:code, DS:data
TO_UNSIGNED_HEX proc near
    xor CX, CX
    mov BX, 16
    mov SI, 3
    mov AX, conv_number
    
    cmp neg_sign, 1
    jne NOT_INVERT 
    neg AX  ;
    NOT_INVERT:
    ; add AX, 1
    xor DX, DX

    TO_HEX:
        div BX
        mov snumber_hex[SI], DL

        cmp DL, 9 
        jg HEX_SYMBOL   ; >
        add snumber_hex[SI], '0'

        BACK:
        xor DX, DX
        inc len_hex

        dec SI
        cmp AX, 0
        jne TO_HEX

    ret

    HEX_SYMBOL:
        add snumber_hex[SI], 55
        jmp BACK
TO_UNSIGNED_HEX endp

TO_TRUNCATE_BIN proc near
    mov AX, conv_number ;
    sub AX, 1

    mov SI, 15
    xor DX, DX
    mov BX, 2

    TO_BIN:
        div BX
        mov buffer[SI], DL
        add buffer[SI], '0'
        xor DX, DX
        inc len_bin

        dec SI
        cmp AX, 0
        jne TO_BIN

    mov SI, 15
    SHIFT:
        mov BL, buffer[SI]
        cmp BL, '0'
        jne NEG_NUMBER
        add BL, 1
        CBACK:
        mov snumber_bin[SI - 8], BL

        dec SI
        cmp SI, 7
        jne SHIFT
    ; neg
    ret
    NEG_NUMBER:
        sub BL, 1
        jmp CBACK
TO_TRUNCATE_BIN endp
code ends
; 00A4$
; +/-00011010$
data SEGMENT byte USE16 PUBLIC 'data'
    len_hex db 0
    snumber_hex db 4 DUP ('0')
                db '$'
    len_bin db 0
    buffer db 16 DUP ('0')
            db '$'
    snumber_bin db 8 DUP ('0')
                db '$'
data ends
END
