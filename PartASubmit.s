		MOV		R0,#1
		MOV		R1,#0xF0000000
		BL		MUL24X24
		END
		
MUL24X24	STMED	R13!,{R0,R1,R4-R12,LR}
		MOV		R8,#0x0 ;Second part of R0
		MOV		R2,#0x0 ;Initialise the sum to 0
		MOV		R3,#0x0
LOOP		MVNS		R7,R1, LSL #31 ;R7 is -1 if first bit of R1 is 1
		ADDSGE	R2,R2,R0
		ADCGE	R3,R3,R8 ;Add with a carry if carry set
		LSLS		R0,R0,#1 ;The first part
		ADC		R8,R8,R8 ;R8 is a left cont. of R2
		LSRS		R1,R1,#1
		BNE		LOOP
		LDMED	R13!,{R0,R1,R4-R12,LR}
		MOV		PC,LR