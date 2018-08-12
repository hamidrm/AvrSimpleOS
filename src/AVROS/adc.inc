/*
 * adc.inc
 *
 *  Created: 5/19/2013 10:56:29 PM
 *   Author: Omran Rezaee
 */ 
GetADC:
	IN		A,ADCSRA
	ORI		A,1<<6
	OUT		ADCSRA,A
	LDELAY	0x100
RET

InitADC:
	ANDI	A,0x07
	ORI		A,1<<7 | 1<<6
	OUT		ADMUX,A
	LDI		A,1<<ADEN | 1<<ADPS0 | 1<<ADPS1 | 1<<ADPS2
	OUT		ADCSRA,A
RET