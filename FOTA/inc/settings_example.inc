; 'settings.inc ' file should stay ignored by subversion

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 'settings.inc' example start

;disable line below if you have matching BL and want to omit fota shadowing (faster bootup)
;FOTA_SHADOWING  equ 1

; include matching BL
include 'inc/S8500XXJEE.inc'
;include 'inc/S8500XXJL2'
;include 'inc/S8530JPKA1.inc'


include 'inc/macros.inc'
include 'inc/vars.inc'
include 'inc/functions.inc'

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 'settings.inc' example end
