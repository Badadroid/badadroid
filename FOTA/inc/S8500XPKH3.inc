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
PRODUCT_CODE                                                equ 'S8500'
FIRMWARE_VER                                                equ 2.0

BL2_DRAM_START                                              equ 0x42000000
BL3_DRAM_START                                              equ 0x42080000
FOTA_DRAM_START                                             equ 0x47200000
FOTA_BUFFER                                                 equ 0x47500000
FOTA_NAND_START                                             equ 0x03300000


; Functions
StartUp                                                     equ 0x42080000
UndefEntry                                                  equ 0x42080004
SwiEntry                                                    equ 0x42080008
IAbortEntry                                                 equ 0x4208000C
DAbortEntry                                                 equ 0x42080010
IrqEntry                                                    equ 0x42080018
FiqEntry                                                    equ 0x4208001C
ResetHandler                                                equ 0x42080020
StartUp_end                                                 equ 0x420800A4
SpinForever                                                 equ 0x42080120
PlatformInit                                                equ 0x4208043C
BootKeyCheck                                                equ 0x42080630
BootFPMKeyCheck                                             equ 0x42080724
BOOTFPMFlagClear                                            equ 0x420807C4
BootDebugKeyCheck                                           equ 0x420807E4
BootDownLoadKeyCheck                                        equ 0x4208083C
BootKeyPressCheck                                           equ 0x420808D0
BootSWCheck                                                 equ 0x420809D8
BootHWCheck                                                 equ 0x420809F8
USBSwitch                                                   equ 0x42080CF0
UARTSwitch                                                  equ 0x42080D38
boot_hw_power_down                                          equ 0x42080D9C
SelectBootingMode                                           equ 0x42080DBC
__main                                                      equ 0x42081234
Boot_CPSide_Upload_Setting                                  equ 0x420815DC
Boot_CPSide_HW_Version_Setting                              equ 0x42081630
System_EnableVIC                                            equ 0x42081668
System_EnableVIC_end                                        equ 0x42081678
System_EnableIRQ                                            equ 0x42081688
System_EnableIRQ_end                                        equ 0x42081698
System_EnableFIQ                                            equ 0x420816A8
System_EnableFIQ_end                                        equ 0x420816B8
System_EnableBP                                             equ 0x420816C8
System_EnableBP_end                                         equ 0x420816D8
System_EnableICache                                         equ 0x420816E8
System_WaitForInterrupt                                     equ 0x420816F8
System_WaitForInterrupt_end                                 equ 0x42081708
System_SetExceptionVectorBase_end                           equ 0x42081710
BootDebugBuffGet                                            equ 0x42081714
BootDebugBuffNandWrite                                      equ 0x4208171C
BootDebugBuffWriteByte                                      equ 0x4208187C
BootDebugBuffError                                          equ 0x420818D0
OEMInitDebugSerial                                          equ 0x420819A4
OEMWriteDebugByte                                           equ 0x42081ACC
OEMReadDebugByte                                            equ 0x42081B14
printchar                                                   equ 0x42081B50
prints                                                      equ 0x42081BA4
printi                                                      equ 0x42081C6C
EdbgOutputDebugStringA                                      equ 0x42081DB4
EdbgOutputDebugString                                       equ 0x420820E8
VIC_InterruptEnable                                         equ 0x420823F0
VIC_InterruptDisable                                        equ 0x42082450
VIC_ClearVectAddr                                           equ 0x420824B0
VIC_InitializeVectTable                                     equ 0x420824E8
InitializeInterrupt                                         equ 0x42082560
C_IsrHandler                                                equ 0x4208268C
BOOT_Register_ISR                                           equ 0x420826D8
DloadTransmite                                              equ 0x4208271C
DloadCmdUSBDebug                                            equ 0x42082A04
DloadResponse                                               equ 0x42082A38
DloadInit                                                   equ 0x42082AB8
DloadReceive                                                equ 0x42082C10
DloadCmdUSBUnlock                                           equ 0x42082FC4
DloadCmdUSBDefault                                          equ 0x42082FD8
DloadCmdUSBLock                                             equ 0x42082FEC
DloadCmdUSBWrite                                            equ 0x42083004
DloadCmdUSBWriteCSC                                         equ 0x42083290
DloadCmdUSBWritePFS                                         equ 0x4208330C
DloadCmdUSBErase                                            equ 0x42083384
DloadCmdUSBFormat                                           equ 0x42083470
DloadCmdUSBDump                                             equ 0x4208348C
DloadCmdUSBReset                                            equ 0x4208351C
DloadCmdUSBSecurity                                         equ 0x420835D0
DloadCmdUSDownloadUnlock                                    equ 0x420837D0
DloadCmdUSBInfo                                             equ 0x420837E4
DloadCmdUSBSetDbgLvl                                        equ 0x42083800
DloadCmdUSBFulldownload                                     equ 0x4208384C
DloadProcessPacket                                          equ 0x42083860
DloadMain                                                   equ 0x42083C44
Get_Onedram_Semaphore                                       equ 0x4208406C
Onedram_Release_Semaphore                                   equ 0x4208407C
UploadMain                                                  equ 0x42084A80
InitializeUSB                                               equ 0x42086530
OTGDEV_SetSoftDisconnect                                    equ 0x420868FC
version_check                                               equ 0x4208693C
security_check                                              equ 0x42086A80
dload_nand_write                                            equ 0x420879A8
DrawProgressBarBeforeNonPagingCodeCopy                      equ 0x4208911C
LoadCompSegments                                            equ 0x420891F8
MemMMUCacheEnable                                           equ 0x42089330
UsbBoot_set_debug_level                                     equ 0x42089678
get_uart_sw_nv                                              equ 0x42089704
get_usb_sw_nv                                               equ 0x42089750
LaunchNucleus                                               equ 0x4208978C
Flash_Erase                                                 equ 0x4208A950
Flash_Init                                                  equ 0x4208A9D8
Flash_Read_Data                                             equ 0x4208AF80
Flash_Write_Data                                            equ 0x4208BA90
SecBootAssert                                               equ 0x4208F4BC
OemCheckHomeDLFlag                                          equ 0x4208FA8C
SysSecBootAcquireMutex                                      equ 0x4208FC58
__SysSecBootEraseRawSecureData                              equ 0x420900A0
__SysSecBootGet4thPhaseFixedKey                             equ 0x4209014C
__SysSecBootGet3rdPhaseFixedKey                             equ 0x42090390
__SysSecBootReadRawSecureData                               equ 0x420903F0
__SysSecBootReadSecureData                                  equ 0x42090578
SysSecBootInit                                              equ 0x42094450
SeedEncrypt                                                 equ 0x420A1914
SeedDecrypt                                                 equ 0x420A2744
_BmSetSegmentPageMode                                       equ 0x420A4C58
_BmSetSegmentCompType                                       equ 0x420A4C98
_BmSetReadFunctionForLoader                                 equ 0x420A4CAC
_BmGetELFHeader                                             equ 0x420A4D08
_BmGetSegmentInfos                                          equ 0x420A4D4C
_BmLoadSegmentsToMem                                        equ 0x420A4E3C
_BmGetSegmentInfoByVAddr                                    equ 0x420A4E84
PfsParser                                                   equ 0x420AA3E0
PfsSetFileInsertOnly                                        equ 0x420AAAF8

