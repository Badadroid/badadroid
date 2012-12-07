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
 
if ~defined PRODUCT_CODE
PRODUCT_CODE                                                    equ 'S8500'
MACH_ID															equ 8500
FIRMWARE_VER                                                    equ 1.2

BL2_DRAM_START                                                  equ 0x42400000
BL3_DRAM_START                                                  equ 0x42480000
FOTA_DRAM_START                                                 equ 0x43800000
FOTA_BUFFER                                                     equ 0x43B00000
FOTA_NAND_START                                                 equ 0x0C600000


; Functions
StartUp                                                         equ 0x42480000
ResetHandler                                                    equ 0x42480020
StartUp_end                                                     equ 0x424800A4
SvcStackEnd                                                     equ 0x424800C8
CoStartL2Cache                                                  equ 0x424800D0
SpinForever                                                     equ 0x42480120
memset_main                                                     equ 0x42480134
memcmp_main                                                     equ 0x42480170
memcpy8                                                         equ 0x424801E4
Delay                                                           equ 0x42480234
InitializeDisplay                                               equ 0x42480274
OneNAND_Init                                                    equ 0x424802E4
DMCLock                                                         equ 0x42480354
KEYPAD_Drv_InitPort                                             equ 0x4248051C
KEYPAD_Drv_COL                                                  equ 0x424805B4
KEYPAD_Drv_ROW                                                  equ 0x424805D4
BootKeyCheck                                                    equ 0x42480630
BootFPMKeyCheck                                                 equ 0x42480724
BOOTFPMFlagClear                                                equ 0x424807C4
BootDebugKeyCheck                                               equ 0x424807E4
BootDownLoadKeyCheck                                            equ 0x4248083C
BootKeyPressCheck                                               equ 0x424808D0
BootSWCheck                                                     equ 0x424809D8
BootHWCheck                                                     equ 0x424809F8
USBSwitch                                                       equ 0x42480CF0
UARTSwitch                                                      equ 0x42480D38
boot_hw_power_down                                              equ 0x42480D9C
SelectBootingMode                                               equ 0x42480DBC
__main                                                          equ 0x42481234
Boot_CPSide_Upload_Setting                                      equ 0x424815EC
Boot_CPSide_HW_Version_Setting                                  equ 0x42481634
System_EnableVIC                                                equ 0x42481670
System_EnableVIC_end                                            equ 0x42481680
System_EnableIRQ                                                equ 0x42481690
System_EnableIRQ_end                                            equ 0x424816A0
System_EnableFIQ                                                equ 0x424816B0
System_EnableFIQ_end                                            equ 0x424816C0
System_EnableBP                                                 equ 0x424816D0
System_EnableBP_end                                             equ 0x424816E0
System_EnableICache                                             equ 0x424816F0
System_WaitForInterrupt                                         equ 0x42481700
System_WaitForInterrupt_end                                     equ 0x42481710
BootDebugBuffGet                                                equ 0x4248171C
BootDebugBuffNandWrite                                          equ 0x42481724
OEMInitDebugSerial                                              equ 0x424819AC
EdbgOutputDebugStringA                                          equ 0x42481DBC
EdbgOutputDebugString                                           equ 0x424820A0
InitializeInterrupt                                             equ 0x42482568
DloadMain                                                       equ 0x42483BD4
Get_Onedram_Semaphore                                           equ 0x42483FFC
Onedram_Release_Semaphore                                       equ 0x4248400C
UploadMain                                                      equ 0x42484A2C
OTGDEV_SetSoftDisconnect                                        equ 0x424868A0
MemMMUCacheEnable                                               equ 0x424892AC
LaunchNucleus                                                   equ 0x4248971C
Flash_Init                                                      equ 0x4248A174
Flash_Read_Data                                                 equ 0x4248A71C
Flash_Unlock                                                    equ 0x4248B5E0
OemCheckHomeDLFlag                                              equ 0x4248E970
OemDisableHomeDLFlag                                            equ 0x4248EA94
__Tfs4PdevMoviInitEx                                            equ 0x4249ECA0
__PfsMassInit                                                   equ 0x424A0AD0
__PfsNandInit                                                   equ 0x424A0BE4
Fota_check                                                      equ 0x424A3B10
FotaMemcmp                                                      equ 0x424A6BA8
Fota_get_version                                                equ 0x424A6BEC
GetBuildInfoRegionOffset                                        equ 0x424A6C08
Fota_check                                                      equ 0x424A6C84
Fota_Init_FS                                                    equ 0x424A70D0
Fota_Load_Delta_File                                            equ 0x424A70F0
Fota_Check_Delta_Exist_File                                     equ 0x424A71CC
disp_dimming_backlight                                          equ 0x424A7248
disp_Main_Clean                                                 equ 0x424A7264
disp_Main_Clean_All                                             equ 0x424A729C
disp_Main_Update                                                equ 0x424A72C8
disp_Main_Dload_DisplayFirst                                    equ 0x424A7384
disp_Main_Dload_Message                                         equ 0x424A76E0
disp_Normal_Init                                                equ 0x424A7A28
disp_Dload_Init                                                 equ 0x424A7A74
disp_Upload_Init                                                equ 0x424A7AD8
disp_Dload_User_Init                                            equ 0x424A7B3C
disp_FOTA_Init                                                  equ 0x424A7D88
disp_FOTA_Printf                                                equ 0x424A7DBC
SDHC_Init                                                       equ 0x424A8F80
SDHC_Open                                                       equ 0x424A91D8
SDHC_Close                                                      equ 0x424A936C
SDHC_Read                                                       equ 0x424A94C8
SDHC_Read_Noncacheable                                          equ 0x424A95FC
SDHC_Write                                                      equ 0x424A96B4
SDHC_Write_Noncacheable                                         equ 0x424A97F0
SDHC_GetCardInformation                                         equ 0x424A98A8
SDHC_IsOpened                                                   equ 0x424A9950
SDHC_is_existing                                                equ 0x424A9958
j___rt_memcpy                                                   equ 0x424A9A58
SysCon_Drv_Get_kHz                                              equ 0x424B0CD4
SysCon_Drv_PSHOLD_Control                                       equ 0x424B1980
Sycon_Power_off_exceptLCD                                       equ 0x424B19F8
Sycon_ARMCLK_Change                                             equ 0x424B1A08
PWM_Drv_Delay                                                   equ 0x424B1B88
GPIO_Set_Config                                                 equ 0x424B1C30
GPIO_Set_Data                                                   equ 0x424B1CD0
GPIO_Get_Data                                                   equ 0x424B1D78
GPIO_Set_Pud                                                    equ 0x424B1E48
GPIO_Drv_UnsetExtInterrupt                                      equ 0x424B35CC
GPIO_Drv_InitExtInterrupt                                       equ 0x424B3C5C
ScatterMemcpy                                                   equ 0x424B3E10
ScatterMemset                                                   equ 0x424B3E34
set_chiprev                                                     equ 0x424B3EB4
FIMD_Drv_InitWin                                                equ 0x424B4A88
FIMD_Drv_INITIALIZE                                             equ 0x424B607C
FIMD_Drv_SetWinOnOff                                            equ 0x424B6C38
tfs4_init                                                       equ 0x424C2CE4
tfs4_mount                                                      equ 0x424C3A1C
tfs4_open                                                       equ 0x424C76F0
tfs4_close                                                      equ 0x424C7864
tfs4_read                                                       equ 0x424C7C20
tfs4_get_errno                                                  equ 0x424C9D40
FSA9480_Get_DEV_TYP2                                            equ 0x424CC3CC
FSA9480_Get_JIG_Status                                          equ 0x424CC3D8
FSA9480_Get_FPM_Status                                          equ 0x424CC404
FSA9480_Get_ADC_Status                                          equ 0x424CC494
FSA9480_Enable_CP_USB                                           equ 0x424CC66C
FSA9480_ResetDevice                                             equ 0x424CC71C
SetFSA9480                                                      equ 0x424CC7F8
BootShared_BootInit                                             equ 0x424CCA40
BootShared_GetPowerOn                                           equ 0x424CCA8C
BootShared_GetPowerOnAddr                                       equ 0x424CCAAC
BootShared_SavePowerOnStatus                                    equ 0x424CCAB4
HW_Get_Reset_status                                             equ 0x424CCB0C
DRV_Modem_BootingStart                                          equ 0x424CD2D4
Set_MAX8998_WTSR_Ctrl                                           equ 0x424D01E0
MAX8998_PM_init                                                 equ 0x424D026C
maxim_chg_status                                                equ 0x424D0600
maxim_jig_status                                                equ 0x424D0654
maxim_pwr_key_status                                            equ 0x424D06A8
max8998_poweron_reason                                          equ 0x424D06FC
maxim_charging_control                                          equ 0x424D0788
maxim_power_off                                                 equ 0x424D0944
maxim_detbat_status_check                                       equ 0x424D09E8
maxim_usb_ldo_control                                           equ 0x424D0A50
__rt_memclr_w                                                   equ 0x425455D0
__rt_memcpy                                                     equ 0x42545624
__aeabi_uidivmod                                                equ 0x425469D4
CoEnableL2Cache                                                 equ 0x42546B38
CoDisableL2Cache                                                equ 0x42546B48
CoInvalidateDCacheIndex                                         equ 0x42546BC8
CoSetL2CacheAuxCrtlReg                                          equ 0x42546C68
_fota_via_r0                                                    equ 0x42580048


; Variables
boot_mode                                                       equ 0x4258004C
hwrev                                                           equ 0x4258004D
g_bUartConnected                                                equ 0x4258004E
pmic_mr_reset                                                   equ 0x42580050
g_DloaDebug                                                     equ 0x42580094
UserDLImagePtr                                                  equ 0x425C3D44
pressed_button                                                  equ 0x425C5A30
gMMUL1PageTable                                                 equ 0x42664000


;Strings
spaces                                                          equ 0x424A6EF4
exlamations                                                     equ 0x424A6F14
sDownloadMode                                                   equ 0x424A7C34



;get_usb_sw_nv                                                  equ 0x424896E0
;get_uart_sw_nv                                                 equ 0x42489694
;strlen                                                         equ 0x42545818
;strcpy                                                         equ 0x4254570C
;CoDisableDCache                                                equ 0x42546AB8
;CoDisableIrq                                                   equ 0x42546A0C
;CoDisableFiq                                                   equ 0x42546A2C
;CoDisableMmu                                                   equ 0x42546AF8

end if ; PRODUCT_CODE
