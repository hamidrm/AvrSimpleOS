/*
 * kernel.asm
 *
 *  Created: 5/22/2013 7:44:10 AM
 *   Author: Hamid
 */
 SKernel:
	CALL	LCD_CLS
	LDI		XL,LOW(RAMS)
	LDI		XH,HIGH(RAMS)
	CALL	LCD_PUTS
	ldi		a,0x80
	out		porta,a
 Kernel:
	LDELAY	0xFFFF
	CALL	USART_Recive
	CALL	USART_Send
	CPI		A,'A'
	BRNE	C2
	CALL	USART_Recive
	CALL	USART_Send
	MOV		C,A
	CALL	PrintResultLayout
	SUBI	C,'0'
	LDI		A,ADC_LOCK
	CALL	SetLock
	MOV		A,C
	CALL	InitADC
	CALL	GetADC
	LDI		A,ADC_LOCK
	CALL	SetUnlock
	IN		A,ADCL
	IN		B,ADCH
	LDI		XL,LOW(RAMS)
	LDI		XH,HIGH(RAMS)
	CALL	itoa
	LDI		XL,LOW(RAMS)
	LDI		XH,HIGH(RAMS)
	CALL	USART_Print
	LDI		A,0xD
	CALL	USART_Send
	RJMP	Kernel

C2:
	CPI		A,'R'
	BREQ	NC3
	RJMP	C3
NC3:
	CALL	USART_Recive
	CALL	USART_Send
	MOV		C,A
	CALL	PrintResultLayout
	MOV		A,C
	CLI
	CPI		A,'1'
	BREQ	RT1
	CPI		A,'2'
	BREQ	RT2
	CPI		A,'3'
	BREQ	RT3
	CPI		A,'4'
	BRNE	NRT4
	RJMP	RT4
NRT4:
	SEI
	CALL	Error
	RJMP	Kernel
RT1:
	LDS		A,Process
	ANDI	A,1
	BREQ	CRT1
	CALL	Error
	SEI
	RJMP	Kernel	
CRT1:
	LDI		ZL,LOW(app1)
	LDI		ZH,HIGH(app1)
	LDI		B,2
	CALL	InitProc
	CALL	Done
	LDI		B,1
	LDS		A,Process
	OR		A,B
	STS		Process,A
	SEI
	RJMP	Kernel
RT2:
	LDS		A,Process
	ANDI	A,2
	BREQ	CRT2
	CALL	Error
	SEI
	RJMP	Kernel	
CRT2:
	LDI		ZL,LOW(app2)
	LDI		ZH,HIGH(app2)
	LDI		B,3
	CALL	InitProc
	CALL	Done
	LDI		B,2
	LDS		A,Process
	OR		A,B
	STS		Process,A
	SEI
	RJMP	Kernel
RT3:
	LDS		A,Process
	ANDI	A,4
	BREQ	CRT3
	CALL	Error
	SEI
	RJMP	Kernel	
CRT3:
	LDI		ZL,LOW(app3)
	LDI		ZH,HIGH(app3)
	LDI		B,4
	CALL	InitProc
	CALL	Done
	LDI		B,4
	LDS		A,Process
	OR		A,B
	STS		Process,A
	SEI
	RJMP	Kernel
RT4:
	LDS		A,Process
	ANDI	A,8
	BREQ	CRT4
	CALL	Error
	SEI
	RJMP	Kernel	
CRT4:
	LDI		ZL,LOW(app4)
	LDI		ZH,HIGH(app4)
	LDI		B,5
	CALL	InitProc
	CALL	Done
	LDI		B,8
	LDS		A,Process
	OR		A,B
	STS		Process,A
	SEI
	RJMP	Kernel

C3:
	CPI		A,'K'
	BREQ	NC4
	RJMP	C4
NC4:
	CALL	USART_Recive
	CALL	USART_Send
	MOV		C,A
	CALL	PrintResultLayout
	MOV		A,C
	CPI		A,'1'
	BREQ	KT1
	CPI		A,'2'
	BREQ	KT2
	CPI		A,'3'
	BREQ	KT3
	CPI		A,'4'
	BREQ	KT4
	CALL	Error
	RJMP	Kernel
KT1:
	LDS		A,Process
	ANDI	A,1
	BRNE	CKT1
	CALL	Error
	RJMP	Kernel
CKT1:
	LDI		A,2
	CALL	KillProc
	CALL	Done
	LDS		A,Process
	ANDI	A,0xFE
	STS		Process,A
	RJMP	Kernel
KT2:
	LDS		A,Process
	ANDI	A,2
	BRNE	CKT2
	CALL	Error
	RJMP	Kernel
CKT2:
	LDI		A,3
	CALL	KillProc
	CALL	Done
	LDS		A,Process
	ANDI	A,0xFD
	STS		Process,A
	RJMP	Kernel
KT3:
	LDS		A,Process
	ANDI	A,4
	BRNE	CKT3
	CALL	Error
	RJMP	Kernel
CKT3:
	LDI		A,4
	CALL	KillProc
	CALL	Done
	LDS		A,Process
	ANDI	A,0xFB
	STS		Process,A
	RJMP	Kernel
KT4:
	LDS		A,Process
	ANDI	A,8
	BRNE	CKT4
	CALL	Error
	RJMP	Kernel
