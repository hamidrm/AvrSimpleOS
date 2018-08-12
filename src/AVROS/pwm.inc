/*
 * pwm.inc
 *
 *  Created: 5/23/2013 8:43:29 AM
 *   Author: Hamid
 */ 


 pwminit:
	LDI		A,(1<<WGM20) | (1<<COM20) | (1<<COM21) | (1<<CS21) | (1<<CS22)
	OUT		TCCR2,A
 RET


 pwmset:
	OUT		OCR2,A
 RET