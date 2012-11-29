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
 
include 'inc/settings.inc'              ; user dependend settings

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


	ADR	R0, s_info
	BL	debug_print

	LDR	R2, [dump_size]
	MOV	R1, 0x00
	LDR	R0, [dump_buf]
	BL	rebell_fillmem

	LDR	R0, [s_netlock_path_a]
	LDR	R1, [dump_buf]
	LDR	R2, [dump_size]
	BL	loadfile
	LDR	R2, [dump_size]
	CMP	R0, R2
	BNE	fail

	LDR	R0, [dump_buf]
	BL	__SysSecBootWriteNetLockInfoToFlash

	LDR	R0, [s_done_a]
	BL	debug_print
	B      dloadmode
fail:
	ADR	R0, s_fail
	BL	debug_print

	B      dloadmode

 s_info      db ' writing netlockinfo',0
 s_fail      db ' failed to read file',0
 align 4
FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables below
DEFAULT_VARIABLES
    pagetable		dw gMMUL1PageTable


   ; dump_what           dw 0xD0000000
    dump_size		dw 0x19A0;256;0x40000
	
    dump_buf		    dw 0x44000000

    ;flash_dump_adr          dw 0xEC000000
    ;NOP_CODE            dw 0xE1A00000
			;0x00010000 ;64KB
			;0x00400000 ;4MB
			;0x01000000 ;16MB
			;0x01400000 ;20MB
			;0x02000000 ;32MB
			;0x08000000 ;128MB



;;;;;;;;;;;;;;;;;;;;;;;;;;;;; add custom strings addresses below (for using by LDR op)
    s_netlock_path_a	 dw s_netlock_path

DEFAULT_STRINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;add custom strings below
    s_netlock_path	du '/g/dumps/syssec.netlockinfo.bin',0 ;where to save?



    
END
