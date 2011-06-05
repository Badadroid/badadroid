
include 'inc/S8530JPKA1.inc'	  ;here include the right BL function pointers, depends on model and BL you've got
include 'inc/macros_S8530.inc'	  ;model dependend FOTA header and footer

include 'inc/vars.inc'
include 'inc/functions.inc'

;No modem booting yet!

START
	SUB	SP, SP, 128

	MOV	r1, #1
	LDR	r0, [pagetable]
	BL	MemMMUCacheEnable
	MOV	R8, R0 ;lets store previous MMU control register to turn it off later

	bl	enable_uart_output
	BL	__PfsNandInit
	BL	__PfsMassInit


	MOV	R1, SP
	LDR	R0, [s_kernel_path_a]
	BL	tfs4_stat

	LDR	R2, [SP,0xC] ;get kernel size
	LDR	R0, [kernel_size_a]
	STR	R2, [R0]	;store for later use
	LDR	R0, [R0]
	BL	hex_debugprint

	ldr	r0, [s_loadkernel_a]
	bl	debug_print
	LDR	R2, [kernel_size_a]
	LDR	R1, [kernel_buf]
	LDR	R0, [s_kernel_path_a]
	BL	loadfile
	BL	int_debugprint
	ldr	r0, [s_done_a]
	bl	debug_print

	ldr	r0, [s_loadsbl_a]
	bl	debug_print
	LDR	R2, [sbl_size]
	LDR	R1, [sbl_start]
	LDR	R0, [s_sbl_path_a]
	BL	loadfile
	BL	int_debugprint
	ldr	r0, [s_done_a]
	bl	debug_print

	ldr	r0, [s_mmuoff_a]
	bl	debug_print

	MCR	p15, 0, R8,c1,c0 ;turn off MMUCache with previous gained MMU control reg
	BL	CoDisableMmu
	ldr	r0, [s_done_a]
	bl	debug_print
	bl	configure_ram

	LDR	R0, [ATAG_ptr]
	MOV	R1, 0x00
	MOV	R2, 512
	BL	rebell_fillmem ;clear memory there


	LDR	R2, [ATAG_ptr]
	 ; I9000 SBL uses full ATAG_CORE struct (length 5 instead of 2)
	 ; but it isnt needed and tbh I've got no clue how to reproduce it
	 ; http://www.simtec.co.uk/products/SWLINUX/files/booting_article.html#ATAG_CORE
	MOV	R0, 2
	STR	R0, [R2]
	ADD	R2, R2, 4
	LDR	R0, [ATAG_CORE]
	STR	R0, [R2]
	ADD	R2, R2, 4

	;couldn't get real serial number, I9000 Sbl function called directly doesn't seem to work
	;giving some random 0x123 0x456
	MOV	R0, 4
	STR	R0, [R2]
	ADD	R2, R2, 4
	LDR	R0, [ATAG_SERIAL]
	STR	R0, [R2]
	ADD	R2, R2, 4
	MOV	R0, 0x00000123
	STR	R0, [R2]
	ADD	R2, R2, 4
	MOV	R0, 0x00000456
	STR	R0, [R2]
	ADD	R2, R2, 4

	;passing hardcoded I9000 Sbl revision (0x30), we can get real chip_revision but I don't feel it necessary for now
	MOV	R0, 3
	STR	R0, [R2]
	ADD	R2, R2, 4
	LDR	R0, [ATAG_REVISION]
	STR	R0, [R2]
	ADD	R2, R2, 4
	MOV	R0, 0x30
	STR	R0, [R2]
	ADD	R2, R2, 4

		MOV	R0, 12345
	BL	int_debugprint
	LDR	R0, [s_atagcmdline_a]
	BL	rebell_strlen
	ADD	R0, R0, 1  ;include zero-ending
	MOV	R5, R0
		MOV	R0, 12345
	BL	int_debugprint
	MOV	R0, R5

	ADD	R0, R0, 0xD
	MOV	R0, R0,LSR#2
	STR	R0, [R2] ;(sizeof(struct atag_header) + linelen + 1 + 4) >> 2  don't ask me why O.o
	ADD	R2, R2, 4

	LDR	R0, [ATAG_CMDLINE]
	STR	R0, [R2]
	ADD	R2, R2, 4

	MOV	R6, R2
	LDR	R0, [s_atagcmdline_a] ;src
	MOV	R1, R2		      ;dst
	MOV	R2, R5		      ;size
	BL	rebell_memcpy
	MOV	R2, R6
       ; SUB     R5, R5, 2
	ADD	R2, R2, R5, LSL#2 ;add length of string*2 (mem is zeroed anyway)

	MOV	R0, 0	;ATAG_NONE size
	STR	R0, [R2]

	ADD	R2, R2, 4
	MOV	R0, 0	;ATAG_NONE
	STR	R0, [R2] ;thats the whole ATAG struct

	BL	relockernel
	ldr	r0, [s_done_a]
	bl	debug_print

	LDR	R0, [SYSCON_NORMAL_CFG]
	LDR	R1, [R0]
	BIC	R1, R1, 0xBE ;turn off all power-managed S5PC110 blocks, this will reset LCD controller :)
	STR	R1, [R0]
	MOV	R1, 0xFFFFFFFF
	STR	R1, [R0]    ;POWAH ON EVRYTHINKS (clock registers in all modules must be available for kernel)


	BL	timer_driver
	BL	configure_clocks
       ; LDR     R1, [SBL_lcd_init_ptr]
       ; BLX     R1


	;MOV     R0, #0xA9
	;BL      GPIO_Drv_UnsetExtInterrupt
	;BL      disp_Normal_Init
       ; BL      DRV_Modem_BootingStart
	;MOV     R0, #0xA9
	;BL      GPIO_Drv_UnsetExtInterrupt

	;BL      CoDisableL2Cache
	BL	CoDisableDCache
       ; BL      CoInvalidateBothCaches

	BL	System_DisableVIC
	BL	System_DisableIRQ
	BL	System_DisableFIQ