CKT4:
	LDI		A,5
	CALL	KillProc
	CALL	Done
	LDS		A,Process
	ANDI	A,0xF7
	STS		Process,A
	RJMP	Kernel

C4:
	CPI		A,'P'
	BRNE	C5
	CALL	PrintResultLayout
	LDI		B,0
	LDS		A,ProcCount
	LDI		XL,LOW(RAMS)
	LDI		XH,HIGH(RAMS)	
	CALL	itoa
	LDI		XL,LOW(RAMS)
	LDI		XH,HIGH(RAMS)
	CALL	USART_Print
	LDI		A,0xD
	CALL	USART_Send
	RJMP	Kernel
C5:
	CPI		A,'S'
	BRNE	C6
	CALL	PrintResultLayout
	LDI		B,0
	LDS		A,Second
	LDI		XL,LOW(RAMS)
	LDI		XH,HIGH(RAMS)	
	CALL	itoa
	LDI		XL,LOW(RAMS)
	LDI		XH,HIGH(RAMS)
	CALL	USART_Print
	LDI		A,0xD
	CALL	USART_Send
	RJMP	Kernel
C6:
	CPI		A,'M'
	BRNE	C7
	CALL	PrintResultLayout
	LDI		B,0
	LDS		A,Minute
	LDI		XL,LOW(RAMS)
	LDI		XH,HIGH(RAMS)	
	CALL	itoa
	LDI		XL,LOW(RAMS)
	LDI		XH,HIGH(RAMS)
	CALL	USART_Print
	LDI		A,0xD
	CALL	USART_Send
	RJMP	Kernel
C7:
	CPI		A,'H'
	BRNE	C8
	CALL	PrintResultLayout
	LDI		B,0
	LDS		A,Hour
	LDI		XL,LOW(RAMS)
	LDI		XH,HIGH(RAMS)	
	CALL	itoa
	LDI		XL,LOW(RAMS)
	LDI		XH,HIGH(RAMS)
	CALL	USART_Print
	LDI		A,0xD
	CALL	USART_Send
	RJMP	Kernel
C8:
	CPI		A,'O'
	BRNE	C9
	CALL	USART_Recive
	CALL	USART_Send
	MOV		C,A
	CALL	PrintResultLayout
	MOV		A,C
	LDI		B,0
	CPI		A,'A'
	BREQ	OAO
	CPI		A,'B'
	BREQ	OBO
	CALL	Error
	RJMP	Kernel
OAO:
	IN		A,PORTA
	LDI		XL,LOW(RAMS)
	LDI		XH,HIGH(RAMS)	
	CALL	itoa
	LDI		XL,LOW(RAMS)
	LDI		XH,HIGH(RAMS)
	CALL	USART_Print
	LDI		A,0xD
	CALL	USART_Send
	RJMP	Kernel
OBO:
	IN		A,PORTB
	LDI		XL,LOW(RAMS)
	LDI		XH,HIGH(RAMS)	
	CALL	itoa
	LDI		XL,LOW(RAMS)
	LDI		XH,HIGH(RAMS)
	CALL	USART_Print
	LDI		A,0xD
	CALL	USART_Send
	RJMP	Kernel
C9:
	CPI		A,'I'
	BRNE	C10
	CALL	USART_Recive
	CALL	USART_Send
	MOV		C,A
	CALL	PrintResultLayout
	MOV		A,C
	LDI		B,0
	CPI		A,'A'
	BREQ	OAI
	CPI		A,'B'
	BREQ	OBI
	CALL	Error
	RJMP	Kernel
OAI:
	IN		A,PINA
	LDI		XL,LOW(RAMS)
	LDI		XH,HIGH(RAMS)	
	CALL	itoa
	LDI		XL,LOW(RAMS)
	LDI		XH,HIGH(RAMS)
	CALL	USART_Print
	LDI		A,0xD
	CALL	USART_Send
	RJMP	Kernel
OBI:
	IN		A,PINB
	LDI		XL,LOW(RAMS)
	LDI		XH,HIGH(RAMS)	
	CALL	itoa
	LDI		XL,LOW(RAMS)
	LDI		XH,HIGH(RAMS)
	CALL	USART_Print
	LDI		A,0xD
	CALL	USART_Send
	RJMP	Kernel
C10:
	LDI		A,0xD
	CALL	USART_Send
	CALL	Error
RJMP	Kernel


PrintResultLayout:
	LDI		A,0xD
	CALL	USART_Send
	LDI		A,' '
	CALL	USART_Send
	CALL	USART_Send
	CALL	USART_Send
	CALL	USART_Send
	LDI		A,'='
	CALL	USART_Send
	LDI		A,' '
	CALL	USART_Send
RET

Done:
	LDI		A,'D'
	CALL	USART_Send
	LDI		A,'o'
	CALL	USART_Send
	LDI		A,'n'
	CALL	USART_Send
	LDI		A,'e'
	CALL	USART_Send
	LDI		A,0xD
	CALL	USART_Send
RET

Error:
	LDI		A,'E'
	CALL	USART_Send
	LDI		A,'r'
	CALL	USART_Send
	LDI		A,'r'
	CALL	USART_Send
	LDI		A,'o'
	CALL	USART_Send
	LDI		A,'r'
	CALL	USART_Send
	LDI		A,'!'
	CALL	USART_Send
	LDI		A,0xD
	CALL	USART_Send
RET