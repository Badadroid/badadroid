include 'inc/S8500.inc'   ;model dependend FOTA header and footer

include 'inc/vars.inc'
include 'inc/functions.inc'

;example dumping whole iROM area

START

	bl	enable_fota_output

	LDR  R0, [s_test_a]
	LDR  R1, [debug_print_str]
	BLX  R1
	MOV	R0, 12345
	BL	int_debugprint
	MOV  R0, 0x18000000 ;~~3sec sleep at 400Mhz
	bl   sleep


	BL	dloadmode

sleep:
     mov r1, 0
sleep_loop:
     add r1, r1, 1
     cmp r1, r0
     BCC sleep_loop
     MOV PC, LR

FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables below
DEFAULT_VARIABLES
debug_print_str dw 0xD0005620

s_test_a dw s_test
s_test db 0xA,'Hey you!',0xA,'Out there on the road,',0xA,'Always doing what you are told,',0xA,'Can you help me?',0xA,0x0




;;;;;;;;;;;;;;;;;;;;;;;;;;;;; strings at the end
DEFAULT_STRINGS_ADDR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; add custom strings addresses below (for using by LDR op)

DEFAULT_STRINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;add custom strings below



    
END
