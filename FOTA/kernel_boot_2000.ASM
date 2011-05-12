
include 'inc/S8500XXJEE.inc'	  ;here include the right BL function pointers, depends on model and BL you've got
include 'inc/macros_S8500.inc'	  ;model dependend FOTA header and footer

include 'inc/vars.inc'
include 'inc/functions.inc'


START
	MOV		R0, #0xA9
	BL		GPIO_Drv_UnsetExtInterrupt
;	BL		disp_Normal_Init
;	BL		DRV_Modem_BootingStart
	;BL		LaunchNucleus

	SUB	SP, SP, 128
	MOV	r1, #1
	LDR	r0, [pagetable]
	BL	MemMMUCacheEnable
	MOV	R8, R0 ;lets store previous MMU control register to turn it off later

	bl	enable_uart_output ;enable_fota_output
	MOV	R0, 1234
	BL	int_debugprint
	BL	__PfsNandInit
	BL	__PfsMassInit

	MOV	R1, SP
	LDR	R0, [s_kernel_path_a]
	BL	tfs4_stat

	LDR	R2, [SP,0xC] ;get kernel size
	ADR	R0, kernel_size
	STR	R2, [R0]	;store for later use

	ldr	r0, [s_loadkernel_a]
	bl	debug_print
	MOV	R2, R2
	LDR	R1, [kernel_ptr]
	LDR	R0, [s_kernel_path_a]
	BL	loadfile
	ldr	r0, [s_done_a]
	bl	debug_print

	MOV	R1, SP
	LDR	R0, [s_atag_path_a]
	BL	tfs4_stat

	LDR	R2, [SP,0xC]				;get atag size
	ADR	R0, atag_size
	STR	R2, [R0]					;store for later use

	ldr	r0, [s_loadatag_a]
	bl	debug_print
	MOV	R2, R2
	LDR	R1, [atag_ptr]
	LDR	R0, [s_atag_path_a]
	BL	loadfile
	ldr	r0, [s_done_a]
	bl	debug_print

	mov	r0, #0x0
	bl VIC_InterruptDisable	; turn off IRQ and FIQ ???

	bl CoDisableVectoredInt
	bl CoDisableIrq

	bl System_EnableVIC_end
	bl System_EnableIRQ_end
	bl System_EnableFIQ_end

	bl CoDisableFiq
	bl CoDisableICache
	bl CoDisableDCache
	bl CoDisableMmu

	ldr	r0, [s_mmuoff_a]
	bl	debug_print

	MCR	p15, 0, R8,c1,c0 ;turn off MMUCache with previous gained MMU control reg
	ldr	r0, [s_done_a]
	bl	debug_print

	LDR		R2, [atag_ptr]
	MOV		R1, 3379		; Samsung S5PC210 Nuri board ???
	MOV		R0, #0x0

	ldr r1, [kernel_ptr]
	ldr	r0, [s_startkernel_a]
	bl	debug_print

	LDR	R5, [kernel_ptr]	; zImage_my 6701096 bytes
	BLX	R5

	ldr	r0, [s_kernelreturn_a]
	bl	debug_print

	BL	dloadmode

FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables below
DEFAULT_VARIABLES
    pagetable		dw gMMUL1PageTable

    kernel_ptr	dw 0x20008000
    kernel_size 	dw 0x0

    atag_ptr		dw 0x20000100
    atag_size		dw 0x0

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
    s_patchsbl_a     dw s_patchsbl
    s_kernelreturn_a dw s_kernelreturn
    s_loadatag_a     dw s_loadatag
    s_startkernel_a  dw s_startkernel
    s_atag_path_a    dw s_atag_path

DEFAULT_STRINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;add custom strings below
    s_kernel_path    du '/g/galaxyboot/zImage',0
    s_sbl_path	     du '/g/galaxyboot/sbl.bin',0
    s_atag_path	     du '/g/galaxyboot/atag.bin',0

    s_loadsbl	     db ' Loading sbl.bin',0
    s_loadkernel     db ' Loading zImage',0
    s_jumpingout     db ' Jumpout to 0x%X',0
    s_mmuoff	     db ' Turning off MMU',0
    s_kernelreloc    db ' Reloc kernel to 0x%X',0
    s_kernelreturn   db ' WTF KERNEL RETURNED',0
    s_patchsbl	     db ' Patching SBL',0
    s_loadatag	     db ' Loading atag.bin',0
    s_startkernel    db ' Starting kernel at 0x%X',0

END
