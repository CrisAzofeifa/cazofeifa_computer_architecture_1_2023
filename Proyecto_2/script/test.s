.global _start
_start:
			mov		R0, #300	
			mov		R1, #75	
			mov 	R3, #0 
			mov		R4, #-1
			mov 	R5, #2 
			

taylor:
			mov 	R2, #0
			mov 	R10, #1000
			mov 	R11, #0
			b 		taylorLoop

taylorLoop: 
			cmp 	R11, #100
			beq 	endTaylor
			b 		taylorNumerator1

taylorNumerator1:
			add 	R11, R11, #1
			b 		powerNeg
	
taylorNumerator2:
			mov 	R3, #2
			mul 	R3, R3, R11
			add 	R3, R3, #1
			b 		power

taylorNumerator3: 
			mul 	R10, R6, R2
			b 		taylorDenominator1

taylorDenominator1:
			b 		factorial

division:
			udiv 	R12, R10, R7
			add 	R2, R2, R12
			b 		taylorLoop

powerNeg:
			and 	R6, R3, #1
			cmp 	R6, #1
			beq		oddNeg
			b		evenNeg
oddNeg: 
			mov 	R6, #-1
			b		taylorNumerator2

evenNeg:
			mov 	R6, #1
			b		taylorNumerator2

power:
			mov		R2, #1 
			mov		R7, R3 
			mov		R8, R5 		
binaryLoop:
			cmp		R7, #0
			bne		comparison
			b		endPow		
comparison:
			mov		R9, R7
			and		R9, R9, #1
			cmp		R9, #1
			beq		odd
			b		even			
odd:
			mul		R2,	R2, R8                  
			mul		R8,	R8, R8                 
			lsr		R7, R7, #1                  
			b		binaryLoop                  	
even:
			mul		R8,	R8, R8                 
			lsr		R7, R7, #1                  
			b		binaryLoop                  	
			
endPow:
			b 		taylorNumerator3


factorial:
			mov 	R7, #1
			mul 	R7, R7, R6
			b 		factLoop
factLoop:
			sub 	R3, R3, #1
			cmp 	R3, #0
			beq 	endFactorial
			mul 	R7, R7, R3
			b 		factLoop
endFactorial:
			b 		division

endTaylor:
			mov 	R1, R2
	