LDR	R0, [EXT_INT_MASKS]   ;zero ext INT masks
MOV	R1, 0xFF
STR	R1, [R0,#0x0]
STR	R1, [R0,#0x4]
STR	R1, [R0,#0x8]
STR	R1, [R0,#0xC]

LDR	R0, [EXT_INT_CTRL]   ;zero ext INT signaling methods
MOV	R1, 0x0
STR	R1, [R0,#0x0]
STR	R1, [R0,#0x4]
STR	R1, [R0,#0x8]
STR	R1, [R0,#0xC]

MOV	R0, #0xF2000000
LDR	R1, [VIC1]
LDR	R2, [VIC2]
LDR	R3, [VIC3]
MOV	R4, 0xFFFFFFFF	;clear INT
STR	R4, [R0,#0x14]
STR	R4, [R1,#0x14]
STR	R4, [R2,#0x14]
STR	R4, [R3,#0x14]

STR	R4, [R0,#0x1C]	;clear software INT
STR	R4, [R1,#0x1C]
STR	R4, [R2,#0x1C]
STR	R4, [R3,#0x1C]

LDR	R5, [INTC_DMA_CLR]   ;clear DMA INT
STR	R4, [R5]
LDR	R5, [INTC_ONENAND_CLR] ;clear oneNand INT
STR	R4, [R5]

MOV	R4, #0		;set all interrupts to IRQ mode
STR	R4, [R0,#0xC]
STR	R4, [R1,#0xC]
STR	R4, [R2,#0xC]
STR	R4, [R3,#0xC]
MOV	R4, #0		;clear ISRs
STR	R4, [R0,#0xF00]
STR	R4, [R1,#0xF00]
STR	R4, [R2,#0xF00]
STR	R4, [R3,#0xF00]


	;LDR     R0, [VIDINTCON0]
	;MOV     R1, 0
	;STR     R1, [R0]
       ; LDR     R0, [VIDINTCON1]
	;STR     R1, [R0]


MOV	R0, #3
BL	FIMD_Drv_ChangeMode
BL	FIMD_Drv_PowerOn
;BL       FIMD_Drv_SetGPIO

	LDR	R5, [NOP_CODE]
	LDR	R0, [SBL_patch_table_adr]

do_patch:
	LDR	R1, [R0], 4 ;post increment R0 by 4
	CMP	R1, 0
	BEQ	patch_done
	STR	R5, [R1]
	B	do_patch

patch_done:
	LDR	R0, [s_done_a]
	BL	debug_print

LDR	R1, [SBL_sblinit_ptr]
BLX	R1
	LDR	R0, [s_done_a]
	BL	debug_print
LDR	R1, [SBL_lcd_init_ptr]
BLX	R1

	LDR	R1, [kernel_start]
	LDR	R0, [s_jumpingout_a]
	BL	debug_print
	MOV	R0, 0	  ;must be 0
	MOV	R1, 0x891 ;machine id of I9000
	LDR	R2, [ATAG_ptr]

	LDR	R5, [kernel_start]
	BLX	R5

	ldr	r0, [s_kernelreturn_a]
	bl	debug_print
       ; mov     r1, 0x32000000
	BL	dloadmode

relockernel:
	STMFD	SP!, {R0-R2,LR}

	LDR	R1, [kernel_start]
	ldr	r0, [s_kernelreloc_a]
	bl	debug_print
	LDR	R0, [kernel_buf]
	LDR	R1, [kernel_start]
	LDR	R2, [kernel_size]
	BL	rebell_memcpy

	LDMFD	SP!, {R0-R2,PC}

FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables below
DEFAULT_VARIABLES
    pagetable		dw gMMUL1PageTable



    INTC_DMA_CLR	dw 0xB0601004
    INTC_ONENAND_CLR	dw 0xB0601008

    SYSCON_NORMAL_CFG	dw 0xE010C010



    ATAG_ptr		dw 0x30000100 ;
    ATAG_CORE		dw 0x54410001
    ATAG_SERIAL 	dw 0x54410006
    ATAG_REVISION	dw 0x54410007
    ATAG_CMDLINE	dw 0x54410009


    VIC1		dw 0xF2100000
    VIC2		dw 0xF2200000
    VIC3		dw 0xF2300000
    def_0x3FF		dw 0x3FF
    def_0x7FFF		dw 0x7FFF
    EXT_INT_MASKS	dw 0xE0200F00
    EXT_INT_CTRL	dw 0xE0200E00

    VIDINTCON0		dw 0xF8000130
    VIDINTCON1		dw 0xF8000134

    kernel_start	dw 0x32000000
    kernel_buf		dw 0x44000000
    kernel_size_a	dw kernel_size
    kernel_size 	dw 0 ;overwritten during runtime

    SBL_sblinit_ptr	dw 0x4024F550
    SBL_lcd_init_ptr	dw 0x40250598 ;0x40250A40;0x40250F90
    sbl_start		dw 0x40244000
    sbl_size		dw 0x140000


    SBL_patch_table_adr dw SBL_patch_table
    NOP_CODE		dw 0xE1A00000
    SBL_patch_table	dw 0x0;0x4025095C
dw 0x0	     ;end


;;;;;;;;;;;;;;;;;;;;;;;;;;;;; strings at the end
DEFAULT_STRINGS_ADDR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; add custom strings addresses below (for using by LDR op)
    s_kernel_path_a  dw s_kernel_path
    s_loadkernel_a   dw s_loadkernel
    s_jumpingout_a   dw s_jumpingout
    s_kernelreloc_a  dw s_kernelreloc
    s_mmuoff_a	     dw s_mmuoff
    s_kernelreturn_a dw s_kernelreturn
    s_atagcmdline_a  dw s_atagcmdline
    s_sbl_path_a     dw s_sbl_path
    s_loadsbl_a      dw s_loadsbl

DEFAULT_STRINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;add custom strings below
    s_kernel_path    du '/g/galaxyboot/zImage',0
    s_sbl_path	     du '/g/galaxyboot/sbl.bin',0
    s_atagcmdline    db 'console=ttySAC2,115200 loglevel=4',0
    s_loadkernel     db ' Loading kernel image to buf',0
    s_jumpingout     db ' Jumpout to 0x%X',0
    s_mmuoff	     db ' Turning off MMU',0
    s_kernelreloc    db ' Reloc kernel to 0x%X',0
    s_kernelreturn   db ' WTF KERNEL RETURNED',0
    s_loadsbl	     db ' Loading SBL',0

END
