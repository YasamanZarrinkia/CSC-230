; a2_morse.asm
; CSC 230: Summer 2019
;
; Student name:
; Student ID:
; Date of completed work:
;
; *******************************
; Code provided for Assignment #2
;
; Author: Mike Zastre (2019-Jun-12)
; 
; This skeleton of an assembly-language program is provided to help you
; begin with the programming tasks for A#2. As with A#1, there are 
; "DO NOT TOUCH" sections. You are *not* to modify the lines
; within these sections. The only exceptions are for specific
; changes announced on conneX or in written permission from the course
; instructor. *** Unapproved changes could result in incorrect code
; execution during assignment evaluation, along with an assignment grade
; of zero. ****
;
; I have added for this assignment an additional kind of section
; called "TOUCH CAREFULLY". The intention here is that one or two
; constants can be changed in such a section -- this will be needed
; as you try to test your code on different messages.
;


; =============================================
; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
; =============================================

.include "m2560def.inc"

.cseg
.equ S_DDRB=0x24
.equ S_PORTB=0x25
.equ S_DDRL=0x10A
.equ S_PORTL=0x10B

	
.org 0
	; Copy test encoding (of 'sos') into SRAM
	;
	ldi ZH, high(TESTBUFFER)
	ldi ZL, low(TESTBUFFER)
	ldi r16, 0x30
	st Z+, r16
	ldi r16, 0x37
	st Z+, r16
	ldi r16, 0x30
	st Z+, r16
	clr r16
	st Z, r16

	; initialize run-time stack
	ldi r17, high(0x21ff)
	ldi r16, low(0x21ff)
	out SPH, r17
	out SPL, r16

	; initialize LED ports to output
	ldi r17, 0xff
	sts S_DDRB, r17
	sts S_DDRL, r17

; =======================================
; ==== END OF "DO NOT TOUCH" SECTION ====
; =======================================

; ***************************************************
; **** BEGINNING OF FIRST "STUDENT CODE" SECTION **** 
; ***************************************************

	; If you're not yet ready to execute the
	; encoding and flashing, then leave the
	; rjmp in below. Otherwise delete it or
	; comment it out.

	;rjmp stop

    ; The following seven lines are only for testing of your
    ; code in part B. When you are confident that your part B
    ; is working, you can then delete these seven lines. 
	/*
	ldi r17, high(TESTBUFFER)
	ldi r16, low(TESTBUFFER)
	push r17
	push r16
	rcall flash_message
    pop r16
    pop r17
	*/

	;LDI R16,0B00010001
	;CALL MORSE_FLASH
	;RJMP STOP
   ;
; ***************************************************
; **** END OF FIRST "STUDENT CODE" SECTION ********** 
; ***************************************************


; ################################################
; #### BEGINNING OF "TOUCH CAREFULLY" SECTION ####
; ################################################

; The only things you can change in this section is
; the message (i.e., MESSAGE01 or MESSAGE02 or MESSAGE03,
; etc., up to MESSAGE09).
;

	; encode a message
	;
	
	ldi r17, high(MESSAGE02 << 1)
	ldi r16, low(MESSAGE02 << 1)
	push r17
	push r16
	ldi r17, high(BUFFER01)
	ldi r16, low(BUFFER01)
	push r17
	push r16
	rcall encode_message
	pop r16
	pop r16
	pop r16
	pop r16
	
	
	LDI R16, 0b01000010
	push r16
	call morse_flash
	pop r16
	rjmp stop
	

; ##########################################
; #### END OF "TOUCH CAREFULLY" SECTION ####
; ##########################################


; =============================================
; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
; =============================================
	; display the message three times
	;
	ldi r18, 1
main_loop:
	ldi r17, high(BUFFER01)
	ldi r16, low(BUFFER01)
	push r17
	push r16
	rcall flash_message
	dec r18
	tst r18
	brne main_loop


stop:
	rjmp stop
; =======================================
; ==== END OF "DO NOT TOUCH" SECTION ====
; =======================================


; ****************************************************
; **** BEGINNING OF SECOND "STUDENT CODE" SECTION **** 
; ****************************************************


flash_message:
.SET OFFSET=7

	PUSH ZH ;FOR PARAMETER
	PUSH ZL
	PUSH YH ;FOR SP
	PUSH YL


	IN YH,SPH
	IN YL,SPL

	LDD ZH,Y+OFFSET+2
	LDD ZL,Y+OFFSET+1

	TRAVERSE:
		Ld R16,Z+ ;LOAD BINARIES
		TST R16   ;IF IT REACHED END OF THE SEQUENCE
		BREQ EXITf
		;PUSH R16
		CALL morse_flash 
		;POP R16
		RJMP TRAVERSE
		 
	EXITf:

		POP ZL
		POP ZH
		POP YL
		POP YH
		ret


