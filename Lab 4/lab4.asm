$NOLIST
$MODDE0CV
$LIST

; student number 12345678
N_1 equ 79H
N_2 equ 24H
N_3 equ 30H
N_4 equ 19H
N_5 equ 12H
N_6 equ 02H
N_7 equ 78H
N_8 equ 00H

BLANK equ 11111111b

;HELLO
L_H equ 09H
L_E equ 06H
L_L equ 47H
L_O equ 40H

;CPN
L_C equ 46H
L_P equ 0CH
L_N equ 48H

org 0
	ljmp main

main:
	mov sp, #7fH
	mov LEDRA, #0
	mov LEDRB, #0
	mov hex5, #N_1
	mov hex4, #N_2
	mov hex3, #N_3
	mov hex2, #N_4
	mov hex1, #N_5
	mov hex0, #N_6
	ljmp Forever
	
DELAY:
	mov R2, #90
L2: mov R1, #250
L1: mov R0, #250
L0: djnz R0, L0
	djnz R1, L1
	djnz R2, L2
	ret

case_000:
	mov hex5, #N_1
	mov hex4, #N_2
	mov hex3, #N_3
	mov hex2, #N_4
	mov hex1, #N_5
	mov hex0, #N_6
	ret

case_001:
	mov hex5, #BLANK
	mov hex4, #BLANK
	mov hex3, #BLANK
	mov hex2, #BLANK
	mov hex1, #N_7
	mov hex0, #N_8
	ret

case_010:
	mov hex5, #N_1
	mov hex4, #N_2
	mov hex3, #N_3
	mov hex2, #N_4
	mov hex1, #N_5
	mov hex0, #N_6
	mov R4, #N_8
	mov R5, #N_7
	jnb KEY.3, SET_STATE_1
	jb SWA.3, ScrollLeft
	lcall ScrollLeftLong
	ret
	
ScrollLeft:
	lcall DELAY
	mov R6, hex5
	mov hex5, hex4
	mov hex4, hex3
	mov hex3, hex2
	mov hex2, hex1
	mov hex1, hex0
	mov hex0, R5
	mov A, R4
	mov R5, A
	mov A, R6
	mov R4, A
	jnb KEY.3, SET_STATE_1
	ljmp ScrollLeft

SET_STATE_1:
	ljmp SET_STATE

ScrollLeftLong:
	lcall DELAY
	lcall DELAY
	mov R6, hex5
	mov hex5, hex4
	mov hex4, hex3
	mov hex3, hex2
	mov hex2, hex1
	mov hex1, hex0
	mov hex0, R5
	mov A, R4
	mov R5, A
	mov A, R6
	mov R4, A
	jnb KEY.3, SET_STATE_1
	ljmp ScrollLeftLong

case_011:
	mov hex5, #N_1
	mov hex4, #N_2
	mov hex3, #N_3
	mov hex2, #N_4
	mov hex1, #N_5
	mov hex0, #N_6
	mov R4, #N_8
	mov R5, #N_7
	jnb KEY.3, SET_STATE_1
	jb SWA.3, ScrollRight
	lcall ScrollRightLong
	ret

ScrollRight:
	lcall DELAY
	mov R6, hex0
	mov hex0, hex1
	mov hex1, hex2
	mov hex2, hex3
	mov hex3, hex4
	mov hex4, hex5
	mov hex5, R4
	mov A, R5
	mov R4, A
	mov A, R6
	mov R5, A
	jnb KEY.3, SET_STATE_1
	ljmp ScrollRight

ScrollRightLong:
	lcall DELAY
	lcall DELAY
	mov R6, hex0
	mov hex0, hex1
	mov hex1, hex2
	mov hex2, hex3
	mov hex3, hex4
	mov hex4, hex5
	mov hex5, R4
	mov A, R5
	mov R4, A
	mov A, R6
	mov R5, A
	jnb KEY.3, SET_STATE_2
	ljmp ScrollRightLong

SET_STATE_2:
	ljmp SET_STATE
	
case_100:
	mov hex5, #N_3
	mov hex4, #N_4
	mov hex3, #N_5
	mov hex2, #N_6
	mov hex1, #N_7
	mov hex0, #N_8
	jnb KEY.3, SET_STATE_2
	jb SWA.3, ShortBlink
	lcall LongBlink
	ret
	
