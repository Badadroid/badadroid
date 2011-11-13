if ~defined PRODUCT_CODE
PRODUCT_CODE                                                    equ 'S8530'
FIRMWARE_VER                                                    equ 2.0

BL2_DRAM_START                                                  equ 0x42000000
BL3_DRAM_START                                                  equ 0x42080000
FOTA_DRAM_START                                                 equ 0x47200000
FOTA_BUFFER                                                     equ 0x47500000
FOTA_NAND_START                                                 equ 0x09500000


; Functions
StartUp                                                         equ 0x42080000


end if ; PRODUCT_CODE
