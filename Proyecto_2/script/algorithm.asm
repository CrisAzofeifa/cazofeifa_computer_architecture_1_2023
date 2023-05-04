global _start

    section .data
    
    section .bss
    lup resw 1

    Lx resw 1
    Ly resw 1

    section .text

_start:
   mov WORD [lup], 478

    mov WORD [lup+4], 958

    mov WORD [lup+8], 587

    mov WORD [lup+12], -319

    mov WORD [lup+16], -930

    mov WORD [lup+20], -692

    mov WORD [lup+24], 187

    mov WORD [lup+28], 896

    mov WORD [lup+32], 775

    mov WORD [lup+36], -53

    mov WORD [lup+40], -832

    mov WORD [lup+44], -852

    mov WORD [lup+48], -82

    mov WORD [lup+52], 762

    mov WORD [lup+56], 900

    mov WORD [lup+60], -217

    mov WORD [lup+64], -667

    mov WORD [lup+68], -943

    mov WORD [lup+72], -345

    mov WORD [lup+76], 567

    mov WORD [lup+80], 954

    mov WORD [lup+84], 471

    mov WORD [lup+88], -449

    mov WORD [lup+92], -959

    mov WORD [lup+96], -906

    mov esi, 1              ; x = esi
    mov edi, 1              ; y = edi
    mov r8d, 75             ; Lx = Ly = r8d
    mov r9d, 5              ; k = r9d

rippling_loop:
    mov esi, 1              ; x = esi
    mov edi, 1              ; y = edi
    cmp r9d, 15            ; fin for anidado k, x y y
    je end

x_loop:
    mov edi, 1              ; y = 1 
    cmp esi, 2            ; fin for anidado x y y
    je  k_sum

y_loop:
    mov  eax, 6
    imul eax, edi           ; 6*y = 2*pi*y
    ; eax = 2*pi*y  dividendo
    mov ecx, r8d            ; divisor
    div ecx                 ; resultado eax = 2*pi*y / Lx
    imul eax, 4             ; indice para saber que valor escoger de la LUT
    mov eax, [lup + eax]    ; sin(2*pi*y/Lx) * 1000

    ;TODO: xaux

    mov eax, 0
    mov edx, 0

    mov  eax, 6
    imul eax, esi           ; 6*x = 2*pi*x
    ; eax = 2*pi*x  dividendo
    div ecx                 ; resultado eax = 2*pi*x / Ly
    imul eax, 4             ;indice para saber que valor escoger de la LUT
    mov eax, [lup + eax]    ;sin(2*pi*x/Ly) * 1000

    ;TODO: yaux

    ;TODO: pendiente linea 22

division:
    ; codigo
    add edi, 1              ; y++
    cmp edi, 2            ;fin for y
    je  x_sum
    jmp y_loop

x_sum:
    add esi, 1              ; x++
    jmp x_loop

k_sum:
    add r9d, 5              ; k += 5
    jmp rippling_loop
    
end:
    mov rax, 60 ; system call 60: sys_exit
    mov rdi, 0
    syscall