ShortBlink:
	lcall DELAY
	mov hex5, #BLANK
	mov hex4, #BLANK
	mov hex3, #BLANK
	mov hex2, #BLANK
	mov hex1, #BLANK
	mov hex0, #BLANK
	lcall DELAY
	ljmp case_100
	
LongBlink:
	lcall DELAY
	lcall DELAY 
	mov hex5, #BLANK
	mov hex4, #BLANK
	mov hex3, #BLANK
	mov hex2, #BLANK
	mov hex1, #BLANK
	mov hex0, #BLANK
	lcall DELAY
	lcall DELAY
	ljmp case_100

case_101:
	mov hex5, #BLANK
	mov hex4, #BLANK
	mov hex3, #BLANK
	mov hex2, #BLANK
	mov hex1, #BLANK
	mov hex0, #BLANK
	jnb KEY.3, SET_STATE_N
	jb SWA.3, ShortAppear
	lcall LongAppear
	ret

SET_STATE_N:
	ljmp SET_STATE

ShortAppear:
	lcall DELAY
	mov hex5, #N_1
	lcall DELAY
	jnb KEY.3, SET_STATE_N
	mov hex4, #N_2
	lcall DELAY
	jnb KEY.3, SET_STATE_N
	mov hex3, #N_3
	lcall DELAY
	jnb KEY.3, SET_STATE_N
	mov hex2, #N_4
	lcall DELAY
	jnb KEY.3, SET_STATE_N
	mov hex1, #N_5
	lcall DELAY
	jnb KEY.3, SET_STATE_N
	mov hex0, #N_6
	lcall DELAY
	jnb KEY.3, SET_STATE_N
	ljmp case_101

LongAppear:
	lcall DELAY
	lcall DELAY
	mov hex5, #N_1
	lcall DELAY
	lcall DELAY
	jnb KEY.3, SET_STATE_3
	mov hex4, #N_2
	lcall DELAY
	lcall DELAY
	jnb KEY.3, SET_STATE_3
	mov hex3, #N_3
	lcall DELAY
	lcall DELAY
	jnb KEY.3, SET_STATE_3
	mov hex2, #N_4
	lcall DELAY
	lcall DELAY
	jnb KEY.3, SET_STATE_3
	mov hex1, #N_5
	lcall DELAY
	lcall DELAY
	jnb KEY.3, SET_STATE_3
	mov hex0, #N_6
	lcall DELAY
	lcall DELAY
	jnb KEY.3, SET_STATE_3
	ljmp case_101
	
SET_STATE_3:
	ljmp SET_STATE

case_110:
	mov hex5, #L_H
	mov hex4, #L_E
	mov hex3, #L_L
	mov hex2, #L_L
	mov hex1, #L_O
	mov hex0, #BLANK
	jnb KEY.3, SET_STATE_3
	jb SWA.3, ShortDelay
	lcall LongDelay
	ret
	
L3:	
	mov hex5, #N_1
	mov hex4, #N_2
	mov hex3, #N_3
	mov hex2, #N_4
	mov hex1, #N_5
	mov hex0, #N_6
	jnb KEY.3, SET_STATE_3
	jb SWA.3, ShortDelay_2
	lcall LongDelay_2
	
L4:	
	mov hex5, #L_C
	mov hex4, #L_P
	mov hex3, #L_N
	mov hex2, #N_3
	mov hex1, #N_1
	mov hex0, #N_2
	jnb KEY.3, SET_STATE_3
	jb SWA.3, ShortDelay_3
	lcall LongDelay_3
	
ShortDelay:
	lcall DELAY
	ljmp L3
	
LongDelay:
	lcall DELAY
	lcall DELAY
	ljmp L3
	
ShortDelay_2:
	lcall DELAY
	ljmp L4
	
LongDelay_2:
	lcall DELAY
	lcall DELAY
	ljmp L4

ShortDelay_3:
	lcall DELAY
	ljmp case_110
	
LongDelay_3:
	lcall DELAY
	lcall DELAY
	ljmp case_110