morse_flash:

	CPI R16,0xff
	BREQ special_case

	PUSH R16
	PUSH R17
	PUSH R18
	PUSH R19

	MOV R19,R16

	MOV R17,R16
	ANDI R17,0xf0
	SWAP R17

	SWAP R19
	ANDI R19,0xf0

	;ldi r16,2
	ldi R24,0b00000100
	mov r23,r17
	sub r24,r23
	ALOOP:
		LSL R19
		DEC R24
		TST R24
		BREQ THE_LOOP

		RJMP ALOOP

	THE_LOOP:

	mov r21,r19	
	ANDI R21,0b10000000
	tst r21
	BREQ IT_DOT
	TST R21
	BRNE IT_DASH


	STOPact:
		POP R19
		POP R18
		POP R17
		POP R16
		ret

	special_case:	; Special case if r16 = 0xff as defined in outline 
		CALL leds_off 
		CALL delay_long 
		 CALL delay_long 
		CALL delay_long
		LSL R19
		RJMP STOPact 


	IT_DOT:
		ldi r16,2	; Dot delays as stated in outline 
		CALL leds_on 
		CALL delay_short 
		CALL leds_off 
		CALL delay_long
		LSL R19 
		DEC R17
		TST R17
		BRNE THE_LOOP
		RJMP STOPact

	IT_DASH:
		ldi r16,4 ; Dash delays as stated in outline 
		CALL leds_on 
		CALL delay_long 
		CALL leds_off 
		CALL delay_long
		LSL R19
		DEC R17
		TST R17
		BRNE THE_LOOP
		RJMP STOPact 

leds_on:

	CPI R16, 0	;COMPARE R16 WITH 0 TO SEE HOW MANY LED SHOULD BE ON  
	BREQ zero		 
				 
	CPI R16, 1		
	BREQ one 


	CPI R16, 2		
	BREQ two 

 
	CPI R16, 3		 
	BREQ three 

	CPI R16, 4		
	BREQ four 

 
	CPI R16, 5		
	BREQ five 

 	CPI R16, 6		 
	BREQ six 

	 
	zero:					 
	 	CALL leds_off 
		RJMP FINISH 

 	one: ; Turns on one LED then returns 
		LDI R17, 0b00000010 
		STS S_PORTL,R17 
		rjmp FINISH 

 	two:						
		LDI R17, 0b00001010 
		STS S_PORTL, R17 
		RJMP FINISH

 	three:					
		LDI R17, 0b00101010    
        STS S_PORTL,R17    
		RJMP FINISH 

 
	four:					 
		LDI R17, 0b00000010 
		STS S_PORTB, R17 
		LDI R17, 0b00101010    
		STS S_PORTL, R17 
		RJMP FINISH

 
	five: 					
		LDI R17, 0b00001010 
		STS S_PORTB, R17 
		LDI R17, 0b00101010 
		STS S_PORTL,R17 
		RJMP FINISH 

 
    six: 					
		LDI R17, 0b00001010 
		STS S_PORTB,R17 
		LDI R17, 0b10101010 
		STS S_PORTL,R17 
		RJMP FINISH 
	
	
	FINISH:
		ret



leds_off:
	LDI R17,0b00000000
	STS S_PORTB,R17
	STS S_PORTL,R17
	ret



encode_message:
.set PARAM_OFFSET=9

	PUSH XH ;x is for buffer
	PUSH XL 
	PUSH YH ;Y is for sp
	PUSH YL
	PUSH ZH ;z is for message
	PUSH ZL 

	IN YH,SPH
	IN YL,SPL

	LDD ZH,Y+PARAM_OFFSET+4
	LDD ZL,Y+PARAM_OFFSET+3

	LDD XH,Y+PARAM_OFFSET+2
	LDD XL,Y+PARAM_OFFSET+1

	LOOP:
		lpm R19,Z+
		CPI R19,0
		BREQ DONE
		PUSH R19
		CALL alphabet_encode
		pop R19
		st X+,R0
		RJMP LOOP

	DONE:
		
		ldi r20, 0
		st X+, r20
		clr r20
		POP ZL
		POP ZH
		POP YL
		POP YH
		POP XL
		POP XH
		
		ret	



