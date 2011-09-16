include 'inc/settings.inc'		; user dependend settings

START

	bl	enable_fota_output

	ldr	r1, [_dst]
	ldr	r0, [_src]		; TEXT:4248377C BL DloadCmdUSBDefault
	bl	ARM32_SetBL

	mov	r1, #1
	ldr	r0, [pagetable]
	bl	MemMMUCacheEnable
	mov	r8, r0			; store original cp15, c1, c0 register

	bl	__PfsNandInit
	bl	__PfsMassInit

	bl	dloadmode

	NORETURN			; endless loop


align 16

FUNCTIONS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables below

DEFAULT_VARIABLES
	pagetable	dw gMMUL1PageTable
	_src		dw 0x4248377C
	_dst		dw DloadCmdUSBRead

DEFAULT_STRINGS_ADDR
DEFAULT_STRINGS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

align 0x10000

DloadCmdUSBRead:
stmfd		sp!, {lr}
sub		sp, sp, #8

mov		r0, #0
str		r0, [sp]
str		r0, [sp, #4]

ldr		r0, [_g_Hdlc]
ldrb		r1, [r0,#13]		; address
strb		r1, [sp, #0]
ldrb		r1, [r0,#14]
strb		r1, [sp, #1]
ldrb		r1, [r0,#15]
strb		r1, [sp, #2]
ldrb		r1, [r0,#16]
strb		r1, [sp, #3]

ldrb		r1, [r0,#17]		; length
strb		r1, [sp, #4]
ldrb		r1, [r0,#18]
strb		r1, [sp, #5]

ldr		r2, [sp, #4]		; length
ldr		r1, [sp]		; address
ldr		r0, [dump_buf]
bl		Flash_Read_Data

ldr		r1, [sp, #4]		; length
ldr		r0, [dump_buf]
bl		DloadTransmite

add		sp, sp, #8
ldmfd		sp!, {pc}

align 4

_g_Hdlc 	dw g_Hdlc
dump_buf	dw 0x44000000

END
