
include 'inc/S8500XXJEE.inc'	  ;here include the right BL function pointers, depends on model and BL you've got
include 'inc/macros_S8500.inc'	  ;model dependend FOTA header and footer

include 'inc/vars.inc'
include 'inc/functions.inc'


START
	;MOV             R0, #0xA9
	;BL              GPIO_Drv_UnsetExtInterrupt
	;BL              disp_Normal_Init
	;BL              DRV_Modem_BootingStart
	;BL             LaunchNucleus

	SUB	SP, SP, 128

	MOV	r1, #1
	LDR	r0, [pagetable]
	BL	MemMMUCacheEnable
	MOV	R8, R0 ;lets store previous MMU control register to turn it off later

	bl	enable_uart_output ;enable_fota_output
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

	ldr	r0, [s_patchsbl_a]
	bl	debug_print
	ldr	r0, [atag_ptr]
	ldr	r1, [sbl_atag_addr]
	str	r0, [r1]
	ldr	r1, [sbl_atag_addr2]
	str	r0, [r1]

	ldr	r0, [kernel_ptr]
	ldr	r1, [sbl_kernel_addr]
	str	r0, [r1]
	ldr	r1, [sbl_kernel_addr2]
	str	r0, [r1]

	ldr	r0, [jmp_op]
	ADD	R0, R0, 0xA ;14 ops
	ldr	r1, [sbl_jmp_patch] ;where to place our jump patch?
	str	r0, [r1]
	ldr	r0, [s_done_a]
	bl	debug_print

	MOV	R1, SP
	LDR	R0, [s_kernel_path_a]
	BL	tfs4_stat

	LDR	R2, [SP,0xC] ;get kernel size
	LDR	R0, [kernel_size_a]
	STR	R2, [R0]	;store for later use
	LDR	R0, [R0]
	BL	hex_debugprint

	ldr	r0, [s_loadkernel_a]
	bl	debug_print
	LDR	R2, [kernel_size_a]
	LDR	R1, [kernel_buf]
	LDR	R0, [s_kernel_path_a]
	BL	loadfile
	BL	int_debugprint
	ldr	r0, [s_done_a]
	bl	debug_print

	ldr	r0, [s_mmuoff_a]
	bl	debug_print

	MCR	p15, 0, R8,c1,c0 ;turn off MMUCache with previous gained MMU control reg
	ldr	r0, [s_done_a]
	bl	debug_print

	;ldr     r0, [s_configramirq_a]
	;bl      debug_print

	;BL      CoDisableL2Cache
	;BL     CoDisableDCache
	;BL      CoInvalidateBothCaches
	;BL      System_DisableVIC
	;BL      System_DisableIRQ
    ;BL      System_DisableFIQ
	BL	configure_ram ;reconfigure DMC1 to map bank0 onto 0x30 instead of 0x20, code from PBL, it isn't trustable

	;BL      relockernel

       ; ldr     r0, [s_done_a]
       ; bl      debug_print
	BL	CoDisableMmu


      ; MOV    R0, #0xA9
      ; BL     GPIO_Drv_UnsetExtInterrupt
      ;  BL     DRV_Modem_BootingStart

      ; MOV    R0, #0xA9
      ; BL     GPIO_Drv_UnsetExtInterrupt

	LDR	R1, [sbl_start]
	LDR	R0, [s_jumpingout_a]
	BL	debug_print

	BL	FIMD_Drv_Stop
	BL	FIMD_Drv_INITIALIZE
	;BL	InitializeDisplay

	LDR	R5, [sbl_start]
	BLX	R5

	ldr	r0, [s_kernelreturn_a]
	bl	debug_print

	BL	dloadmode

relockernel:
	STMFD	SP!, {R0-R2,LR}

	LDR	R1, [kernel_start]
	ldr	r0, [s_kernelreloc_a]
	bl	debug_print
	LDR	R0, [kernel_buf]
	LDR	R1, [kernel_start]
	LDR	R2, [kernel_size]
	BL	rebell_memcpy

	LDMFD	SP!, {R0-R2,PC}
FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables below
DEFAULT_VARIABLES
    pagetable		dw gMMUL1PageTable

    sbl_start		dw 0x40244000
    sbl_size		dw 0x140000

    kernel_start	dw 0x32000000

    kernel_buf		dw 0x44000000
    kernel_size_a	dw kernel_size
    kernel_size 	dw 0 ;overwritten during runtime ;0x6664C8  ;6710472

    sbl_kernel_addr	dw 0x402D4BC0
    sbl_kernel_addr2	dw 0x402D4BBC
    sbl_atag_addr	dw 0x40244FC0
    sbl_atag_addr2	dw 0x40246DF8

    atag_ptr		dw 0x30000100
    kernel_ptr		dw 0x32000000

    ;opcode              dw 0xE1A0F00E
    jmp_op		dw 0xEA000000

    sbl_jmp_patch	dw 0x40246D88

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
    s_configramirq_a dw s_configram_irq

DEFAULT_STRINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;add custom strings below
    s_kernel_path    du '/g/galaxyboot/zImage',0
    s_sbl_path	     du '/g/galaxyboot/sbl.bin',0

    s_loadsbl	     db ' Loading SBL',0
    s_loadkernel     db ' Loading kernel image to buf',0
    s_jumpingout     db ' Jumpout to 0x%X',0
    s_mmuoff	     db ' Turning off MMU',0
    s_kernelreloc    db ' Reloc kernel to 0x%X',0
    s_kernelreturn   db ' WTF KERNEL RETURNED',0
    s_patchsbl	     db ' Patching SBL',0
    s_configram_irq  db ' DMC1 config',0

copykernel_helper:
	code_len = copykernel_helper - c_start
	db	0x4000 - code_len dup 0xFF
copykernel:
	STMFD	SP!, {R1-R3,LR}
	MOV	R0, 9999
	BL	int_debugprint

       ; MOV    R0, #0xA9
	;BL     GPIO_Drv_UnsetExtInterrupt
	;BL     disp_Normal_Init
	BL	relockernel
	MOV	R0, #9
	LDR	R1, [sbl_get_boot_param]
	BLX	R1 ;get_bootparam_offset
	MOV	R3, R0
	LDR	R1, [sbl_boot_params]
	ADD	R3, R3, #1
	MOV	R2, #4
	MOV	R3, R3,LSL#3
	ADD	R3, R1, R3
	ADD	R3, R3, R2
	MOV	R1, 0
	STR	R1, [R3]

	LDMFD	SP!, {R1-R3,PC}
sbl_get_boot_param dw 0x40244ACC
sbl_boot_params dw 0x40704AD4
END
