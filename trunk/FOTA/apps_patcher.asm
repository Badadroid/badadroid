include 'inc/settings.inc'		; user dependend settings

START
	stmfd	sp!, {lr}

	ldr	r0, [.src]
	ldr	r1, [.dst]
	bl	ARM32_SetBL

	ldmfd	sp!, {pc}		; back to the bootloader

	align 4
	.src			dw 0x4208984C	 ; NOP NOP NOP sequence in LaunchNucleus
	.dst			dw AppsPatcher


AppsPatcher:

	; add some code here
       ; ldr     r0, [.src]      ; example
       ; ldr     r1, [.dst]      ; example
       ; bl      ARM32_SetBL     ; example

	ldr	r0, [.src]
	ldrh	r1, [MOV_R5_A]
	strh	r1, [r0]

	mov pc, lr

	align 4
	.src			dw 0x4026DDD4
       ; .dst                    dw _hook1


THUMB
MOV_R5_A:
MOVS R5, 0xA


CODE32
ALIGN 4


; ==============================================================================

FUNCTIONS

DEFAULT_VARIABLES
DEFAULT_STRINGS

END
