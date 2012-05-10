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
tfs4_stat				 equ 0x420D0498
tfs4_opendir				 equ 0x420CE4A4
tfs4_closedir				 equ 0x420CE7A0
tfs4_readdir				 equ 0x420CECEC
tfs4_write				 equ 0x420CFA78
tfs4_get_errno				 equ 0x420D19E0
DloadResponse				 equ 0x42082978
DloadProcessPacket			 equ 0x420837A0
DloadMain				 equ 0x42083B84
DloadTransmite				 equ 0x4208265C
memcpy					 equ 0x42151664
Flash_Read_Data 			 equ 0x4208A528
OemSysGetSystemInfo			 equ 0x42092B10
OemSysSetSystemInfo			 equ 0x42092BA0
__SysSecBootReadNetLockInfoFromFlash	 equ 0x42091380
LCDTypeCheck				 equ 0x42080AE8
GPIO_Set_Config 			 equ 0x420B992C
GPIO_Get_Data				 equ 0x420B9A4C


; Variables
pressed_button				equ 0x421F53FC
gMMUL1PageTable 			equ 0x4229C000
x_pos@disp_FOTA_Printf_1		equ 0x421E1820
gLCDType				equ 0x4FF00064


g_bUartConnected equ 0x4219CD07

end if ; PRODUCT_CODE
