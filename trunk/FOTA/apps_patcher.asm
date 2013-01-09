 ;
 ; This file is part of Badadroid project.
 ;
 ; Copyright (C) 2012 Rebellos, mijoma, b_kubica
 ;
 ;
 ; Badadroid is free software: you can redistribute it and/or modify
 ; it under the terms of the GNU General Public License as published by
 ; the Free Software Foundation, either version 3 of the License, or
 ; (at your option) any later version.
 ;
 ; Badadroid is distributed in the hope that it will be useful,
 ; but WITHOUT ANY WARRANTY; without even the implied warranty of
 ; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ; GNU General Public License for more details.
 ;
 ; You should have received a copy of the GNU General Public License
 ; along with Badadroid.  If not, see <http://www.gnu.org/licenses/>.
 ;
 ;
 
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
      ;  LDR      R0, [.patch2]
      ;  LDRH     R1, [MOV_R0_1]
      ;  STRH     R1, [R0]

      ;  LDR     R0, [.mkeypatch]
      ;  LDR     R1, [.mkeyloc]
      ;  STR     R1, [R0]

	LDR	 R0, [drv_add_hook_loc_a]
	ADR	 R1, drv_add_hook
	LDR	 R2, [drv_hook_size]
      ;  BL       memcpy

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
	.mkeypatch		   dw 0x414292D4
	.mkeyloc		   dw fakemkeycheck
       ; .dst                    dw _hook1


dumper_loc equ 0x40880000;0x408FD000


THUMB
MOV_R5_A:
MOVS R5, 0xBA
MOV_R0_1:
MOVS R0, 1


ALIGN 4
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


CODE32

ALIGN 4

drv_add_hook_loc equ 0x40381E20
drv_add_hook_loc_a dw drv_add_hook_loc
drv_add_hook:
org drv_add_hook_loc
drv_hook_begin:
BL drv_dumper
drv_hook_end:
org ((drv_hook_end-drv_hook_begin)+drv_add_hook)
ALIGN 4
drv_hook_size dw (drv_hook_end-drv_hook_begin)

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

	CMP	R8, 3 ;is it DRV packet?
	MOVEQ	R7, R1 ;get size from second param
	BEQ	do_dump  ;dump

	LDR	R7, [R0, 8] ; load buffer size
	ADD	R7, R7, 0xC ; add header size
	MOV	R6, R0
	LDR	R3, [R0, 4]
	CMP	R3, 6	 ;skip FM_PACKETs
	BNE	do_dump
	B	dumper_ret
do_dump:
	MOV	R1, 0
	MOV	R2, 0
	CMP	R8, 0
	ADREQ	R4, rx_head
	BEQ	prefix_print
	CMPNE	R8, 1
	ADREQ	R4, tx_head
	BEQ	prefix_print
	CMPNE	R8, 2
	ADREQ	R4, lrx_head
	CMPNE	R8, 3
	ADREQ	R4, drv_event
	ADRNE	R4, drv_event
	B	prefix_print
rx_head db "rx_frame: ",0
tx_head db "tx_frame: ",0
ltx_head db "ltx_frame: ",0
lrx_head db "lrx_frame: ",0
drv_event db "drv_event: ",0
ALIGN 4
prefix_print:
	MOV	R0, R4
	BL	uart_print_string

	MOV	R1, 0
	MOV	R2, 0
dumploop:
	LDRB	R4, [R6, R1]

	UBFX	R0, R4, 4, 4
	CMP	R0, 10
	ADDCC	R0, R0, 48
	ADDCS	R0, R0, (65-10)
	BL	uart_print_byte

	UBFX	R0, R4, 0, 4
	CMP	R0, 10
	ADDCC	R0, R0, 48
	ADDCS	R0, R0, (65-10)
	BL	uart_print_byte
	MOV	R0, ' '
	BL	uart_print_byte

	ADD	R1, R1, 1
	CMP	R1, R7
	BLT	dumploop
	MOV	R0, 0xA
	BL	uart_print_byte

	MOV	R0, 0
dumper_ret:
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

ALIGN 4

fakemkeycheck:
MOV	R0, 1
MOV	PC, LR

THUMB
THUMB_NOP:
NOP
CODE32

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

drv_dumper:
MOV		R3, SP
STMFD		SP!, {R4, LR}
ADD		R0, R3, 4
MOV		R1, 1
MOV		R2, 3
LDR		R4, [R0]
CMP		R4, 0x26
BLNE		dumper_loc
MOV		R3, 0
LDMFD		SP!, {R4, PC}


dumper_end:
org ((dumper_end-dumper_begin)+dumper)

ALIGN 4


; ==============================================================================

FUNCTIONS

DEFAULT_VARIABLES
DEFAULT_STRINGS

END
