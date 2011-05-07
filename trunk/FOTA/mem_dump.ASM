
include 'inc/S8530JPKA1.inc'	  ;here include the right BL function pointers, depends on model and BL you've got
include 'inc/macros_S8530.inc'	  ;model dependend FOTA header and footer

include 'inc/vars.inc'
include 'inc/functions.inc'

; VERY rough code for loading sbl to 0x40244000 and Kernel to 0x32000000, then executes KERNEL.
; Sbl is unused in this code
START
	MOV	r1, #1
	LDR	r0, [pagetable]
	BL	MemMMUCacheEnable
	bl	enable_fota_output
	MOV	R0, 1234
	BL	int_debugprint
	BL	__PfsNandInit
	BL	__PfsMassInit

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

    dump_start		dw 0x41000000
    dump_size		dw 0x10000 ;128MB
			;0x10000  ;64KB
			;1400000 ;16MB

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; strings at the end
DEFAULT_STRINGS_ADDR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; add custom strings addresses below (for using by LDR op)
    s_dumppath_a     dw s_dumppath
    s_dirpath_a      dw s_dirpath

DEFAULT_STRINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;add custom strings below
    s_dumppath	     du '/g/0x41000000_test.bin',0
    s_dirpath	     du '/g/',0


    
END
