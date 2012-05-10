include 'inc/settings.inc'		; user dependend settings

START
   BL	 enable_uart_output ;I recommend to change it to uart output - saves battery ALOT ~Rebellos

   LDR	 R4, [reinit_bool]
   MOV	 R5, 0
   STR	 R5, [R4]

   MOV	 r1, #0
   LDR	   r0, [pagetable]
   BL	   MemMMUCacheEnable
   STR	 R0, [mmu_register] ;lets store previous MMU control register to turn it off later

   BL	 dloadmode
bootkernel_helper:
	code_len = bootkernel_helper - c_start
	db	0x1000 - code_len dup 0x00
bootkernel:	      ;0x43201000 on 2.0 new release ;0x43801000 on 8530JPKA1

   MOV	 R1, 4
   ADR	 R0, output_msg
   BL	 debug_print
   MOV	 R0, R1
   BL	 countdown
   B	 @f

   output_msg db " Toogling UART output in %ds",0
   kernel_crc db " Kernel CRC32 = 0x%X",0

ALIGN 4
   kernel_crc_a dw kernel_crc
@@:
   BL	 enable_uart_output

   ldr	 r0, [s_mmuoff_a]
   BL	 debug_print

   LDR	R8, [mmu_register]
   MCR	 p15, 0, R8,c1,c0 ;turn off MMUCache with previous gained MMU control reg
   BL	 _CoDisableMmu
   ldr	 r0, [s_done_a]
   BL	 debug_print
  ; BL    configure_ram
  BL		  DRV_Modem_BootingStart ;boot modem

   LDR	 R0, [ATAG_ptr]
   MOV	 R1, 0x00
   MOV	 R2, 512
   BL	 rebell_fillmem ;clear memory there


   LDR	 R2, [ATAG_ptr]
    ; I9000 SBL uses full ATAG_CORE struct (length 5 instead of 2) but short ATAG struct works aswell
    ; http://www.simtec.co.uk/products/SWLINUX/files/booting_article.html#ATAG_CORE
   MOV	 R0, 2
   STR	 R0, [R2]
   ADD	 R2, R2, 4
   LDR	 R0, [ATAG_CORE]
   STR	 R0, [R2]
   ADD	 R2, R2, 4

   ;giving some random serial number 0x123 0x456, probably doesnt matter at all
   MOV	 R0, 4
   STR	 R0, [R2]
   ADD	 R2, R2, 4
   LDR	 R0, [ATAG_SERIAL]
   STR	 R0, [R2]
   ADD	 R2, R2, 4
   MOV	 R0, 0x00008500
   STR	 R0, [R2]
   ADD	 R2, R2, 4
   MOV	 R0, 0x00008530
   STR	 R0, [R2]
   ADD	 R2, R2, 4

   ;passing hardcoded I9000 Sbl revision (0x30), we can get real chip_revision but I don't feel it necessary for now
   MOV	 R0, 3
   STR	 R0, [R2]
   ADD	 R2, R2, 4
   LDR	 R0, [ATAG_REVISION]
   STR	 R0, [R2]
   ADD	 R2, R2, 4
   MOV	 R0, 0x30
   STR	 R0, [R2]
   ADD	 R2, R2, 4


   LDR	 R0, [s_atagcmdline_a]
   BL	 rebell_strlen
   ADD	 R0, R0, 1  ;include zero-ending
   MOV	 R5, R0
   MOV	 R0, R5

   ADD	 R0, R0, 0xD
   MOV	 R0, R0,LSR#2
   STR	 R0, [R2] ;(sizeof(struct atag_header) + linelen + 1 + 4) >> 2  don't ask me why O.o
   ADD	 R2, R2, 4

   LDR	 R0, [ATAG_CMDLINE]
   STR	 R0, [R2]
   ADD	 R2, R2, 4

   MOV	 R6, R2
   LDR	 R0, [s_atagcmdline_a] ;src
   MOV	 R1, R2 	   ;dst
   MOV	 R2, R5 	   ;size
   BL	 rebell_memcpy
   MOV	 R2, R6
       ; SUB     R5, R5, 2
   ADD	 R2, R2, R5, LSL#2 ;add length of string*2 (mem is zeroed anyway)

   MOV	 R0, 0	 ;ATAG_NONE size
   STR	 R0, [R2]

   ADD	 R2, R2, 4
   MOV	 R0, 0	 ;ATAG_NONE
   STR	 R0, [R2] ;thats the whole ATAG struct
   ldr	 r0, [s_done_a]
   BL	 debug_print

   ldr	 r1, [kernel_start_a]
   ldr	 r0, [s_kernelreloc_a]
   BL	 debug_print

   BL	 relockernel
   ldr	 r0, [s_done_a]
   BL	 debug_print

   LDR	 R0, [SYSCON_NORMAL_CFG]
   LDR	 R1, [R0]
   LDR	 R4, [reinit_bool]
   LDR	 R4, [R4]
   CMP	 R4, 0
   BICNE   R1, R1, 0xBE ;turn off all power-managed S5PC110 blocks, this will reset LCD controller :)
   STR	 R1, [R0]
   MOV	 R1, 0xFFFFFFFF
   STR	 R1, [R0]    ;POWAH ON EVRYTHINKS (clock registers in all modules must be available for kernel)


   BL	 timer_driver
   BL	 configure_clocks
   BL	 _CoDisableDCache

   BL	 _System_DisableVIC
   BL	 _System_DisableIRQ
   BL	 _System_DisableFIQ


   LDR	 R0, [s_done_a]
   BL	 debug_print

   LDR	 R0, [kernel_start_a]
   LDR	 R1, [kernel_size_a]
   LDR	 R1, [R1]
   BL	 calc_crc32
   MOV	 R1, R0
   LDR	 R0, [kernel_crc_a]
   BL	 debug_print

   LDR	 R1, [kernel_start_a]
   LDR	 R0, [s_jumpingout_a]
   BL	 debug_print
   MOV	 R0, 0	   ;must be 0
   MOV	 R1, 0x891
   LDR	 R2, [ATAG_ptr]


   LDR	 R5, [kernel_start_a]
   BLX	 R5

   ldr	 r0, [s_kernelreturn_a]
   BL	 debug_print
   
