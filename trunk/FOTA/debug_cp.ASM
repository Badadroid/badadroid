include 'inc/settings.inc'              ; user dependend settings

;example dumping whole iROM area

START
	MOV	R8, LR


	bl	enable_uart_output
	LDR	R1, [boot_mode_a]
	LDRB	R0, [R1]
	BL	int_debugprint
	MOV	R0, 8
	STRB	R0, [R1]
	MOV	R0, 1
	BL	USBSwitch
	MOV	R0, 1
	BL	UARTSwitch

	BLX	R8

FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables below
DEFAULT_VARIABLES
    pagetable		dw gMMUL1PageTable
    boot_mode_a 	  dw boot_mode

   ; dump_what           dw 0xD0000000




;;;;;;;;;;;;;;;;;;;;;;;;;;;;; add custom strings addresses below (for using by LDR op)


DEFAULT_STRINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;add custom strings below


    
END
