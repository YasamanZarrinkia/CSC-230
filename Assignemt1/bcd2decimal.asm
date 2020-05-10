; modulo.asm
; CSC 230: Summer 2019
;
; Code provided for Assignment #1
;
; Mike Zastre (2019-May-22)

; This skeleton of an assembly-language program is provided to help you
; begin with the programming task for A#1, part (c). In this and other
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
; Your task: Given a binary-coded decimal (BCD) number stored in
; R16, conver this number into the usual binary representation,
; and store in BCD2BINARY.
;

    .cseg
    .org 0

    .equ TEST1=0x99 ; 99 decimal, equivalent to 0b01100011
    .equ TEST2=0x81 ; 81 decimal, equivalent to 0b01010001
	.equ TEST3=0x20 ; 20 decimal, equivalent to 0b00010100
	 
	ldi r16, TEST1

; ==== END OF "DO NOT TOUCH" SECTION ==========

; **** BEGINNING OF "STUDENT CODE" SECTION **** 

ldi r17,0xF0
ldi r18,0x0F
ldi r19,4
ldi r20,9
and r17,r16
and r18,r16



loop:
	ror r17
	dec r19
	breq done
	rjmp loop

done:
mov r21,r17
loop2:
	add r17,r21
	dec r20
	breq done2
	rjmp loop2

done2:

add r17,r18
STS BCD2BINARY,r17







; **** END OF "STUDENT CODE" SECTION ********** 

; ==== BEGINNING OF "DO NOT TOUCH" SECTION ====
end:
	rjmp end


.dseg
.org 0x200
BCD2BINARY: .byte 1
; ==== END OF "DO NOT TOUCH" SECTION ==========
