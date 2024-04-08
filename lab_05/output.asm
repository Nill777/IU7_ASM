.386
PUBLIC NEW_LINE
PUBLIC OUTPUT_UNSIGNED_HEX
PUBLIC OUTPUT_TRUNCATE_BIN
PUBLIC OUTPUT_MIN_DEGREE_TWO

PUBLIC rev_degree

EXTRN TO_UNSIGNED_HEX: near
EXTRN TO_TRUNCATE_BIN: near
EXTRN MIN_DEGREE_TWO: near
EXTRN CLEAR: near

EXTRN len_hex: byte
EXTRN snumber_hex: byte
EXTRN len_bin: byte
EXTRN snumber_bin: byte
EXTRN degree: byte

EXTRN neg_sign: byte
EXTRN conv_number: word


code SEGMENT para USE16 PUBLIC 'code'
    assume CS:code, DS:data

NEW_LINE proc near
    mov AH, 02h
    mov DL, 0Dh
    int 21h
    mov DL, 0Ah
    int 21h
    ret
NEW_LINE endp

; OUTPUT_DEGREE proc near
;     mov AL, degree
;     mov BL, 10
;     mov SI, 1
;     ; dec degree
;     NEXT_DIGIT:
;         xor AH, AH
;         div BL

;         ; mov DH, AL
;         mov DL, AH
;         add DL, '0'
;         mov sdegree[SI], AL
;         dec SI
;         ; mov AH, 02h
;         ; int 21h
;         ; mov AL, DH

;         cmp AL, 0
;         jne NEXT_DIGIT
;     ret
; OUTPUT_DEGREE endp

REVERSE_DEGREE proc near
    xor AH, AH
    mov AL, degree
    mov BL, 10

    NEXT_DIG:
        xor AH, AH
        div BL

        mov DX, AX
        mov AL, rev_degree
        mul BL              ; портит AH
        mov rev_degree, AL  ; не переполнимся
        mov AX, DX

        add rev_degree, AH
        cmp AL, 0
        jne NEXT_DIG
    ret
            
REVERSE_DEGREE endp

OUTPUT_REV_DEGREE proc near
    mov AL, rev_degree
    mov BL, 10

    NEXT_DIGIT:
        xor AH, AH
        div BL

        mov DH, AL
        mov DL, AH
        add DL, '0'
        mov AH, 02h
        int 21h
        mov AL, DH

        cmp AL, 0
        jne NEXT_DIGIT

    cmp degree, 9
    ja ADD_NULL    ; >
    BACK:
    ret

    ADD_NULL:       ; для 10
        xor AH, AH
        mov AL, degree
        div BL

        cmp AH, 0
        jne BACK

        mov DL, '0'
        mov AH, 02h
        int 21h
        jmp BACK
OUTPUT_REV_DEGREE endp

OUTPUT_UNSIGNED_HEX proc near
    call CLEAR
    call TO_UNSIGNED_HEX

    mov AH, 09h
    mov DX, offset msg_unsigned_hex
    int 21h

    mov AH, 09h
    mov DX, offset snumber_hex
    int 21h

    call NEW_LINE
    ret
OUTPUT_UNSIGNED_HEX endp

OUTPUT_TRUNCATE_BIN proc near
    call CLEAR
    call TO_TRUNCATE_BIN

    mov AH, 09h
    mov DX, offset msg_truncate_bin
    int 21h

    cmp neg_sign, 1
    je NEGATIVE
    mov DL, '-'
    jmp POSITIVE
    NEGATIVE:
        mov DL, '+'
    POSITIVE:
    mov AH, 02h
    int 21h

    mov AH, 09h
    mov DX, offset snumber_bin
    int 21h

    call NEW_LINE
    ret
OUTPUT_TRUNCATE_BIN endp

OUTPUT_MIN_DEGREE_TWO proc near
    call CLEAR
    call MIN_DEGREE_TWO

    mov AH, 09h
    mov DX, offset msg_min_degree_two
    int 21h

    call REVERSE_DEGREE
    call OUTPUT_REV_DEGREE
    call NEW_LINE
    ret
OUTPUT_MIN_DEGREE_TWO endp

code ends

data SEGMENT byte USE16 PUBLIC 'data'
    msg_unsigned_hex db "Unsigned hex: $"
    msg_truncate_bin db "Truncate bin: $"
    msg_min_degree_two db "Min degree 2: $"
    rev_degree db 0
data ends
END