memcpy                                                      equ 0x421502D0
__rt_memcpy                                                 equ 0x421503C0
__PfsCheckSupport                                           equ 0x420AA3D8
__PfsHeaderParser                                           equ 0x420AA284
__PfsNandInit                                               equ 0x420AA144
__PfsMassInit                                               equ 0x420AA030
tfs4_open                                                   equ 0x420CFF78
tfs4_close                                                  equ 0x420D00EC
_DestroyOpenDirAll                                          equ 0x420D021C
_FsCloseAll                                                 equ 0x420D0360
tfs4_closeall                                               equ 0x420D03B0
_FsReadFile                                                 equ 0x420D0434
tfs4_read                                                   equ 0x420D04A8
_FsWriteFile                                                equ 0x420D05EC
tfs4_write                                                  equ 0x420D0660
tfs4_get_errno                                              equ 0x420D25C8
tfs4_opendir                                                equ 0x420CF08C
tfs4_readdir                                                equ 0x420CF8D4
tfs4_closedir                                               equ 0x420CF388
x_pos@disp_FOTA_Printf_1                                    equ 0x421E06D8


QuramMduceBReadDataEx                                       equ 0x420AF06C
QuramMduceBReadData                                         equ 0x420AF0D0
QuramMduceBSleep                                            equ 0x420AF2CC
FotaMemcmp                                                  equ 0x420AFA30
Fota_get_version                                            equ 0x420AFA74
GetBuildInfoRegionOffset                                    equ 0x420AFA90
Fota_check                                                  equ 0x420AFB0C
disp_dimming_backlight                                      equ 0x420AFEC8
disp_Main_Clean                                             equ 0x420AFEE4
disp_Main_Clean_All                                         equ 0x420AFF1C
disp_Main_Update                                            equ 0x420AFF48
disp_Normal_Init                                            equ 0x420B0690
disp_Dload_Init                                             equ 0x420B06DC
disp_Upload_Init                                            equ 0x420B077C
disp_Dload_User_Init                                        equ 0x420B07E0
disp_Dload_Fail_Init                                        equ 0x420B0804
disp_LPM_Init                                               equ 0x420B0828
disp_FPM_Init                                               equ 0x420B0984
disp_FOTA_Init                                              equ 0x420B0A20
disp_FOTA_Printf                                            equ 0x420B0A54
SysCon_Drv_PowerOn                                          equ 0x420B91A4
SysCon_Drv_Get_kHz                                          equ 0x420B9544
SysCon_Drv_PSHOLD_Control                                   equ 0x420BA1F0
Sycon_Power_off_exceptLCD                                   equ 0x420BA268
Sycon_ARMCLK_Change                                         equ 0x420BA278
PWM_Drv_Delay                                               equ 0x420BA46C
GPIO_Set_Config                                             equ 0x420BA514
GPIO_Set_Data                                               equ 0x420BA5A0
GPIO_Get_Data                                               equ 0x420BA634
GPIO_Set_PudPdn                                             equ 0x420BA8C0
GPIO_Drv_UnsetExtInterrupt                                  equ 0x420BBD9C
GPIO_Drv_InitExtInterrupt                                   equ 0x420BC400
ScatterMemcpy                                               equ 0x420BC5B4
ScatterMemset                                               equ 0x420BC5D8
set_chiprev                                                 equ 0x420BC63C
FSA9480_Get_DEV_TYP2                                        equ 0x420D4C54
FSA9480_Get_JIG_Status                                      equ 0x420D4C60
FSA9480_Get_FPM_Status                                      equ 0x420D4C8C
FSA9480_ResetDevice                                         equ 0x420D4F88
SetFSA9480                                                  equ 0x420D5064
BootShared_BootInit                                         equ 0x420D52AC
BootShared_GetPowerOn                                       equ 0x420D52F8
BootShared_GetPowerOnAddr                                   equ 0x420D5318
BootShared_SavePowerOnStatus                                equ 0x420D5320
HW_Get_Reset_status                                         equ 0x420D5378
DRV_Modem_BootingStart                                      equ 0x420D5A60
maxim_chg_status                                            equ 0x420D83DC
maxim_jig_status                                            equ 0x420D8430
maxim_pwr_key_status                                        equ 0x420D8484
max8998_poweron_reason                                      equ 0x420D84D8
maxim_charging_control                                      equ 0x420D8564
maxim_detbat_status_check                                   equ 0x420D87C4
maxim_usb_ldo_control                                       equ 0x420D882C
MduceBFotaDecompress                                        equ 0x420D8AF0
QuramMduceBFlashInit                                        equ 0x420DB580
QuramMduceBFlashReadData                                    equ 0x420DB8C4
__rt_memclr_w                                               equ 0x4215036C
__rt_memcpy_w                                               equ 0x421504C8
__aeabi_uidivmod                                            equ 0x42151870
guSecBootDataAddress                                        equ 0x42174000
guSecBootOtpBaseAddress                                     equ 0x42174004
guSecBootSecondDataAddress                                  equ 0x42174010
SS0                                                         equ 0x42175330
SS1                                                         equ 0x42175730
SS2                                                         equ 0x42175B30
SS3                                                         equ 0x42175F30
_fota_via_r0                                                equ 0x4219BBD0


