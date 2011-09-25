include 'inc/settings.inc'              ; user dependend settings

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



; r0 = g_Hdlc + 13
DloadCmdHandler:
	stmfd	sp!, {r4, lr}

	; commands
	ldrb	r4, [r0]
	cmp	r4, #1                  ; read nand
	cmpne	r4, #2                  ; read memory
	ldmfdne	sp!, {r4, pc}

	; clear variables
	sub	sp, sp, #8
	mov	r1, #0
	str	r1, [sp]
	str	r1, [sp, #4]

	; address
	ldrb	r1, [r0,#1]
	strb	r1, [sp, #0]
	ldrb	r1, [r0,#2]
	strb	r1, [sp, #1]
	ldrb	r1, [r0,#3]
	strb	r1, [sp, #2]
	ldrb	r1, [r0,#4]
	strb	r1, [sp, #3]

	; length
	ldrb	r1, [r0,#5]
	strb	r1, [sp, #4]
	ldrb	r1, [r0,#6]
	strb	r1, [sp, #5]

	ldr	r2, [sp, #4]            ; length
	ldr	r1, [sp]                ; address
	ldr	r0, [dump_buf]

	cmp	r4, #1                  ; nand
	bleq	Flash_Read_Data
	cmp	r4, #2                  ; memory
	bleq	rebell_memcpy

	ldr	r1, [sp, #4]            ; length
	ldr	r0, [dump_buf]
	bl	DloadTransmite

	add	sp, sp, #8
	ldmfd	sp!, {r4, pc}

	align 4

	pagetable                       dw gMMUL1PageTable
	dump_buf                        dw 0x44000000

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FUNCTIONS

DEFAULT_VARIABLES
DEFAULT_STRINGS_ADDR
DEFAULT_STRINGS

END
