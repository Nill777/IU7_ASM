#!/bin/bash

g++ -masm=intel -c cmp_asm_cpp.cpp
g++ -o app.exe cmp_asm_cpp.o -lm
