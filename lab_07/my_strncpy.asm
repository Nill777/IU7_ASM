global my_strncpy
section .text
; rdx - len
; rsi - src
; rdi - dst

; без перекрытия:
; src dst
; dst src
; с перекрытием:
; src == dst
; src dst
; dst src

my_strncpy:
    xor bl, 0   ; флаг для dst src
    mov rcx, rdx         ; в rcx количество символов для копирования
    cmp rsi, rdi         
    ; ==
    je exit     ; строки совпали, выходим
    jne not_equal       ; переходим к проверкам на перекрытие

not_equal:
    cmp rsi, rdi
    ; >
    jg greater
    ; <
    mov rax, rdi
    sub rax, rsi         ; rax число символов между rsi и rdi
    cmp rax, rcx         ; достаточно места?
    jge simple_copy      ; не перекрываются

    ; перекрываются
    add rdi, rcx         ; указатель dst в конец dst
    add rsi, rcx         ; указатель src в конец src
    ; т.к. '\0' уже затрём
    dec rsi
    dec rdi
    std     ; флаг направления строки, обратный ход

simple_copy:
    ; копируем rcx байт из rsi в rdi, rep автоматически изменяет rsi и rdi
    ; увеличиваются на 1, если флаг DF = 0, или уменьшаются на 1, если DF = 1
    rep movsb
    
    ; чтобы дописать '\0' в конец строки
    cmp bl, 1
    jne exit
    mov byte [rdi], 0 

    cld     ; сбросить флаг направления строки (DF = 0)
exit:
    ret

greater:
    mov rax, rdi
    sub rax, rsi         ; rax число символов между rsi и rdi
    cmp rax, rcx         ; достаточно места?
    jge simple_copy      ; не перекрываются
    
    mov bl, 1            ; перекрываются
    jmp simple_copy
