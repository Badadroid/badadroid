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
PRODUCT_CODE							equ 'S8530'
FIRMWARE_VER							equ 2.0

BL2_DRAM_START							equ 0x42000000
BL3_DRAM_START							equ 0x42080000
FOTA_DRAM_START 						equ 0x43200000
FOTA_BUFFER							equ 0x43500000
FOTA_NAND_START 						equ 0x09500000


; Functions

DloadMain							equ 0x42083B74
MemMMUCacheEnable						equ 0x42089288
disp_dimming_backlight						equ 0x420AF248
disp_FOTA_Init							equ 0x420AFDB0
PWM_Drv_Delay							equ 0x420B982C
disp_FOTA_Printf						equ 0x420AFDE4
__PfsMassInit							equ 0x420A9340
__PfsNandInit							equ 0x420A9490
tfs4_close							equ 0x420CF4AC
tfs4_open							equ 0x420CF868
tfs4_stat							equ 0x420CEB8C
tfs4_read							equ 0x420CF868
maxim_charging_control						equ 0x420DA0CC
EdbgOutputDebugString						equ 0x42082018

; Variables
pressed_button				equ 0x421F5274
gMMUL1PageTable 			equ 0x4229C000
x_pos@disp_FOTA_Printf_1		equ 0x421E16A0

end if ; PRODUCT_CODE
