		mov		R0, #300	; dimension
		mov		R1, #75	; Lx y Ly
		
taylor
		mov		R2, #0	;resultado
		mov		R3, #0	;contador
		mov		R4, #-1
		mov		R5, R3
		b		power	; R4 ** R5
		
		;R4		= base
		;R5		= base
power
		mov		R6, #1