;   BL    dloadmode
loop_forever:
   b	 loop_forever


relockernel:
   STMFD   SP!, {R0-R2,LR}

   LDR	 R0, [kernel_buf]
   LDR	 R1, [kernel_start_a]
   LDR	 R2, [kernel_size_a]
   LDR	 R2, [R2]
   BL	 rebell_memcpy

   LDMFD   SP!, {R0-R2,PC}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables below
DEFAULT_VARIABLES


   pagetable	       dw gMMUL1PageTable
   mmu_register 	  dw 0 ;runtime overwritten
   INTC_DMA_CLR 	  dw 0xB0601004
   INTC_ONENAND_CLR	  dw 0xB0601008

   SYSCON_NORMAL_CFG	  dw 0xE010C010


   ATAG_ptr		  dw 0x20000100 ;
   ATAG_CORE		  dw 0x54410001
   ATAG_SERIAL		  dw 0x54410006
   ATAG_REVISION	  dw 0x54410007
   ATAG_CMDLINE 	  dw 0x54410009


   VIC1 		  dw 0xF2100000
   VIC2 		  dw 0xF2200000
   VIC3 		  dw 0xF2300000
   def_0x3FF		  dw 0x3FF
   def_0x7FFF		  dw 0x7FFF
   EXT_INT_MASKS	  dw 0xE0200F00
   EXT_INT_CTRL 	  dw 0xE0200E00

   VIDINTCON0		  dw 0xF8000130
   VIDINTCON1		  dw 0xF8000134

   kernel_start_a	  dw 0x22000000
   kernel_buf		  dw 0x44000000
   reinit_bool		  dw 0x43FFFFFC
   kernel_size_a	  dw kernel_size





;;;;;;;;;;;;;;;;;;;;;;;;;;;;; strings at the end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; add custom strings addresses below (for using by LDR op)
   s_jumpingout_a	  dw s_jumpingout
   s_kernelreloc_a	  dw s_kernelreloc
   s_mmuoff_a		  dw s_mmuoff
   s_kernelreturn_a	  dw s_kernelreturn


DEFAULT_STRINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;add custom strings below
   s_kernelreloc	  db ' Reloc kernel to 0x%X',0
   s_jumpingout 	  db ' Jumpout to 0x%X',0
   s_mmuoff		  db ' Turning off MMU & configuring DMC',0
   s_kernelreturn	  db ' WTF KERNEL RETURNED',0
 
FUNCTIONS

kernel_size_helper:
   code_len = kernel_size_helper - c_start
   db	   0x4000 - code_len dup 0x00
kernel_size	       dw 0 ;should be overwritten during runtime 0x43204000 on 8530XXKK5 0x43804000 on 8530JPKA1

END
