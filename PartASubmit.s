MUL24X24	STMED	R13!,{R0,R1,R4,R5,LR}
		MOV		R2,#0x0
		MOV		R3,#0x0
		SUBS		R4,R3,#1
ADDER	RSB		R5,R4,#32
		ADDSPL	R2,R2,R0,LSL R4
		ADC		R3,R3,R0,LSR R5
LOOP		LSRS		R1,R1,#1
		ADD		R4,R4,#1
		BCS		ADDER
		BNE		LOOP
		LDMED	R13!,{R0,R1,R4,R5,PC}