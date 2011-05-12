
include 'inc/S8530JPKA1.inc'	  ;here include the right BL function pointers, depends on model and BL you've got
include 'inc/macros_S8530.inc'	  ;model dependend FOTA header and footer

include 'inc/vars.inc'
include 'inc/functions.inc'

START
	bl	enable_fota_output


	MOV	R0, 2222
	BL	int_debugprint

	BL	testmembank
	BL	testmembank


	MOV	R0, 333
	BL	int_debugprint

	;B       configure_ram

	LDR	R1, [DMC0_REG]
	LDR	R0, [R1,#8]
	BL	hex_debugprint
	LDR	R0, [R1,#0xC]
	BL	hex_debugprint

	LDR	R1, [DMC1_REG]
	LDR	R0, [R1,#8]
	BL	hex_debugprint
	LDR	R0, [R1,#0xC]
	BL	hex_debugprint


	MOV	R0, 333
	BL	int_debugprint

       ; B       raminit

the_morning_after:
	MOV	R0, 3334
	BL	int_debugprint

	MOV	R0, 4444
	BL	int_debugprint

	BL	testmembank
	BL	testmembank

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

LDR	R1, [conf_0x20F00312]
STR	R1, [R0,#0xC]


	MOV	R0, 9999
	BL	int_debugprint
B	the_morning_after
FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables below
DEFAULT_VARIABLES
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
