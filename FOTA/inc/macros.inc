macro NORETURN
{
@@:
	b	@b
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

f_ver:
	db 0x100 - (f_ver-c_start) dup 0
	db 'FOTA_ENGINE_VER_INFO_2.0'
	db 232 dup 0
	
c_run:
if defined FOTA_SHADOWING
	LDR	R0, [bl3_image_adr]
	LDR	R1, [shadowed_bl3_adr]
	LDR	R2, [bl3_image_size]
	BL	rebell_memcpy
	LDR	R0, [shadowed_bl3_adr]
	BX	R0 ;restart BL3

align 4
bl3_image_size	   dw 0x17FF80
shadowed_bl3_adr   dw 0x42480000
bl3_image_adr	   dw bl3_image

main_fota_code_helper:
	code_len = main_fota_code_helper - c_start
	db	0x4000 - code_len dup 0xFF
end if

main_fota_code:
	ldr		r0, [_key2]
	ldrb		r0, [r0, 0]	; Menu/Home key
	cmp		r0, 1
	beq		check_vol

	ldr		r0, [_key2]
	ldrb		r0, [r0, 2]
	cmp		r0, 0
	BEQ		return_to_bl

	B		fota_run     ;call key - run fota
	;
check_vol:
	ldr		r0, [_key2]
	ldrb		r0, [r0, 4]	; voldown key
	cmp		r0, 1
	beq		fota_dload_mode  ;home+voldown - dload mode

	ldr		r0, [_key2]
	ldrb		r0, [r0, 7]	; volup key
	cmp		r0, 0
	beq		fota_dload_mode ;return_to_bl

	ldr		r0, [s_atagcmdlineRM_a]  ; quick and dirty address copy...
	ldr		r1, [s_atagcmdline_aa]
	str		r0, [r1]
	B		fota_run	;home+volup - recovery mode


return_to_bl:
	bx	 lr	 ; back to the bootloader

fota_dload_mode:
	bl		enable_fota_output
	bl		dloadmode
	NORETURN
align 4
   _key2		  dw pressed_button
   s_atagcmdlineRM_a	  dw s_atagcmdlineRM
   s_atagcmdline_aa	  dw s_atagcmdline_a
   s_atagcmdline_a	  dw s_atagcmdline

   s_atagcmdlineRM	  db 'bootmode=2 console=ttySAC2,115200 loglevel=4',0
   s_atagcmdline	  db 'console=ttySAC2,115200 loglevel=4',0
   align 4
fota_run:
}
