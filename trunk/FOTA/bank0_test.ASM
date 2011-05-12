
include 'inc/S8530JPKA1.inc'	  ;here include the right BL function pointers, depends on model and BL you've got
include 'inc/macros_S8530.inc'	  ;model dependend FOTA header and footer

include 'inc/vars.inc'
include 'inc/functions.inc'

; VERY rough code for loading sbl to 0x40244000 and Kernel to 0x32000000, then executes KERNEL.
; Sbl is unused in this code
START
	bl	enable_fota_output


	MOV	R0, 2222
	BL	int_debugprint

	BL	testmembank
	BL	testmembank

	MOV	R0, 333
	BL	int_debugprint



	MOV	R0, 333
	BL	int_debugprint

	B	raminit

the_morning_after:
	MOV	R0, 3334
	BL	int_debugprint

	MOV	R0, 4444
	BL	int_debugprint

	BL	testmembank
	BL	testmembank

	MOV	R0, 1111
	BL	int_debugprint


	BL	testmembank


	MOV	R0, 1234
	BL	int_debugprint

	;BL      testmembank

	MOV	R0, 1234
	BL	int_debugprint

	BL	dloadmode

testmembank:
	STMFD	SP!, {R0-R1,LR}

	LDR	R0, [read_addr]
	LDR	R0, [R0]
	BL	hex_debugprint

	LDR	R0, [opcode]
	LDR	R1, [write_addr]
	STR	R0, [R1]

	LDR	R0, [read_addr]
	LDR	R0, [R0]
	BL	hex_debugprint
	LDMFD	SP!, {R0-R1,PC}

configure_ram:
LDR	R0, [DMC0_REG]
LDR	R1, [conf_0x30F82222]
STR	R1, [R0,#8]

	MOV	R0, 9999
	BL	int_debugprint

LDR	R1, [conf_0x20F02222]
STR	R1, [R0,#0xC]


	MOV	R0, 9999
	BL	int_debugprint
B	the_morning_after
FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables below
DEFAULT_VARIABLES
	conf_0x20F02222  dw 0x20F02222
	conf_0x20F82222  dw 0x20F82222
	conf_0xE2700000  dw 0xE2700000
	conf_0xE2900C00  dw 0xE2900C00
	conf_0x120020	 dw 0x120020
	conf_0xFFF10B0	 dw 0xFFF10B0
	conf_0x212113	 dw 0x212113
	conf_0x50101003  dw 0x50101003
	conf_0x50101001  dw 0x50101001
	conf_0xFFF1010	 dw 0xFFF1010
	APLL_LOCK	 dw 0xE0100000
	RST_STAT	 dw 0xE010A000
	ASYNC_MSYS_DMC0  dw 0xF1E00000
	DMC0_REG	 dw 0xF0000000
	conf_0x60101003  dw 0x60101003
	conf_0x60101001  dw 0x60101001
	conf_0x101000	 dw 0x101000
	DMC1_REG	 dw 0xF1400000
	conf_0x40F02222  dw 0x40F02222
	conf_0x212100	 dw 0x212100
	conf_0x30F82222  dw 0x30F82222
	conf_0x14233287  dw 0x14233287
	conf_0x12130005  dw 0x12130005
	conf_0xE140222	 dw 0xE140222
	conf_0x20020	 dw 0x20020
	conf_0x100032	 dw 0x100032

    pagetable		dw gMMUL1PageTable
    opcode		dw 0xE1A0F00E
    write_addr		dw 0x32000004
    read_addr		dw 0x32000004

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
    s_kernel_path    du '/g/galaxyboot/zImage_return',0
    s_sbl_path	     du '/g/galaxyboot/Sbl_mijoma.bin',0

    s_loadsbl	     db ' Loading SBL',0
    s_loadkernel     db ' Loading kernel image to buf',0
    s_jumpingout     db ' Jumpout to 0x%X',0
    s_mmuoff	     db ' Turning off MMU',0
    s_kernelreloc    db ' Reloc kernel to 0x%X',0
    s_kernelreturn   db ' WTF KERNEL RETURNED',0

raminit_callback_helper:  ;
	code_len = raminit_callback_helper - c_start
	db	0x5500 - code_len dup 0xFF
raminit_callback:	;0x43805500   0xEAFFFCF7 from 0x4380611C
	B	the_morning_after

raminit_helper:
	code_len = raminit_helper - c_start
	db	0x6000 - code_len dup 0xFF
raminit:		;0x43806000
	file 'ram_init.bin'

    
END
