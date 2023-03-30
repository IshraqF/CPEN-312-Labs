$modde0cv

	CSEG at 0
	ljmp mycode

dseg at 30h

x:		ds	4 ; 32-bits for variable 'x'
y:		ds	4 ; 32-bits fro variable 'y'
bcd:	ds	5 ; 10-digit packed BDC (each byte stores 2 digits)
temp1:	ds	4 ; 32-bits for variable 'temp1'
temp2:	ds	4 ; 32-bits for variable 'temp2'

bseg

mf:			dbit 1 ; Math functions flag

$include(math32.asm)

	CSEG

; Look-up table for 7-seg displays
myLUT:
    DB 0C0H, 0F9H, 0A4H, 0B0H, 099H        ; 0 TO 4
    DB 092H, 082H, 0F8H, 080H, 090H        ; 4 TO 9

showBCD MAC
	; Display LSD
    mov A, %0
    anl a, #0fh
    movc A, @A+dptr
    mov %1, A
	; Display MSD
    mov A, %0
    swap a
    anl a, #0fh
    movc A, @A+dptr
    mov %2, A
ENDMAC

Display:
	mov dptr, #myLUT
	showBCD(bcd+0, HEX0, HEX1)
	showBCD(bcd+1, HEX2, HEX3)
	showBCD(bcd+2, HEX4, HEX5)
    ret

MYRLC MAC
	mov a, %0
	rlc a
	mov %0, a
ENDMAC

Shift_Digits:
	mov R0, #4 ; shift left four bits
Shift_Digits_L0:
	clr c
	MYRLC(bcd+0)
	MYRLC(bcd+1)
	MYRLC(bcd+2)
	MYRLC(bcd+3)
	MYRLC(bcd+4)
	djnz R0, Shift_Digits_L0
	; R7 has the new bcd digit	
	mov a, R7
	orl a, bcd+0
	mov bcd+0, a
	; bcd+3 and bcd+4 don't fit in the 7-segment displays so make them zero
	clr a
	mov bcd+4, a
	ret

Wait50ms:
;33.33MHz, 1 clk per cycle: 0.03us
	mov R0, #30
L3: mov R1, #74
L2: mov R2, #250
L1: djnz R2, L1 ;3*250*0.03us=22.5us
    djnz R1, L2 ;74*22.5us=1.665ms
    djnz R0, L3 ;1.665ms*30=50ms
    ret

; Check if SW0 to SW9 are toggled up.  Returns the toggled switch in
; R7.  If the carry is not set, no toggling switches were detected.
ReadNumber:
	mov r4, SWA ; Read switches 0 to 7
	mov a, SWB ; Read switches 8 to 9
	anl a, #00000011B ; Only two bits of SWB available
	mov r5, a
	mov a, r4
	orl a, r5
	jz ReadNumber_no_number
	lcall Wait50ms ; debounce
	mov a, SWA
	clr c
	subb a, r4
	jnz ReadNumber_no_number ; it was a bounce
	mov a, SWB
	anl a, #00000011B
	clr c
	subb a, r5
	jnz ReadNumber_no_number ; it was a bounce
	mov r7, #16 ; Loop counter
ReadNumber_L0:
	clr c
	mov a, r4
	rlc a
	mov r4, a
	mov a, r5
	rlc a
	mov r5, a
	jc ReadNumber_decode
	djnz r7, ReadNumber_L0
	sjmp ReadNumber_no_number	
ReadNumber_decode:
	dec r7
	setb c
ReadNumber_L1:
	mov a, SWA
	jnz ReadNumber_L1
ReadNumber_L2:
	mov a, SWB
	jnz ReadNumber_L2
	ret
ReadNumber_no_number:
	clr c
	ret

; macro for loading temp1
LOAD_temp1 MAC
	mov x+0, #low (%0 % 0x10000) 
	mov x+1, #high(%0 % 0x10000) 
	mov x+2, #low (%0 / 0x10000) 
	mov x+3, #high(%0 / 0x10000) 
ENDMAC

; macro for loading temp2
LOAD_temp2 MAC
	mov x+0, #low (%0 % 0x10000) 
	mov x+1, #high(%0 % 0x10000) 
	mov x+2, #low (%0 / 0x10000) 
	mov x+3, #high(%0 / 0x10000) 
ENDMAC

; temp1 = x
copy_xtemp1:
	mov temp1+0, x+0
	mov temp1+1, x+1
	mov temp1+2, x+2
	mov temp1+3, x+3
	ret

; y = temp1	
copy_temp1y:
	mov y+0, temp1+0
	mov y+1, temp1+1
	mov y+2, temp1+2
	mov y+3, temp1+3
	ret

; temp2 = x
copy_xtemp2:
	mov temp2+0, x+0
	mov temp2+1, x+1
	mov temp2+2, x+2
	mov temp2+3, x+3
	ret

; x = temp2	
copy_temp2x:
	mov x+0, temp2+0
	mov x+1, temp2+1
	mov x+2, temp2+2
	mov x+3, temp2+3
	ret

; jump to forever loop
forever_jump:
	ljmp forever

