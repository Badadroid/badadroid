;some functions built by Rebellos and b.kubica
;if adding new please make them model-independent
macro FUNCTIONS
{

;void fota_dloadmode()
fota_dloadmode:
	ldr	r0, [s_downloadmode_a]
	bl	disp_FOTA_Printf
	bl	dloadmode


;void dloadmode()
dloadmode:
	mov	r1, 0
	mov	r0, 2
	bl	maxim_charging_control
	bl	DloadMain


;int loadfile(wchar* filepath, ulong startaddr, ulong size)
;loads file to RAM under specific address
;returns bytes read or 0 if error
loadfile:
	STMFD	SP!,{R3-R6,LR\}
	mov	r4, r1
	mov	r5, r2

	mov	r1, 4 ;flag, probably READ or READWRITE
	mov	r0, r0	;path
	bl	tfs4_open
	mov	r6, r0
	cmp	r0, 0	;is it FILE index or -1?
	blt	loadfile_notfound

	mov	r0, 1

	mov	r0, r6

	mov	r2, r5	 ;len
	mov	r1, r4	 ;buffer
	mov	r0, r6	 ;FILE index
	bl	tfs4_read
	mov	r4, r0

	mov	r0, 2

	mov	r0, r4

	mov	r0, r6
	bl	tfs4_close
	mov	r0, r4
loadfile_ret:
	LDMFD	SP!, {R3-R6,PC\}
loadfile_notfound:
	mov	r0, 0
	b	loadfile_ret

;void fota_int_debugprint(int num)
fota_int_debugprint:
	STMFD	SP!, {R1,LR\}
	mov	r1, r0
	ldr	r0, [s_debug_fmt_a]
	bl	disp_FOTA_Printf
	LDMFD	SP!, {R1,PC\}

;void uart_int_debugprint(int num)
uart_int_debugprint:
	STMFD	SP!, {R1,LR\}
	mov	r1, r0
	ldr	r0, [s_debug_fmt_a]
	bl	EdbgOutputDebugString
	LDMFD	SP!, {R1,PC\}


;int fota_listdir(wchar* path)
;auto reset
;returns 0 and print FOTA message if error occured/dir not found, otherwise returns 1 (even if dir is empty)
fota_listdir:
	STMFD	SP!, {R1-R5,LR\}
	mov	r1, 0xC
	mov	r0, r0
	bl	tfs4_opendir
	cmp	r0, 0
	beq	fota_listdir_notfound  ;tfs4_opendir returns 0 if something went wrong
	mov	r5, r0	 ;store *DIR

	mov r4, 0
fota_listdir_loop:
	mov	r0, r5
	bl	tfs4_readdir
	cmp	r0, 0
	beq	fota_listdir_end ;EOF

	;lets convert wcstr to cstr
	mov	r1, 2
	mov	r2, 1

fota_listdir_convertloop:
	ldrb	r3, [r0, r1]
	strb	r3, [r0, r2]

	add	r1, 2
	add	r2, 1

	ldrb	r3, [r0, r1]
	cmp	r3, 0x00

	bne	fota_listdir_convertloop
	strb	r3, [r0, r2] ;make sure str is zero-ending


	mov	r1, r0
	ldr	r0, [s_fmt_a]
	bl	disp_FOTA_Printf


	ldr	r0, [v_delay_100ms]  ;pause to make it easy readable
	bl	PWM_Drv_Delay

	add	r4, 1
	cmp	r4, 20
	ble	fota_listdir_loop    ;if we've got more than 20 lines on the screen - clean it and reset counter

	ldr	r0, [v_delay_800ms]  ;wait 0.8s so we we can read the text
	bl	PWM_Drv_Delay

	bl	disp_FOTA_Init
	mov	r4, 0
	ldr	r3, [fota_x]
	str	r4, [r3]	    ;reset fota_printf_x position counter
	b	fota_listdir_loop
fota_listdir_end:
	mov	r0, r5
	bl	tfs4_closedir
	mov	r0, 1
	b	fota_listdir_ret
fota_listdir_notfound:
	ldr	r0, [s_notfound_a]
	bl	disp_FOTA_Printf
	mov	r0, 0
	b	fota_listdir_ret
fota_listdir_ret:
	LDMFD	SP!, {R1-R5,PC\}
}