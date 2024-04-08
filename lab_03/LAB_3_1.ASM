.MODEL SMALL
EXTRN MY_PRINT: near
StkSeg SEGMENT PARA STACK 'STACK'
    DB 200h DUP (?)
StkSeg ENDS
DSEG SEGMENT BYTE PUBLIC 'DATA'
    MESSAGE1 DB "Input str:", 0Dh, 0Ah, '$'
    MESSAGE2 DB "Result:", 0Dh, 0Ah, '$'
    INPUT    DW 22 DUP(?)
    OUTPUT   DW 10 DUP(?)
    X DB 2
DSEG ENDS
CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, DS:DSEG
START:
    MOV     AX, DSEG
    MOV     DS, AX
    
    MOV     AH, 09H         
    MOV     DX, OFFSET MESSAGE1    
    INT     21H
    
    MOV     AH, 3FH             ;Ввод строки с клавиатуры
    MOV     BX, 0               ;0 - дескриптор входного потока
    MOV     CX, 20              ;Максимальная допустимая длина строки
    MOV     DX, OFFSET INPUT    ;Адрес для записи строки
    INT     21H
    
    SUB     AL, 2           ;Вычитаем 2, избавляясь от символов 0Dh, 0Ah в конце
    MOV     AH, 0           ;Дополняем AL до AX чтобы делить слово на байт
    
    DIV     X               ;Получаем количество символов для новой строки 
    MOV     AH, 0           ;Дополняем AL до слова для использования AX
    MOV     DI, AX          ;Длина введёной строки в DI
    
    MOV     CX, DI
    MOV     SI, 0           ;Индекс символа в исходной строке
    
    call MY_PRINT
    
    MOV     AH, 4CH
    INT     21H
CSEG ENDS

PUBLIC INPUT
PUBLIC OUTPUT
PUBLIC MESSAGE2

END START