			;		This testbench checks MUL24X24 for correct outputs as determined by the provided data
			;		The code will run correctly even if MUL24X24 is not cooperative, as long as it does not corrupt stack with unbalanced push/pop
			;		At the end of execution R0 contains a non-negative error code, or -1 for a pass indication
PROJTB		MOV		R4, #0 ; test number
			ADR		R5, PROJTBDATA0 ; pointer to base of test data
PROJTBLOOP
			ADD		R8, R5, R4, LSL #4  ; R8 points to current test data
			LDMIA	R8, {R0,R1,R6,R7} ; R0,R1 are test inputs. R6,R7 will be matched with outputs
			MOV		R12, R13 ; copy of R13 to save
			STMED	R13!, {R4,R5,R6,R7,R12} ; save registers in case tested code is not cooperative
			BL		MUL24X24 ; do multiplication
			LDMED	R13!, {R4,R5,R6,R7,R12} ; restore registers in case tested code is not cooperative
			MOV		R11, R13 ; cannot directly compare R13
			CMP		R12, R11 ; if R12 <> R13 then MUL24X24 has corrupted the stack with unbalanced PUSH/POP
			BNE		PROJTBFAIL2
			CMP		R3,R7
			CMPEQ	R2, R6
			BNE		PROJTBFAIL
			ADD		R4, R4, #1
			CMP		R4, #PROJTBNUMTESTS
			BNE		PROJTBLOOP
			MOV		R0, #-1
			B		PROJTBPASS
			
PROJTBFAIL	MOV		R0, R4 ; R0 contains the number of the test that failed (0 - NUMTESTS-1)
			END
			
PROJTBFAIL2	MOV		R0, #100 ; 100 indicates that tested code has corrupted the stack pointer
			END
			
PROJTBPASS	MOV		R0, #-1 ; -1 in R0 is a PASS indication
			END
			
PROJTBNUMTESTS	EQU		16 ; constant equal to the number of tests provided. The test data must exist for each test.
			
PROJTBDATA0	DCD		3, 3, 9, 0
PROJTBDATA1	DCD		0x9BEEB0, 0x40310A, 0x8AC702E0, 0x2719
PROJTBDATA2	DCD		0xF56585, 0xFD22CF, 0xB259C08B, 0xF2A6
PROJTBDATA3	DCD		0x631B68, 0x85D24C, 0xA6EF72E0, 0x33CE
PROJTBDATA4	DCD		0x47C366, 0x81AEF9, 0x83026236, 0x245A
PROJTBDATA5	DCD		0x881591, 0xE981A, 0x88E48BA, 0x7C2
PROJTBDATA6	DCD		0x47D25C, 0x7EFF04, 0x14F0ED70, 0x23A1
PROJTBDATA7	DCD		0xD8AEAF, 0x9CF7E9, 0x4865D647, 0x84DC
PROJTBDATA8	DCD		0x1AAA24, 0xBE0946, 0x3DFDC9D8, 0x13CB
PROJTBDATA9	DCD		0x66E15A, 0xEEF2D1, 0x16B10E7A, 0x6007
PROJTBDATA10	DCD		0x217572, 0xB31C69, 0xD547A3C2, 0x1768
PROJTBDATA11	DCD		0x9D8B6A, 0xD4A019, 0xFA4CDD5A, 0x82D9
PROJTBDATA12	DCD		0xAF6474, 0x91DAA4, 0xB19B2250, 0x63ED
PROJTBDATA13	DCD		0x2C3A7F, 0x2F3D8A, 0x5F18CB76, 0x829
PROJTBDATA14	DCD		0xFF42EA, 0x9195A1, 0x1905472A, 0x912A
PROJTBDATA15	DCD		0x103D62, 0x4380C7, 0x3BF6B72E, 0x448
			
			;------------------------------------------------------------------------------------------------
			;		Do not change code above this line
			;		User code to be tested (the MUL24X24 subroutine and all its code) must be appended below this line
			;------------------------------------------------------------------------------------------------
			
			
MUL24X24		STMED	R13!,{R0,R1,R4-R12,LR}
			MOV		R4,#0x0 ;A zero
			MOV		R8,#0x0 ;Second part of R0
			MOV		R2,#0x0 ;Initialise the sum to 0
			MOV		R3,#0x0
LOOP			ANDS		R7,R1,#1 ;R7 holds the ANDed values
			BEQ		SKPADD ;If zero then skip adding
			ADDS		R2,R2,R0
			ADC		R3,R3,R8
SKPADD		LSLS		R0,R0,#1 ;The first part
			ADC		R8,R4,R8, LSL #1 ;R8 is a left cont. of R2
			LSRS		R1,R1,#1
			BNE		LOOP
			LDMED	R13!,{R0,R1,R4-R12,LR}
			MOV		PC,LR
			
			;TODO:	Need to fix it for filling into R2 and R3
			;TODO:	Need to check no. of instructions and optimise
			;TODO:	Need to research online for better methods
			;Could	we use auto increment to for example add to R1 or shift automatically? Could we also add into mutliple registers automatically?
			
