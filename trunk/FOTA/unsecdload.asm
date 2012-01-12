include 'inc/settings.inc'		; user dependend settings

START
	bl	enable_output

	ldr	r1, [.mov_r0_0]

	ldr	r0, [.loc1]
	str	r1, [r0]

	ldr	r0, [.loc2]
	str	r1, [r0]

	bl	dloadmode


.loc1                           dw 0x42094884
.loc2                           dw 0x42094960

.mov_r0_0:
mov	r0, 0

; ==============================================================================

FUNCTIONS

DEFAULT_VARIABLES
DEFAULT_STRINGS

END
