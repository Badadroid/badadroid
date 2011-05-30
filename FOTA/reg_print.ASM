
include 'inc/S8530JPKA1.inc'	  ;here include the right BL function pointers, depends on model and BL you've got
include 'inc/macros_S8530.inc'	  ;model dependend FOTA header and footer

include 'inc/vars.inc'
include 'inc/functions.inc'

;simple printing one register

START
	SUB	SP, SP, #16

	bl	enable_fota_output

	MOV	R0, 12345
	BL	int_debugprint


	LDR	R0, [rst_status]
	LDR	R0, [R0]
	BL	hex_debugprint
		MOV	R0, 12345
	BL	int_debugprint
	LDR	R4, [USBSW_I2C_CH_adr]
	MOV	R0, #6
	STRB	R0, [R4]
	MOV	R0, #0x91
	STRH	R0, [R4,#4]
	MOV	R0, #0x90
	STRH	R0, [R4,#6]
	MOV	R0, #0x2710
	BL	PWM_Drv_Delay

	LDR	R3, [const_0x186A0]
	LDRH	R2, [R4,#6]
	LDRH	R1, [R4,#4]
	LDRB	R0, [R4]
	BL	I2C_GPIO_Drv_Open
	MOV	R0, #0x2710
	BL	PWM_Drv_Delay
	LDRB	R0, [R4]
	MOV	R3, #0x1E
	MOV	R2, #2
	MOV	R1, #0x4A
	BL	I2C_GPIO_Drv_Write
	LDRB	R0, [R4]
	MOV	R3, #0xFC
	MOV	R2, #5
	MOV	R1, #0x4A
	BL	I2C_GPIO_Drv_Write
	MOV	R0, #0x2710
	BL	PWM_Drv_Delay
	LDRB	R0, [R4]
	MOV	R3, #4
	MOV	R2, #8
	MOV	R1, #0x4A
	BL	I2C_GPIO_Drv_Write
	MOV	R0, #0x2710
	BL	PWM_Drv_Delay

	LDRB	R0, [R4]
	ADD	R3, SP, #0
	MOV	R2, #0x14
	MOV	R1, #0x4A
	BL	I2C_GPIO_Drv_Read
	LDRB	R0, [SP,0]
	BL	hex_debugprint

	LDRB	R0, [R4]
	MOV	R3, 0x12
	MOV	R2, #0x14
	MOV	R1, #0x4A
	BL	I2C_GPIO_Drv_Write

	LDRB	R0, [R4]
	ADD	R3, SP, #0
	MOV	R2, #0xB
	MOV	R1, #0x4A
	BL	I2C_GPIO_Drv_Read
	LDRB	R0, [SP,0]
	BL	hex_debugprint

	LDRB	R0, [R4]
	ADD	R3, SP, #0
	MOV	R2, #0xA
	MOV	R1, #0x4A
	BL	I2C_GPIO_Drv_Read
	LDRB	R0, [SP,0]
	BL	hex_debugprint

	LDRB	R0, [R4]
	ADD	R3, SP, #0
	MOV	R2, #0x14
	MOV	R1, #0x4A
	BL	I2C_GPIO_Drv_Read
	LDRB	R0, [SP,0]
	BL	hex_debugprint

	LDRB	R0, [R4]
	BL	I2C_GPIO_Drv_Close

	LDR	R3, [_key]
	LDR	R0, [R3]
	BL	hex_debugprint
	LDR	R0, [R3,4]
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; strings at the end
DEFAULT_STRINGS_ADDR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; add custom strings addresses below (for using by LDR op)

DEFAULT_STRINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;add custom strings below
    
END
