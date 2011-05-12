
include 'inc/S8530JPKA1.inc'	  ;here include the right BL function pointers, depends on model and BL you've got
include 'inc/macros_S8530.inc'	  ;model dependend FOTA header and footer

include 'inc/vars.inc'
include 'inc/functions.inc'

; VERY rough code for loading sbl to 0x40244000 and Kernel to 0x32000000, then executes KERNEL.
; Sbl is unused in this code
START
	bl	enable_fota_output


	MOV	R0, 2222
	BL	int_debugprint

	BL	testmembank
	BL	testmembank

	MOV	R0, 333
	BL	int_debugprint

MRS	R0, CPSR
BIC	R0, R0, #0x1F
ORR	R0, R0, #0xD3
MSR	CPSR_cf, R0
LDR	R0, [conf_0xE2900C00]
MOV	R1, #0
STR	R1, [R0]
STR	R1, [R0,#8]
STR	R1, [R0,#4]
STR	R1, [R0,#0x28]
STR	R1, [R0,#0x2C]
MOV	R1, #0xF
STR	R1, [R0,#0x34]
STR	R1, [R0,#0x30]
MOV	R0, #0
MCR	p15, 0, R0,c7,c5
MCR	p15, 0, R0,c7,c6, 2
MRC	p15, 0, R0,c1,c0
BIC	R0, R0, #0x1000
MCR	p15, 0, R0,c1,c0
MOV	R0, #0
MRC	p15, 0, R0,c1,c0, 1
BIC	R0, R0, #2
MCR	p15, 0, R0,c1,c0, 1
MOV	R0, #0
MOV	R1, #0
MOV	R3, #0
MOV	R4, #0
loc_40202090:
MOV	R2, #0
loc_40202094:
MOV	R3, R1,LSL#29
MOV	R4, R2,LSL#6
ORR	R4, R4, #2
ORR	R3, R3, R4
MOV	R0, R3
MCR	p15, 0, R0,c7,c6, 2
ADD	R2, R2, #1
CMP	R2, #0x400
BNE	loc_40202094
ADD	R1, R1, #1
CMP	R1, #8
BNE	loc_40202090
MOV	R1, #0
MCR	p15, 1, R1,c9,c0, 2
MRC	p15, 0, R0,c1,c0, 1
ORR	R0, R0, #2
MCR	p15, 0, R0,c1,c0, 1
MRC	p15, 0, R0,c1,c0
ORR	R0, R0, #0x1000
MCR	p15, 0, R0,c1,c0
MRC	p15, 0, R0,c1,c0
BIC	R0, R0, #0x2000
BIC	R0, R0, #7
ORR	R0, R0, #2
ORR	R0, R0, #0x800
MCR	p15, 0, R0,c1,c0
LDR	R0, [conf_0xE2700000]
MOV	R1, #0
STR	R1, [R0]
MOV	R0, #0xE8000000
MOV	R1, #0xB
STR	R1, [R0]




	MOV	R0, 333
	BL	int_debugprint

	B      configure_ram
the_morning_after:
	MOV	R0, 3334
	BL	int_debugprint

	MOV	R0, 4444
	BL	int_debugprint

	BL	testmembank
	BL	testmembank

	MOV	R0, 1111
	BL	int_debugprint


	BL	testmembank


	MOV	R0, 1234
	BL	int_debugprint

	;BL      testmembank

	MOV	R0, 1234
	BL	int_debugprint

	BL	dloadmode

testmembank:
	STMFD	SP!, {R0-R1,LR}

	LDR	R0, [read_addr]
	LDR	R0, [R0]
	BL	hex_debugprint

	LDR	R0, [opcode]
	LDR	R1, [write_addr]
	STR	R0, [R1]

	LDR	R0, [read_addr]
	LDR	R0, [R0]
	BL	hex_debugprint
	LDMFD	SP!, {R0-R1,PC}
do_something:
LDR	R0, [conf_0xE010A000]
LDR	R1, [R0]
AND	R1, R1, #0x10000
CMP	R1, #0x10000
BEQ	loc_40202218
LDR	R0, [conf_0xE0100000]
LDR	R1, [R0,#0x300]
MOV	R2, 0x7FFFFFFF
BIC	R1, R1, R2
LDR	R2, [conf_0x14131131]
ORR	R1, R1, R2
STR	R1, [R0,#0x300]

loc_402021B8:
LDR	R1, [conf_0xE0101000]
LDR	R2, [R1]
AND	R2, R2, #1
CMP	R2, #1
BEQ	loc_402021B8

LDR	R1, [conf_0x80300302]
STR	R1, [R0,#0x110]
LDR	R1, [conf_0x806C0603]
STR	R1, [R0,#0x120]
LDR	R1, [R0,#0x200]
LDR	R2, [conf_0x10001111]
ORR	R1, R1, R2
STR	R1, [R0,#0x200]
LDR	R1, [R0,#0x218]
MOV	R2, #0x1000000
ORR	R1, R1, R2
STR	R1, [R0,#0x218]
LDR	R1, [R0,#0x318]
MOV	R2, #0x30000000
MOV	R3, #0x7000
ORR	R1, R1, R2
BIC	R1, R1, R3
STR	R1, [R0,#0x318]
B	loc_402022A0

loc_40202218:
LDR	R0, [conf_0xE0100000]
MOV	R1, #0
STR	R1, [R0,#0x200]
LDR	R1, [R0,#0x300]
MOV	R2, 0x7FFFFFFF
BIC	R1, R1, R2
LDR	R2, [conf_0x14131330]
ORR	R1, R1, R2
STR	R1, [R0,#0x300]
LDR	R1, [conf_0x80C80601]
STR	R1, [R0,#0x100]
LDR	R1, [conf_0x829B0C01]
STR	R1, [R0,#0x108]
LDR	R1, [conf_0x80300302]
STR	R1, [R0,#0x110]
LDR	R1, [conf_0x806C0603]
STR	R1, [R0,#0x120]
MOV	R1, #0x10000
loc_40202260:
SUBS	R1, R1, #1
BNE	loc_40202260

LDR	R1, [R0,#0x200]
LDR	R2, [conf_0x10001111]
ORR	R1, R1, R2
STR	R1, [R0,#0x200]
LDR	R1, [R0,#0x218]
MOV	R2, #0x1000000
ORR	R1, R1, R2
STR	R1, [R0,#0x218]
LDR	R1, [R0,#0x318]
MOV	R2, #0x30000000
MOV	R3, #0x7000
ORR	R1, R1, R2
BIC	R1, R1, R3
STR	R1, [R0,#0x318]
loc_402022A0:
LDR	R0, [conf_0xF1500000]
MOV	R1, #0
STR	R1, [R0]
MOV	R1, #0xFF
STR	R1, [R0,#0x804]
STR	R1, [R0,#0x810]
STR	R1, [R0,#0x81C]
LDR	R0, [conf_0xFAD00000]
STR	R1, [R0,#0x804]
STR	R1, [R0,#0x810]
STR	R1, [R0,#0x81C]
LDR	R0, [conf_0xE0600000]
STR	R1, [R0,#0x804]
STR	R1, [R0,#0x810]
STR	R1, [R0,#0x81C]
LDR	R0, [conf_0xE1C00000]
STR	R1, [R0,#0x804]
STR	R1, [R0,#0x810]
STR	R1, [R0,#0x81C]
MOV	PC, LR




configure_ram:
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


LDR	R0, [DMC1_REG]
LDR	R1, [conf_0xFFF1010]

	MOV	R0, 9999
	BL	int_debugprint

STR	R1, [R0]



LDR	R1, [conf_0x212100]
	MOV	R5, R0
	MOV	R0, 9999
	BL	int_debugprint
	MOV	R0, R5
STR	R1, [R0,#4]

	MOV	R0, 9999
	BL	int_debugprint
B	the_morning_after
FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables below
DEFAULT_VARIABLES
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

    pagetable		dw gMMUL1PageTable
    opcode		dw 0xE1A0F00E
    write_addr		dw 0x32000004
    read_addr		dw 0x32000004

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; strings at the end
DEFAULT_STRINGS_ADDR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; add custom strings addresses below (for using by LDR op)
    s_kernel_path_a  dw s_kernel_path
    s_sbl_path_a     dw s_sbl_path
    s_loadsbl_a      dw s_loadsbl
    s_loadkernel_a   dw s_loadkernel
    s_jumpingout_a   dw s_jumpingout
    s_kernelreloc_a  dw s_kernelreloc
    s_mmuoff_a	     dw s_mmuoff
    s_kernelreturn_a dw s_kernelreturn

DEFAULT_STRINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;add custom strings below
    s_kernel_path    du '/g/galaxyboot/zImage_return',0
    s_sbl_path	     du '/g/galaxyboot/Sbl_mijoma.bin',0

    s_loadsbl	     db ' Loading SBL',0
    s_loadkernel     db ' Loading kernel image to buf',0
    s_jumpingout     db ' Jumpout to 0x%X',0
    s_mmuoff	     db ' Turning off MMU',0
    s_kernelreloc    db ' Reloc kernel to 0x%X',0
    s_kernelreturn   db ' WTF KERNEL RETURNED',0


    
END
