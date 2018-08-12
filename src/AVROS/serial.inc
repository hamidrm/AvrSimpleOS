/*
 * serial.inc
 *
 *  Created: 5/20/2013 12:56:45 AM
 *   Author: Omran Rezaee
 */ 

 USART_Init:
 	LDI		A,1<<2 | 1<<1 | 1<<7
	OUT		UCSRC,A
	LDI		A,0x18
	OUT		UCSRB,A
  	LDI		A,HIGH(UBRR)
	OUT		UBRRH,A
  	LDI		A,LOW(UBRR)
	OUT		UBRRL,A
RET


USART_Recive:
	IN		B,UCSRA
	ANDI	B,1<<7
	BREQ	USART_Recive
	IN		A,UDR
RET

USART_Send:
	IN		B,UCSRA
	ANDI	B,1<<5
	BREQ	USART_Send
	OUT		UDR,A
RET

USART_Scan:
	CALL	USART_Recive
	CPI		A,0x0D
	BREQ	EndScan
	ST		X+,A
	CALL	USART_Send
	RJMP	USART_Scan
EndScan:
	LDI		A,0
	ST		X+,A
RET

USART_Print:
	LD		A,X+
	CPI		A,0
	BREQ	EndPrint
	CALL	USART_Send
	RJMP	USART_Print
EndPrint:
RET

USART_Printf:
	LPM		A,Z+
	CPI		A,0
	BREQ	EndPrintf
	CALL	USART_Send
	RJMP	USART_Printf
EndPrintf:
RET