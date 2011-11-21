include 'inc/settings.inc'		; user dependend settings

START
	stmfd	sp!, {lr}

	ldr	r0, [.src]
	ldr	r0, [.dst]
	bl	ARM32_SetBL

	ldmfd	sp!, {pc}               ; back to the bootloader

	align 4
	.src                    dw LaunchNucleus + 0x160    ; NOP NOP NOP sequence in LaunchNucleus
	.dst                    dw AppsPatcher


AppsPatcher:
	stmfd	sp!, {lr}

	; add some code here
	ldr	r0, [.src]      ; example
	ldr	r0, [.dst]      ; example
	bl	ARM32_SetBL     ; example

	ldmfd	sp!, {pc}

	align 4
	.src                    dw 0x40100000
	.dst                    dw _hook1


_hook1:
	ldr	pc, [loc_4088A2EC]

	align 4
	loc_4088A2EC            dw 0x4088A2EC


; ==============================================================================

FUNCTIONS

DEFAULT_VARIABLES
DEFAULT_STRINGS

END
