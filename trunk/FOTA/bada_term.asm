include 'inc/settings.inc'              ; user dependend settings

CODE_BUFFER equ BUF2_DRAM_START
DUMP_BUFFER equ CODE_BUFFER + 1 MB

START
	bl	enable_fota_output

	adr	r0, DloadCmdHandler     ; register our handler
	bl	DloadPacketHandler

	mov	r1, #1
	ldr	r0, [pagetable]
	bl	MemMMUCacheEnable

	bl	__PfsNandInit
	bl	__PfsMassInit

	bl	dloadmode

	NORETURN                        ; endless loop


DloadRead:
	stmfd	sp!, {r4, lr}
	mov	r3, r1
	ldrb	r1, [r0, #2]
	cmp	r3, #1
	ldrb	ip, [r0, #1]
	ldrb	r2, [r0, #0]
	mov	r1, r1, lsl #16
	ldrb	r4, [r0, #5]
	orr	r1, r1, ip, lsl #8
	orr	r1, r1, r2
	ldrb	r2, [r0, #3]
	orr	r1, r1, r2, lsl #24
	ldrb	r2, [r0, #4]
	orr	r4, r2, r4, lsl #8
	bne	@f
	mov	r2, r4
	ldr	r0, [dump_buf]
	bl	Flash_Read_Data
	b	.transmite
@@:
	cmp	r3, #2
	ldmfdne	sp!, {r4, pc}
	ldr	r0, [dump_buf]
	mov	r2, r4
	bl	memcpy

.transmite:
	mov	r1, r4
	ldr	r0, [dump_buf]
	ldmfd	sp!, {r4, lr}
	b	DloadTransmite


DloadRunCode:
	stmfd	sp!, {lr}
	ldrb	r2, [r0, #0]
	ldrb	r3, [r0, #1]
	orr	r2, r2, r3, lsl #8
	add	r1, r0, #2
	ldr	r0, [code_buf]
	bl	memcpy
	blx	r0
	ldmfd	sp!, {lr}
	b	DloadResponseOK


DloadCmdHandler:
	ldrb	r1, [r0]
	add	r0, #1
	sub	r3, r1, #1
	cmp	r3, #1
	bhi	@f
	b	DloadRead
@@:
	cmp	r1, #3
	bxne	lr
	b	DloadRunCode


	align 4
	pagetable                       dw gMMUL1PageTable
	dump_buf                        dw DUMP_BUFFER
	code_buf                        dw CODE_BUFFER

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FUNCTIONS

DEFAULT_VARIABLES
DEFAULT_STRINGS_ADDR
DEFAULT_STRINGS

END
