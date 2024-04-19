#!/bin/bash

gcc -c -masm=intel -o main.o main.c
gcc main.o copy.o
