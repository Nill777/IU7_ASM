.MODEL tiny
comment @
Написать резидентную программу под DOS, которая будет каждую секунду менять
скорость автоповтора ввода символов в циклическом режиме, от самой медленной до
самой быстрой. По желанию можно реализовать другой способ взаимодействия с
устройствами через порты ввода-вывода, но такой, который можно будет
наглядно продемонстрировать на сдаче лаб. работы.

Варианты вызова предшествующего обработчика прерывания:
    1. Командой дальнего вызова подпрограммы CALL в начале обработчика
    прерывания с предварительным сохранением регистра флагов в стеке.
    2. Командой дальнего безусловного перехода JMP в конце обработчика
    прерывания, сохранив адрес перехода в переменной.
    (Мой вариант)
    0. Через машинный код EA команды far JMP, сохранив адрес перехода напрямую в
    непосредственный операнд команды.

Ссылки:
int 21h http://www.codenet.ru/progr/dos/int_0026.php
прерывания DOS и BIOS http://www.codenet.ru/progr/dos/
клавиатура https://www.frolov-lib.ru/books/bsp.old/v33/ch2.htm
@

code SEGMENT para USE16 PUBLIC 'code'
    assume CS:code
    org 100h         

    MAIN:
        ;считываем адрес обработчика прерывания
        mov ah, 35h ;дать вектор прерывания
        mov al, 08h ; номер прерывания таймера в BIOS          
        int 21h        
        ;загружает в BX 0000:[AL*4], а в ES - 0000:[(AL*4)+2]. 
        ;адрес обработчика сохраняется в регистрах ES - адрес сегмента и BX - смещение

        ; if - else
        cmp es:is_install, 1      
        je SKIP_INSTALL     
        call INSTALL
        jmp SKIP_UNINSTALL
        SKIP_INSTALL:
            call UNINSTALL
        SKIP_UNINSTALL:

        speed db 00011111b      
        is_install db 1               
        time db 0           

    HANDLER proc near
        pushf   ;FLAGS, CS, IP
        mov ah, 02h         ;читать время из "постоянных" (CMOS) часов реального времени
        ; выход: CH = часы в коде BCD   (пример: CX = 1243H = 12:43)
        ;        CL = минуты в коде BCD
        ;        DH = секунды в коде BCD
        ; выход: CF = 1, если часы не работают
        int 1Ah     ;прерывание BIOS ввод-вывод для времени.

        cmp dh, time    
        je skip_set_speed 

        mov time, dh    
        dec speed           

        ;https://www.frolov-lib.ru/books/bsp.old/v33/ch2.htm
        ;Для установки характеристик режима автоповтора в порт 60h (клавиатура)
        ;необходимо записать код команды 0F3h
        mov al, 0F3h
        out 60h, al
        mov al, speed
        out 60h, al     ;выставили скорость автоповтора

        skip_set_speed:
            popf    ;FLAGS, CS, IP
            db 0EAh     ;far jmp возвращаем усправление
            sys_handler dd  0   ;адрес старого обработчика прерываний  
    HANDLER endp

    INSTALL proc        
        ;копируем изначальный обработчик (смещение)
        mov word ptr sys_handler, bx       
        ;копируем изначальный обработчик (сегмент)  
        mov word ptr sys_handler + 2, es    
        
        mov ah, 25h     ;установить вектор прерывания
        mov al, 08h           
        mov dx, offset HANDLER
        int 21h                     

        mov dx, offset install_msg             
        mov ah, 09h
        int 21h                        
                  
        mov dx, offset INSTALL  ;DX = адрес первого байта за резидентным участком программы (смещение от PSP)
        int 27h

        install_msg db 'Your handler is installed$'  
    INSTALL endp

    UNINSTALL proc
        mov dx, offset uninstall_msg             
        mov ah, 09h
        int 21h

        ;https://www.frolov-lib.ru/books/bsp.old/v33/ch2.htm
        ;Для установки характеристик режима автоповтора в порт 60h (клавиатура)
        ;необходимо записать код команды 0F3h
        mov al, 0F3h    
        out 60h, al
        ;выставляем стандартные значения
        ;устанавливаем 30 символов в секунду, пауза перед началом автоповтора 250 мс
        mov al, 0
        out 60h, al                 
        
        mov dx, word ptr es:sys_handler                       
        mov ds, word ptr es:sys_handler + 2
        mov ah, 25h     ;установить вектор прерывания
        mov al, 08h 
        int 21h                  
        ;ES = сегментный адрес (параграф) освобождаемого блока памяти
        mov ah, 49h ;освободить распределенный блок памяти
        int 21h

        mov ax, 4c00h
        int 21h

        uninstall_msg db 'Your handler is uninstalled$'
    UNINSTALL endp
code ends
END MAIN
