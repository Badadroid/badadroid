if ~defined INCLUDED_MODEL
INCLUDED_MODEL                            equ S8530v2

; FOTA execution address
FOTA_START                                equ 0x43000000


; Functions
StartUp                                   equ 0x42080000


end if ; INCLUDED_MODEL
