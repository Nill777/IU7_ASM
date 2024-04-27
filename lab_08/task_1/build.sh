#!/bin/bash

g++ -masm=intel -c main.cpp cout_time.cpp
g++ -o app.exe main.o cout_time.o -lm
