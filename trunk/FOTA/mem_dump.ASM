
include 'inc/S8530JPKA1.inc'	  ;here include the right BL function pointers, depends on model and BL you've got
include 'inc/macros_S8530.inc'	  ;model dependend FOTA header and footer

include 'inc/vars.inc'
include 'inc/functions.inc'

START

B skip
	LDR	R3, [pagetable]
	MOV	R2, #4
	MOV	R1, #35
	MUL	R2, R2, R1
	ADD	R3, R3, R2
	LDR	R0, [cache_start]
	STR	R0, [R3]
	STR	R0, [R3,#4]
	LDR	R0, [cache_size]
	STR	R0, [R3,#8]
	MOV	R0, 0x103 ;some flags
	STR	R0, [R3,#12]
	MOV	R0, 0x3   ;access flags
	STR	R0, [R3,#16]
skip:

	bl	enable_fota_output

	MOV	R0, 0
	LDR	R1, [dump_start]
	LDR	R2, [dump_size]
	BL	rebell_memcpy

	MOV	r1, #1
	LDR	r0, [pagetable]
	BL	MemMMUCacheEnable
	MOV	R0, 1234
	BL	int_debugprint
	BL	__PfsNandInit
	BL	__PfsMassInit

	MOV	R0, 12345
	BL	int_debugprint
	;MRC     p15, 0, R7,c1,c0
	;MOV     R8, #0x1805
	;BIC     R7, R7, R8
	;MCR     p15, 0, R7,c1,c0

	;LDR     R0, [reloc_origin]
	;LDR     R1, [dump_start]
	;LDR     R2, [dump_size]
	;BL      rebell_memcpy
	;ldr     r0, [s_done_a]
	;bl      debug_print

	mov	r0, 11
	bl	int_debugprint

	;MOV     r1, #1
	;LDR     r0, [pagetable]
	;BL      MemMMUCacheEnable

	mov	r0, 55
	bl	int_debugprint
	LDR	R2, [dump_size]
	LDR	R1, [dump_start]
	LDR	R0, [s_dumppath_a]
	BL	memdump

	LDR	R0, [s_dirpath_a]  ;load the address of directory we want to list
	BL	listdir 	    ;jump into list function

	BL	dloadmode

FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables below
DEFAULT_VARIABLES
    pagetable		dw gMMUL1PageTable

    cache_start 	dw 0x30000000
    cache_size		dw 0x10000000

    reloc_origin	dw 0x32000000

    dump_start		dw 0x43000000
    dump_size		dw 0xFFFF
			;0x10000   ;64KB
			;0x1400000 ;16MB
			;0xA000000 ;128MB

    s_kernel_path_a  dw s_kernel_path

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; strings at the end
DEFAULT_STRINGS_ADDR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; add custom strings addresses below (for using by LDR op)
    s_dumppath_a     dw s_dumppath
    s_dirpath_a      dw s_dirpath

DEFAULT_STRINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;add custom strings below
    s_dumppath	     du '/g/dumps/0x0.0xFFFF.bin',0
    s_kernel_path    du '/g/galaxyboot/zImage',0
    s_dirpath	     du '/g/dumps/',0


    
END
