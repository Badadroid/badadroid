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
	stmfd	sp!, {lr}

	; add some code here
       ; ldr     r0, [.src]      ; example
       ; ldr     r1, [.dst]      ; example
       ; bl      ARM32_SetBL     ; example

	ldr	r0, [.src]
	ldr	r1, [MOV_R5_A]
	str	r1, [r0]

	ldmfd	sp!, {pc}

	align 4
	.src			dw 0x4026DDD4
       ; .dst                    dw _hook1

MOV_R5_A	dw 0xE3A0500A


_hook1:
	ldr	pc, [loc_4088A2EC]

	align 4
	loc_4088A2EC		dw 0x4088A2EC


; ==============================================================================

FUNCTIONS

DEFAULT_VARIABLES
DEFAULT_STRINGS

END
