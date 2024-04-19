#!/bin/bash

nasm -f elf64 -o my_strncpy.o my_strncpy.asm
gcc -c -masm=intel -c main.c my_strlen.c
gcc -o app.exe main.o my_strlen.o my_strncpy.o -lm
