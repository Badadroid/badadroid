;some functions written by Rebellos and b.kubica
;if adding new please make them model-independent
macro FUNCTIONS
{

;void dloadmode()
;prints info message to current debug interface and enters downloading mode
dloadmode:
	ldr	r0, [s_downloadmode_a]
	bl	debug_print

	mov	r1, 0
	mov	r0, 2
	bl	maxim_charging_control
	bl	DloadMain

;int rebell_strlen(char* str)
rebell_strlen:
	STMFD	SP!, {R1-R4,LR\}
	MOV	R1, 0
rebell_strlen_loop:
	LDRB	R2, [R0], 1
	CMP	R2, 0x0
	BEQ	rebell_strlen_ret
	ADD	R1, R1, 1
	B	rebell_strlen_loop
rebell_strlen_ret:
	MOV	R0, R1
	LDMFD	SP!, {R1-R4,PC\}

;void rebell_fillmem(R0 void* ptr, R1 byte fillbyte, R2 int length)
rebell_fillmem:
	STMFD	SP!, {R3,LR\}
	MOV	R3, 0
rebell_fillmem_loop:
	CMP	R3, R2
	BGE	rebell_fillmem_ret
	STRB	R1, [R0, R3]
	ADD	R3, R3, 1
	B	rebell_fillmem_loop
rebell_fillmem_ret:
	LDMFD	SP!, {R3,PC\}
;be aware of code below, need someone to check and fix it
;it is 100% copy->paste from PBL with commented out 0x40 mapping
configure_ram:
	STMFD	SP!, {R0-R5,LR\}
	LDR	R0, [APLL_LOCK]
	ORR	R0, R0, #0x6200
	ORR	R0, R0, #8
	MOV	R1, #0
	STR	R1, [R0]
	LDR	R0, [RST_STAT]
	LDR	R3, [R0]
	AND	R3, R3, #0x10000
	LDR	R0, [ASYNC_MSYS_DMC0]
	MOV	R1, #0
	STR	R1, [R0]
	MOV	R1, #0
	STR	R1, [R0,#0xC]
	LDR	R0, [DMC0_REG]
	LDR	R1, [conf_0x101000]
	STR	R1, [R0,#0x18]
	MOV	R1, #0x84
	STR	R1, [R0,#0x1C]
	LDR	R1, [conf_0x101000]
	ADD	R1, R1, 2
	STR	R1, [R0,#0x18]
	LDR	R1, [conf_0x101000]
	ADD	R1, R1, 3
	STR	R1, [R0,#0x18]
	MOV	R2, #0x4000
loopconfram:
	SUBS	R2, R2, #1
	CMP	R2, #0
	BNE	loopconfram
	LDR	R1, [conf_0x60101003]
	STR	R1, [R0,#0x18]
	CMP	R3, #0x10000
	BNE	configram2
	LDR	R1, [conf_0x60101001]
	STR	R1, [R0,#0x18]
configram2:
	LDR	R1, [conf_0xFFF1010]
	STR	R1, [R0]
	LDR	R1, [conf_0x212100]
	STR	R1, [R0,#4]
	LDR	R1, [conf_0x30F82222]
	STR	R1, [R0,#8]
	LDR	R1, [conf_0x40F02222]
	STR	R1, [R0,#0xC]
	MOV	R1, #0xFF000000
	STR	R1, [R0,#0x14]
	MOV	R1, 0x50E
	STR	R1, [R0,#0x30]
	LDR	R1, [conf_0x14233287]
	STR	R1, [R0,#0x34]
	LDR	R1, [conf_0x12130005]
	STR	R1, [R0,#0x38]
	LDR	R1, [conf_0xE140222]
	STR	R1, [R0,#0x3C]
	MOV	R1, #0x7000000
	STR	R1, [R0,#0x10]
	MOV	R1, #0x1000000
	STR	R1, [R0,#0x10]
	MOV	R1, #0x5000000
	STR	R1, [R0,#0x10]
	MOV	R1, #0x5000000
	STR	R1, [R0,#0x10]
	MOV	R1, #0x32
	STR	R1, [R0,#0x10]
	LDR	R1, [conf_0x20020]
	STR	R1, [R0,#0x10]
	MOV	R1, #0x7100000
	STR	R1, [R0,#0x10]
	MOV	R1, #0x1100000
	STR	R1, [R0,#0x10]
	MOV	R1, #0x5100000
	STR	R1, [R0,#0x10]
	MOV	R1, #0x5100000
	STR	R1, [R0,#0x10]
	LDR	R1, [conf_0x100032]
	STR	R1, [R0,#0x10]
	LDR	R1, [conf_0x120020]
	STR	R1, [R0,#0x10]
	LDR	R1, [conf_0xFFF10B0]
	STR	R1, [R0]
	MOV	R1, 0xFFFF00FF
	STR	R1, [R0,#0x28]
	LDR	R1, [conf_0x212113]
	STR	R1, [R0,#4]
	LDR	R0, [DMC1_REG] ; DMC1_config
	LDR	R1, [conf_0x101000]
	STR	R1, [R0,#0x18]
	MOV	R1, #0x84
	STR	R1, [R0,#0x1C]
	LDR	R1, [conf_0x101000]
	ADD	R1, R1, 2
	STR	R1, [R0,#0x18]
	LDR	R1, [conf_0x101000]
	ADD	R1, R1, 3
	STR	R1, [R0,#0x18]
	MOV	R2, #0x4000
loopconfram2:
	SUBS	R2, R2, #1
	CMP	R2, #0
BNE	loopconfram2
	LDR	R1, [conf_0x50101003]
	STR	R1, [R0,#0x18]
	CMP	R3, #0x10000
BNE	configram3
	LDR	R1, [conf_0x50101001]
	STR	R1, [R0,#0x18]
configram3:
;LDR     R0, [DMC1_REG]
;LDR     R1, [conf_0xFFF1010]
;STR     R1, [R0]
;LDR     R1, [conf_0x212100]
	;MOV     R5, R0
	;MOV     R0, 9999
	;BL      int_debugprint
       ; MOV     R0, R5
;STR     R1, [R0,#4]

	;MOV     R0, 9999
	;BL      int_debugprint
	LDMFD	SP!, {R0-R5,PC\}
;endproc

	conf_0xE2700000  dw 0xE2700000
	conf_0xE2900C00  dw 0xE2900C00
	conf_0x120020	 dw 0x120020
	conf_0xFFF10B0	 dw 0xFFF10B0
	conf_0x212113	 dw 0x212113
	conf_0x50101003  dw 0x50101003
	conf_0x50101001  dw 0x50101001
	conf_0xFFF1010	 dw 0xFFF1010
	APLL_LOCK	 dw 0xE0100000
	RST_STAT	 dw 0xE010A000
	ASYNC_MSYS_DMC0  dw 0xF1E00000
	DMC0_REG	 dw 0xF0000000
	conf_0x60101003  dw 0x60101003
	conf_0x60101001  dw 0x60101001
	conf_0x101000	 dw 0x101000
	DMC1_REG	 dw 0xF1400000
	conf_0x40F02222  dw 0x40F02222
	conf_0x212100	 dw 0x212100
	conf_0x30F82222  dw 0x30F82222
	conf_0x14233287  dw 0x14233287
	conf_0x12130005  dw 0x12130005
	conf_0xE140222	 dw 0xE140222
	conf_0x20020	 dw 0x20020
	conf_0x100032	 dw 0x100032

;void rebell_memcpy(int source(r0), int target(r1), int size(r2))
;returns num of bytes copied (always equal to size or just hangs on mem access violation)
rebell_memcpy:
	STMFD	SP!, {R3-R6,LR\}

	MOV	R3, R2
	MOV	R2, R1
	MOV	R1, R0
	LDR	R0, [s_memcpy_a]
	BL	debug_print

	MOV	R0, R1
	MOV	R1, R2
	MOV	R2, R3

	MOV	R3, 0
rebell_memcpy_copyloop:
	ldrb	r4, [r0,r3] ;src
	strb	r4, [r1,r3] ;dst
	add	r3, r3, 1
	cmp	r3, r2
	BLT	rebell_memcpy_copyloop
	MOV	R0, R2
	LDMFD	SP!, {R3-R6,PC\}

;void debug_print(char* fmt, ...)
debug_print:
	STMFD	SP!, {R0-R11,LR\} ;make sure no registers change
	LDR	R10, [output_switch]
	CMP	R10, 1
	BEQ	debug_print_fota
	CMP	R10, 2
	BEQ	debug_print_uart
	B	debug_print_ret
debug_print_fota:
	BL	disp_FOTA_Printf

	ldr	r3, [fota_x]
	ldr	r3, [r3]
	cmp	r3, 21
	BLE	debug_print_ret

	ldr	r0, [v_delay_800ms]  ;wait 0.8s so we we can read the text
	bl	PWM_Drv_Delay
	BL	disp_FOTA_Init
	mov	r4, 0
	ldr	r3, [fota_x]
	str	r4, [r3]	    ;reset fota_printf_x position counter

	B	debug_print_ret
debug_print_uart:
	BL	EdbgOutputDebugString
	LDR	r0, [s_uart_newline_a]
	BL	EdbgOutputDebugString
	B	debug_print_ret
debug_print_ret:
	LDMFD	SP!, {R0-R11,PC\}

;void enable_fota_output()
enable_fota_output:
	STMFD	SP!, {R0-R1,LR\}
	ADR	r1, output_switch
	MOV	r0, 1
	STR	R0, [r1]
	BL	disp_FOTA_Init
	MOV	R0, 0x1
	bl	disp_dimming_backlight
	ldr	r0, [s_fotaoutput_a]
	bl	debug_print
	LDMFD	SP!, {R0-R1,PC\}

;void enable_uart_output()
enable_uart_output:
	STMFD	SP!, {R0-R1,LR\}
	ADR	r1, output_switch
	MOV	r0, 2
	STR	R0, [r1]
	ldr	r0, [s_uartoutput_a]
	bl	debug_print
	LDMFD	SP!, {R0-R1,PC\}

;void int_debugprint(int num)
int_debugprint:
	STMFD	SP!, {R0-R1,LR\}
	mov	r1, r0
	ldr	r0, [s_debug_fmt_int_a]
	bl	debug_print
	LDMFD	SP!, {R0-R1,PC\}

;void hex_debugprint(int num)
hex_debugprint:
	STMFD	SP!, {R0-R1,LR\}
	mov	r1, r0
	ldr	r0, [s_debug_fmt_hex_a]
	bl	debug_print
	LDMFD	SP!, {R0-R1,PC\}
;void memdump(wchar* filepath, ulong buf, ulong size)
memdump:
	STMFD	SP!, {R1-R10,LR\}
	MOV	r4, R0
	MOV	r5, R1
	MOV	r6, R2


	mov	r2, r6
	mov	r1, r5
	ldr	r0, [s_memdump_a]
	bl	debug_print
	mov	r1, 0xC
	mov	r0, R4
	bl	tfs4_open
	mov	r9, r0
	cmp	r9, 0
	blt	memdump_error

	mov	r2, r6;r6 ;len
	mov	r1, r5
	mov	r0, r9
	bl	tfs4_write

	mov	r1, r0
	ldr	r0, [s_written_a]
	bl	debug_print
	cmp	r1, -1
	beq	memdump_error

	mov	r0, r9
	bl	tfs4_close

	ldr	r0, [s_done_a]
	bl	debug_print
	b	memdump_ret
memdump_error:
	BL	tfs4_get_errno
	mov	r1, r0
	ldr	r0, [s_dumpmem_error_a]
	bl	debug_print
	mov	r0, 0
memdump_ret:
	LDMFD	SP!, {R1-R10,PC\}
;int loadfile(wchar* filepath, ulong target_addr, ulong size)
;loads file to RAM under specific address
;returns bytes read or 0 if error
loadfile:
	STMFD	SP!,{R3-R6,LR\}
	mov	r4, r1
	mov	r5, r2
	mov	r6, r0

	mov	r1, r4
	ldr	r0, [s_fileload_a]
	bl	debug_print

	mov	r0, r6

	mov	r1, 4 ;flag, probably READ or READWRITE
	mov	r6, r0	;path
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
	
	mov	r1, r0
	ldr	r0, [s_filesize_a]
	bl	debug_print
	
	mov	r0, r6
	bl	tfs4_close
	mov	r0, r4
loadfile_ret:
	LDMFD	SP!, {R3-R6,PC\}
loadfile_notfound:
	ldr	r0, [s_loadfile_error_a]
	bl	debug_print
	mov	r0, 0
	b	loadfile_ret


;int fota_listdir(wchar* path)
;auto reset
;returns 0 and print FOTA message if error occured/dir not found, otherwise returns 1 (even if dir is empty)
listdir:
	STMFD	SP!, {R1-R5,LR\}
	mov	r1, 0xC
	mov	r0, r0
	bl	tfs4_opendir
	cmp	r0, 0
	beq	listdir_notfound  ;tfs4_opendir returns 0 if something went wrong
	mov	r5, r0	 ;store *DIR

	mov r4, 0
listdir_loop:
	mov	r0, r5
	bl	tfs4_readdir
	cmp	r0, 0
	beq	listdir_end ;EOF

	;lets convert wcstr to cstr
	mov	r1, 2
	mov	r2, 1

listdir_convertloop:
	ldrb	r3, [r0, r1]
	strb	r3, [r0, r2]

	add	r1, 2
	add	r2, 1

	ldrb	r3, [r0, r1]
	cmp	r3, 0x00

	bne	listdir_convertloop
	strb	r3, [r0, r2] ;make sure str is zero-ending


	mov	r1, r0
	ldr	r0, [s_fmt_a]
	bl	debug_print


	ldr	r0, [v_delay_100ms]  ;pause to make it easy readable
	bl	PWM_Drv_Delay

	b	listdir_loop
listdir_end:
	mov	r0, r5
	bl	tfs4_closedir
	mov	r0, 1
	b	listdir_ret
listdir_notfound:
	ldr	r0, [s_notfound_a]
	bl	debug_print
	mov	r0, 0
	b	listdir_ret
listdir_ret:
	LDMFD	SP!, {R1-R5,PC\}
}