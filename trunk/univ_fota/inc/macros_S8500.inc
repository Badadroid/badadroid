; Macros

macro NORETURN
{
___NORETURN:
   b	___NORETURN
}

macro START
{
   format binary as 'fota'

   processor 0x2FFFFFE
   coprocessor 0x30F8

   org 0x43800000
   align 4

c_start:

   mov   r9, lr ; save the return address
   ldr   r0, [_shadowed_bl_addr]
   ldr   r1, [_bl_size]
   bl    calc_crc32
   ;find matching bootloader pointers
   mov   r2, #0
   ldr   r1, [BL_crc_ptr]
   
bl_crc_loop:
   ldr   r3, [r1]
   cmp   r3, #0   ;finished?
   beq   no_match
   cmp   r0, r3
   beq   crc_match
   add   r1, r1, #bl_abs_st_len
   b     bl_crc_loop
no_match:
   bx    r9 ;return to bootloader
   
crc_match:
   ;copy pointers
   mov r0, #0
   ldr r2, [BL_abs_ptr]
   
crc_copy_loop:
   ldr r3, [r1]
   str r3, [r2]
   add r1, r1, 4
   add r2, r2, 4
   add r0, r0, 4
   cmp r0, #bl_abs_st_len
   bcc crc_copy_loop
         
   ldr      r0, [button_pressed]
   ldrb     r0, [r0, 2]   ; CALL key
   cmp      r0, 0
   bne      c_run

   bx       r9      ; back to the bootloader

_shadowed_bl_addr    dw    0x42480000
_bl_size             dw    0x180000


f_ver:
   db 0x100 - (f_ver-c_start) dup 0
   db 'FOTA_ENGINE_VER_INFO_2.0'
   db 232 dup 0
   
align 4
c_run:
}

macro END
{
magic_1:
   code_len = magic_1 - c_start
   db 0x280000 - code_len dup 0xFF
   db 'BPDZ'
   db 12 dup 0
   dw 0xABCDABCD
   dw 0x0C600000
   dw 0
   db 'S8500'
   db 27 dup 0
   db 'fota'
   dw 0
   dw 6
   dw 1
   dw 2
   dw 0x800
   dw 0x20000

magic_2:
   code_len = magic_2 - c_start
   db 0x280410 - code_len dup 0
}
