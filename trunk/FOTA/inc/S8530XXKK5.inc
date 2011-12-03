if ~defined PRODUCT_CODE
PRODUCT_CODE							equ 'S8530'
FIRMWARE_VER							equ 2.0

BL2_DRAM_START							equ 0x42000000
BL3_DRAM_START							equ 0x42080000
FOTA_DRAM_START 						equ 0x43200000
FOTA_BUFFER							equ 0x43500000
FOTA_NAND_START 						equ 0x09500000


; Functions

EdbgOutputDebugString			 equ 0x42082028
EdbgOutputDebugStringA			 equ 0x42081CF4
LaunchNucleus				 equ 0x420896FC
MemMMUCacheEnable			 equ 0x42089298
PWM_Drv_Delay				 equ 0x420B9884
__PfsMassInit				 equ 0x420A9398
__PfsNandInit				 equ 0x420A94E8
disp_FOTA_Init				 equ 0x420AFE08
disp_FOTA_Printf			 equ 0x420AFE3C
disp_dimming_backlight			 equ 0x420AF2A0
maxim_charging_control			 equ 0x420DA124
tfs4_close				 equ 0x420CF504
tfs4_open				 equ 0x420CF390
tfs4_read				 equ 0x420CF8C0
tfs4_stat				 equ 0x420CEBE4
DloadMain				 equ 0x42083B84

; Variables
pressed_button				equ 0x421F53FC
gMMUL1PageTable 			equ 0x4229C000
x_pos@disp_FOTA_Printf_1		equ 0x421E1820

end if ; PRODUCT_CODE
