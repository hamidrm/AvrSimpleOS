/*
 * stdlib.inc
 *
 *  Created: 5/19/2013 9:01:44 AM
 *   Author: Omran Rezaee
 */ 
.def		A=R16
.def		B=R17
.def		C=R18
.def		D=R19
.def		E=R20
.def		F=R21
.def		G=R22
.def		PL=R23
.def		PH=R24
.def		CurentPID=R25


; You Can Lock Each Resource That Connected To AVR
.equ		LCD_LOCK		= 1;
.equ		ADC_LOCK		= 2;

.equ		BAUD		= 9600
.equ		UBRR		= (1000000/BAUD)-1
 .equ		ProcPIDS	=	0x60
 .equ		ProcCount	=	0x65
 .equ		PrevProcess  =   0x66
 .equ		ProcessTSS  =   0x67
 .equ		Second		= 0xA8
 .equ		Minute		= 0xA9
.equ		Hour		= 0xAA
.equ		TCNTL		= 0xAB
.equ		TCNTH		= 0xAD
.equ		Lock		= 0xAC
.equ		Process		= 0xAE
 .equ		RAMS		= 0xAF
  .equ		RAMSA		= 0x100

 strcmp:
	MOV		XL,A
	MOV		XH,B
	LD		E,X
	MOV		XL,C
	MOV		XH,D
	LD		F,X+
	CP		E,F
	BRNE	NOTES
	CPI		E,0
	BREQ	SAMES
	MOV		C,XL
	MOV		D,XH
	MOV		XL,A
	MOV		XH,B
	LD		E,X+
	MOV		A,XL
	MOV		B,XH
	RJMP	strcmp
NOTES:
	CLC
	RET
SAMES:
	SEC
 RET



itoa:
	LDI		C,255
	PUSH	C
startti:
	LDI		C,0
	LDI		D,0
DIVN:
	CPI		A,10
	BRLO	LBL
	RJMP	NOLT
LBL:
	CPI		B,0
	BREQ	ENDD
NOLT:
	INC		C
	CPI		C,0
	BRNE	NOTOV
	INC		D
NOTOV:
	CALL	DEC10
	RJMP	DIVN
ENDD:
	PUSH	A
	MOV		A,C
	MOV		B,D
	CPI		A,0
	BRNE	startti
	CPI		B,0
	BREQ	ENDTT
	RJMP	startti
ENDTT:
	POP		A
	CPI		A,255
	BREQ	ENDCONVERT
	LDI		B,'0'
	ADD		A,B
	ST		X+,A
	RJMP	ENDTT
ENDCONVERT:
	LDI		A,0
	ST		X+,A
RET

DEC10:
	LDI		E,0
SDEC:
	INC		E
	CPI		A,0
	BRNE	DECC
	DEC		B
	LDI		A,0
DECC:
	DEC		A
	CPI		E,10
	BRNE	SDEC
RET

Wait_Unlock:
	LDS		B,Lock
	AND		B,A
	CP		B,A
	BREQ	Wait_Unlock
RET

SetLock:
	CALL	Wait_Unlock
	LDS		B,Lock
	OR		B,A
	STS		Lock,B
RET

SetUnlock:
	LDS		B,Lock
	COM		A
	AND		B,A
	STS		Lock,B
RET