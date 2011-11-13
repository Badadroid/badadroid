include 'inc/settings.inc'		; user dependend settings

START

	bl	enable_fota_output
	bl	dloadmode

	NORETURN			; endless loop

; ==============================================================================

FUNCTIONS

DEFAULT_VARIABLES
DEFAULT_STRINGS

END
