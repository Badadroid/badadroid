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
 
INCLUDE_ONCE BADA_TERM

CODE_BUFFER equ FOTA_BUFFER
DUMP_BUFFER equ CODE_BUFFER + 1 MB

; =============================================================================

; void DloadResponseOK ( );
DloadResponseOK:
	mov	r0, 0
	b	DloadResponse


; void DloadPacketHandler ( void (*handler) ( const unsigned char *packet ) );
DloadPacketHandler:
	stmfd	sp!, {lr\}
	mov	r1, r0
	adr	r0, _hook_DloadProcessPacketCustom
	bl	ARM32_SetBL
	adr	r1, _DloadProcessPacketCustom
	ldr	r0, [.src]
	bl	ARM32_SetBL
	ldmfd	sp!, {pc\}

	align 4
	.src			dw DloadProcessPacket + 8


; internal function - do not use
_DloadProcessPacketCustom:
	stmfd	sp!, {lr\}
	ldrb	r4, [r0,12]	; we need to return that value in r4 to DloadProcessPacket()
	cmp	r4, 0xDE	; unused, for now
	ldmfdne sp!, {pc\}
	add	r0, 13
_hook_DloadProcessPacketCustom:
	nop
	ldmfd	sp!, {pc\}

; =============================================================================

DloadRead:
	stmfd	sp!, {r4, lr\}
	mov	r3, r1
	MOV	R2, R0
	BL	loadWord
	MOV	R1, R0
	ADD	R0, R2, 4
	BL	loadHalf
	mov	r4, r0
	cmp	r3, 1
	bne	@f
	mov	r2, r0		  ;read flash
	ldr	r0, [dump_buf]
	bl	Flash_Read_Data
	b	.transmite
@@:
	cmp	r3, 2	 ;read ram
	ldmfdne sp!, {r4, pc\}
	mov	r2, r0
	ldr	r0, [dump_buf]
	bl	memcpy

.transmite:
	mov	r1, r4
	ldr	r0, [dump_buf]
	ldmfd	sp!, {r4, lr\}
	b	DloadTransmite


DloadRunCode:
	stmfd	sp!, {lr\}
	mov	r1, r0
	BL	loadHalf
	mov	r2, r0
	add	r1, r1, 2
	ldr	r0, [code_buf]
	bl	memcpy
	blx	r0
	ldmfd	sp!, {lr\}
	b	DloadResponseOK


DloadLoadBinary:
	stmfd	sp!, {lr\}
	mov	r1, r0
	BL	loadHalf
	mov	r2, r0
	add	r0, r1, 2
	BL	loadWord ;target addr
	add	r1, 6
	bl	memcpy
	ldmfd	sp!, {pc\}

DloadBranch:
	stmfd	sp!, {lr\}
	BL	loadWord
	MOV	R9, R0
	bl	DloadResponseOK
	BX	R9
	ldmfd	sp!, {pc\}

DloadDebugPrint:
	stmfd	sp!, {lr\}
      ;  BL      loadWord
      ;  mov     r2, r0
       ; add     r1, r1, 4
       ; ldr     r0, [code_buf]
       ; bl      memcpy
      ;  LDR     R0, [code_buf]
	ADD	R0, R0, 4
	BL	debug_print
	ldmfd	sp!, {pc\}

DloadSetSysInfo:
	stmfd	sp!, {lr\}
	BL	loadWord
if defined OemSysSetSystemInfo
	LDR R4, [OemSysSetSystemInfo_a]
	LDR R5, [mov_r0_0]
	STR R5, [R4, 0xC]
	BL  OemSysSetSystemInfo
end if
	ldmfd	sp!, {pc\}

mov_r0_0:
MOV R0, 0
OemSysSetSystemInfo_a dw OemSysSetSystemInfo

DloadGetSysInfo:
	stmfd	sp!, {lr\}
	BL	loadWord
if defined OemSysGetSystemInfo
	BL  OemSysGetSystemInfo
end if
	ldmfd	sp!, {pc\}

DloadCmdHandler:
	ldrb	r1, [r0]
	add	r0, 1
	sub	r3, r1, 1
	cmp	r3, 1
	bhi	@f
	b	DloadRead		; CMD_READ_NAND, CMD_READ_RAM
@@:
	cmp	r1, 3
	bne	@f
	b	DloadRunCode		; CMD_CODE_RUN
@@:
	cmp	r1, 4
	bne	@f
	b	DloadResponseOK 	; CMD_CONN_CHECK
@@:
	cmp	r1, 5
	bne	@f
	b	DloadLoadBinary 	; CMD_LOAD_BIN
@@:
	cmp	r1, 6
	bne	@f
	b	DloadBranch		; CMD_BRANCH
@@:
	cmp	r1, 7
	bne	@f
	b	DloadDebugPrint 	    ; CMD_DEBUGPRINT
@@:
	cmp	r1, 8
	bne	@f
	b	DloadGetSysInfo 	    ; CMD_GET_SYS_INFO
@@:
	cmp	r1, 9
	bxne	lr
	b	DloadSetSysInfo 	    ; CMD_SET_SYS_INFO

	align 4
	dump_buf			dw DUMP_BUFFER
	code_buf			dw CODE_BUFFER

; =============================================================================

END_INCLUDE_ONCE
