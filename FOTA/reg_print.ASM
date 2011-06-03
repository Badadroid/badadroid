
include 'inc/S8530JPKA1.inc'	  ;here include the right BL function pointers, depends on model and BL you've got
include 'inc/macros_S8530.inc'	  ;model dependend FOTA header and footer

include 'inc/vars.inc'
include 'inc/functions.inc'

;simple printing one register

START
	SUB	SP, SP, #16

	bl	enable_uart_output

	MOV	R0, 12345
	BL	int_debugprint


	LDR	R0, [rst_status]
	LDR	R0, [R0]
	BL	hex_debugprint
	MOV	R0, 12345
	BL	int_debugprint

	LDR	R1, [DWORD_LOOP_BEGIN]
	LDR	R2, [DWORD_LOOP_END]
loopek3:
	CMP	R1, R2
	BGT	end_print3
	LDR	R0, [R1], 4
	;BL      hex_debugprint
	B	loopek3
end_print3:


	LDR	R0, [TZIC0FIQEnable]
	LDR	R0, [R0]
	BL	hex_debugprint

	LDR	R0, [TZIC1FIQEnable]
	LDR	R0, [R0]
	BL	hex_debugprint

	LDR	R0, [TZIC2FIQEnable]
	LDR	R0, [R0]
	BL	hex_debugprint

	LDR	R0, [TZIC3FIQEnable]
	LDR	R0, [R0]
	BL	hex_debugprint


	LDR	R0, [SYSCON_NORMAL_CFG]
	LDR	R1, [R0]
	BIC	R1, R1, 0x3E ;turn off everything
	STR	R1, [R0]

	LDR	R0, [SYSCON_NORMAL_CFG]
	MOV	R1, 0xFFFFFFFF
	STR	R1, [R0]


	LDR	R0, [TZIC2FIQEnable]
	LDR	R0, [R0]
	BL	hex_debugprint

	LDR	R0, [TZIC3FIQEnable]
	LDR	R0, [R0]
	BL	hex_debugprint
	BL	dloadmode

       ; BL      boot_hw_power_down

FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables below
DEFAULT_VARIABLES
    pagetable		dw gMMUL1PageTable
    const_0x186A0	dw 0x186A0
    dump_what		dw 0xE010C010
    watchdog		dw 0xE2700000
    rst_status		dw 0xE010A000
    USBSW_I2C_CH_adr	dw USBSW_I2C_CH
    GPIO_FIRST_MASK	dw 0xE0200900
    GPIO_LAST_MASK	dw 0xE0200954
    EXT_FIRST_MASK	dw 0xE0200F00
    EXT_LAST_MASK	dw 0xE0200F0C
    DWORD_LOOP_BEGIN	dw 0xE0200E00
    DWORD_LOOP_END	dw 0xE0200E0C
    SYSCON_NORMAL_CFG	dw 0xE010C010

    TZIC0FIQEnable	dw 0xB0601024;0xF2800004;0xF2000F00
    TZIC1FIQEnable	dw 0xB0601028;0xF2900004;0xF2100F00
    TZIC2FIQEnable	dw 0xF8000130;0xF2200f00
    TZIC3FIQEnable	dw 0xF8000134;0xF2300f00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; strings at the end
DEFAULT_STRINGS_ADDR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; add custom strings addresses below (for using by LDR op)

DEFAULT_STRINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;add custom strings below
    
END
