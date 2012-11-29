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

;example dumping whole iROM area

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


	;LDR     R2, [dump_size]
	;LDR     R1, [flash_dump_adr]
	;LDR     R0, [dump_buf]
	;BL      Flash_Read_Data

	LDR	R0, [dump_buf]
	BL	__SysSecBootReadNetLockInfoFromFlash

	LDR	R2, [dump_size]
	LDR	R1, [dump_buf]
	LDR	R0, [s_dumppath_a]
	BL	memdump

	LDR	R0, [dump_buf]
	BL	__SysSecBootGet4thPhaseFixedKey

	LDR	R2, [dump_size]
	LDR	R1, [dump_buf]
	LDR	R0, [s_dumppath2_a]
	BL	memdump

	LDR	R0, [dump_buf]
	BL	__SysSecBootGet3rdPhaseFixedKey

	LDR	R2, [dump_size]
	LDR	R1, [dump_buf]
	LDR	R0, [s_dumppath3_a]
	BL	memdump

	LDR	R0, [s_dirpath_a]  ;load the address of directory we want to list
	BL	listdir 	    ;jump into dir function, only to make sure our dump has been stored

	BL	dloadmode

FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables below
DEFAULT_VARIABLES
    pagetable		dw gMMUL1PageTable


    ;dump_what           dw 0xD0000000
    dump_size		dw 0x19A0
	
    dump_buf		    dw 0x44000000
    flash_dump_adr	    dw 0x1EC0C000
			;0x00010000 ;64KB
			;0x00400000 ;4MB
			;0x01000000 ;16MB
			;0x01400000 ;20MB
			;0x02000000 ;32MB
			;0x08000000 ;128MB



;;;;;;;;;;;;;;;;;;;;;;;;;;;;; add custom strings addresses below (for using by LDR op)
    s_dumppath_a     dw s_dumppath
    s_dumppath2_a    dw s_dumppath2
    s_dumppath3_a    dw s_dumppath3
    s_dirpath_a      dw s_dirpath

DEFAULT_STRINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;add custom strings below
    s_dumppath	     du '/g/dumps/syssec.gstSavedLockInfo.bin',0 ;where to save?
    s_dumppath2      du '/g/dumps/syssec.4thPhaseFixedKey.bin',0 ;where to save?
    s_dumppath3      du '/g/dumps/syssec.3rdPhaseFixedKey.bin',0 ;where to save?
	
    s_dirpath	     du '/g/dumps/',0 ;dir command


    
END
