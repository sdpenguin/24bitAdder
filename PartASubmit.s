MUL24X24
		STMED	R13!,{R4-R12,LR}
		MOV		R4,#0x1 ;This is to be used as the AND mask for R2
		MOV		R5,#0x0 ;The amount of shift
		MOV		R6,#32 ;The amount of shift for R3
		MOV		R2,#0x0 ;Initialise the sum to 0
		MOV		R3,#0x0
		MOV		R8,#1
LOOP		ANDS		R7,R1,R4 ;R5 holds the ANDed values
		ADDSNE	R2,R2,R0, LSL R5 ;If the result is non-zero then there exists a bit at that position
		ADDCS	R3,R3,#1 ;If there's an unsigned overflow
		ANDS		R7,R1,R4
		ADDNE	R3,R3,R0, LSR R6
		LSL		R4,R4,#1
		ADD		R5,R5,#1
		SUB		R6,R6,#1

		LSLS		R0,R0,
		
		CMP		R4,#0x1000000 ;Compare R4 to 2^24 (this means that this is the 24th bit shift and this signals the end
		BNE		LOOP
		LDMED	R13!,{R4-R12,LR}
		MOV		PC,LR
		
		;TODO:	Need to check no. of instructions and optimise
		;TODO:	Need to research online for better methods
		;Could	we use auto increment to for example add to R1 or shift automatically? Could we also add into mutliple registers automatically?
