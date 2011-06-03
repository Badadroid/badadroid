
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


	LDR	R0, [VIDINTCON0]
	MOV	R1, 0
	STR	R1, [R0]
	LDR	R0, [VIDINTCON1]
	STR	R1, [R0]

	LDR	R0, [SYSCON_NORMAL_CFG]
	MOV	R1, 0xFFFFFFFF
	STR	R1, [R0]    ;POWAH ON EVRYTHINKS (clock registers in all modules must be available for kernel)

LDR	R4, [UART2_PTR]
MOV	R3, #0x23
STRH	R3, [SP,#8]
MOV	R3, #0x80
STRH	R3, [SP,#6]
LDR	R3, [R4, #4]
BIC	R3, R3, #0xF
STR	R3, [R4, #4]
MOV	R3, #0
STR	R3, [R4, #8]
MOV	R3, #0
STR	R3, [R4, #0xC]
MOV	R3, #3
STR	R3, [R4]
MOV	R3, #0x240
STR	R3, [R4, 4]
LDRH	R3, [SP,#8]
STR	R3, [R4, 0x28]
LDRH	R3, [SP,#6]
STR	R3, [R4, 0x2C]
LDR	R3, [R4, 4]
ORR	R3, R3, #5
STR	R3, [R4, 4]

BL	timer_driver

		LDR	R3, [CLK_DIV1]
		LDR	R3, [R3]
		BIC	R3, R3, #0xF00000
		ORR	R3, R3, #0x300000
		LDR	R2, [CLK_DIV1]
		STR	R3, [R2]
LDR	R3, [CLK_DIV0]
LDR	R3, [R3]
AND	R3, R3, #0x80000000
MOV	R2, R3
LDR	R3, [clk_div_mask]
ORR	R3, R2, R3
LDR	R2, [CLK_DIV0]
STR	R3, [R2]

wait_for_stable_div:
LDR	R3, [CLK_DIV_STAT0]
LDR	R3, [R3]
AND	R3, R3, #1
CMP	R3, #0
BNE	wait_for_stable_div

LDR	R3, [DMC0_REG]
LDR	R3, [R3, 0x18]
BIC	R3, R3, #2
LDR	R2, [DMC0_REG]
STR	R3, [R2, 0x18]
LDR	R3, [DMC1_REG]
LDR	R3, [R3, 0x18]
BIC	R3, R3, #2
LDR	R2, [DMC1_REG]
STR	R3, [R2, 0x18]


LDR	R2, [CLK_GATE_IP0]
LDR	R3, [CLK_GATE_IP0]
LDR	R3, [R3]
BIC	R3, R3, #0x80000000
STR	R3, [R2]
LDR	R2, [CLK_GATE_IP1]
LDR	R3, [CLK_GATE_IP1]
LDR	R3, [R3]
BIC	R3, R3, #0x10000000
STR	R3, [R2]
LDR	R2, [CLK_GATE_IP2]
LDR	R3, [CLK_GATE_IP2]
LDR	R3, [R3]
BIC	R3, R3, #0x200
BIC	R3, R3, #2
STR	R3, [R2]
LDR	R2, [CLK_GATE_IP3]
LDR	R3, [CLK_GATE_IP3]
LDR	R3, [R3]
BIC	R3, R3, #3
STR	R3, [R2]
LDR	R2, [CLK_GATE_IP4]
LDR	R3, [CLK_GATE_IP4]
LDR	R3, [R3]
BIC	R3, R3, #6
STR	R3, [R2]



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

timer_driver:

var_18= -0x18
var_4= -4

STR	R11, [SP,#var_4]!
ADD	R11, SP, #4+var_4
SUB	SP, SP, #0xC
LDR	R2, [TCFG0]
MOV	R3, #0xF00
STR	R3, [R2]
LDR	R3, [TCFG1]
LDR	R3, [R3]
BIC	R3, R3, #0xF0000
STR	R3, [R11,#0x10+var_18]
LDR	R2, [TCFG1]
LDR	R3, [R11,#0x10+var_18]
ORR	R3, R3, #0x10000
STR	R3, [R2]
LDR	R2, [TCNTB4]
MOV	R3, 0xFFFFFFFF
STR	R3, [R2]
LDR	R2, [TCON]
LDR	R3, [TCON]
LDR	R3, [R3]
BIC	R3, R3, #0x700000
ORR	R3, R3, #0x600000
STR	R3, [R2]
LDR	R2, [TCON]
LDR	R3, [TCON]
LDR	R3, [R3]
BIC	R3, R3, #0x700000
ORR	R3, R3, #0x500000
STR	R3, [R2]
MOV	SP, R11
LDMFD	SP!, {R11}
BX	LR

TCFG0	dw  0xE2500000
TCFG1	dw  0xE2500004
TCON	dw  0xE2500008

TCNTB4	dw  0xE250003C

FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables below
DEFAULT_VARIABLES
    pagetable		dw gMMUL1PageTable

    GPIO_INT_FIRST	dw 0xE0200700
    GPIO_INT_LAST	dw 0xE0200754

    INTC_DMA_CLR	dw 0xB0601004
    INTC_ONENAND_CLR	dw 0xB0601008

    SYSCON_NORMAL_CFG	dw 0xE010C010


    kernel_start	dw 0x32000000

    ATAG_ptr		dw 0x30000100 ;
    ATAG_CORE		dw 0x54410001
    ATAG_SERIAL 	dw 0x54410006
    ATAG_REVISION	dw 0x54410007
    ATAG_CMDLINE	dw 0x54410009

    UART2_PTR		dw 0xE2900800
    clk_div_mask	dw 0x14131330
    CLK_DIV0		dw 0xE0100300
    CLK_DIV1		dw 0xE0100304
    CLK_DIV2		dw 0xE0100308
    CLK_DIV3		dw 0xE010030C
    CLK_DIV4		dw 0xE0100310
    CLK_DIV5		dw 0xE0100314
    CLK_DIV6		dw 0xE0100318
    CLK_DIV7		dw 0xE010031C
    CLK_GATE_IP0	dw 0xE0100460
    CLK_GATE_IP1	dw 0xE0100464
    CLK_GATE_IP2	dw 0xE0100468
    CLK_GATE_IP3	dw 0xE010046C
    CLK_GATE_IP4	dw 0xE0100470
    CLK_DIV_STAT0	dw 0xE0101000

    WATCHDOG_TIMER	dw 0xE2700000

    VIC1		dw 0xF2100000
    VIC2		dw 0xF2200000
    VIC3		dw 0xF2300000
    def_0x3FF		dw 0x3FF
    def_0x7FFF		dw 0x7FFF
    EXT_INT_MASKS	dw 0xE0200F00
    EXT_INT_CTRL	dw 0xE0200E00

    VIDINTCON0		dw 0xF8000130
    VIDINTCON1		dw 0xF8000134


    kernel_buf		dw 0x44000000
    kernel_size_a	dw kernel_size
    kernel_size 	dw 0 ;overwritten during runtime ;0x6664C8  ;6710472


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

DEFAULT_STRINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;add custom strings below
    s_kernel_path    du '/g/galaxyboot/zImage',0
    s_atagcmdline    db 'console=ttySAC2,115200 loglevel=4',0
    s_loadkernel     db ' Loading kernel image to buf',0
    s_jumpingout     db ' Jumpout to 0x%X',0
    s_mmuoff	     db ' Turning off MMU',0
    s_kernelreloc    db ' Reloc kernel to 0x%X',0
    s_kernelreturn   db ' WTF KERNEL RETURNED',0

END
