 ;
 ; This file is part of Badadroid project.
 ;
 ; Copyright (C) 2012 Rebellos, mijoma, b_kubica
 ;
 ;
 ; Badadroid is free software: you can redistribute it and/or modify
 ; it under the terms of the GNU General Public License as published by
 ; the Free Software Foundation, either version 3 of the License, or
 ; (at your option) any later version.
 ;
 ; Badadroid is distributed in the hope that it will be useful,
 ; but WITHOUT ANY WARRANTY; without even the implied warranty of
 ; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ; GNU General Public License for more details.
 ;
 ; You should have received a copy of the GNU General Public License
 ; along with Badadroid.  If not, see <http://www.gnu.org/licenses/>.
 ;
 ;
 
include 'inc/settings.inc'		; user dependend settings


START


  B	bootkernel

bootkernel_helper:
	code_len = bootkernel_helper - c_start
	db	0x1000 - code_len dup 0x00
bootkernel:	      ;0x43201000 on 2.0 new release ;0x43801000 on 8530JPKA1

   SUB	 SP, SP, 128
   MOV	 r1, #1
   LDR	   r0, [pagetable]
   BL	   MemMMUCacheEnable
   MOV	 R8, R0 ;lets store previous MMU control register to turn it off later

   bl	enable_output

   LDR	R0, [used_download]
   CMP	R0, 0
   BNE	code_loaded

   BL	 __PfsNandInit
   BL	 __PfsMassInit



   MOV	 R1, SP
   LDR	 R0, [s_kernel_path_a]
   BL	 tfs4_stat
   BL	 hex_debugprint
   LDR	 R2, [SP,0xC] ;get kernel size
   LDR	 R0, [kernel_size_a]
   STR	 R2, [R0]   ;store for later use
   LDR	 R0, [R0]
   BL	 hex_debugprint

   ldr	 r0, [s_loadkernel_a]
   BL	 debug_print
   LDR	 R2, [kernel_size_a]
   LDR	 R2, [R2]
   LDR	 R1, [kernel_buf]
   LDR	 R0, [s_kernel_path_a]
   BL	 loadfile
   ldr	 r0, [s_done_a]
   BL	 debug_print



code_loaded:
   ldr	 r0, [s_mmuoff_a]
   BL	 debug_print

   MCR	 p15, 0, R8,c1,c0 ;turn off MMUCache with previous gained MMU control reg
   BL	 _CoDisableMmu
   ldr	 r0, [s_done_a]
   BL	 debug_print
 ;  BL    configure_ram

   ldr	 r0, [s_modemboot_a]
   BL	 debug_print
   BL	 DRV_Modem_BootingStart
   ldr	 r0, [s_done_a]
   BL	 debug_print

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

   ;giving some random serial number 0x123 0x456
   MOV	 R0, 4
   STR	 R0, [R2]
   ADD	 R2, R2, 4
   LDR	 R0, [ATAG_SERIAL]
   STR	 R0, [R2]
   ADD	 R2, R2, 4
   MOV	 R0, 0x00000123
   STR	 R0, [R2]
   ADD	 R2, R2, 4
   MOV	 R0, 0x00000456
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
;   BIC   R1, R1, 0xBE ;turn off all power-managed S5PC110 blocks, this will reset LCD controller :)
   STR	 R1, [R0]
   MOV	 R1, 0xFFFFFFFF
   STR	 R1, [R0]    ;POWAH ON EVRYTHINKS (clock registers in all modules must be available for kernel)


;   BL    timer_driver
;   BL    configure_clocks
   BL	 _CoDisableDCache

   BL	 _System_DisableVIC
   BL	 _System_DisableIRQ
   BL	 _System_DisableFIQ

   LDR	 R0, [s_bootingkernel_a]
   BL	 debug_print

   LDR	 R1, [kernel_start_a]
   LDR	 R0, [s_jumpingout_a]
   BL	 debug_print
   MOV	 R0, 0	   ;must be 0
   LDR	 R1, [mach_id] ;load 8500 or 8530, depending on the model which for FOTA is compiled
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
   kernel_size_a	  dw kernel_size
  ; kernel_size            dw 0 ;overwritten during runtime

   framebuffer_ptr	  dw 0x403EC00C ;0x4EC00000
   framebuffer_size	  dw 0x5DBFF






;;;;;;;;;;;;;;;;;;;;;;;;;;;;; strings at the end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; add custom strings addresses below (for using by LDR op)
   s_kernel_path_a	  dw s_kernel_path
   s_loadkernel_a	  dw s_loadkernel
   s_bootingkernel_a	  dw s_bootingkernel
   s_jumpingout_a	  dw s_jumpingout
   s_kernelreloc_a	  dw s_kernelreloc
   s_mmuoff_a		  dw s_mmuoff
   s_modemboot_a	  dw s_modemboot
   s_kernelreturn_a	  dw s_kernelreturn


DEFAULT_STRINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;add custom strings below
   s_kernel_path	  du '/g/zImage',0
   s_kernelreloc	  db ' Reloc kernel to 0x%X',0
   s_loadkernel 	  db ' Loading kernel image to buf',0
   s_bootingkernel	  db ' Booting kernel...',0
   s_jumpingout 	  db ' Jumpout to 0x%X',0
   s_mmuoff		  db ' Turning off MMU...',0
   s_modemboot		  db ' Booting up modem...',0
   s_kernelreturn	  db ' WTF KERNEL RETURNED',0
 
FUNCTIONS

kernel_size_helper:
   code_len = kernel_size_helper - c_start
   db	   0x4000 - code_len dup 0x00
kernel_size	       dw 0 ;should be overwritten during runtime 0x43204000 on 8530XXKK5 0x43804000 on 8530JPKA1

END
