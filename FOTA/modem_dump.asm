
include 'inc/S8500XXJEE.inc'	  ;here include the right BL function pointers, depends on model and BL you've got
include 'inc/macros_S8500.inc'	  ;model dependend FOTA header and footer

include 'inc/vars.inc'
include 'inc/functions.inc'

START

;;;;;;;;;;;;;;;
	MOV		R0, #0xA9
	BL		GPIO_Drv_UnsetExtInterrupt
	BL		disp_Normal_Init
	;BL		DRV_Modem_BootingStart				; modem_start
	BL		DRV_modem_reset
	BL		DRV_Send_ModemBootloader
	BL		DRV_Wait_ModemInit
	BL		DRV_CopyModemBootBinary
	BL		DRV_Send_BinaryCopyComplete
BL		modem_dump
BL		dloadmode							; ENTERING DOWNLOAD MODE
;;;;;;;;;;;;;;;

	MOV		R0, #0xA9
	BL		GPIO_Drv_UnsetExtInterrupt
	BL		disp_Normal_Init
	BL		DRV_Modem_BootingStart
	;BL		LaunchNucleus

	SUB	SP, SP, 128
	MOV	r1, #1
	LDR	r0, [pagetable]
	BL	MemMMUCacheEnable
	MOV	R8, R0 ;lets store previous MMU control register to turn it off later

	BL	enable_uart_output
	BL	__PfsNandInit
	BL	__PfsMassInit

modem_dump:
	STMFD	SP!, {R0-R2,LR}

	LDR		R2, [modem_DBL]						; modem_DBL
	LDR		R1, [s_dumpfrom_a]
	MOV		R0, #0
	BL		EdbgOutputDebugStringA
	MOV		R1, 256
	LDR		R0, [modem_DBL]
	BL		mem_dump

	LDR		R2, [modem_FSBL]					; modem_FSBL
	LDR		R1, [s_dumpfrom_a]
	MOV		R0, #0
	BL		EdbgOutputDebugStringA
	MOV		R1, 256
	LDR		R0, [modem_FSBL]
	BL		mem_dump

	LDR		R2, [modem_OSBL]					; modem_OSBL
	LDR		R1, [s_dumpfrom_a]
	MOV		R0, #0
	BL		EdbgOutputDebugStringA
	MOV		R1, 256
	LDR		R0, [modem_OSBL]
	BL		mem_dump

	LDR		R2, [modem_AMSS]					; modem_AMSS
	LDR		R1, [s_dumpfrom_a]
	MOV		R0, #0
	BL		EdbgOutputDebugStringA
	MOV		R1, 256
	LDR		R0, [modem_AMSS]
	BL		mem_dump

	LDR		R1, [s_endl_a]						; end line
	MOV		R0, #0
	BL		EdbgOutputDebugStringA

	LDR		R0, [modem_HW_rew]					; out 0x
	LDR		R2, [R0]
	LDR		R1, [s_hexout_a]
	MOV		R0, #0
	BL		EdbgOutputDebugStringA

	LDR		R0, [modem_mgc_val]					; out 0x
	LDR		R2, [R0]
	LDR		R1, [s_hexout_a]
	MOV		R0, #0
	BL		EdbgOutputDebugStringA

	LDMFD	SP!, {R0-R2,PC}
FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables below
DEFAULT_VARIABLES
    pagetable		dw gMMUL1PageTable

    modem_DBL		dw 0x25000000
    modem_FSBL		dw 0x25008000
    modem_OSBL		dw 0x25038000
    modem_AMSS		dw 0x25088000
    modem_HW_rew	dw 0x25FFF7F8
    modem_mgc_val	dw 0x25FFF820

    sbl_start		dw 0x40244000
    sbl_size		dw 0x140000

    kernel_start	dw 0x44000000

    kernel_buf		dw 0x44000000
    kernel_size 	dw 0x0		;overwritten during runtime ;0x6664C8  ;6710472

    sbl_kernel_addr	dw 0x402D4BC0
    sbl_atag_addr	dw 0x40244FC0
    sbl_atag_addr2	dw 0x40246DF8

    atag_ptr		dw 0x40000100
    kernel_ptr		dw 0x44000000;0x44000000

    opcode		    dw 0xE1A0F00E
    jmp_by_14_ops	dw 0xEA00000A
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

	s_endl_a			dw s_endl
	s_hexout_a			dw s_hexout
	s_dumpfrom_a		dw s_dumpfrom
	s_aAst_poweron_a	dw s_aAst_poweron

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

	s_endl				db 0xA,0
	s_hexout			db 'out 0x%X',0xA,0
	s_dumpfrom			db 'dump from 0x%X',0xA,0
	s_aAst_poweron		db 'AST_POWERON  0x%X',0xA,0

copykernel_helper:
	code_len = copykernel_helper - c_start
	db	0x4000 - code_len dup 0xFF
copykernel:
	STMFD	SP!, {R1-R2,LR}
	MOV	R0, 9999
	BL	int_debugprint

	;BL      testmembank

	LDMFD	SP!, {R1-R2,PC}

END
