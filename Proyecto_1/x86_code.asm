cpu x86-64
bits 64
%include "sys.inc"
global   					_start
section .data
    filename 	db 		"Encriptada.txt",0  ;nombre del archivo que contiene la matriz de pixeles de la imagen a procesar
	filename2 	dw 		"Desencriptada.txt", 0			;nombre del archivo donde se guardará el resultado 
	fileLlaves 	db 		"llaves.txt",0  ;nombre del archivo que contiene las llaves
    string   	dw 		"0", 0				;String donde se almacenaran temporalmente los números que se vayan leyendo del txt
    vec 		times 	2550000 dd 0

section .bss
    text       	resq 	2550000				;vector que almacenará la matriz de pixeles de la imagen encriptada
    final 	   	resq 	2550000				;vector que almacenará la matriz de pixeles de la imagen encriptada en enteros
	llaves      resq 	1000				;vector que almacenará las llaves
	llavesInt      resq 	1000		;vector que almacenará las llaves en enteros
	IntDencryp 	resq 	2550000				;vector que almacenará la matriz de pixeles desencriptada de la imagen encriptada en enteros
	base  		resb 	32
	exponente  	resb 	32
	modulo  	resb 	32
	llave_d  	resb 	32
	llave_n  	resb 	32
	cantPixeles resb 	10										;Almacenará resolución de la imagen
	resolucionSalida 	resb 	10	
	len 	   	resb 	10										;almacena el largo de la subcadena leída del txt
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
	mov 	rdx, 2457600								
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
	jmp 	_startLlaves	

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

_startLlaves:
	mov 	rax, 0												;Se reinician los registros rax, rbx y  rcx
	mov 	rbx, 0				
	mov 	rdx, 0	
    ;abre el archivo de llaves.txt
    mov     rbx, 0								
    mov 	rax, SYS_OPEN										
	mov 	rdi, fileLlaves 										
	mov 	rsi, O_RDONLY   									
	mov 	rdx, 0												
	syscall
	
    ;lee el archivo de llaves.txt
	push 	rax													
	mov 	rdi, rax
	mov 	rax, SYS_READ 										
	mov 	rsi, llaves 	
	mov 	rdx, 1000								
	syscall
	mov 	rax, SYS_CLOSE 										
	pop 	rdi
	syscall
	mov 	rax, 0												;Se reinician los registros rax, rbx y  rcx
	mov 	rbx, 0				
	mov 	rdx, 0	

;se itera sobre el archivo llaves.txt para cargar las llaves
while2:			
    mov 	cl, [llaves+rbx]									;Se lee un byte de la cadena llaves
	cmp 	cl, ','												;Se compara con el indicador de final del archivo  ','
	jne 	continua2											
	jmp 	fin2

continua2:
    cmp 	cl, byte ' '										
	je 		divid2 												
	jmp		no2	

divid2:			
    push 	rdx												
	mov 	edi, string 																		
	call 	atoi 			;llama a atoi para convertir a entero el valor  									
	pop 	rdx 
	mov 	rsi,rdx																					
	mov 	[llavesInt+edx*4],eax		;almacena el valor en la matriz llavesInt  	
	mov 	dword[string], '0'									
	mov 	eax, 0												
	inc 	edx 												
	jmp 	salto2 	

no2:				
    mov 	[string + eax], cl 	;agregar el byte a la cadena string   								
	inc 	eax		

salto2:			
    inc 	ebx													
	jmp 	while2

fin2:
	mov rax, 614400
	mov [cantPixeles], rax
	mov ebx, [llavesInt+0]
	mov [llave_d], ebx
	mov ebx, [llavesInt+4]
	mov [llave_n], ebx

	xor esi, esi
	xor edi, edi

_RSALoop:
	cmp esi, [cantPixeles]
	je _finLoop
	mov rdx, [llave_n]
	mov [modulo], rdx
	mov rbx, [modulo]
	mov rdx, [llave_d]
	mov [exponente], rdx
	mov ebx, esi
	mov rax, 4
	mul rbx
	jmp _RSALoopAux 

_RSALoopAux:
	mov ebx, [vec+rax]
	mov eax, [vec+rax+4]
	shl rbx, 8
	or rax, rbx

	xor rdx,rdx
	mov rbx, [modulo]
	
	div rbx
	
	mov [base], rdx

	mov eax, [base]
	mov ebx, 1 
	mov ecx, [exponente]
	

	call _ExpModLoop
	mov [IntDencryp+(edi*8)], ebx
	inc esi
	inc esi
	inc edi
	
	jmp _RSALoop
	
_finLoop:	
	mov ecx, 307200
	mov [resolucionSalida], ecx
	mov ecx, 0
	mov edi, 0

while3:		
	cmp 	ecx, [resolucionSalida]								;mueve el valor de la resolucion de la salida al registro ecx
	jle 	continua3 	
	jmp 	fin3
continua3:
	mov 	eax, dword[IntDencryp+ecx*8]						;Toma el valor  actual de la matriz
	mov 	[len], rdi											
	call 	itoa 												;llama a itoa para convertir de entero a ascii
	jmp 	while3

fin3:						
	mov 	rax, SYS_OPEN										
	mov 	rdi, filename2 										;Nombre de archivo a abrir: "Desencriptada.txt"
	mov 	rsi, O_CREAT+O_WRONLY								
	mov 	rdx, 0644o 											
	syscall 													
	mov 	rdi, rax
	mov 	rax, SYS_WRITE 										
	mov 	rsi, final 											;Escribir array final en el archivo
	mov 	rdx, [len]											;La cantidad de caracteres a escribir es len
	syscall 
	mov 	rax, SYS_CLOSE 										
	syscall
	jmp _exit


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

_ExpModLoop:
    cmp ecx, 0                  ;Verifica que el exponente siga siendo mayor que 0
    jg _ExpModAux           ;Continúa calculando si se cumple la condición
    ret                         ;Se llegó al resultado y se regresa al lugar donde se llamó la función
    
_ExpModAux:
    push rcx                    ;Guarda el exponente actual
    push rax                    ;Guarda la base actual
    and ecx, 1                  ;Obtiene el bit menos significativo del exponente actual
    cmp ecx, 1                  ;Lo compara con uno
    jne _ExpModAux2         	;En caso de no ser 1 se salta la actualización del resultado
    mul rbx                     ;Multiplica el resultado actual por la base
	xor rdx, rdx 
	mov rbx, [modulo]
	div rbx 
    mov rbx, rdx                ;Guarda el resultado en rbx
    jmp _ExpModAux2         

_ExpModAux2:
    pop rax                     ;Saca la base de la pila
    push rbx                    ;Guarda el resultado actual en la pila
    mov rbx, rax                ;Prepara rbx con el valor de la base
    mul rbx                     ;Realiza la op base = base*base 

	xor rdx, rdx
	mov rbx, [modulo]
	div rbx 
	mov [base], rdx
	mov rax, rdx
    pop rcx                     ;Saca el resultado actual de la pila
    pop rbx                     ;Saca el exponente de la pila
	
    
    push rax                    ;Guarda la nueva base en la pila
    push rcx                    ;Guarda el resultado actual en la pila
	mov rax, [exponente]
	shr rax, 1 
	
	mov [exponente], rax
    mov rcx, rax                ;Actualiza los valores de base, resultado y exponente
    pop rbx
    pop rax

    jmp _ExpModLoop         	;Continúa el loop

_exit:
	exit