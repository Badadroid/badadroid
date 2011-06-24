macro BL_CRC_TABLE
{
align 4
BL_crc_ptr dw crc_ptrs
crc_ptrs:
   include 'inc/crcS8500DDJE7.inc'
   include 'inc/crcS8500JVKC1.inc'
   include 'inc/crcS8500XXJD9.inc'
   include 'inc/crcS8500XXJEE.inc'
   include 'inc/crcS8500XXJID.inc'
   include 'inc/crcS8500XXJF1.inc'
   include 'inc/crcS8500XXJF4.inc'
   include 'inc/crcS8500XXJH2.inc'
   include 'inc/crcS8500XXJH3.inc'
   include 'inc/crcS8500XXJI3.inc'
   include 'inc/crcS8500XXJL2_DEC.inc'
   include 'inc/crcS8500XXJL2_MAR.inc'
dw 0 ;end marker
}

macro BL_ABSTRACT_POINTERS
{
align 4
bl_abs_st:

   crc_value                 dw 0 
   v_MemMMUCacheEnable       dw 0
   v___PfsNandInit           dw 0
   v___PfsMassInit           dw 0
   v_tfs4_stat               dw 0
   v_tfs4_open               dw 0
   v_tfs4_read               dw 0
   v_tfs4_close              dw 0
   v_EdbgOutputDebugString   dw 0
   button_pressed            dw 0
   gMMUL1PageTable           dw 0

bl_abs_st_end:
BL_abs_ptr dw bl_abs_st
bl_abs_st_len = bl_abs_st_end - bl_abs_st
}

macro BL_STUB_TABLE
{
   align 4
   MemMMUCacheEnable:      ldr pc, [v_MemMMUCacheEnable]
   __PfsNandInit:          ldr pc, [v___PfsNandInit]
   __PfsMassInit:          ldr pc, [v___PfsMassInit]
   tfs4_stat:              ldr pc, [v_tfs4_stat]
   tfs4_open:              ldr pc, [v_tfs4_open]
   tfs4_read:              ldr pc, [v_tfs4_read]
   tfs4_close:             ldr pc, [v_tfs4_close]
   EdbgOutputDebugString:  ldr pc, [v_EdbgOutputDebugString]
}
