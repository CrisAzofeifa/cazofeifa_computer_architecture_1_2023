cpu x86-64
bits 64
%include "sys.inc"
global   					_start
section .data
    filename 	db 		"Encriptada.txt",0  ;nombre del archivo que contiene la matriz de pixeles de la imagen a procesar
    string   	dw 		"0", 0				;String donde se almacenaran temporalmente los números que se vayan leyendo del txt
    vec 		times 	2550000 dd 0

section .bss
    text       	resq 	2550000				;vector que almacenará la matriz de pixeles de la imagen encriptada
    final 	   	resq 	2550000				;vector que almacenará la matriz de pixeles de la imagen encriptada en enteros
section .text

_start:
	mov 	rax, 0												;Se reinician los registros rax, rbx y  rcx
	mov 	rbx, 0				
	mov 	rdx, 0	
    ;abre el archivo de Encriptada.txt
    mov     rbx, 0								
    mov 	rax, SYS_OPEN										
	mov 	rdi, filename 										
	mov 	rsi, O_RDONLY   									
	mov 	rdx, 0												
	syscall
	
    ;lee el archivo de Encriptada.txt
	push 	rax													
	mov 	rdi, rax
	mov 	rax, SYS_READ 										
	mov 	rsi, text 	
	mov 	rdx, 819200								
	syscall
	mov 	rax, SYS_CLOSE 										
	pop 	rdi
	syscall
	mov 	rax, 0												;Se reinician los registros rax, rbx y  rcx
	mov 	rbx, 0				
	mov 	rdx, 0	

;se itera sobre el archivo Encriptada.txt para cargar los pixeles
while:			
    mov 	cl, [text+rbx]										;Se lee un byte de la cadena text
	cmp 	cl, ','												;Se compara con el indicador de final del archivo  ','
	jne 	continua											
	jmp 	fin	

continua:
    cmp 	cl, byte ' '										
	je 		divid 												
	jmp		no	

divid:			
    push 	rdx												
	mov 	edi, string 																		
	call 	atoi 			;llama a atoi para convertir a entero el valor  									
	pop 	rdx 
	mov 	rsi,rdx																					
	mov 	[vec+edx*4],eax		;almacena el valor en la matriz vec  	
	mov 	dword[string], '0'									
	mov 	eax, 0												
	inc 	edx 												
	jmp 	salto 	

no:				
    mov 	[string + eax], cl 	;agregar el byte a la cadena string   								
	inc 	eax		

salto:			
    inc 	ebx													
	jmp 	while	

fin:
    mov eax, [vec+4]
	call b

b:


;Convierte un entero a ASCII
itoa:		
    push    rbp         										
	push    rax         									
	push    rbx	
	push    rdx
	mov 	rbx, dword 10   									  
    push    rbx   

itoa_loop:	
    cmp 	rax, rbx        									
	jl  	itoa_unroll     									
	xor 	rdx, rdx        									
	div 	rbx             									
	push    rdx         										
	jmp 	itoa_loop  	

itoa_unroll:
    add 	al, 0x30      										
	mov 	[final +rdi], byte al 
	inc 	rdi        											
	pop 	rax         										
	cmp 	rax, rbx        									
	jne 	itoa_unroll     									
	mov 	[final +rdi], byte ' ' 								;Agregar ' ' como ASCII al valor 
	inc 	rdi
	inc 	rcx             									
	pop 	rdx         										
	pop 	rbx
	pop 	rax
	pop 	rbp
	ret	

;convierte a ascii
atoi:			
    mov 	rax, 0     

convert:		
    movzx 	rsi, byte [rdi]   									
	test 	rsi, rsi           									
	je 		done
	cmp 	rsi, 48             								
	jl 		done 												
    cmp 	rsi, 57             								
	jg 		done 												
	sub 	rsi, 48            							 		
	imul 	rax, 10            									
	add 	rax, rsi            								
	inc 	rdi                 							
	jmp 	convert
done:			
    ret

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