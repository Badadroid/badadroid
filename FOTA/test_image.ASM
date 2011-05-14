processor 0x2FFFFFE
coprocessor 0x30F8

align 4
org 0x32000000

mov r1,512
ldr r0,[atag_addr]
ldr r3, [mem_dump_addr]
bx r3

mem_dump_addr dw 0x42482ab4
atag_addr     dw 0x30000100


