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
	bl	enable_output

	ldr	r1, [.mov_r0_0]

	ldr	r0, [.loc1]
	str	r1, [r0]

	ldr	r0, [.loc2]
	str	r1, [r0]

	bl	dloadmode


.loc1                           dw 0x42094884
.loc2                           dw 0x42094960

.mov_r0_0:
mov	r0, 0

; ==============================================================================

FUNCTIONS

DEFAULT_VARIABLES
DEFAULT_STRINGS

END
