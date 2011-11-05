include 'inc/settings.inc'              ; user dependend settings

;example dumping whole iROM area

START


	bl	enable_fota_output

	;LDR	R0, [dump_what]
	;LDR	R1, [dump_buf]
	;LDR	R2, [dump_size]
	;BL	rebell_memcpy

	MOV	r1, #1
	LDR	r0, [pagetable]
	BL	MemMMUCacheEnable
	MOV	R8, R0	            ; store original cp15, c1, c0 register
	MOV	R0, 1234
	BL	int_debugprint
	BL	__PfsNandInit
	BL	__PfsMassInit

	MOV	R0, 12345
	BL	int_debugprint

	LDR	R0, [dump_buf]
	MOV	R1, 0x00
	LDR	R2, [dump_size]
	BL	rebell_fillmem

	LDR	R2, [dump_size]
	LDR	R1, [flash_dump_adr]
	LDR	R0, [dump_buf]
	BL	Flash_Read_Data
	BL	hex_debugprint


	LDR	R2, [dump_size]
	LDR	R1, [dump_buf]
	LDR	R0, [s_dumppath_a]
	BL	memdump


	LDR	R0, [s_dirpath_a]     ; load the address of directory we want to list
	BL	listdir 	            ; jump into dir function, only to make sure our dump has been stored

	BL	dloadmode

	NORETURN

FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables below
DEFAULT_VARIABLES
	pagetable                  dw gMMUL1PageTable

	;dump_what                  dw 0xD0000000
	dump_size                  dw 512 KB
	
	dump_buf                   dw 0x44000000
	flash_dump_adr             dw 0x1EC11000



;;;;;;;;;;;;;;;;;;;;;;;;;;;;; add custom strings addresses below (for using by LDR op)
	s_dumppath_a               dw s_dumppath
	s_dirpath_a                dw s_dirpath

DEFAULT_STRINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;add custom strings below
	s_dumppath                 du '/g/dumps/0x1EC11000.0x00080000.bin',0 ;where to save?
	
	s_dirpath                  du '/g/dumps/',0 ;dir command

END
