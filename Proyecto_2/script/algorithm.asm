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

    mov eax, 319
    neg eax
    mov [lup+12], eax
    
    mov eax, 930
    neg eax
    mov [lup+16], eax

    mov eax, 692
    neg eax
    mov [lup+20], eax

    mov WORD [lup+24], 187

    mov WORD [lup+28], 896

    mov WORD [lup+32], 775

    mov eax, 53
    neg eax
    mov [lup+36], eax

    mov eax, 832
    neg eax
    mov [lup+40], eax

    mov eax, 852
    neg eax
    mov [lup+44], eax

    mov eax, 82
    neg eax
    mov [lup+48], eax

    mov WORD [lup+52], 762

    mov WORD [lup+56], 900

    mov eax, 217
    neg eax
    mov [lup+60], eax

    mov eax, 667
    neg eax
    mov [lup+64], eax

    mov eax, 943
    neg eax
    mov [lup+68], eax

    mov eax, 345
    neg eax
    mov [lup+72], eax

    mov WORD [lup+76], 567

    mov WORD [lup+80], 954

    mov WORD [lup+84], 471

    mov eax, 449
    neg eax
    mov [lup+88], eax

    mov eax, 959
    neg eax
    mov [lup+92], eax

    mov eax, 986
    neg eax
    mov [lup+96], eax

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
    cmp esi, 3            ; fin for anidado x y y
    je  k_sum

y_loop:
    mov  eax, 6
    mov  edx, 0
    imul eax, edi           ; 6*y = 2*pi*y
    ; eax = 2*pi*y  dividendo
    mov ecx, r8d            ; divisor
    div ecx                 ; resultado eax = 2*pi*y / Lx
    imul eax, 4             ; indice para saber que valor escoger de la LUT
    mov eax, [lup + eax]    ; sin(2*pi*y/Lx) * 1000

    ;TODO: xaux
    mov edx, 0
    mov ecx, 1000
    imul eax, r9d
    div ecx                 ; se elimina el factor x1000
    add eax, esi            ;x + Ax + xsin
    
    mov ecx, 300            ;ecx = 300 = m = n
    mov edx, 0
    div ecx

    mov r10d, edx           ;xnew = xaux % m
    

    mov eax, 0
    mov edx, 0

    mov  eax, 6
    imul eax, esi           ; 6*x = 2*pi*x
    ; eax = 2*pi*x  dividendo
    mov ecx, r8d            ; divisor
    div ecx                 ; resultado eax = 2*pi*x / Ly
    imul eax, 4             ; indice para saber que valor escoger de la LUT
    mov eax, [lup + eax]    ; sin(2*pi*x/Ly) * 1000

    ;TODO: yaux
    mov edx, 0
    mov ecx, 1000
    imul eax, r9d
    div ecx                 ; se elimina el factor x1000
    add eax, edi            ; y + Ay + ysin

    mov ecx, 300            ; ecx = 300 = m = n
    mov edx, 0
    div ecx

    mov r11d, edx           ; ynew = yaux % m


    ;TODO: pendiente linea 22

division:
    ; codigo
    add edi, 1              ; y++
    cmp edi, 3            ;fin for y
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
