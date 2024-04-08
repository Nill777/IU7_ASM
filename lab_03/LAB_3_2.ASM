PUBLIC MY_PRINT

EXTRN INPUT: WORD
EXTRN OUTPUT: WORD
EXTRN MESSAGE2: BYTE

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG

MY_PRINT proc near
    PUSH    INPUT[SI]       ;Сохраняем в стек символ для копирования
        
    MOV     BX, DI          ;Вычисляем индекс символа
    SUB     BX, CX          ;в новой строке
  
    POP     OUTPUT[BX]      ;Извлекаем символ из стека в новую строку
    ADD     SI, 3           
    LOOP    MY_PRINT         

    MOV     AH, 09H         
    MOV     DX, OFFSET MESSAGE2
    INT     21H
    
    MOV     AH, 40H                 ;Вывод результирующей строки
    MOV     BX, 1                   ;1 - дескриптор выходного потока
    MOV     CX, DI                  ;Длина выводимой строки
    MOV     DX, OFFSET OUTPUT       ;Адрес строки
    INT     21H
    RET

MY_PRINT endp
CSEG ENDS
END