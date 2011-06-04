
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

	BL	configure_ram
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
    s_kernel_path    du '/g/galaxyboot/zImage_return',0
    s_sbl_path	     du '/g/galaxyboot/Sbl_mijoma.bin',0

    s_loadsbl	     db ' Loading SBL',0
    s_loadkernel     db ' Loading kernel image to buf',0
    s_jumpingout     db ' Jumpout to 0x%X',0
    s_mmuoff	     db ' Turning off MMU',0
    s_kernelreloc    db ' Reloc kernel to 0x%X',0
    s_kernelreturn   db ' WTF KERNEL RETURNED',0


    
END
