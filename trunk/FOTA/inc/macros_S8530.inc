; Macros
include 'inc/S8530JPKA1.inc'

macro NORETURN
{
___NORETURN:
	b	___NORETURN
}

macro START
{
	format binary as 'fota'

	processor 0x2FFFFFE
	coprocessor 0x30F8

	org 0x43800000
	align 4

c_start:

	B	      c_run


fota_dload_mode:
	bl		enable_fota_output
	bl		dloadmode
	NORETURN


f_ver:
	db 0x100 - (f_ver-c_start) dup 0
	db 'FOTA_ENGINE_VER_INFO_2.0'
	db 232 dup 0
	
align 4
bl3_image_size	   dw 0x17FF80
shadowed_bl3_adr   dw 0x42480000
bl3_image_adr	   dw bl3_image
c_run:
	BL	enable_uart_output
	LDR	R0, [bl3_image_adr]
	LDR	R1, [shadowed_bl3_adr]
	LDR	R2, [bl3_image_size]
	BL	rebell_memcpy
	LDR	R0, [shadowed_bl3_adr]
	BX	R0 ;restart BL3


main_fota_code_helper:
	code_len = main_fota_code_helper - c_start
	db	0x4000 - code_len dup 0xFF
main_fota_code:
	ldr		r0, [_key2]
	ldrb		r0, [r0]     ; Middle key
	cmp		r0, 1
	beq		fota_dload_mode

	ldr		r0, [_key2]
	ldrb		r0, [r0, 2]	; CALL key
	cmp		r0, 0

	BNE		keystore
	bx		lr		; back to the bootloader

	_key2		dw pressed_button
keystore:
}

macro END
{
bl3_image_helper:
	code_len = bl3_image_helper - c_start
	db	0x10000 - code_len dup 0xFF
bl3_image:
	file 'S8530JPKA1_BL3.bin'
magic_1:
	code_len = magic_1 - c_start
	db 0x280000 - code_len dup 0xFF
	db 'BPDZ'
	db 12 dup 0
	dw 0xABCDABCD
	dw 0x0A900000
	dw 0
	db 'S8530'
	db 27 dup 0
	db 'fota'
	dw 0
	dw 6
	dw 1
	dw 2
	dw 0x800
	dw 0x20000

magic_2:
	code_len = magic_2 - c_start
	db 0x280410 - code_len dup 0
}