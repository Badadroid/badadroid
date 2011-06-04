
include 'inc/S8500XXJEE.inc'	  ;here include the right BL function pointers, depends on model and BL you've got
include 'inc/macros_S8500.inc'	  ;model dependend FOTA header and footer

include 'inc/vars.inc'
include 'inc/functions.inc'


START
	SUB	SP, SP, 128

	MOV	r1, #1
	LDR	r0, [pagetable]
	BL	MemMMUCacheEnable
	MOV	R8, R0 ;lets store previous MMU control register to turn it off later

	bl	enable_uart_output
	LDR	R0, [s_bl3_patch_a]
	BL	debug_print

	LDR	R5, [mov_r0_2]
	LDR	R0, [patch_table_adr]

do_patch:
	LDR	R1, [R0], 4 ;post increment R0 by 4
	CMP	R1, 0
	BEQ	patch_done
	STR	R5, [R1]
	B	do_patch

patch_done:
	LDR	R0, [s_done_a]
	BL	debug_print

	BL	__PfsNandInit
	BL	__PfsMassInit



	MOV	r0, 678
	bl	int_debugprint
	LDR	R0, [s_dir_path_a]
	BL	listdir
	BL	dloadmode


FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables below
DEFAULT_VARIABLES
    pagetable		dw gMMUL1PageTable
    patch_table_adr	dw patch_table
patch_table dw 0x4249BC38
dw 0x4249BC48
dw 0x4249BC6C
dw 0x4249BC7C
dw 0x4249BCA0
dw 0x4249BCB8
dw 0x4249BD8C
dw 0x4249BD9C
dw 0x4249BF60
dw 0x4249BF70
dw 0x4249BF80
dw 0x4249C0C4
dw 0x4249C170
dw 0x4249C21C
dw 0x4249C22C
dw 0x4249C23C
dw 0x4249C360
dw 0x4249C43C
dw 0x0	     ;end

    mov_r0_2		dw 0xE3A00002

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; strings at the end
DEFAULT_STRINGS_ADDR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; add custom strings addresses below (for using by LDR op)
    s_dir_path_a     dw s_dir_path
    s_bl3_patch_a    dw s_bl3_patch

DEFAULT_STRINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;add custom strings below
    s_dir_path	     du '/g/',0

    s_bl3_patch      db ' patching BL3 moviNAND functions',0


END
