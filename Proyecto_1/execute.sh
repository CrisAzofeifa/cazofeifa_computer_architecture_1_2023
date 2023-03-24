#! /bin/bash
nasm -felf64 -o x86_code.o x86_code.asm && ld -o x86_code x86_code.o && ./x86_code
python3 ./FinImagen.py
python3 ./Interfaz.py