alphabet_encode:
.SET OFFSET=7
	PUSH YH
	PUSH YL
	PUSH ZH
	PUSH ZL

	IN YH,SPH
	IN YL,SPL

	LDD R20,Y+OFFSET+1

	LDI ZH,HIGH(ITU_MORSE<<1) ;LOAD ITU_MORSE ADDRESS
	LDI ZL,LOW(ITU_MORSE<<1)
	LDI R21,0  ;DOTS AND DASHES PLACE HOLDER
	LPM R22,Z+  ;LOAD FIRST CHARACTER FROM PROGRAM_MEMMORY TO R22
	CPI R22,0
	BREQ NULL_EXIT

	LOOP1:
		LDI R17,0
		MOV R0,R17
		CPi R20,0x20
		BREQ SPECIAL
		CP R20,R22  ;COMPARE WITH THE GIVEN CHARACTER
		BREQ LOOP2  ;IF IT'S SAME GO TO NEXT STAGE
		LPM R22,Z+ ;GO TO THE NEXT CHARACTER IN THE TABLE
		LPM R22,Z+
		LPM R22,Z+
		LPM R22,Z+
		LPM R22,Z+
		LPM R22,Z+
		LPM R22,Z+
		LPM R22,Z+
		RJMP LOOP1  ;KEEP CHECKING
	SPECIAL:
		LDI R23,0xff
		MOV R0,R23
		POP ZL
		POP ZH
		POP YL
		POP YH
		ret	 


	LOOP2:
		LPM R22,Z+  ;GO OVER DASHES AND DOTS
		CPI R22,0
		BREQ EXIT   ;ONCE REACH TO THE 0 EXIT
		INC R0
		LSL R21
		CPI R22,'-' ;COMPARE TO SEE IF IT'S DASH
		BREQ DASH	;IF IT IS GO TO DASH LABEL
	    BRNE DOT		;IF IT'S NOT GO TO DOT LABEL

	DASH:
		INC R21
		RJMP LOOP2

	DOT:
		RJMP LOOP2

	EXIT:
		
		LSL R0
		LSL R0
		LSL R0
		LSL R0
		
		OR R0,R21

	NULL_EXIT:		
		POP ZL
		POP ZH
		POP YL
		POP YH
		ret	 


; **********************************************
; **** END OF SECOND "STUDENT CODE" SECTION **** 
; **********************************************


; =============================================
; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
; =============================================

delay_long:
	rcall delay
	rcall delay
	rcall delay
	ret

delay_short:
	rcall delay
	ret

; When wanting about a 1/5th of second delay, all other
; code must call this function
;
delay:
	rcall delay_busywait
	ret


; This function is ONLY called from "delay", and
; never directly from other code.
;
delay_busywait:
	push r16
	push r17
	push r18

	ldi r16, 0x08
delay_busywait_loop1:
	dec r16
	breq delay_busywait_exit
	
	ldi r17, 0xff
delay_busywait_loop2:
	dec	r17
	breq delay_busywait_loop1

	ldi r18, 0xff
delay_busywait_loop3:
	dec r18
	breq delay_busywait_loop2
	rjmp delay_busywait_loop3

delay_busywait_exit:
	pop r18
	pop r17
	pop r16
	ret



;.org 0x1000

ITU_MORSE: .db "a", ".-", 0, 0, 0, 0, 0
	.db "b", "-...", 0, 0, 0
	.db "c", "-.-.", 0, 0, 0
	.db "d", "-..", 0, 0, 0, 0
	.db "e", ".", 0, 0, 0, 0, 0, 0
	.db "f", "..-.", 0, 0, 0
	.db "g", "--.", 0, 0, 0, 0
	.db "h", "....", 0, 0, 0
	.db "i", "..", 0, 0, 0, 0, 0
	.db "j", ".---", 0, 0, 0
	.db "k", "-.-", 0, 0, 0, 0
	.db "l", ".-..", 0, 0, 0
	.db "j", "--", 0, 0, 0, 0, 0
	.db "n", "-.", 0, 0, 0, 0, 0
	.db "o", "---", 0, 0, 0, 0
	.db "p", ".--.", 0, 0, 0
	.db "q", "--.-", 0, 0, 0
	.db "r", ".-.", 0, 0, 0, 0
	.db "s", "...", 0, 0, 0, 0
	.db "t", "-", 0, 0, 0, 0, 0, 0
	.db "u", "..-", 0, 0, 0, 0
	.db "v", "...-", 0, 0, 0
	.db "w", ".--", 0, 0, 0, 0
	.db "x", "-..-", 0, 0, 0
	.db "y", "-.--", 0, 0, 0
	.db "z", "--..", 0, 0, 0
	.db 0, 0, 0, 0, 0, 0, 0, 0

MESSAGE01: .db "a a a", 0
MESSAGE02: .db "sos", 0
MESSAGE03: .db "a box", 0
MESSAGE04: .db "dairy queen", 0
MESSAGE05: .db "the shape of water", 0, 0
MESSAGE06: .db "john wick parabellum", 0, 0
MESSAGE07: .db "how to train your dragon", 0, 0
MESSAGE08: .db "oh canada our own and native land", 0
MESSAGE09: .db "is that your final answer", 0

; First message ever sent by Morse code (in 1844)
MESSAGE10: .db "what god hath wrought", 0


.dseg
.org 0x2000
BUFFER01: .byte 128
BUFFER02: .byte 128
TESTBUFFER: .byte 4

; =======================================
; ==== END OF "DO NOT TOUCH" SECTION ====
; =======================================
