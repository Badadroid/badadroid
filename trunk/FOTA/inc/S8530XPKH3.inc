if ~defined PRODUCT_CODE
PRODUCT_CODE                                                    equ 'S8530'
FIRMWARE_VER                                                    equ 2.0

BUF1_DRAM_START                                                 equ 0x40000000
BL2_DRAM_START                                                  equ 0x42000000
BL3_DRAM_START                                                  equ 0x42080000
FOTA_DRAM_START                                                 equ 0x43400000
BUF2_DRAM_START                                                 equ 0x43700000
BSHI_DRAM_START                                                 equ 0x4FF00000
FOTA_NAND_START                                                 equ 0x09500000

; Functions
StartUp                                                         equ 0x42080000


end if ; PRODUCT_CODE
