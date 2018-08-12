/*
 * AVROS.asm
 *
 *  Created: 5/19/2013 8:47:33 AM
 *   Author: Hamid & Omran
 */ 
 .org	0
 JMP	start

 .org	OVF0ADDR
 JMP	SwitchContext

   .org	OVF1ADDR
 JMP	Timer1_OVF


 .org	0x30
  RJMP	start
 .include	"m32def.inc"
 .include	"stdlib.inc"
 .include	"process.inc"
 .include	"lcd.inc"
 .include	"adc.inc"
 .include	"clock.inc"
 .include	"serial.inc"
 .include	"kernel.asm"
 .include	"pwm.inc"
 .include	"app1.asm"
 .include	"app2.asm"
 .include	"app3.asm"
 .include	"app4.asm"
  
 TEXT1:
	.DB		"*****AVR OS***** Version1.0.0 ",0
 START_MSG:
	.DB		"Hello From M e g a 1 6 !!!",0xd,"AVROS Version 1.0.0",0xd,"*******************",0xd,"Commonds : ",0xd,"Rn - Run a task (n=task number)",0xd,"Kn - Kill a task (n=task number)",0xd,"P - Show running task number",0xd,"S - Show Second",0xd,"M - Show Minute",0xd,"H - Show Hour",0xd,"An - Print ADC value(n=channel number)",0xd,"IA - Print pin A value",0xd,"OA - Print port A value",0xd,"IB - Print pin B value",0xd,"OB - Print port B value",0xd,0
start:
	LDI		A,0x3
	LDI		B,0x1F
	OUT		SPL,B
	OUT		SPH,A
	LDI		B,0xFF
	out		DDRC,B
	OUT		DDRA,B
heree:
	;rjmp	heree
	LDI		A,0
	OUT		TCNT0,A
	LDI		A,5
	OUT		TCCR0,A
	LDI		A,0x10
	OUT		TCNT0,A
	LDI		A,5
	OUT		TCCR1B,A
	LDI		A,0xF7
	LDI		B,0xC2
	OUT		TCNT1L,A
	OUT		TCNT1H,B
	LDI		A,4
	OUT		TCCR2,A
	LDI		A,250
	OUT		OCR2,A
	LDI		A,(1<<TOIE0) | (1<<TOIE1)
	OUT		TIMSK,A



;;	Clear SRAM

	LDI		XL,0x60
	LDI		XH,0x00
	LDI		A,0
	LDI		B,100
CLEARING:
	CPI		B,0
	BREQ	END_CLEARING
	ST		X+,A
	DEC		B
	RJMP	CLEARING
END_CLEARING:


	LDI		ZL,LOW(TEXT1<<1)
	LDI		ZH,HIGH(TEXT1<<1)
	LDI		XL,LOW(RAMS)
	LDI		XH,HIGH(RAMS)
COPY_MSG:
	LPM		A,Z+
	CPI		A,0
	BREQ	ENDCM
	ST		X+,A
	RJMP	COPY_MSG



ENDCM:
	LDI		ZL,LOW(SKernel)
	LDI		ZH,HIGH(SKernel)
	LDI		B,1
	CALL	InitProc

	CALL	LCD_INIT
	CALL	USART_Init
	CALL	InitADC
	LDI		ZL,LOW(START_MSG<<1)
	LDI		ZH,HIGH(START_MSG<<1)
	CALL	USART_Printf
	;CALL	LCD_INIT
	SEI
JMP		SKernel