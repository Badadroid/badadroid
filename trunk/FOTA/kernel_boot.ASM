
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
	ldr	r0, [s_done_a]
	bl	debug_print
	bl	configure_ram

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


	;LDR     R0, [s_atagcmdline_a]
	;BL      strlen
       ; MOV     R5, CMDLINE_LEN  ;hardcoded strlen
	;MOV     R0, CMDLINE_LEN  ;hardcoded strlen

	LDR	R0, [s_atagcmdline_a]
	BL	rebell_strlen
	ADD	R0, R0, 1  ;include zero-ending
	MOV	R5, R0



	ADD	R0, R0, 0xD
	MOV	R0, R0,LSR#2
	STR	R0, [R2] ;(sizeof(struct atag_header) + linelen + 1 + 4) >> 2  don't ask me why O.o
	ADD	R2, R2, 4

	LDR	R0, [ATAG_CMDLINE]
	STR	R0, [R2]
	ADD	R2, R2, 4

	STMFD	sp!, {R2}
	LDR	R0, [s_atagcmdline_a] ;src
	MOV	R1, R2		      ;dst
	MOV	R2, R5		      ;size
	BL	rebell_memcpy
	LDMFD	sp!,{R2}
	SUB	R5, R5, 2
	ADD	R2, R2, R5,LSL#2 ;add length of string

	MOV	R0, R2
	MOV	R0, 0	;ATAG_NONE size (zero, because of weird linux kernel programmers)
	STR	R0, [R2]

	ADD	R2, R2, 4
	MOV	R0, 0x00000000	 ;ATAG_NONE
	STR	R0, [R2] ;thats the whole ATAG struct

	BL	relockernel
	ldr	r0, [s_done_a]
	bl	debug_print
	MRS	R0, CPSR
