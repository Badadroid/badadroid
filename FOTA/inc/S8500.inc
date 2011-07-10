; Macros
include 'inc/S8500XXJEE.inc'
include 'inc/macros.inc'

macro END
{
bl3_image_helper:
	code_len = bl3_image_helper - c_start
	db	0x10000 - code_len dup 0xFF
bl3_image:
	file 'S8500XXJEE_BL3.bin'
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
