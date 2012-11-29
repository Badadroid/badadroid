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

START
   stmfd   sp!, {lr}
   LDR	 R1, [mov_r0_0]
   LDR	 R0, [mov_r0_0_loc]
   STR	 R1, [R0]

   ldmfd   sp!, {pc}


mov_r0_0_loc dw 0x42089344   ;S8500XXKL5

mov_r0_0:
MOV    R0, 0

THUMB
MOV_R5_A:
MOVS R5, 0xA

CODE32
ALIGN 4


; ==============================================================================

FUNCTIONS

DEFAULT_VARIABLES
DEFAULT_STRINGS

END
