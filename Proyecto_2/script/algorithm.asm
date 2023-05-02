global _start

    section .data
    
    section .bss
    lup resw 1

    section .text

_start:
    mov WORD [lup], 841

    mov WORD [lup+4], 909

    mov WORD [lup+8], 141

    mov WORD [lup+12], -757

    mov WORD [lup+16], -959

    mov WORD [lup+20], -279

    mov WORD [lup+24], 657

    mov WORD [lup+28], 989

    mov WORD [lup+32], 412

    mov WORD [lup+36], -544

    mov WORD [lup+40], -1000

    mov WORD [lup+44], -537

    mov WORD [lup+48], 420

    mov WORD [lup+52], 991

    mov WORD [lup+56], 650

    mov WORD [lup+60], -288

    mov WORD [lup+64], -961

    mov WORD [lup+68], -751

    mov WORD [lup+72], 150

    mov WORD [lup+74], 913

    mov WORD [lup+78], 837

    mov WORD [lup+82], -9

    mov WORD [lup+86], -846

    mov WORD [lup+90], -906

    mov WORD [lup+94], -132

    mov WORD [lup+98], 763

    ; x = eax
    ; y = ecx
    mov eax, 1
    mov ecx, 1

x_loop:
    mov ecx, 1 ; y = 1 
    cmp eax, 301 ; fin for anidado
    je  end

y_loop:
    ; codigo
    add ecx, 1 ; y++
    cmp ecx, 301
    je  x_sum
    jmp y_loop

x_sum:
    add eax, 1 ; x++
    jmp x_loop

end:
    mov rax, 60 ; system call 60: sys_exit
    mov rdi, 0
    syscall
