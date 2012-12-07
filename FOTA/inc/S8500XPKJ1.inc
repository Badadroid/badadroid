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
PRODUCT_CODE							equ 'S8500'
MACH_ID									equ 8500
FIRMWARE_VER							equ 2.0

BL2_DRAM_START							equ 0x42000000
BL3_DRAM_START							equ 0x42080000
FOTA_DRAM_START 						equ 0x43200000
FOTA_BUFFER							equ 0x43500000
FOTA_NAND_START 						equ 0x03300000


; Functions
StartUp 							equ 0x42080000
UndefEntry							equ 0x42080004
SwiEntry							equ 0x42080008
IAbortEntry							equ 0x4208000C
DAbortEntry							equ 0x42080010
IrqEntry							equ 0x42080018
FiqEntry							equ 0x4208001C
ResetHandler							equ 0x42080020
MemMMUCacheEnable						equ 0x420893D0
disp_FOTA_Init							equ 0x420B03A0
disp_FOTA_Printf						equ 0x420B03D4
__PfsMassInit							equ 0x420A9930
__PfsNandInit							equ 0x420A9A80
tfs4_close							equ 0x420CFA74
tfs4_open							equ 0x420CF900
tfs4_stat							equ 0x420D0A08
CoDisableMmu							equ 0x42150A8C
CoDisableDCache 						equ 0x42150A4C
maxim_charging_control						equ 0x420D7EEC
DloadMain							equ 0x42083C44
PWM_Drv_Delay							equ 0x420B9DF4
EdbgOutputDebugString						equ 0x420820E8
disp_dimming_backlight						equ 0x420AF834
tfs4_read							equ 0x420CFE30

; Variables
pressed_button				equ 0x421F3208
gMMUL1PageTable 			equ 0x4229C000
x_pos@disp_FOTA_Printf_1		equ 0x421DF820

end if ; PRODUCT_CODE
