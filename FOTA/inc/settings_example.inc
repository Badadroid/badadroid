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
 
; 'settings.inc ' file should stay ignored by subversion

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 'settings.inc' example start

;disable line below if you have matching BL and want to omit fota shadowing (faster bootup)
;FOTA_SHADOWING  equ 1

; enable line below to invert FOTA lcd background (unset pixel consume no energy )
;FOTA_INVERT_BACKGROUND equ 1

; enable line below to redirect output to UART (default to FOTA printf)
;DEFAULT_OUTPUT_UART equ 1

; 0 - disable charging
; 1 - enable USB charging
CHARGING_CONTROL equ 0

;enable line below to turn off few functions which require expanded BL3 address list and are unrequired to boot ARMLinux
;MINIMAL_CONFIG  equ 1

;enable line below to use custom packet handler (handled by bTerm)
;USE_BTERM equ 1


; include matching BL
include 'inc/S8500XXJEE.inc'
;include 'inc/S8500XXJL2'
;include 'inc/S8530JPKA1.inc'

include 'inc/macros.inc'
include 'inc/vars.inc'
include 'inc/functions.inc'
include 'inc/bada_term.inc'

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 'settings.inc' example end
