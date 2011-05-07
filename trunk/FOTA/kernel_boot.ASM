
include 'inc/S8500XXJEE.inc'	  ;here include the right BL function pointers, depends on model and BL you've got
include 'inc/macros_S8500.inc'	  ;model dependend FOTA header and footer

include 'inc/vars.inc'
include 'inc/functions.inc'

; VERY rough code for loading sbl to 0x40244000 and Kernel to 0x32000000, then executes KERNEL.
; Sbl is unused in this code
START
	MOV	r1, #1
	LDR	r0, [pagetable]
	BL	MemMMUCacheEnable
	bl	enable_uart_output ;enable_fota_output
	MOV	R0, 1234
	BL	int_debugprint
	BL	__PfsNandInit
	BL	__PfsMassInit


	ldr	r0, [s_loadsbl_a]
	bl	debug_print
	LDR	R2, [sbl_size]
	LDR	R1, [sbl_start]
	LDR	R0, [s_sbl_path_a]
	BL	loadfile
	BL	int_debugprint
	ldr	r0, [s_done_a]
	bl	debug_print

	ldr	r0, [s_loadkernel_a]
	bl	debug_print
	LDR	R2, [kernel_size]
	LDR	R1, [kernel_buf]
	LDR	R0, [s_kernel_path_a]
	BL	loadfile
	BL	int_debugprint
	ldr	r0, [s_done_a]
	bl	debug_print

	ldr	r0, [s_mmuoff_a]
	bl	debug_print
	bl	CoDisableMmu
	ldr	r0, [s_done_a]
	bl	debug_print

	LDR	R1, [sbl_start]
	LDR	R0, [s_jumpingout_a]
	BL	debug_print

	LDR	R5, [sbl_start]
	BLX	R5

	ldr	r0, [s_kernelreturn_a]
	bl	debug_print
	mov	r1, 0x32000000
	BL	dloadmode
testmembank:
	STMFD	SP!, {R0-R1,LR}

semafor:
	BL	Get_Onedram_Semaphore
	CMP	R0, #0
	BEQ	semafor

	LDR	R0, [opcode]
	LDR	R1, [kernel_start]
	STR	R0, [R1]

	MOV	R0, 0
	LDR	R0, [R1]
	BL	hex_debugprint
	BL	Onedram_Release_Semaphore
	LDMFD	SP!, {R0-R1,PC}
relockernel:
	STMFD	SP!, {R0-R2,LR}

	LDR	R1, [kernel_start]
	ldr	r0, [s_kernelreloc_a]
	bl	debug_print
	LDR	R0, [kernel_buf]
	LDR	R1, [kernel_start]
	LDR	R2, [kernel_size]
	BL	rebell_memcpy
	ldr	r0, [s_done_a]
	bl	debug_print

	LDMFD	SP!, {R1-R2,PC}
FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables below
DEFAULT_VARIABLES
    pagetable		dw gMMUL1PageTable

    sbl_start		dw 0x40244000
    sbl_size		dw 0x140000

    kernel_start	dw 0x32000000

    kernel_buf		dw 0x41000000
    kernel_size 	dw 0x6664C8  ;6710472
    kernel_buf_end	dw 0x416664C8

    opcode		dw 0xE1A0F00E

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; strings at the end
DEFAULT_STRINGS_ADDR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; add custom strings addresses below (for using by LDR op)
    s_kernel_path_a  dw s_kernel_path
    s_sbl_path_a     dw s_sbl_path
    s_loadsbl_a      dw s_loadsbl
    s_loadkernel_a   dw s_loadkernel
    s_jumpingout_a   dw s_jumpingout
    s_kernelreloc_a  dw s_kernelreloc
    s_mmuoff_a	     dw s_mmuoff
    s_kernelreturn_a dw s_kernelreturn

DEFAULT_STRINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;add custom strings below
    s_kernel_path    du '/g/galaxyboot/zImage',0
    s_sbl_path	     du '/g/galaxyboot/Sbl2FOTA_mijoma2.bin',0

    s_loadsbl	     db ' Loading SBL',0
    s_loadkernel     db ' Loading kernel image to buf',0
    s_jumpingout     db ' Jumpout to 0x%X',0
    s_mmuoff	     db ' Turning off MMU',0
    s_kernelreloc    db ' Reloc kernel to 0x%X',0
    s_kernelreturn   db ' WTF KERNEL RETURNED',0

copykernel:
	code_len = copykernel - c_start
	db	0x4000 - code_len dup 0xFF
	STMFD	SP!, {R1-R2,LR}
	MOV	R0, 9999
	BL	int_debugprint

	BL	testmembank

	LDMFD	SP!, {R1-R2,PC}

END
