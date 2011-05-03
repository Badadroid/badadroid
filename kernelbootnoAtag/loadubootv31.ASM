include 'inc/S8500XXJEEnb66.inc'

START

    mov r1, #1
    ldr r0, [pagetable]
    bl MemMMUCacheEnable


    ;bl disp_FOTA_Init

   ; bl CoDisableMmu


    ;ldr r0, [wykrz_a]
    ;bl disp_FOTA_Printf



	;ldr     r0, [spaces_a]
	;bl      disp_FOTA_Printf

	bl	__PfsNandInit
	bl	__PfsMassInit


       ; b       dloadmode


	MOV	R0, #0xA9
	BL	GPIO_Drv_UnsetExtInterrupt
	;BL      disp_Normal_Init
	;BL      DRV_Modem_BootingStart
	;BL      UsbBoot_set_debug_level ;lets not use it for now
	;BL      get_usb_sw_nv
	;MOV     R7, R0
	;BL      USBSwitch
	;BL      get_uart_sw_nv
	;MOV     R7, R0
	;BL      UARTSwitch
	;MOV     R0, #0xA9
	;BL      GPIO_Drv_UnsetExtInterrupt

	;BL     LoadCompSegments ;lets not use it too

	bl	loadAndroidKernel ;loads to buf in DDR_1, disables MMU and loads it to DDR_0
	cmp	r0, 0
	beq	dloadmode

	;ldr     r0, [s_done_a]
	;bl      disp_FOTA_Printf

	;BL      CoDisableMmu

	BL	CoDisableMmu
	BL	CoCleanDCacheVA
	;BL      CoCleanDCacheIndex
	BL	CoDisableDCache
	BL	CoDisableIrq
	BL	CoDisableFiq
	;ldr     r0, [wykrz_a]
	;bl      disp_FOTA_Printf
	;BL      DRV_Modem_BootingStart
	;BL      GPIO_Drv_UnsetExtInterrupt
	;BL      InitializeDisplay
	;MOV     R0, 0
	;LDR     R1, [machine_id]  ;*should be correct now0
	;MOV     R2, 0 ;ATAGS, TODO

	LDR	R3, [kernel_start]
	BLX	R3


loadAndroidKernel:
	STMFD	SP!, {R1-R6,LR}
	ldr	r1, [kernel_buf_start]
	ldr	r2, [kernel_size]
	ldr	r0, [s_kernel_path_a]
	bl	loadfile
	ldr	r1, [kernel_size]
	cmp	r0, r1
	beq	loadAndroidKernel_copymem
	ldr	r0, [s_error_a]
	;bl      disp_FOTA_Printf
	mov	r0, 0
	b	loadAndroidKernel_ret

loadAndroidKernel_copymem:
	bl CoDisableMmu
	mov	r6, r0

	mov	r0, 1337
	bl	debugprint

	ldr	r0, [kernel_buf_start]
	ldr	r1, [kernel_start]
	ldr	r2, [kernel_size]
	mov	r3, 0
	b	copyloop

copyloop:
	ldrb	r4, [r0,r3] ;src
	mov	r5, r0

	strb	r4, [r1,r3] ;dst

	mov	r0, r5

	add	r3, r3, 1
	cmp	r3, r2
	ble	copyloop

	mov	r0, r6
loadAndroidKernel_ret:
	LDMFD	SP!, {R1-R6,PC}

dloadmode:
	mov	r1, 0
	mov	r0, 2
	bl	maxim_charging_control
	ldr	r0, [s_downloadmode_a]
	;bl      disp_FOTA_Printf
	bl	DloadMain
	NORETURN

;int loadfile(wchar* filename, ulong startaddr, ulong size)
;returns bytes read or 0 if error
loadfile:
	STMFD	SP!, {R3-R6,LR}
	mov	r4, r1
	mov	r5, r2

	mov	r1, 4 ;flag, probably READ or READWRITE
	mov	r0, r0	;path
	bl	tfs4_open
	mov	r6, r0
	cmp	r0, 0	;is it FILE index or -1?
	blt	loadfile_notfound

	mov	r0, 1
	bl	debugprint

	mov	r0, r6
	bl	debugprint

	mov	r2, r5	 ;len
	mov	r1, r4	 ;buffer
	mov	r0, r6	 ;FILE index
	bl	tfs4_read
	mov	r4, r0

	mov	r0, 2
	bl	debugprint

	mov	r0, r4
	bl	debugprint

	mov	r0, r6
	bl	tfs4_close
	mov	r0, r4
loadfile_ret:
	LDMFD	SP!, {R3-R6,PC}
loadfile_notfound:
	ldr	r0, [s_notfound_a]
	bl	disp_FOTA_Printf
	mov	r0, 0
	b	loadfile_ret

;void debugprint(int num)
debugprint:
	STMFD	SP!, {R1,LR}
	mov r1, r0
	ldr r0, [s_debug_fmt_a]
	bl	disp_FOTA_Printf
	LDMFD	SP!, {R1,PC}

;variables
align 4


    spaces_a dw spaces
    wykrz_a dw exlamations

    pagetable dw gMMUL1PageTable

    v_delay_100ms	dw 100000
    v_delay_800ms	dw 800000
    v_delay		dw 4000000


    ;kernel_start        dw 0x40100000
    kernel_buf_start	    dw 0x41000000

    kernel_start	dw 0x30000000
    kernel_size 	dw 0x2CE7C
    machine_id		dw 0x891

    ;test_start          dw 0x32000000
    ;dump_start          dw 0x40200000
    ;dump_end            dw 0x40340000

    fota_x dw x_pos@disp_FOTA_Printf_1


    ; strings at the end

    s_fmt_a		dw s_fmt
    s_dir_a		dw s_dir
    s_debug_fmt_a	dw s_debug_fmt
    s_notfound_a	dw s_notfound
    s_downloadmode_a	dw s_downloadmode
    s_memdump_a 	dw s_memdump
    s_done_a		dw s_done
    s_written_a 	dw s_written
    s_fileload_a	dw s_fileload
    s_read_a		dw s_read
    s_kernel_path_a	dw s_kernel_path
    s_error_a		dw s_error
    s_path_a		dw s_path

    s_path			    du '/g/',0
    s_kernel_path		    du '/g/galaxyboot/uboot.bin',0

    s_downloadmode		    db ' ENTERING DOWNLOAD MODE',0
    s_notfound			    db ' not found!',0
    s_debug_fmt 		    db ' debug: %d',0
    s_memdump			    db ' dump 0x%X - 0x%X',0
    s_written			    db ' written: 0x%X',0
    s_error			    db ' ERROR!',0
    s_shutdown			    db ' SHUTDOWN',0

    s_fileload			    db ' load 0x%X - 0x%X',0
    s_read			    db ' read: 0x%X', 0

    s_done			    db ' done!',0
    s_fmt			    db ' %s',0
    s_dir			    db ' Dir: %s',0
    
END