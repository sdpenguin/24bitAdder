		MOV		R0,#1
		MOV		R1,#0xFFFFFFFF
		BL		MUL24X24
		END
		
MUL24X24	STMED	R13!,{R0,R1,R4-R12,LR}
		MOV		R8,#0x0 ;Counter
		MOV		R2,#0x0 ;Initialise the sum to 0
		MOV		R3,#0x0
LOOP		ANDS		R7,R1,#1 ;R7 is -1 if first bit of R1 is 1
		BEQ		SKIP
		RSB		R6,R8,#32
		ADDS		R2,R2,R0, LSL R8
		ADC		R3,R3,R0, LSR R6 ;Add with a carry if carry set
SKIP		ADD		R8,R8,#1
		LSRS		R1,R1,#1
		BNE		LOOP
		LDMED	R13!,{R0,R1,R4-R12,LR}
		MOV		PC,LR
