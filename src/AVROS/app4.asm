/*
 * app4.asm
 *
 *  Created: 5/22/2013 7:45:06 AM
 *   Author: Hamid
 */ 
 .equ	LIGHT = RAMSA + 12
  app4:
    LDI		A,1<<7
	OUT		DDRD,A
	CALL	pwminit
	LDI		F,0
KEYUP:
  SBIS	PINB,1
  RJMP	KEYUP
KEYDOWN:
  SBIC	PINB,1
  RJMP	KEYDOWN
  LDI	A,5
  ADD	F,A
  MOV	A,F
  CALL	pwmset
  MOV	A,F
  LDI	B,0
  LDI	XL,LOW(LIGHT)
  LDI	XH,HIGH(LIGHT)
  CALL	itoa
  LDI	XL,LOW(LIGHT)
  LDI	XH,HIGH(LIGHT)
  LDI	A,LCD_LOCK
  CALL	Setlock
  CALL	LCD_CLS
  CALL	LCD_PUTS
  LDI	A,LCD_LOCK
  CALL	SetUnlock

rjmp KEYUP