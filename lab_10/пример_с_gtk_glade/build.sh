#!/bin/bash

# nasm -f elf64 -o main.o main.asm
gcc -o main.o -c main.c $(pkg-config --cflags --libs gtk+-3.0)
gcc main.o $(pkg-config --cflags --libs gtk+-3.0) -o app.exe -no-pie

# patchelf --replace-needed /snap/core20/current/lib/x86_64-linux-gnu/libpthread.so.0 /usr/lib/libpthread.so.0 app.exe
# gcc -o main.o -c main.c `pkg-config --cflags --libs gtk+-3.0`
# gcc main.o `pkg-config --cflags --libs gtk+-3.0` -o app.exe
# gcc -o app.exe $(pkg-config --cflags --libs gtk+-3.0) main.c
# gcc example.c $(pkg-config --cflags --libs gtk+-3.0 girara-gtk3)
# gcc -static main.o -L/usr/lib/x86_64-linux-gnu -o app.exe -no-pie
# gcc main.o $(pkg-config --libs gtk+-3.0) -o app.exe -no-pie
# gcc -static main.o -L /usr/lib/x86_64-linux-gnu -o app.exe
# gcc main.o $(pkg-config --libs gtk+-3.0) -o app.exe
