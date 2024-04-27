#!/bin/bash

g++ -masm=intel -c main.cpp secant_method.cpp
g++ -o app.exe main.o secant_method.o -lm
