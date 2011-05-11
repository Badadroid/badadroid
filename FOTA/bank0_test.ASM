
include 'inc/S8530JPKA1.inc'	  ;here include the right BL function pointers, depends on model and BL you've got
include 'inc/macros_S8530.inc'	  ;model dependend FOTA header and footer

include 'inc/vars.inc'
include 'inc/functions.inc'

; VERY rough code for loading sbl to 0x40244000 and Kernel to 0x32000000, then executes KERNEL.
; Sbl is unused in this code
START
	;BL      CoDisableMmu

	;MOV     r1, #1
       ; LDR     r0, [pagetable]
       ; BL      MemMMUCacheEnable
	;MOV     R8, R0 ;lets store previous MMU control register to turn it off later

	;BL      System_EnableVIC
	;BL      System_DisableIRQ
	;BL      CoDisableL2Cache

	bl	enable_fota_output

	MRS	R0, CPSR
BIC	R0, R0, #0x1F
ORR	R0, R0, #0xD3
MSR	CPSR_cf, R0
MOV	R0, #0
MCR	p15, 0, R0,c8,c7
MCR	p15, 0, R0,c7,c5
MRC	p15, 0, R0,c1,c0
BIC	R0, R0, #0x2000
BIC	R0, R0, #7
ORR	R0, R0, #2
ORR	R0, R0, #0x800
MCR	p15, 0, R0,c1,c0



	MOV	R0, 2222
	BL	int_debugprint

	BL	testmembank
	BL	testmembank

	MOV	R0, 333
	BL	int_debugprint

	MRC	p15, 0, R0, c2, c0, 0
	BL	hex_debugprint

	MRC	p15, 0, R0, c2, c0, 1
	BL	hex_debugprint

	MRC	p15, 0, R0, c2, c0, 2
	BL	hex_debugprint

	MOV	R0, 4444
	BL	int_debugprint
	MRC	p15, 0, R0, c10, c2, 0 ; Read Primary Region Remap Register
	BL	hex_debugprint
	MRC	p15, 0, R0, c10, c2, 1 ; Read Normal Region Remap Register
	BL	hex_debugprint

	MOV	R0, 0
	MCR	p15, 0, R0, c10, c2, 0
	MCR	p15, 0, R0, c10, c2, 1


	MOV	R0, 5555
	BL	int_debugprint
	MRC	p15, 0, R0, c10, c2, 0
	BL	hex_debugprint

	MRC	p15, 0, R0, c10, c2, 1
	BL	hex_debugprint


	LDR	R0, [read_addr]
	BL	hex_debugprint

	MCR	p15, 0, R0, c8, c7, 1 ; Invalidate Inst-TLB and Data-TLB entry (MVA

	MCR	p15,0,R0,c7,c8,3 ; Write VA to Other State Privileged Write VA to PA Translation Register
				 ; Performs VA to PA translation for Non-secure security state
	MRC	p15,0,R0,c7,c4,0 ; Read PA from Physical Address Register
	BL	hex_debugprint

	;ADR     R1, read_addr
	;STR     R0, [R1]

	MOV	R0, 1111
	BL	int_debugprint

	LDR	R0, [read_addr]
	MCR p15, 0, R0, c8, c7, 1 ; Invalidate Inst-TLB and Data-TLB entry (MVA)

	BL	testmembank


	;BL      testmembank

	MOV	R0, 1234
	BL	int_debugprint

	;BL      testmembank

	MOV	R0, 1234
	BL	int_debugprint


	BL	System_DisableVIC
	BL	System_EnableIRQ

	BL	dloadmode

testmembank:
	STMFD	SP!, {R0-R1,LR}

semafor:
	;BL      Get_Onedram_Semaphore
	;CMP     R0, #0
       ; BEQ     semafor
	LDR	R0, [read_addr]
	LDR	R0, [R0]
	BL	hex_debugprint

	LDR	R0, [opcode]
	LDR	R1, [write_addr]
	STR	R0, [R1]

	LDR	R0, [read_addr]
	LDR	R0, [R0]
	BL	hex_debugprint
	;BL      Onedram_Release_Semaphore
	LDMFD	SP!, {R0-R1,PC}
FUNCTIONS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables below
DEFAULT_VARIABLES
    pagetable		dw gMMUL1PageTable
    opcode		dw 0xE1A0F00E
    translate_test	dw 0x123
    write_addr		dw 0x32000000
    read_addr		dw 0x32000000
    semaphore		dw 0x25FFF800

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
