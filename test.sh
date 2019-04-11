#!/bin/bash
rm -r MMp1c-es
rm -r MMp1c-es.o
yasm -f elf64 -g dwarf2 MMp1-es.asm
gcc -no-pie -g -o MMp1c-es MMp1-es.o MMp1c-es.c
./MMp1c-es

