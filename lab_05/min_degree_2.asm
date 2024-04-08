.386
PUBLIC MIN_DEGREE_TWO

PUBLIC degree

EXTRN conv_number: word

code SEGMENT para USE16 PUBLIC 'code'
    assume CS:code, DS:data
MIN_DEGREE_TWO proc near
    ; push AX
    ; push BX
    mov AX, 1
    mov BX, 2
    FIND:
        cmp conv_number, AX
        jb FOUND    ; <        
        mul BX
        inc degree
        jmp FIND

	; pop BX
    ; pop AX
    FOUND:
    ret
MIN_DEGREE_TWO endp
code ends

data SEGMENT byte USE16 PUBLIC 'data'
    degree db 0
data ends
END
