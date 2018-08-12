/*
 * process.inc
 *
 *  Created: 5/19/2013 9:00:33 AM
 *   Author: Hamid Reza Mehrabian
 *   A  V  R    M U L T I T A S K I N G
 *   
 */ 
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;;		   TSS Structure
 ;;       _______________
 ;;      |       A       |  1
 ;;      |_______________|
 ;;      |       B       |  2
 ;;      |_______________|
 ;;      |       C       |  3
 ;;      |_______________|
 ;;      |       D       |  4
 ;;      |_______________|
 ;;      |       E       |  5
 ;;      |_______________|
 ;;      |       F       |  6
 ;;      |_______________|
 ;;      |     FLAGS     |  7
 ;;      |_______________|
 ;;      |               |  8
 ;;      |  Instruction  |
 ;;      |    Pointer    |  9
 ;;      |_______________|
 ;;      |               |  10
 ;;      | Stack Pointer |
 ;;      |               |  11
 ;;      |_______________|
 ;;      |   X Pointer   |  12
 ;;      |               | 
 ;;      |_______________|  13







 SwitchContext:
	POP		G
	MOV		YH,G
	POP		G
	MOV		YL,G
	IN		G,SREG
	CALL	SaveABCDY
NextPID:
	MOV		XL,CurentPID
	LDI		XH,0
	LDI		B,LOW(ProcPIDS)
	ADD		XL,B
	LDI		B,HIGH(ProcPIDS)
	ADC		XH,B
	LD		A,X+
	TST		A
	BRNE	VALIDPID
	INC		CurentPID
	CPI		CurentPID,5
	BRNE	NextPID
	LDI		CurentPID,0
	LDI		A,0
	OUT		TCNT0,A
	LDI		CurentPID,0
	RJMP	NextPID
VALIDPID:
	CALL	LoadABCDY
	OUT		SPL,ZL
	OUT		SPH,ZH
	MOV		ZL,YL
	MOV		ZH,YH
	STS		PrevProcess,CurentPID
	INC		CurentPID
	CPI		CurentPID,5
	BRNE	POF
	LDI		CurentPID,0
POF:
	OUT		SREG,G
	SEI
	IJMP






 KillProc:
	CLI
	;DEC		A
	LDI		D,0
	LDI		XL,LOW(ProcPIDS)
	LDI		XH,HIGH(ProcPIDS)
	LD		C,X+
NPID:
	LD		C,X+
	CP		C,A
	BREQ	TF
	INC		D
	CPI		D,4
	BREQ	INVPID
	RJMP	NPID
TF:
	LDI		A,0
	ST		-X,A
	LDI		A,LCD_LOCK
	CALL	SetUnlock
	LDI		A,ADC_LOCK
	CALL	SetUnlock
 	LDS		B,ProcCount
	DEC		B
	STS		ProcCount,B
	SEI
	SEC
	RET
INVPID:
	CLC
	LDI		A,LCD_LOCK
	CALL	SetUnlock
	LDI		A,ADC_LOCK
	CALL	SetUnlock
 RET

 ;;		Input  : Z => Process Address
 ;;		Output : C => PID , Carry => 1 Successfully
 InitProc:
	CLI
	LDS		A,ProcCount
	CPI		A,5
	BREQ	QueueFull
	INC		A
	STS		ProcCount,A
	LDI		D,0
	LDI		XL,LOW(ProcPIDS)
	LDI		XH,HIGH(ProcPIDS)
NPIDS:	
	INC		D
	LD		A,X+
	TST		A
	BREQ	FPID
	CPI		D,5
	BRNE	NPIDS
	RJMP	QueueFull
FPID:
	DEC		D
	ST		-X,B
	MOV		C,D
	LDI		B,13
	MUL		D,B
	MOV		XL,R0
	MOV		XH,R1
	LDI		B,LOW(ProcessTSS)
	ADD		XL,B
	LDI		B,HIGH(ProcessTSS)
	ADC		XH,B
	LDI		A,0
	ST		X+,A
	ST		X+,A
	ST		X+,A
	ST		X+,A
	ST		X+,A
	ST		X+,A
	ST		X+,A
	ST		X+,ZL
	ST		X+ ,ZH
	LDI		A,64
	MUL		C,A
	MOV		ZL,R0
	MOV		ZH,R1
	LDI		A,0x1F
	ADD		ZL,A
	LDI		A,0x3
	ADC		ZH,A
	ST		X+,ZL
	ST		X+ ,ZH
	SEC
	RET
QueueFull:
	CLC
 RET


 LoadABCDY:
	LDI		A,13
	MUL		A,CurentPID
	MOV		XL,R0
	MOV		XH,R1
	LDI		B,LOW(ProcessTSS)
	ADD		XL,B
	LDI		B,HIGH(ProcessTSS)
	ADC		XH,B
	IN		YL,SREG
	ANDI	YL,1<<7
	LD		A,X+
	LD		B,X+
	LD		C,X+
	LD		D,X+
	LD		E,X+
	LD		F,X+
	LD		G,X+
	ANDI	G,0x7F
	OR		G,YL
	LD		YL,X+
	LD		YH,X+
	LD		ZL,X+
	LD		ZH,X+
	LD		PL,X+
	LD		PH,X+
	MOV		XL,PL
	MOV		XH,PH
 RET

  SaveABCDY:
	MOV		PL,XL
	MOV		PH,XH
	PUSH	A
	PUSH	B
	PUSH	CurentPID
	LDI		A,13
	LDS		CurentPID,PrevProcess
	MUL		A,CurentPID
	MOV		XL,R0
	MOV		XH,R1
	LDI		B, LOW(ProcessTSS)
	ADD		XL,B
	LDI		B,HIGH(ProcessTSS)
	ADC		XH,B
	POP		CurentPID
	POP		B
	POP		A
	ST		X+,A
	ST		X+,B
	ST		X+,C
	ST		X+,D
	ST		X+,E
	ST		X+,F
	ST		X+,G
	ST		X+,YL
	ST		X+,YH
	IN		YL,SPL
	IN		YH,SPH
	LDI		A,2
	ADD		YL,A
	LDI		A,0
	ADC		YH,A
	ST		X+,YL
	ST		X+,YH
	ST		X+,PL
	ST		X+,PH
 RET