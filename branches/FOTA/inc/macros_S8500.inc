; Macros

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

	ldr		r0, [_key]
	ldrb		r0, [r0]     ; Middle key
	cmp		r0, 1
	beq		fota_dload_mode
	ldr		r0, [_key]
	ldrb		r0, [r0, 2]	; CALL key
	cmp		r0, 0
	bne		c_run

	bx		lr		; back to the bootloader
fota_dload_mode:
	bl		enable_fota_output
	bl		dloadmode
	NORETURN

_key	dw pressed_button

f_ver:
	db 0x100 - (f_ver-c_start) dup 0
	db 'FOTA_ENGINE_VER_INFO_2.0'
	db 232 dup 0
	
align 4
c_run:
}

macro END
{
magic_1:
	code_len = magic_1 - c_start
	db 0x280000 - code_len dup 0xFF
	db 'BPDZ'
	db 12 dup 0
	dw 0xABCDABCD
	dw 0x0C600000
	dw 0
	db 'S8500'
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
