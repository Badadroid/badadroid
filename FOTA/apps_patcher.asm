include 'inc/settings.inc'		; user dependend settings

START
	stmfd	sp!, {lr}
	BL	enable_uart_output

	ldr	r0, [.src]
	ldr	r1, [.dst]
	bl	ARM32_SetBL

	ldmfd	sp!, {pc}		; back to the bootloader

	align 4
	.src			dw 0x4208985C	 ; NOP NOP NOP sequence in LaunchNucleus
	.dst			dw AppsPatcher


AppsPatcher:

	; add some code here
       ; ldr     r0, [.src]      ; example
       ; ldr     r1, [.dst]      ; example
       ; bl      ARM32_SetBL     ; example

	;ldr     r0, [.src]
	;ldrh    r1, [MOV_R5_A]
	;strh    r1, [r0]

	stmfd	 sp!, {lr}
	LDR	 R0, [.patch2]
	LDRH	 R1, [MOV_R0_1]
	STRH	 R1, [R0]


	LDR	 R0, [hook_loc_a]
	BL	 hex_debugprint

	LDR	 R0, [hook_size]
	BL	 hex_debugprint

	LDR	 R0, [hook_loc_a]
	ADR	 R1, hook
	LDR	 R2, [hook_size]
	BL	 memcpy


	LDR	 R0, [dumper_loc_a]
	BL	 hex_debugprint

	LDR	 R0, [dumper_size]
	BL	 hex_debugprint

	LDR	 R0, [dumper_loc_a]
	ADR	 R1, dumper
	LDR	 R2, [dumper_size]
	BL	 memcpy
	ldmfd	 sp!, {pc}

	align 4
	.patch1 		   dw 0x402702B8
	.patch2 		   dw 0x4026FC1C; 0x4026FBD8
       ; .dst                    dw _hook1


THUMB
MOV_R5_A:
MOVS R5, 0xBA
MOV_R0_1:
MOVS R0, 1


ALIGN 4
dumper_loc equ 0x408FD000
dumper_loc_a dw dumper_loc
BadaPrint equ 0x40442800
hook_loc equ 0x40304D54 ;0x400F64A8
hook_loc_a dw hook_loc
hook:
org hook_loc
hook_begin:
;size must be 0x14
;NOP ;ADR R0, 0x40305038
NOP ;ADR R0, 0x40305038
BLX  dumper_loc
;NOP ;BL  BadaPrint
;NOP ;MOV.W = 4bytes

NOP
NOP
NOP
NOP
NOP

NOP
NOP ;BL = 4 bytes
hook_end:
org ((hook_end-hook_begin)+hook)
ALIGN 4
hook_size dw (hook_end-hook_begin)



CODE32
ALIGN 4

dumper_size dw (dumper_end-dumper_begin)

dumper:
org dumper_loc
dumper_begin:
	stmfd	sp!, {r0-r10, lr}
	MOV	R6, R1
	MOV	R5, R0
	ADR	R0, string_buf
	MOV	R1, 0
	MOV	R2, 0
clearloop:
	STRB	R2, [R0, R1]
	ADD	R1, R1, 1
	CMP	R1, 8192
	BLT	clearloop

	MOV	R1, 0
	MOV	R2, 0
	ADR	R3, string_buf
printloop:
	LDRB	R4, [R5, R1]

	UBFX	R0, R4, 4, 4
	CMP	R0, 10
	ADDCC	R0, R0, 48
	ADDCS	R0, R0, (65-10)
	STRB	R0, [R3], 1

	UBFX	R0, R4, 0, 4
	CMP	R0, 10
	ADDCC	R0, R0, 48
	ADDCS	R0, R0, (65-10)
	STRB	R0, [R3], 1
	MOV	R0, ' '
	STRB	R0, [R3], 1

	ADD	R1, R1, 1
	CMP	R1, R6
	BLT	printloop
	MOV	R0, 0xA
	STRB	R0, [R3], 1
	ADR	R0, string_buf
	BL	BadaPrint

	LDMFD	sp!, {r0-r10, pc}
string_buf db 8192 dup 0x0
dumper_end:
org ((dumper_end-dumper_begin)+dumper)



; ==============================================================================

FUNCTIONS

DEFAULT_VARIABLES
DEFAULT_STRINGS

END