BIC	R0, R0, #0xFF
ORR	R0, R0, #0xD3
MSR	CPSR_cf, R0
MOV	R0, #0
MCR	p15, 0, R0,c8,c7
MCR	p15, 0, R0,c7,c5
MCR	p15, 0, R0,c7,c6, 2
MRC	p15, 0, R0,c1,c0
BIC	R0, R0, #0x1000
MCR	p15, 0, R0,c1,c0
BL	sub_40244118
MRC	p15, 0, R0,c1,c0
BIC	R0, R0, #0x2000
BIC	R0, R0, #7
ORR	R0, R0, #2
ORR	R0, R0, #0x800
MCR	p15, 0, R0,c1,c0
LDR	R0, [WATCHDOG_TIMER]
MOV	R1, #0
STR	R1, [R0]
LDR	R0, [MANUAL_IRQ]
LDR	R1, [R0,#0x40]
STR	R1, [R0,#0x40]
LDR	R1, [R0,#0x44]
STR	R1, [R0,#0x44]
LDR	R1, [R0,#0x48]
STR	R1, [R0,#0x48]
LDR	R1, [R0,#0x4C]
STR	R1, [R0,#0x4C]

MOV	R0, #0xF2000000
LDR	R1, [VIC1]
LDR	R2, [VIC2]
LDR	R3, [VIC3]
MOV	R4, 0xFFFFFFFF
STR	R4, [R0,#0x14]
STR	R4, [R1,#0x14]
STR	R4, [R2,#0x14]
STR	R4, [R3,#0x14]
MOV	R4, #0
STR	R4, [R0,#0xC]
STR	R4, [R1,#0xC]
STR	R4, [R2,#0xC]
STR	R4, [R3,#0xC]
MOV	R4, #0
STR	R4, [R0,#0xF00]
STR	R4, [R1,#0xF00]
STR	R4, [R2,#0xF00]
STR	R4, [R3,#0xF00]


LDR	R3, [CLK_DIV0]
LDR	R3, [R3]


AND	R3, R3, #0x80000000
LDR	R3, [clk_div_mask]
ORR	R3, R2, R3
LDR	R2, [CLK_DIV0]
;STR     R3, [R2]

BL	timer_driver

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

	MOV	R0, #0xA9
	BL	GPIO_Drv_UnsetExtInterrupt
	BL	disp_Normal_Init
       ; BL      DRV_Modem_BootingStart
	MOV	R0, #0xA9
	BL	GPIO_Drv_UnsetExtInterrupt

	;BL      CoDisableL2Cache
	BL	CoDisableDCache
	;BL      CoInvalidateBothCaches
	;BL      System_DisableVIC
	BL	System_DisableIRQ
       ; BL      System_DisableFIQ

	LDR	R0, [SYSCON_NORMAL_CFG]
	MOV	R1, 0xFFFFFFFF
	STR	R1, [R0]    ;POWAH ON EVRYTHINKS (clock registers in all modules must be available for kernel)



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
 sub_40244118:
MOV	R0, 0xFFFFFFFF
MRC	p15, 1, R0,c0,c0, 1
ANDS	R3, R0, #0x7000000
MOV	R3, R3,LSR#23
BEQ	locret_4024419C
MOV	R10, #0
loc_40244130:
ADD	R2, R10, R10,LSR#1
MOV	R1, R0,LSR R2
AND	R1, R1, #7
CMP	R1, #2
BLT	loc_40244190
MCR	p15, 2, R10,c0,c0
MOV	R1, #0
MCR	p15, 0, R1,c7,c5, 4
MRC	p15, 1, R1,c0,c0
AND	R2, R1, #7
ADD	R2, R2, #4
LDR	R4, [def_0x3FF]
ANDS	R4, R4, R1,LSR#3
CLZ	R5, R4
LDR	R7, [def_0x7FFF]
ANDS	R7, R7, R1,LSR#13
loc_40244170:
MOV	R9, R4
loc_40244174:
ORR	R11, R10, R9,LSL R5
ORR	R11, R11, R7,LSL R2
MCR	p15, 0, R11,c7,c6, 2
SUBS	R9, R9, #1
BGE	loc_40244174
SUBS	R7, R7, #1
BGE	loc_40244170
loc_40244190:
ADD	R10, R10, #2
CMP	R3, R10
BGT	loc_40244130
locret_4024419C:
MOV	PC, LR

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

    SYSCON_NORMAL_CFG	dw 0xE010C010
    CLK_DIV0		dw 0xE0100300
    clk_div_mask	dw 0x14131330

    kernel_start	dw 0x32000000

    ATAG_ptr		dw 0x30000100 ;
    ATAG_CORE		dw 0x54410001
    ATAG_SERIAL 	dw 0x54410006
    ATAG_REVISION	dw 0x54410007
    ATAG_CMDLINE	dw 0x54410009

    CLK_GATE_IP0	dw 0xE0100460
    CLK_GATE_IP1	dw 0xE0100464
    CLK_GATE_IP2	dw 0xE0100468
    CLK_GATE_IP3	dw 0xE010046C
    CLK_GATE_IP4	dw 0xE0100470

    WATCHDOG_TIMER	dw 0xE2700000

    VIC1		dw 0xF2100000
    VIC2		dw 0xF2200000
    VIC3		dw 0xF2300000
    def_0x3FF		dw 0x3FF
    def_0x7FFF		dw 0x7FFF
    MANUAL_IRQ		dw 0xE0200F00


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
    s_kernel_path    du '/g/galaxyboot/zImage_oleg',0
    s_atagcmdline    db 'bootmode= console=ttySAC2,115200 loglevel=4',0
   ; CMDLINE_LEN      =  46 ;strlen+1 it is hardcoded for now, as I am too dumb to use BL3 str functions properly. ~Rebellos
    s_loadkernel     db ' Loading kernel image to buf',0
    s_jumpingout     db ' Jumpout to 0x%X',0
    s_mmuoff	     db ' Turning off MMU',0
    s_kernelreloc    db ' Reloc kernel to 0x%X',0
    s_kernelreturn   db ' WTF KERNEL RETURNED',0

END