; Variables
boot_mode                                                   equ 0x4219BBD4
hwrev                                                       equ 0x4219BBD6
pmic_mr_reset                                               equ 0x4219BBD8
UART_Reg                                                    equ 0x4219BBDC
g_BootDebugBuffIndex                                        equ 0x4219BBE0
g_pBootDebugHeader                                          equ 0x4219BBE4
szSprintf_pos                                               equ 0x4219BBEC
SYSLSIAP_VIC0                                               equ 0x4219BBF0
SYSLSIAP_VIC1                                               equ 0x4219BBF4
SYSLSIAP_VIC2                                               equ 0x4219BBF8
SYSLSIAP_VIC3                                               equ 0x4219BBFC
g_DloaDebug                                                 equ 0x4219BC14
phone_info                                                  equ 0x4219BC18
CRC_Table                                                   equ 0x4219BCFC
guNonPagingRegionSize                                       equ 0x4219C364
guRWRamRegionSize                                           equ 0x4219C368
guNonPagingRegionOffsetFromBin                              equ 0x4219C36C
g_quram_mduceb_fota_header                                  equ 0x421E12F0
diffTable                                                   equ 0x421E1334
pressed_button                                              equ 0x421F40C0
g_BootDebugBlockBuff                                        equ 0x421F40C9
g_BootDebugBuff                                             equ 0x421F80C9
szSprintf                                                   equ 0x421FC0C9
BOOT_ISR_Interrupt_Handler                                  equ 0x421FD4CC
g_Hdlc                                                      equ 0x421FD680
g_Dload                                                     equ 0x4220DAA0
gMMUL1PageTable                                             equ 0x4229C000

gstSecBootLastestVersionInfo                                equ 0x422F4150
gstSecureData                                               equ 0x422F5D4C
gstTempSecureData                                           equ 0x42305E3C
oBootSharedInfo                                             equ 0x4FF00000

end if ; PRODUCT_CODE
