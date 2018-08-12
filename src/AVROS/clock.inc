/*
 * clock.inc
 *
 *  Created: 5/20/2013 12:35:03 AM
 *   Author: Hamid Reza Mehrabian
 */ 
 Timer1_OVF:
	PUSH	A
	PUSH	B
	PUSH	C
	LDI		A,0xF7
	LDI		B,0xC2
	OUT		TCNT1L,A
	OUT		TCNT1H,B
	LDS		A,Second
	CPI		A,59
	BRNE	SNOF
	LDS		B,Minute
	CPI		B,59
	BRNE	MNOF
	LDS		C,Hour
	CPI		C,23
	BRNE	HNOF
	LDI		C,0
	STS		Hour,C
	STS		Minute,C
	STS		Second,C
	POP		C
	POP		B
	POP		A
	RETI
HNOF:
	LDI		A,0
	STS		Minute,A
	STS		Second,A
	INC		C
	STS		Hour,C
	POP		C
	POP		B
	POP		A
	RETI
MNOF:
	LDI		A,0
	STS		Second,A
	INC		B
	STS		Minute,B
	POP		C
	POP		B
	POP		A
	RETI
SNOF:
	INC		A
	STS		Second,A
	POP		C
	POP		B
	POP		A
 RETI