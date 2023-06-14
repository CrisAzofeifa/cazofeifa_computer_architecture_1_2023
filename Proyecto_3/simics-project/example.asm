section .data
    matrixA db 1, 2, 3, 4    ; Matriz A: 2x2
    matrixB db 1, 2, 1, 2    ; Matriz B: 2x2
    result  times 4 db 0    ; Matriz resultado: 2x2

section .text
    global _start

_start:
    mov esi, matrixA     ; Cargar dirección de memoria de la matriz A en esi
    mov edi, matrixB     ; Cargar dirección de memoria de la matriz B en edi
    mov edx, result      ; Cargar dirección de memoria de la matriz resultado en edx
    
    ; Multiplicar el primer elemento de A por el primer elemento de B
    mov al, [esi]
    mov dl, [edi]
    mul dl
    mov [edx], al
    
    ; Multiplicar el segundo elemento de A por el tercer elemento de B
    mov al, [esi + 1]
    mov dl, [edi + 2]
    mul dl
    add [edx], al
    
    ; Multiplicar el primer elemento de A por el segundo elemento de B
    mov al, [esi]
    mov dl, [edi + 1]
    mul dl
    add [edx], al
    
    ; Multiplicar el segundo elemento de A por el cuarto elemento de B
    mov al, [esi + 1]
    mov dl, [edi + 3]
    mul dl
    add [edx + 1], al
    
    ; Salir del programa
    mov eax, 1
    mov ebx, 0
    int 0x80

