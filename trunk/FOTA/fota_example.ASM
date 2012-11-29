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
 
; this sample script mounts oneNAND and internal SDHC in TFS4 filesystem and prints listdir of selected directory

; mounting external SD card doesn't seem to be so easy

include 'inc/settings.inc'		; user dependend settings


START	;don't touch this macro, it contains correct FOTA magic numbers and does auto CALL-KEY check and jumps here if its pressed
	;MMUCache is required for TFS4 system operations, enabling cache enables the whole MMU too
	MOV		r1, #1
	LDR		r0, [pagetable]
	BL		MemMMUCacheEnable
	bl	enable_output
	MOV		R0, 1234
	BL		int_debugprint	    ;prints "debug: 1234" to the FOTA or UART
	BL		__PfsNandInit	    ;oneNAND FS
	BL		__PfsMassInit	    ;SDHC on interface MMC0 init (internal 2gb sd card)
	LDR		R0, [s_dir_path_a]  ;load the address of directory we want to list
	BL		listdir 	    ;jump into list function
	BL		dloadmode	    ;enter download mode and inform about that after all, that makes our life easier

FUNCTIONS ;macro from functions.inc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables below
DEFAULT_VARIABLES	;macro from vars.inc
    pagetable		 dw gMMUL1PageTable

	;macro from vars.inc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; add custom strings addresses below (for using by LDR op)
    s_dir_path_a     dw s_dir_path

DEFAULT_STRINGS 	;macro from vars.inc
;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;add custom strings below
    s_dir_path	     du '/g/galaxyboot/',0 ;tfs4 path must be wchar string
    ;/g/ is the User Media storage space in internal SDHC

    
END	;don't touch this macro, it contains correct FOTA magic numbers and Multiloader header
