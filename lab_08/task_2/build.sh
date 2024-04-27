#!/bin/bash

g++ -masm=intel -c main.cpp sin.cpp
g++ -o app.exe main.o sin.o -lm
