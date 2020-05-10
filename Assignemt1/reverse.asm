; reverse.asm
; CSC 230: Summer 2019
;
; Code provided for Assignment #1
;
; Mike Zastre (2019-May-22)

; This skeleton of an assembly-language program is provided to help you
; begin with the programming task for A#1, part (b). In this and other
; files provided through the semester, you will see lines of code
; indicating "DO NOT TOUCH" sections. You are *not* to modify the
; lines within these sections. The only exceptions are for specific
; changes announced on conneX or in written permission from the course
; instructor. *** Unapproved changes could result in incorrect code
; execution during assignment evaluation, along with an assignment grade
; of zero. ****
;
; In a more positive vein, you are expected to place your code with the
; area marked "STUDENT CODE" sections.

; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
; Your task: To reverse the bits in the word IN1:IN2 and to store the
; result in OUT1:OUT2. For example, if the word stored in IN1:IN2 is
; 0xA174, then reversing the bits will yield the value 0x2E85 to be
; stored in OUT1:OUT2.

    .cseg
    .org 0

; ==== END OF "DO NOT TOUCH" SECTION ==========

; **** BEGINNING OF "STUDENT CODE" SECTION **** 
    ; These first lines store a word into IN1:IN2. You may
    ; change the value of the word as part of your coding and
    ; testing.
    ;
    ldi R16, 0xA1
    sts IN1, R16 ;IN1 <= 0XA1
    ldi R16, 0x74
    sts IN2, R16 ;IN2 <= 0X74

	ldi r17, 8 ;these two are counters for loop and loop2
	ldi r20, 8
	lds r21, IN1 ;load the value of IN1 (0XA1) in to r21
	lds r23, IN2 ;load the value of IN2 (0X74) in to r23
;This loop is for reversing the first byte
loop: 
	ror r21	;rotate right r21
	rol r22 ;rotate left r22
	dec r17 ;count--
	brne loop 
;This loop is for reversing the second byte
loop2:
	ror r23
	rol r24
	dec r20
	brne loop2

	;Storing the reversed parts
	sts IN1, r22
	sts IN2, r24
    
    ; This code only swaps the order of the bytes from the
    ; input word to the output word. This clearly isn't enough
    ; so you may modify or delete these lines as you wish.
    ;
    lds R16, IN1
	sts OUT2, R16

    lds R16, IN2
	sts OUT1, R16

; **** END OF "STUDENT CODE" SECTION ********** 



; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
stop:
    rjmp stop

    .dseg
    .org 0x200
IN1:	.byte 1
IN2:	.byte 1
OUT1:	.byte 1
OUT2:	.byte 1
; ==== END OF "DO NOT TOUCH" SECTION ==========
