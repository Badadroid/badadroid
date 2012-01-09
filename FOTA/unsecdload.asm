include 'inc/settings.inc'		; user dependend settings

START
	bl	enable_output
	ldr	r1, [mov_r0_0]
	ldr	r0, [mov_r0_0_loc]
	str	r1, [r0]
	bl	dloadmode


mov_r0_0_loc dw 0x42087B14   ;S8500XXKL5

mov_r0_0:
MOV	R0, 0

ALIGN 4

; ==============================================================================

FUNCTIONS

DEFAULT_VARIABLES
DEFAULT_STRINGS

END
