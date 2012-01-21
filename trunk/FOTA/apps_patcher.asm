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
	ADR	 R1, hook
	LDR	 R2, [hook_size]
	BL	 memcpy


	LDR	 R0, [hook2_loc_a]
	ADR	 R1, hook2
	LDR	 R2, [hook2_size]
	BL	 memcpy

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
dumper_loc equ 0x40880000;0x408FD000
dumper_loc_a dw dumper_loc
hook_loc equ 0x40304D54 ;0x400F64A8
hook_loc_a dw hook_loc
hook:
org hook_loc
hook_begin:
;size must be 0x14
;NOP ;ADR R0, 0x40305038
NOP ;ADR R0, 0x40305038
MOV.W R2, 0
BLX  dumper_loc
;NOP ;BL  BadaPrint
;NOP ;MOV.W = 4bytes

;NOP
;NOP
NOP
NOP
NOP

NOP
NOP ;BL = 4 bytes
hook_end:
org ((hook_end-hook_begin)+hook)
ALIGN 4
hook_size dw (hook_end-hook_begin)




MemAllocTraceEx equ 0x401F5476
MemFreeTraceEx equ 0x401F599E

CODE32

ALIGN 4
hook2_loc equ 0x4039A798
hook2_loc_a dw hook2_loc
hook2:
org hook2_loc
hook2_begin:
BL  tx_hook

hook2_end:
org ((hook2_end-hook2_begin)+hook2)
ALIGN 4

hook2_size dw (hook2_end-hook2_begin)
dumper_size dw (dumper_end-dumper_begin)

dumper:
org dumper_loc
dumper_begin:
	stmfd	sp!, {r0-r10, lr}
	MOV	R8, R2
	MOV	R7, R1
	MOV	R6, R0
	LDR	R3, [R0, 4]
	CMP	R3, 6
	BNE	do_dump
	LDMFD	sp!, {r0-r10, pc}
do_dump:
	MOV	 R3, 0
	MOV	 R2, 0
	MOV	 R1, 0x4000
	MOV	 R0, 0
	BLX	MemAllocTraceEx
	MOV	R5, R0

	MOV	R1, 0
	MOV	R2, 0
	MOV	R3, R5
	CMP	R8, 0
	ADREQ	R4, rx_head
	BEQ	headerloop
	CMPNE	R8, 1
	ADREQ	R4, tx_head
	BEQ	headerloop
	CMPNE	R8, 2
	ADREQ	R4, lrx_head
	ADRNE	R4, ltx_head
headerloop:
ldrb R0, [R4, R1]
add  r1, r1, 1
cmp r0, 0
strbne r0, [r3], 1
bne    headerloop

	MOV	R1, 0
	MOV	R2, 0
       ; MOV     R3, R5
dumploop:
	LDRB	R4, [R6, R1]

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
	CMP	R1, R7
	BLT	dumploop
	MOV	R0, 0xA
	STRB	R0, [R3], 1

	MOV	R0, 0
	STRB	R0, [R3], 1
	mov	R0, R5

	BL	uart_print_string


	MOV	 R3, 0
	MOV	 R2, 0
	MOV	 R1, R5
	MOV	 R0, 0
	BLX	MemFreeTraceEx

	LDMFD	sp!, {r0-r10, pc}

uart_print_string:
STMFD		SP!, {R4,LR}
MOV		R4, R0
printloop:
ldrb	R0, [R4]
cmp	r0, 0
blne	uart_print_byte
ldrb	R0, [R4], 1
cmp	r0, 0
bne	printloop
LDMFD		SP!, {R4,PC}

uart_print_byte:
STMFD		SP!, {R4,LR}
MOV		R4, R0
uart_wait:
LDR		R0, [uart_sfr]
LDR		R0, [R0,#0x10]
TST		R0, #2
BEQ		uart_wait
LDR		R0, [uart_sfr]
STR		R4, [R0,#0x20]
LDMFD		SP!, {R4,PC}

uart_sfr dw 0xE2900800
rx_head db "rx_frame: ",0
tx_head db "tx_frame: ",0
ltx_head db "ltx_frame: ",0
lrx_head db "lrx_frame: ",0

ALIGN 4
getCurrentFramePtr   equ 0x403994AC
tx_hook:
STMFD		SP!, {R1-R10,LR}
BL		getCurrentFramePtr
LDR		R1, [R0, 0x8]
ADD		R1, 0xC
MOV		R2, 1
BL		dumper_loc
MOV		R0, 0x1000 ;replaced opcode
LDMFD		SP!, {R1-R10,PC}

dumper_end:
org ((dumper_end-dumper_begin)+dumper)

ALIGN 4


; ==============================================================================

FUNCTIONS

DEFAULT_VARIABLES
DEFAULT_STRINGS

END