remainder_loop:
	; remainder = dividend (x is the dividend and y is the divisor)
	; while remainder >= divisor
	;	remainder = remainder - divisor (x = x - y)
	lcall sub32
	lcall x_lt_y
	jnb mf, remainder_loop
	ret

do_percentage:
	; x = x*y
	; x//100
	lcall mul32
	Load_y(100)
	lcall div32
	ret

do_isqrt:
	; def babylonian(n):
	; x = n
	; y = 1
	; while(x>y):
	;	x = (x+y)//2
	;	y = n//x
	; return x
	LOAD_y(1)
	lcall copy_xtemp1
do_isqrt_loop:
	lcall add32
	LOAD_y(2)
	lcall div32
	lcall copy_xtemp2
	lcall copy_temp1y
	lcall xchg_xy
	lcall div32
	lcall copy_xy
	lcall copy_temp2x
	lcall x_lteq_y
	jnb mf, do_isqrt_loop
	ret

; check the function and turn the corresponding LED on
check:
	cjne R3, #0, case1
	mov LEDRA, #0b
	setb LEDRA.0
case1:
	cjne R3, #1, case2
	mov LEDRA, #0b
	setb LEDRA.1
case2:
	cjne R3, #2, case3
	mov LEDRA, #0b
	setb LEDRA.2
case3:
	cjne R3, #3, case4
	mov LEDRA, #0b
	setb LEDRA.3
case4:
	cjne R3, #4, case5
	mov LEDRA, #0b
	setb LEDRA.4
case5:
	cjne R3, #5, case6
	mov LEDRA, #0b
	setb LEDRA.5
case6:
	cjne R3, #6, other
	mov LEDRA, #0b
	setb LEDRA.6
other:
	ret
		
mycode:
	mov SP, #7FH
	clr a
	mov LEDRA, a
	mov LEDRB, a
	mov bcd+0, a
	mov bcd+1, a
	mov bcd+2, a
	mov bcd+3, a
	mov bcd+4, a
	lcall Display
	mov b, #0 ; b = 0: addition, b = 1: subtraction, etc
	setb LEDRA.0 ; turn on LEDR0 to indicate addition

; KEYs are set to 1 by default.
; So, 'not pressed' means KEY is pressed or the bit is set to 0
forever:
	mov R3, b
	lcall check
	jb KEY.3, no_funct ; If 'Function' key not pressed, skip
	jnb KEY.3, $ ; Wait for the release of 'Function' key
	inc b ; 'b' is used as function select
	mov a, b ; make sure b is not larger than 6
	cjne a, #7, forever ; loop in forever until b gets larger than 6
	mov b, #0 ; set b to 0 if it gets larger than 7
	ljmp forever ; Go check for more input

no_funct:
	jb KEY.2, no_load ; If 'Load' key is not pressed, skip
	jnb KEY.2, $ ; Wait for the release of 'Load' key
	lcall bcd2hex ; Convert the BCD number to hex in x
	lcall copy_xy ; Copy x to y
	Load_X(0) ; Cear x (this is a macro)
	lcall hex2bcd ; Convert result in x to BCD
	lcall Display ; Display the new BCD number
	ljmp forever

no_load:
	jb KEY.1, no_equal_jump ; If 'equal' is not pressed, skip
	jnb KEY.1, $ ; Wait for the release of 'equal' key
	lcall bcd2hex ; Convert the BCD number to hex in x
	mov a, b ; Check if we are doing addition
	cjne a, #0, sub ; If we are not doing addition, go to subtraction
	lcall add32 ; x = x+y
	lcall hex2bcd ; Convert result in x to BCD
	lcall Display ; Display the new BCD number
	ljmp forever ; Go check for more input

no_equal_jump:
	ljmp no_equal ; long jump to no_equal

sub:
	cjne a, #1, multiply
	lcall xchg_xy
	lcall sub32 ; x = x-y
	lcall hex2bcd
	lcall Display
	ljmp forever

multiply:
	cjne a, #2, division
	lcall xchg_xy
	lcall mul32 ; x = x*y
	lcall hex2bcd
	lcall Display
	ljmp forever

division:
	cjne a, #3, remainder
	lcall xchg_xy
	lcall div32 ; x = x//y (floor division)
	lcall hex2bcd
	lcall Display
	ljmp forever

remainder:
	cjne a, #4, percentage
	lcall xchg_xy
	lcall x_lt_y
	jnb mf, remainder_loop_jump ; if x < y, just display x, else go to remainder
	lcall hex2bcd
	lcall Display
	ljmp forever
remainder_loop_jump:
	lcall remainder_loop
	lcall hex2bcd
	lcall Display
	ljmp forever

percentage:
	cjne a, #5, isqrt
	lcall xchg_xy
	lcall do_percentage
	lcall hex2bcd
	lcall Display
	ljmp forever

isqrt:
	cjne a, #6, no_new_digit
	lcall xchg_xy
	lcall do_isqrt
	lcall hex2bcd
	lcall Display
	ljmp forever

no_equal:
	lcall ReadNumber
	jnc no_new_digit
	lcall Shift_Digits
	lcall Display

no_new_digit:
	ljmp forever
	
end
