 ;
 ; This file is part of Badadroid project.
 ;
 ; Copyright (C) 2012 Rebellos, mijoma, b_kubica
 ;
 ;
 ; Badadroid is free software: you can redistribute it and/or modify
 ; it under the terms of the GNU General Public License as published by
 ; the Free Software Foundation, either version 3 of the License, or
 ; (at your option) any later version.
 ;
 ; Badadroid is distributed in the hope that it will be useful,
 ; but WITHOUT ANY WARRANTY; without even the implied warranty of
 ; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ; GNU General Public License for more details.
 ;
 ; You should have received a copy of the GNU General Public License
 ; along with Badadroid.  If not, see <http://www.gnu.org/licenses/>.
 ;
 ;
 
include 'inc/settings.inc'		; user dependend settings

;WARNING
;THIS CODE WILL BRICK YOUR PHONE! IT'S HERE ONLY FOR STUDYING!

START


	bl	enable_output

	;LDR     R0, [dump_what]
	;LDR     R1, [dump_buf]
	;LDR     R2, [dump_size]
       ; BL      rebell_memcpy

	MOV	r1, #1
	LDR	r0, [pagetable]
	BL	MemMMUCacheEnable
	MOV	R8, R0	     ;store original cp15, c1, c0 register
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

	LDR	R0, [s_flashpath_a]
	LDR	R1, [dump_buf]
	LDR	R2, [dump_size]
	BL	loadfile
	LDR	R2, [dump_size]
	CMP	R0, R2
	BNE	fail

	LDR	R2, [dump_size]
	LDR	R1, [flash_dump_adr]
	LDR	R0, [dump_buf]
	BL	Flash_Write_Data
	BL	hex_debugprint

	LDR	R0, [s_done_a]
	BL	debug_print

	B      dloadmode

	fail:
	ADR	R0, s_fail
	BL	debug_print

	B      dloadmode

 s_info      db ' writing flash',0
 s_fail      db ' failed to read file',0
 align 4

FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables below
DEFAULT_VARIABLES
    pagetable		dw gMMUL1PageTable


   ; dump_what           dw 0xD0000000
    dump_size		dw 0x00400000
	
    dump_buf		    dw 0x44000000
    flash_dump_adr	    dw 0x1F000000
			;0x00010000 ;64KB
			;0x00400000 ;4MB
			;0x01000000 ;16MB
			;0x01400000 ;20MB
			;0x02000000 ;32MB
			;0x08000000 ;128MB



;;;;;;;;;;;;;;;;;;;;;;;;;;;;; add custom strings addresses below (for using by LDR op)
    s_flashpath_a     dw s_flashpath
    s_dirpath_a      dw s_dirpath

DEFAULT_STRINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;add custom strings below
    s_flashpath       du '/g/0x1F000000.0x00400000.bin',0 ;where to save?
	
    s_dirpath	     du '/g/',0 ;dir command


    
END
