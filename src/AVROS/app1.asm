/*
 * app1.asm
 *  Beep
 *  Created: 5/22/2013 7:44:35 AM
 *   Author: Hamid
 */ 
 app1:
 IN		A,DDRB
 ORI	A,1
 LDI	C,0x80
 LDI	D,0
 OUT	DDRB,A
 LOOP1:
 SBI	PORTB,0
 LDELAY	0x100
 CBI	PORTB,0
 LDELAY	0x100
 INC	B
 CPI	B,255
 BRNE	LOOP1
 LDI	B,0
 INC	D
 CPI	D,100
 ;BRNE	LOOP1
 LDI	D,0
 COM	C
 ANDI	C,0xC0
 OUT	PORTA,C
rjmp LOOP1