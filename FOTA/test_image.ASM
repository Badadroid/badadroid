processor 0x2FFFFFE
coprocessor 0x30F8

align 4
org 0x32000000
ldr r0, [v_addr]
bx r0

v_addr dw 0x43800300 ;jump to somewhere in FOTA code
