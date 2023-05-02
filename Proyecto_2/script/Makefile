all: algorithm.asm
	nasm -f elf64 -o algorithm.o algorithm.asm -g
	ld algorithm.o -o algorithm