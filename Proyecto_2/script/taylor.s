seno:
	mov R0, #2	;X
	mov R1, R0	;actual
	mov R2, R0	;resultado
	mov R3, #-1	;signo
	mov R4, #3	;contador i
	mov R7, #-1
	mov R8, #1000
senoLoop:
	cmp R4, #100
	bgt endTaylor
	mul R1, R1, R0
	mul R1, R1, R0	; actual * x * x
	sub R5, R4, #1	; i-1
	mul R5, R4, R5	; i*(i-1)
	mov R6, #0
division:
    cmp R1, R5     
    blt endDivision    
    sub R1, R1, R5 
    add R6, R6, #1	;resultado division
    b division         
endDivision:
	mov R1, R6
	mul R5, R3, R1	;signo * término_actual
	add R2, R2, R5	;resultado + signo * término_actual
	mul R3, R3, R7 ;-signo
	add R4, R4, #2
	b senoLoop

endTaylor:
	mul R2, R2, R8