case_111:
	mov hex5, #BLANK
	mov hex4, #BLANK
	mov hex3, #BLANK
	mov hex2, #BLANK
	mov hex1, #BLANK
	mov hex0, #BLANK
	jnb KEY.3, SET_STATE_4
	jb SWA.4, MostSigRand
	lcall LeastSigRand
	ret

SET_STATE_4:
	ljmp SET_STATE

MostSigRand:
	jb SWA.3, SMostRand
	lcall LMostRand

SMostRand:
	lcall DELAY
	mov hex3, #N_1
	lcall DELAY
	jnb KEY.3, SET_STATE_4
	mov hex0, #N_2
	lcall DELAY
	jnb KEY.3, SET_STATE_4
	mov hex2, #N_3
	lcall DELAY
	jnb KEY.3, SET_STATE_4
	mov hex4, #N_4
	lcall DELAY
	jnb KEY.3, SET_STATE_4
	mov hex1, #N_5
	lcall DELAY
	jnb KEY.3, SET_STATE_4
	mov hex5, #N_6
	lcall DELAY
	jnb KEY.3, SET_STATE_4
	ljmp case_111

LMostRand:
	lcall DELAY
	lcall DELAY
	mov hex3, #N_1
	lcall DELAY
	lcall DELAY
	jnb KEY.3, SET_STATE_4
	mov hex0, #N_2
	lcall DELAY
	lcall DELAY
	jnb KEY.3, SET_STATE_4
	mov hex2, #N_3
	lcall DELAY
	lcall DELAY
	jnb KEY.3, SET_STATE_4
	mov hex4, #N_4
	lcall DELAY
	lcall DELAY
	jnb KEY.3, SET_STATE_4
	mov hex1, #N_5
	lcall DELAY
	lcall DELAY
	jnb KEY.3, SET_STATE_M
	mov hex5, #N_6
	lcall DELAY
	lcall DELAY
	jnb KEY.3, SET_STATE_M
	ljmp case_111

SET_STATE_M:
	ljmp SET_STATE

LeastSigRand:
	jb SWA.3, SLeastRand
	lcall LLeastRand

SLeastRand:
	lcall DELAY
	mov hex4, #N_3
	lcall DELAY
	jnb KEY.3, SET_STATE_M
	mov hex0, #N_4
	lcall DELAY
	jnb KEY.3, SET_STATE_M
	mov hex3, #N_5
	lcall DELAY
	jnb KEY.3, SET_STATE_M
	mov hex5, #N_6
	lcall DELAY
	jnb KEY.3, SET_STATE_M
	mov hex1, #N_7
	lcall DELAY
	jnb KEY.3, SET_STATE_M
	mov hex2, #N_8
	lcall DELAY
	jnb KEY.3, SET_STATE_M
	ljmp case_111

LLeastRand:
	lcall DELAY
	lcall DELAY
	mov hex4, #N_3
	lcall DELAY
	lcall DELAY
	jnb KEY.3, SET_STATE
	mov hex0, #N_4
	lcall DELAY
	lcall DELAY
	jnb KEY.3, SET_STATE
	mov hex3, #N_5
	lcall DELAY
	lcall DELAY
	jnb KEY.3, SET_STATE
	mov hex5, #N_6
	lcall DELAY
	lcall DELAY
	jnb KEY.3, SET_STATE
	mov hex1, #N_7
	lcall DELAY
	lcall DELAY
	jnb KEY.3, SET_STATE
	mov hex2, #N_8
	lcall DELAY
	lcall DELAY
	jnb KEY.3, SET_STATE
	ljmp case_111

SET_STATE:
	mov A, SWA
	anl A, #00000111B
	mov R3, A
	ljmp Forever 

Forever:
	jnb KEY.3, SET_STATE
	mov LEDRA, R3
Label0:
	cjne R3, #00000000B, Label1
	lcall case_000
Label1:
	cjne R3, #00000001B, Label2
	lcall case_001
Label2:
	cjne R3, #00000010B, Label3
	lcall case_010
Label3:
	cjne R3, #00000011B, Label4
	lcall case_011
Label4:
	cjne A, #00000100B, Label5
	lcall case_100
Label5:
	cjne A, #00000101B, Label6
	lcall case_101
Label6:
	cjne A, #00000110B, Label7
	lcall case_110
Label7:
	cjne A, #00000111B, Forever
	lcall case_111

END	