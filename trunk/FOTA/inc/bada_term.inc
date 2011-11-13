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
	ldrb	r1, [r0, 2]
	cmp	r3, 1
	ldrb	ip, [r0, 1]
	ldrb	r2, [r0, 0]
	mov	r1, r1, lsl 16
	ldrb	r4, [r0, 5]
	orr	r1, r1, ip, lsl 8
	orr	r1, r1, r2
	ldrb	r2, [r0, 3]
	orr	r1, r1, r2, lsl 24
	ldrb	r2, [r0, 4]
	orr	r4, r2, r4, lsl 8
	bne	@f
	mov	r2, r4
	ldr	r0, [dump_buf]
	bl	Flash_Read_Data
	b	.transmite
@@:
	cmp	r3, 2
	ldmfdne sp!, {r4, pc\}
	ldr	r0, [dump_buf]
	mov	r2, r4
	bl	memcpy

.transmite:
	mov	r1, r4
	ldr	r0, [dump_buf]
	ldmfd	sp!, {r4, lr\}
	b	DloadTransmite


DloadRunCode:
	stmfd	sp!, {lr\}
	ldrb	r2, [r0, 0]
	ldrb	r3, [r0, 1]
	orr	r2, r2, r3, lsl 8
	add	r1, r0, 2
	ldr	r0, [code_buf]
	bl	memcpy
	blx	r0
	ldmfd	sp!, {lr\}
	b	DloadResponseOK


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
	bxne	lr
	b	DloadResponseOK 	; CMD_CONN_CHECK

	align 4
	dump_buf                        dw DUMP_BUFFER
	code_buf                        dw CODE_BUFFER

; =============================================================================

END_INCLUDE_ONCE
