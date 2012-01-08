include 'inc/settings.inc'		; user dependend settings

START
   stmfd   sp!, {lr}
   LDR	 R1, [mov_r0_0]
   LDR	 R0, [mov_r0_0_loc]
   STR	 R1, [R0]

   ldmfd   sp!, {pc}


mov_r0_0_loc dw 0x42089344   ;S8500XXKL5

mov_r0_0:
MOV    R0, 0

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
