_start:
    ; Inicializar los registros
    mov eax, 5     ; base
    mov ebx, 1     ; resultado
    mov ecx, 5     ; exponente
    call _ExpBinariaLoop

_ExpBinariaLoop:
    cmp eax, 0                  ;Verifica que el exponente siga siendo mayor que 0
    jg _ExpBinariaAux           ;Continúa calculando si se cumple la condición
    ret                         ;Se llegó al resultado y se regresa al lugar donde se llamó la función
    
_ExpBinariaAux:
    push rcx                    ;Guarda el exponente actual
    push rax                    ;Guarda la base actual
    and ecx, 1                  ;Obtiene el bit menos significativo del exponente actual
    cmp ecx, 1                  ;Lo compara con uno
    jne _ExpBinariaAux2         ;En caso de no ser 1 se salta la actualización del resultado
    mul rbx                     ;Multiplica el resultado actual por la base
    mov rbx, rax                ;Guarda el resultado en rbx
    jmp _ExpBinariaAux2         

_ExpBinariaAux2:
    pop rax                     ;Saca la base de la pila
    push rbx                    ;Guarda el resultado actual en la pila
    mov rbx, rax                ;Prepara rbx con el valor de la base
    mul rbx                     ;Realiza la op base = base*base 
    pop rcx                     ;Saca el resultado actual de la pila
    pop rbx                     ;Saca el exponente de la pila
    
    push rax                    ;Guarda la nueva base en la pila
    push rcx                    ;Guarda el resultado actual en la pila
    mov rax, rbx                ;Prepara rax con el valor del exponente
    mov rbx, 2                  
    div rbx                     ;Divide el exponente entre 2 dando asi exponente = exponente//2

    mov rcx, rax                ;Actualiza los valores de base, resultado y exponente
    pop rbx
    pop rax

    jmp _ExpBinariaLoop         ;Continúa el loop
