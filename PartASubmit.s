		MOV		R0,#1
		MOV		R1,#1
		BL		MUL24X24
		END
		
MUL24X24	STMED	R13!,{R4-R12,LR}
		MOV		R4,#0x1 ;This is to be used as the AND mask for R2
		MOV		R5,#0x0 ;The amount of shift
		MOV		R6,#32 ;The amount of shift for R3
		MOV		R2,#0x0 ;Initialise the sum to 0
		MOV		R3,#0x0
LOOP		ANDS		R7,R1,R4,LSL R5 ;R5 holds the ANDed values
		BEQ		SKPADD
		RSB		R6,R5,#32
		ADDS		R2,R2,R0, LSL R5 ;If the result is non-zero then there exists a bit at that position
		ADC		R3,R3,R0, LSR R6
SKPADD	ADD		R5,R5,#1
		CMP		R5,#24 ;Compare R4 to 2^24 (this means that this is the 24th bit shift and this signals the end
		BNE		LOOP
		LDMED	R13!,{R4-R12,LR}
		MOV		PC,LR
