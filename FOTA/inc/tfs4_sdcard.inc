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
 
;tfs4_pdev SD Card interface for Samsung Wave BL3 code(MMC2)
macro TFS4_SD_INTERFACE
{
__Tfs4PdevSDWaitHwReset:
	STMFD   SP!, {R4,LR}
	LDR     R0, =0x7A120
	BL      PWM_Drv_Delay
	LDMFD   SP!, {R4,PC}
	
Tfs4PdevSDReadStatus:
	STMFD   SP!, {R2-R6,LR}
	MOV     R4, R0
	MOV     R5, R1
	LDR     R0, =tfs4_movi_info
	LDR     R0, [R0,#0x14]
	TST     R0, #0x100
	BEQ     loc_4249BBA0
	MOV     R3, #0x1BA
	ADR     R2, aTfs4_pdev_movi ; "tfs4_pdev_movi_reindeer_plus.c"
	STRD    R2, [SP,#0x18+var_18]
	MOV     R3, #4
	MOV     R2, #0x44
	LDR     R1, =tfs4_movi_info
	MOV     R0, R4
	BL      AcMemcpyEx
	MOV     R0, #0
locret_4249BB9C::
	LDMFD   SP!, {R2-R6,PC}
loc_4249BBA0::
	MOV     R0, 0xFFFFFFFB
	B       locret_4249BB9C
	
Tfs4PdevSDClose:
	STMFD   SP!, {R2-R4,LR}
	MOV     R4, R0
	MOV     R3, #0x18E
	ADR     R2, aTfs4_pdev_movi ; "tfs4_pdev_movi_reindeer_plus.c"
	STRD    R2, [SP,#0x10+var_10]
	MOV     R3, #4
	MOV     R2, #0x44
	MOV     R1, #0
	LDR     R0, =tfs4_movi_info
	BL      AcMemsetEx
	ADR     R1, aMoviclose  ; "moviclose"
	LDR     R0, =(tfs4_movi_info+0x18)
	BL      uni_wcscpy
	MOV     R0, #0
	LDMFD   SP!, {R2-R4,PC}

Tfs4PdevSDOpen:
	MOV     R1, R0
	MOV     R0, #0
	BX      LR
	
__Tfs4PdevSDInitEx:
	STMFD   SP!, {R2-R4,LR}
	MOV     R4, R0
	MOV     R3, #0x141
	ADR     R2, aTfs4_pdev_movi ; "tfs4_pdev_movi_reindeer_plus.c"
	STRD    R2, [SP,#0x10+var_10]
	MOV     R3, #4
	MOV     R2, #0x44
	MOV     R1, #0
	LDR     R0, =tfs4_movi_info
	BL      AcMemsetEx
	ADR     R1, aDevMs      ; "/dev/ms"
	LDR     R0, =(tfs4_movi_info+0x18)
	BL      uni_wcscpy
	BL      SDHC_Init
	CMP     R0, #0
	BEQ     loc_4249BC38
	MVN     R0, #4
locret_4249BC34:
	LDMFD   SP!, {R2-R4,PC}
loc_4249BC38:
	MOV     R0, #0
	BL      SDHC_IsOpened
	CMP     R0, #1
	BNE     loc_4249BC6C
	MOV     R0, #0
	BL      SDHC_Close
	CMP     R0, #0
	BEQ     loc_4249BC6C
	LDR     R0, =guTfs4PdevInitFailCountWoReset
	LDR     R0, [R0]
	ADD     R0, R0, #1
	LDR     R1, =guTfs4PdevInitFailCountWoReset
	STR     R0, [R1]

loc_4249BC6C:
	MOV     R0, #0
	BL      SDHC_IsOpened
	CMP     R0, #0
	BNE     loc_4249BCB4
	MOV     R0, #0
	BL      SDHC_Open
	CMP     R0, #0
	BEQ     loc_4249BCB4
	LDR     R0, =guTfs4PdevInitFailCountWoReset
	LDR     R0, [R0]
	ADD     R0, R0, #1
	LDR     R1, =guTfs4PdevInitFailCountWoReset
	STR     R0, [R1]
	MOV     R0, #0
	BL      SDHC_Close
	BL      __Tfs4PdevSDWaitHwReset
	MOV     R0, 0xFFFFFFFB
	B       locret_4249BC34

loc_4249BCB4:
	LDR     R1, =gstSdhc2ndStorageInfo
	MOV     R0, #0
	BL      SDHC_GetCardInformation
	CMP     R0, #0
	BEQ     loc_4249BCE4

	LDR     R0, =guTfs4PdevInitFailCountWoReset
	LDR     R0, [R0]
	ADD     R0, R0, #1
	LDR     R1, =guTfs4PdevInitFailCountWoReset
	STR     R0, [R1]
	MOV     R0, 0xFFFFFFFB
	B       locret_4249BC34

loc_4249BCE4:
	LDR     R0, =gstSdhc2ndStorageInfo
	LDR     R0, [R0]
	LDR     R1, =tfs4_movi_info
	STR     R0, [R1]
	LDR     R0, =gstSdhc2ndStorageInfo
	LDR     R0, [R0,#4]
	STR     R0, [R1,#4]
	MOV     R0, #0
	STR     R0, [R1,#8]
	MOV     R0, R1
	LDR     R0, [R0,#4]
	SUB     R0, R0, #1
	STR     R0, [R1,#0xC]
	MOV     R0, #1
	STR     R0, [R1,#0x10]
	MOV     R0, #8
	STR     R0, [R1,#0x14]
	MOV     R0, R1
	LDR     R0, [R0,#0x14]
	ORR     R0, R0, #0x100
	STR     R0, [R1,#0x14]
	MOV     R0, #0
	B       locret_4249BC34

Tfs4PdevSDIoctl                       ; DATA XREF: tfs4_pdev_movi_rp_get_op+44o
                                         ; _4249C598o
                 STMFD   SP!, {R4-R8,LR}
                 MOV     R4, R0
                 MOV     R5, R1
                 MOV     R7, R2
                 CMP     R4, #0x40
                 BEQ     loc_4249BDE4
                 BGT     loc_4249BD70
                 CMP     R4, #0x10
                 BEQ     loc_4249BD88
                 CMP     R4, #0x20
                 BNE     loc_4249BE1C
                 B       loc_4249BDD0
 ; ---------------------------------------------------------------------------

loc_4249BD70:                            ; CODE XREF: Tfs4PdevSDIoctl+18j
                 CMP     R4, #0x80
                 BEQ     loc_4249BDF8
                 MOV     R0, #0x270F
                 SUBS    R0, R4, R0
                 BNE     loc_4249BE1C
                 B       loc_4249BE10
 ; ---------------------------------------------------------------------------

loc_4249BD88:                            ; CODE XREF: Tfs4PdevSDIoctl+20j
                 NOP
                 MOV     R0, #0
                 BL      SDHC_IsOpened
                 CMP     R0, #1
                 BNE     loc_4249BDC0
                 MOV     R0, #0
                 BL      SDHC_Close
                 CMP     R0, #0
                 BEQ     loc_4249BDC0
                 LDR     R0, =guTfs4PdevInitFailCountWoReset
                 LDR     R0, [R0]
                 ADD     R0, R0, #1
                 LDR     R1, =guTfs4PdevInitFailCountWoReset
                 STR     R0, [R1]

loc_4249BDC0:                            ; CODE XREF: Tfs4PdevSDIoctl+58j
                                         ; Tfs4PdevSDIoctl+68j
                 MOV     R0, R7
                 BL      __Tfs4PdevSDInitEx
                 MOV     R6, R0
                 B       loc_4249BE28
 ; ---------------------------------------------------------------------------

loc_4249BDD0:                            ; CODE XREF: Tfs4PdevSDIoctl+2Cj
                 NOP
                 MOV     R0, R7
                 BL      Tfs4PdevSDOpen
                 MOV     R6, R0
                 B       loc_4249BE28
 ; ---------------------------------------------------------------------------

loc_4249BDE4:                            ; CODE XREF: Tfs4PdevSDIoctl+14j
                 NOP
                 MOV     R0, R7
                 BL      Tfs4PdevSDClose
                 MOV     R6, R0
                 B       loc_4249BE28
 ; ---------------------------------------------------------------------------

loc_4249BDF8:                            ; CODE XREF: Tfs4PdevSDIoctl+34j
                 NOP
                 MOV     R1, R7
                 MOV     R0, R5
                 BL      Tfs4PdevSDReadStatus
                 MOV     R6, R0
                 B       loc_4249BE28
 ; ---------------------------------------------------------------------------

loc_4249BE10:                            ; CODE XREF: Tfs4PdevSDIoctl+44j
                 NOP
                 MOV     R6, #0
                 B       loc_4249BE28
 ; ---------------------------------------------------------------------------

loc_4249BE1C:                            ; CODE XREF: Tfs4PdevSDIoctl+28j
                                         ; Tfs4PdevSDIoctl+40j
                 NOP
                 MOV     R6, 0xFFFFFFFA
                 NOP

loc_4249BE28:                            ; CODE XREF: Tfs4PdevSDIoctl+8Cj
                                         ; Tfs4PdevSDIoctl+A0j
                                         ; Tfs4PdevSDIoctl+B4j
                                         ; Tfs4PdevSDIoctl+CCj
                                         ; Tfs4PdevSDIoctl+D8j
                 NOP
                 MOV     R0, R6
                 LDMFD   SP!, {R4-R8,PC}
 ; End of function Tfs4PdevSDIoctl

 ; ---------------------------------------------------------------------------
 dword_4249BE34  DCD 0x7A120             ; DATA XREF: __Tfs4PdevSDWaitHwReset+4r
 off_4249BE38    DCD tfs4_movi_info      ; DATA XREF: Tfs4PdevSDReadStatus+Cr
                                         ; Tfs4PdevSDReadStatus+30r
                                         ; Tfs4PdevSDClose+20r
                                         ; __Tfs4PdevSDInitEx+20r
                                         ; __Tfs4PdevSDInitEx+FCr
 aTfs4_pdev_movi DCB "tfs4_pdev_movi_reindeer_plus.c",0
                                         ; DATA XREF: Tfs4PdevSDReadStatus+20o
                                         ; Tfs4PdevSDClose+Co
                                         ; __Tfs4PdevSDInitEx+Co
                                         ; __Tfs4PdevSDReadData+190o
                                         ; _4249C584o
                 DCB 0
 aMoviclose      unicode 0, <moviclose>,0 ; DATA XREF: Tfs4PdevSDClose+28o
 off_4249BE70    DCD tfs4_movi_info+0x18 ; DATA XREF: Tfs4PdevSDClose+2Cr
                                         ; __Tfs4PdevSDInitEx+2Cr
 aDevMs          unicode 0, </dev/ms>,0  ; DATA XREF: __Tfs4PdevSDInitEx+28o
 off_4249BE84    DCD guTfs4PdevInitFailCountWoReset
                                         ; DATA XREF: __Tfs4PdevSDInitEx+68r
                                         ; __Tfs4PdevSDInitEx+74r
                                         ; __Tfs4PdevSDInitEx+9Cr
                                         ; __Tfs4PdevSDInitEx+A8r
                                         ; __Tfs4PdevSDInitEx+D8r
                                         ; __Tfs4PdevSDInitEx+E4r
                                         ; Tfs4PdevSDIoctl+6Cr
                                         ; Tfs4PdevSDIoctl+78r
                                         ; __Tfs4PdevSDWriteData+48r
                                         ; __Tfs4PdevSDWriteData+54r
                                         ; __Tfs4PdevSDWriteSectorEx+74r
                                         ; __Tfs4PdevSDWriteSectorEx+80r
                                         ; __Tfs4PdevSDReadData+48r
                                         ; __Tfs4PdevSDReadData+54r
                                         ; __Tfs4PdevSDReadSectorEx+7Cr
                                         ; __Tfs4PdevSDReadSectorEx+88r
 off_4249BE88    DCD gstSdhc2ndStorageInfo
                                         ; DATA XREF: __Tfs4PdevSDInitEx:loc_4249BCB4r
                                         ; __Tfs4PdevSDInitEx:loc_4249BCE4r
                                         ; __Tfs4PdevSDInitEx+104r
                                         ; __Tfs4PdevSDWriteData+70r
                                         ; __Tfs4PdevSDWriteData:loc_4249BFD8r
                                         ; __Tfs4PdevSDWriteData+1B0r
                                         ; __Tfs4PdevSDReadData:loc_4249C264r
                                         ; __Tfs4PdevSDReadData+194r
                                         ; __Tfs4PdevSDReadData+1B8r

 ; =============== S U B R O U T I N E =======================================


 Tfs4PdevSDEraseSector                 ; DATA XREF: tfs4_pdev_movi_rp_get_op+3Co
                 MOV     R3, R0
                 MOV     R0, R1
                 BX      LR
 ; End of function Tfs4PdevSDEraseSector


 ; =============== S U B R O U T I N E =======================================


                 EXPORT Tfs4PdevSDInit
 Tfs4PdevSDInit                        ; CODE XREF: __Tfs4PdevSDWriteSectorEx+98p
                                         ; __Tfs4PdevSDReadSectorEx+A0p
                                         ; DATA XREF: tfs4_pdev_movi_rp_get_op:loc_4249C4DCo
                                         ; _4249C58Co
                 STMFD   SP!, {R4-R6,LR}
                 MOV     R5, R0
                 MOV     R4, #3
                 B       loc_4249BEC4
 ; ---------------------------------------------------------------------------

loc_4249BEA8:                            ; CODE XREF: Tfs4PdevSDInit+30j
                 MOV     R0, #0
                 BL      __Tfs4PdevSDInitEx
                 CMP     R0, #0
                 BNE     loc_4249BEC0
                 MOV     R0, #0

locret_4249BEBC:                         ; CODE XREF: Tfs4PdevSDInit+38j
                 LDMFD   SP!, {R4-R6,PC}
 ; ---------------------------------------------------------------------------

loc_4249BEC0:                            ; CODE XREF: Tfs4PdevSDInit+1Cj
                 SUB     R4, R4, #1

loc_4249BEC4:                            ; CODE XREF: Tfs4PdevSDInit+Cj
                 CMP     R4, #0
                 BNE     loc_4249BEA8
                 MOV     R0, 0xFFFFFFFB
                 B       locret_4249BEBC
 ; End of function Tfs4PdevSDInit


 ; =============== S U B R O U T I N E =======================================


 __Tfs4PdevSDErrorNumRest              ; CODE XREF: __Tfs4PdevSDWriteData:loc_4249C0E8p
                                         ; __Tfs4PdevSDReadData:loc_4249C384p
                 MOV     R0, #0
                 LDR     R1, =guMoviDeviceErrorNum
                 STR     R0, [R1]
                 LDR     R1, =guLastSDHCErrorCode
                 STR     R0, [R1]
                 BX      LR
 ; End of function __Tfs4PdevSDErrorNumRest


 ; =============== S U B R O U T I N E =======================================


 __Tfs4PdevSDErrorOccured              ; CODE XREF: __Tfs4PdevSDWriteData+19Cp
                                         ; __Tfs4PdevSDReadData+17Cp
                 LDR     R1, =guLastSDHCErrorCode
                 STR     R0, [R1]
                 LDR     R1, =guMoviDeviceErrorNum
                 LDR     R1, [R1]
                 ADD     R1, R1, #1
                 LDR     R2, =guMoviDeviceErrorNum
                 STR     R1, [R2]
                 LDR     R1, =guSDHCRWFailCountWoReset
                 LDR     R1, [R1]
                 ADD     R1, R1, #1
                 LDR     R2, =guSDHCRWFailCountWoReset
                 STR     R1, [R2]
                 BX      LR
 ; End of function __Tfs4PdevSDErrorOccured


 ; =============== S U B R O U T I N E =======================================


 __Tfs4PdevSDDisabled                  ; CODE XREF: __Tfs4PdevSDWriteData:loc_4249C0A4p
                                         ; __Tfs4PdevSDReadData:loc_4249C27Cp
                 LDR     R0, =guMoviDeviceErrorNum
                 LDR     R0, [R0]
                 CMP     R0, #0xA
                 BLS     loc_4249BF38
                 MOV     R0, #1

locret_4249BF34:                         ; CODE XREF: __Tfs4PdevSDDisabled+1Cj
                 BX      LR
 ; ---------------------------------------------------------------------------

loc_4249BF38:                            ; CODE XREF: __Tfs4PdevSDDisabled+Cj
                 MOV     R0, #0
                 B       locret_4249BF34
 ; End of function __Tfs4PdevSDDisabled


 ; =============== S U B R O U T I N E =======================================


                 EXPORT __Tfs4PdevSDWriteData
 __Tfs4PdevSDWriteData                 ; CODE XREF: __Tfs4PdevSDWriteSectorEx+44p
                 STMFD   SP!, {R0-R12,LR}
                 MOV     R4, R0
                 MOV     R5, R1
                 MOV     R6, R2
                 MOV     R7, #0
                 MOV     R8, #0
                 MOV     R9, #0
                 MOV     R10, #0
                 MOV     R0, #0
                 BL      SDHC_IsOpened
                 CMP     R0, #0
                 BNE     loc_4249BFA8
                 MOV     R0, #0
                 BL      SDHC_Open
                 CMP     R0, #0
                 BEQ     loc_4249BFA8
                 MOV     R0, #0
                 BL      SDHC_Close
                 LDR     R0, =guTfs4PdevInitFailCountWoReset
                 LDR     R0, [R0]
                 ADD     R0, R0, #1
                 LDR     R1, =guTfs4PdevInitFailCountWoReset
                 STR     R0, [R1]
                 MOV     R0, #0

loc_4249BFA0:                            ; CODE XREF: __Tfs4PdevSDWriteData+174j
                                         ; __Tfs4PdevSDWriteData+1A4j
                                         ; __Tfs4PdevSDWriteData+1C8j
                 ADD     SP, SP, #0x10
                 LDMFD   SP!, {R4-R12,PC}
 ; ---------------------------------------------------------------------------

loc_4249BFA8:                            ; CODE XREF: __Tfs4PdevSDWriteData+2Cj
                                         ; __Tfs4PdevSDWriteData+3Cj
                 MOV     R10, #0
                 MOV     R11, R4
                 LDR     R0, =gstSdhc2ndStorageInfo
                 LDR     R1, [R0]
                 MOV     R0, #0x8000
                 BL      __aeabi_uidivmod
                 MOV     R8, R0
                 B       loc_4249C0FC
 ; ---------------------------------------------------------------------------

loc_4249BFC8:                            ; CODE XREF: __Tfs4PdevSDWriteData+1C0j
                 SUB     R9, R6, R10
                 CMP     R9, R8
                 BLS     loc_4249BFD8
                 MOV     R9, R8

loc_4249BFD8:                            ; CODE XREF: __Tfs4PdevSDWriteData+90j
                 LDR     R0, =gstSdhc2ndStorageInfo
                 LDR     R0, [R0]
                 MUL     R2, R0, R9
                 MOV     R1, R11
                 LDR     R0, =gp4ByteAlignMovi
                 BL      __rt_memcpy
                 MOV     R3, #0
                 MRS     R0, CPSR
                 TST     R0, #0x80
                 BEQ     loc_4249C008
                 MOV     R3, #1
                 B       loc_4249C014
 ; ---------------------------------------------------------------------------

loc_4249C008:                            ; CODE XREF: __Tfs4PdevSDWriteData+BCj
                 ORR     R0, R0, #0x80
                 MOV     R3, #0
                 MSR     CPSR_cxsf, R0

loc_4249C014:                            ; CODE XREF: __Tfs4PdevSDWriteData+C4j
                 MOV     R12, #0
                 MCR     p15, 0, R12,c7,c10, 5
                 MOV     R1, #0
                 B       loc_4249C048
 ; ---------------------------------------------------------------------------

loc_4249C024:                            ; CODE XREF: __Tfs4PdevSDWriteData+10Cj
                 MOV     R2, #0
                 B       loc_4249C03C
 ; ---------------------------------------------------------------------------

loc_4249C02C:                            ; CODE XREF: __Tfs4PdevSDWriteData+100j
                 MOV     LR, R1,LSL#30
                 ORR     R12, LR, R2,LSL#6
                 MCR     p15, 0, R12,c7,c14, 2
                 ADD     R2, R2, #1

loc_4249C03C:                            ; CODE XREF: __Tfs4PdevSDWriteData+E8j
                 CMP     R2, #0x80
                 BCC     loc_4249C02C
                 ADD     R1, R1, #1

loc_4249C048:                            ; CODE XREF: __Tfs4PdevSDWriteData+E0j
                 CMP     R1, #4
                 BCC     loc_4249C024
                 MOV     R1, #0
                 B       loc_4249C080
 ; ---------------------------------------------------------------------------

loc_4249C058:                            ; CODE XREF: __Tfs4PdevSDWriteData+144j
                 MOV     R2, #0
                 B       loc_4249C074
 ; ---------------------------------------------------------------------------

loc_4249C060:                            ; CODE XREF: __Tfs4PdevSDWriteData+138j
                 MOV     LR, R1,LSL#29
                 ORR     LR, LR, R2,LSL#6
                 ORR     R12, LR, #2
                 MCR     p15, 0, R12,c7,c14, 2
                 ADD     R2, R2, #1

loc_4249C074:                            ; CODE XREF: __Tfs4PdevSDWriteData+11Cj
                 CMP     R2, #0x400
                 BCC     loc_4249C060
                 ADD     R1, R1, #1

loc_4249C080:                            ; CODE XREF: __Tfs4PdevSDWriteData+114j
                 CMP     R1, #8
                 BCC     loc_4249C058
                 MOV     R12, #0
                 MCR     p15, 0, R12,c7,c10, 4
                 CMP     R3, #0
                 BNE     loc_4249C0A4
                 MRS     R0, CPSR
                 BIC     R0, R0, #0x80
                 MSR     CPSR_cxsf, R0

loc_4249C0A4:                            ; CODE XREF: __Tfs4PdevSDWriteData+154j
                 BL      __Tfs4PdevSDDisabled
                 CMP     R0, #0
                 BEQ     loc_4249C0B8
                 MOV     R0, #0
                 B       loc_4249BFA0
 ; ---------------------------------------------------------------------------

loc_4249C0B8:                            ; CODE XREF: __Tfs4PdevSDWriteData+16Cj
                 ADD     R1, R5, R10
                 LDR     R3, =gp4ByteAlignMovi
                 MOV     R2, R9
                 MOV     R0, #0
                 BL      SDHC_Write
                 MOV     R7, R0
                 CMP     R7, #0
                 BEQ     loc_4249C0E8
                 MOV     R0, R7
                 BL      __Tfs4PdevSDErrorOccured
                 MOV     R0, #0
                 B       loc_4249BFA0
 ; ---------------------------------------------------------------------------

loc_4249C0E8:                            ; CODE XREF: __Tfs4PdevSDWriteData+194j
                 BL      __Tfs4PdevSDErrorNumRest
                 ADD     R10, R10, R9
                 LDR     R0, =gstSdhc2ndStorageInfo
                 LDR     R0, [R0]
                 MLA     R11, R10, R0, R4

loc_4249C0FC:                            ; CODE XREF: __Tfs4PdevSDWriteData+84j
                 CMP     R10, R6
                 BCC     loc_4249BFC8
                 MOV     R0, #1
                 B       loc_4249BFA0
 ; End of function __Tfs4PdevSDWriteData


 ; =============== S U B R O U T I N E =======================================


                 EXPORT __Tfs4PdevSDWriteSectorEx
 __Tfs4PdevSDWriteSectorEx             ; CODE XREF: Tfs4PdevSDWriteSector+2Cp

 arg_0           =  0

                 STMFD   SP!, {R4-R12,LR}
                 MOV     R4, R0
                 MOV     R5, R1
                 MOV     R6, R2
                 MOV     R11, R3
                 LDR     R7, [SP,#0x28+arg_0]
                 MOV     R8, #3
                 MOV     R9, #0
                 MOV     R10, #0
                 NOP
                 B       loc_4249C1AC
 ; ---------------------------------------------------------------------------

loc_4249C138:                            ; CODE XREF: __Tfs4PdevSDWriteSectorEx+A8j
                 CMP     R9, #0
                 BNE     loc_4249C168
                 MOV     R3, R7
                 MOV     R2, R6
                 MOV     R1, R4
                 MOV     R0, R5
                 BL      __Tfs4PdevSDWriteData
                 MOV     R10, R0
                 CMP     R10, #0
                 BEQ     loc_4249C168
                 MOV     R0, R6

locret_4249C164:                         ; CODE XREF: __Tfs4PdevSDWriteSectorEx+B0j
                 LDMFD   SP!, {R4-R12,PC}
 ; ---------------------------------------------------------------------------

loc_4249C168:                            ; CODE XREF: __Tfs4PdevSDWriteSectorEx+30j
                                         ; __Tfs4PdevSDWriteSectorEx+50j
                 CMP     R10, #0
                 BNE     loc_4249C1AC
                 MOV     R0, #0
                 BL      SDHC_Close
                 CMP     R0, #0
                 BEQ     loc_4249C194
                 LDR     R0, =guTfs4PdevInitFailCountWoReset
                 LDR     R0, [R0]
                 ADD     R0, R0, #1
                 LDR     R1, =guTfs4PdevInitFailCountWoReset
                 STR     R0, [R1]

loc_4249C194:                            ; CODE XREF: __Tfs4PdevSDWriteSectorEx+70j
                 CMP     R8, #2
                 BGE     loc_4249C1A0
                 BL      __Tfs4PdevSDWaitHwReset

loc_4249C1A0:                            ; CODE XREF: __Tfs4PdevSDWriteSectorEx+8Cj
                 MOV     R0, #0
                 BL      Tfs4PdevSDInit
                 MOV     R9, R0

loc_4249C1AC:                            ; CODE XREF: __Tfs4PdevSDWriteSectorEx+28j
                                         ; __Tfs4PdevSDWriteSectorEx+60j
                 MOVS    R0, R8
                 SUB     R8, R8, #1
                 BNE     loc_4249C138
                 MOV     R0, 0xFFFFFFFB
                 B       locret_4249C164
 ; End of function __Tfs4PdevSDWriteSectorEx


 ; =============== S U B R O U T I N E =======================================


                 EXPORT Tfs4PdevSDWriteSector
 Tfs4PdevSDWriteSector                 ; CODE XREF: Tfs4PdevSDWriteSector4UMS+20p
                                         ; DATA XREF: tfs4_pdev_movi_rp_get_op+34o

 var_20          = -0x20

                 STMFD   SP!, {R3-R9,LR}
                 MOV     R4, R0
                 MOV     R5, R1
                 MOV     R6, R2
                 MOV     R7, R3
                 MOV     R3, #1
                 STR     R3, [SP,#0x20+var_20]
                 MOV     R3, R7
                 MOV     R2, R6
                 MOV     R1, R5
                 MOV     R0, R4
                 BL      __Tfs4PdevSDWriteSectorEx
                 MOV     R8, R0
                 MOV     R0, R8
                 LDMFD   SP!, {R3-R9,PC}
 ; End of function Tfs4PdevSDWriteSector


 ; =============== S U B R O U T I N E =======================================


                 EXPORT __Tfs4PdevSDReadData
 __Tfs4PdevSDReadData                  ; CODE XREF: __Tfs4PdevSDReadSectorEx+40p

 var_40          = -0x40

                 STMFD   SP!, {R0-R11,LR}
                 SUB     SP, SP, #0xC
                 MOV     R4, R0
                 MOV     R5, R1
                 MOV     R6, R2
                 MOV     R8, #0
                 MOV     R10, #0
                 MOV     R11, R4
                 MOV     R0, #0
                 BL      SDHC_IsOpened
                 CMP     R0, #0
                 BNE     loc_4249C264
                 MOV     R0, #0
                 BL      SDHC_Open
                 CMP     R0, #0
                 BEQ     loc_4249C264
                 MOV     R0, #0
                 BL      SDHC_Close
                 LDR     R0, =guTfs4PdevInitFailCountWoReset
                 LDR     R0, [R0]
                 ADD     R0, R0, #1
                 LDR     R1, =guTfs4PdevInitFailCountWoReset
                 STR     R0, [R1]
                 MVN     R0, #4

loc_4249C25C:                            ; CODE XREF: __Tfs4PdevSDReadData+90j
                                         ; __Tfs4PdevSDReadData+184j
                                         ; __Tfs4PdevSDReadData+1D0j
                 ADD     SP, SP, #0x1C
                 LDMFD   SP!, {R4-R11,PC}
 ; ---------------------------------------------------------------------------

loc_4249C264:                            ; CODE XREF: __Tfs4PdevSDReadData+2Cj
                                         ; __Tfs4PdevSDReadData+3Cj
                 LDR     R0, =gstSdhc2ndStorageInfo
                 LDR     R1, [R0]
                 MOV     R0, #0x8000
                 BL      __aeabi_uidivmod
                 MOV     R8, R0
                 B       loc_4249C3C0
 ; ---------------------------------------------------------------------------

loc_4249C27C:                            ; CODE XREF: __Tfs4PdevSDReadData+1C8j
                 BL      __Tfs4PdevSDDisabled
                 CMP     R0, #0
                 BEQ     loc_4249C290
                 MOV     R0, #0
                 B       loc_4249C25C
 ; ---------------------------------------------------------------------------

loc_4249C290:                            ; CODE XREF: __Tfs4PdevSDReadData+88j
                 SUB     R9, R6, R10
                 CMP     R9, R8
                 BLS     loc_4249C2A0
                 MOV     R9, R8

loc_4249C2A0:                            ; CODE XREF: __Tfs4PdevSDReadData+9Cj
                 MOV     R3, #0
                 MRS     R0, CPSR
                 TST     R0, #0x80
                 BEQ     loc_4249C2B8
                 MOV     R3, #1
                 B       loc_4249C2C4
 ; ---------------------------------------------------------------------------

loc_4249C2B8:                            ; CODE XREF: __Tfs4PdevSDReadData+B0j
                 ORR     R0, R0, #0x80
                 MOV     R3, #0
                 MSR     CPSR_cxsf, R0

loc_4249C2C4:                            ; CODE XREF: __Tfs4PdevSDReadData+B8j
                 MOV     R12, #0
                 MCR     p15, 0, R12,c7,c10, 5
                 MOV     R1, #0
                 B       loc_4249C2F8
 ; ---------------------------------------------------------------------------

loc_4249C2D4:                            ; CODE XREF: __Tfs4PdevSDReadData+100j
                 MOV     R2, #0
                 B       loc_4249C2EC
 ; ---------------------------------------------------------------------------

loc_4249C2DC:                            ; CODE XREF: __Tfs4PdevSDReadData+F4j
                 MOV     LR, R1,LSL#30
                 ORR     R12, LR, R2,LSL#6
                 MCR     p15, 0, R12,c7,c14, 2
                 ADD     R2, R2, #1

loc_4249C2EC:                            ; CODE XREF: __Tfs4PdevSDReadData+DCj
                 CMP     R2, #0x80
                 BCC     loc_4249C2DC
                 ADD     R1, R1, #1

loc_4249C2F8:                            ; CODE XREF: __Tfs4PdevSDReadData+D4j
                 CMP     R1, #4
                 BCC     loc_4249C2D4
                 MOV     R1, #0
                 B       loc_4249C330
 ; ---------------------------------------------------------------------------

loc_4249C308:                            ; CODE XREF: __Tfs4PdevSDReadData+138j
                 MOV     R2, #0
                 B       loc_4249C324
 ; ---------------------------------------------------------------------------

loc_4249C310:                            ; CODE XREF: __Tfs4PdevSDReadData+12Cj
                 MOV     LR, R1,LSL#29
                 ORR     LR, LR, R2,LSL#6
                 ORR     R12, LR, #2
                 MCR     p15, 0, R12,c7,c14, 2
                 ADD     R2, R2, #1

loc_4249C324:                            ; CODE XREF: __Tfs4PdevSDReadData+110j
                 CMP     R2, #0x400
                 BCC     loc_4249C310
                 ADD     R1, R1, #1

loc_4249C330:                            ; CODE XREF: __Tfs4PdevSDReadData+108j
                 CMP     R1, #8
                 BCC     loc_4249C308
                 MOV     R12, #0
                 MCR     p15, 0, R12,c7,c10, 4
                 CMP     R3, #0
                 BNE     loc_4249C354
                 MRS     R0, CPSR
                 BIC     R0, R0, #0x80
                 MSR     CPSR_cxsf, R0

loc_4249C354:                            ; CODE XREF: __Tfs4PdevSDReadData+148j
                 ADD     R1, R5, R10
                 LDR     R3, =gp4ByteAlignMovi
                 MOV     R2, R9
                 MOV     R0, #0
                 BL      SDHC_Read
                 MOV     R7, R0
                 CMP     R7, #0
                 BEQ     loc_4249C384
                 MOV     R0, R7
                 BL      __Tfs4PdevSDErrorOccured
                 MOV     R0, #0
                 B       loc_4249C25C
 ; ---------------------------------------------------------------------------

loc_4249C384:                            ; CODE XREF: __Tfs4PdevSDReadData+174j
                 BL      __Tfs4PdevSDErrorNumRest
                 MOV     R3, #0x43E
                 LDR     R2, =aTfs4_pdev_movi ; "tfs4_pdev_movi_reindeer_plus.c"
                 LDR     R0, =gstSdhc2ndStorageInfo
                 STRD    R2, [SP,#0x40+var_40]
                 LDR     R0, [R0]
                 MUL     R2, R0, R9
                 MOV     R3, #4
                 LDR     R1, =gp4ByteAlignMovi
                 MOV     R0, R11
                 BL      AcMemcpyEx
                 ADD     R10, R10, R9
                 LDR     R0, =gstSdhc2ndStorageInfo
                 LDR     R0, [R0]
                 MLA     R11, R10, R0, R4

loc_4249C3C0:                            ; CODE XREF: __Tfs4PdevSDReadData+7Cj
                 CMP     R10, R6
                 BCC     loc_4249C27C
                 MOV     R0, #1
                 B       loc_4249C25C
 ; End of function __Tfs4PdevSDReadData


 ; =============== S U B R O U T I N E =======================================


                 EXPORT __Tfs4PdevSDReadSectorEx
 __Tfs4PdevSDReadSectorEx              ; CODE XREF: Tfs4PdevSDReadSector+2Cp

 arg_0           =  0

                 STMFD   SP!, {R4-R12,LR}
                 MOV     R4, R0
                 MOV     R5, R1
                 MOV     R6, R2
                 MOV     R11, R3
                 LDR     R7, [SP,#0x28+arg_0]
                 MOV     R8, #0
                 MOV     R9, #0
                 MOV     R10, #3
                 B       loc_4249C478
 ; ---------------------------------------------------------------------------

loc_4249C3F8:                            ; CODE XREF: __Tfs4PdevSDReadSectorEx+B0j
                 CMP     R8, #0
                 BNE     loc_4249C434
                 MOV     R3, R7
                 MOV     R2, R6
                 MOV     R1, R4
                 MOV     R0, R5
                 BL      __Tfs4PdevSDReadData
                 MOV     R9, R0
                 CMP     R9, #0
                 BEQ     loc_4249C434
                 MOV     R0, #0
                 LDR     R1, =uTfs4MoviLastReadErrSector
                 STR     R0, [R1]
                 MOV     R0, R6

locret_4249C430:                         ; CODE XREF: __Tfs4PdevSDReadSectorEx+B8j
                 LDMFD   SP!, {R4-R12,PC}
 ; ---------------------------------------------------------------------------

loc_4249C434:                            ; CODE XREF: __Tfs4PdevSDReadSectorEx+2Cj
                                         ; __Tfs4PdevSDReadSectorEx+4Cj
                 CMP     R9, #0
                 BNE     loc_4249C478
                 MOV     R0, #0
                 BL      SDHC_Close
                 CMP     R0, #0
                 BEQ     loc_4249C460
                 LDR     R0, =guTfs4PdevInitFailCountWoReset
                 LDR     R0, [R0]
                 ADD     R0, R0, #1
                 LDR     R1, =guTfs4PdevInitFailCountWoReset
                 STR     R0, [R1]

loc_4249C460:                            ; CODE XREF: __Tfs4PdevSDReadSectorEx+78j
                 CMP     R10, #2
                 BGE     loc_4249C46C
                 BL      __Tfs4PdevSDWaitHwReset

loc_4249C46C:                            ; CODE XREF: __Tfs4PdevSDReadSectorEx+94j
                 MOV     R0, #0
                 BL      Tfs4PdevSDInit
                 MOV     R8, R0

loc_4249C478:                            ; CODE XREF: __Tfs4PdevSDReadSectorEx+24j
                                         ; __Tfs4PdevSDReadSectorEx+68j
                 MOVS    R0, R10
                 SUB     R10, R10, #1
                 BNE     loc_4249C3F8
                 MOV     R0, 0xFFFFFFFB
                 B       locret_4249C430
 ; End of function __Tfs4PdevSDReadSectorEx


 ; =============== S U B R O U T I N E =======================================


                 EXPORT Tfs4PdevSDReadSector
 Tfs4PdevSDReadSector                  ; CODE XREF: Tfs4PdevSDReadSector4UMS+20p
                                         ; DATA XREF: tfs4_pdev_movi_rp_get_op+2Co

 var_20          = -0x20

                 STMFD   SP!, {R3-R9,LR}
                 MOV     R4, R0
                 MOV     R5, R1
                 MOV     R6, R2
                 MOV     R7, R3
                 MOV     R3, #1
                 STR     R3, [SP,#0x20+var_20]
                 MOV     R3, R7
                 MOV     R2, R6
                 MOV     R1, R5
                 MOV     R0, R4
                 BL      __Tfs4PdevSDReadSectorEx
                 MOV     R8, R0
                 MOV     R0, R8
                 LDMFD   SP!, {R3-R9,PC}
 ; End of function Tfs4PdevSDReadSector


 ; =============== S U B R O U T I N E =======================================


                 EXPORT tfs4_pdev_movi_rp_get_op
 tfs4_pdev_movi_rp_get_op                ; CODE XREF: PfsMassFormat+40p
                                         ; __PfsMassInit+30p
                 MOV     R1, R0
                 CMP     R1, #0
                 BNE     loc_4249C4DC
                 MVN     R0, #5

locret_4249C4D8:                         ; CODE XREF: tfs4_pdev_movi_rp_get_op+58j
                 BX      LR
 ; ---------------------------------------------------------------------------

loc_4249C4DC:                            ; CODE XREF: tfs4_pdev_movi_rp_get_op+8j
                 LDR     R0, =Tfs4PdevSDInit
                 STR     R0, [R1]
                 LDR     R0, =Tfs4PdevSDOpen
                 STR     R0, [R1,#4]
                 LDR     R0, =Tfs4PdevSDClose
                 STR     R0, [R1,#8]
                 ADR     R0, Tfs4PdevSDReadSector
                 STR     R0, [R1,#0x10]
                 ADR     R0, Tfs4PdevSDWriteSector
                 STR     R0, [R1,#0x14]
                 ADR     R0, Tfs4PdevSDEraseSector
                 STR     R0, [R1,#0x18]
                 LDR     R0, =Tfs4PdevSDIoctl
                 STR     R0, [R1,#0x1C]
                 ADR     R0, Tfs4PdevSDReadStatus
                 STR     R0, [R1,#0xC]
                 MOV     R0, #0
                 B       locret_4249C4D8
 ; End of function tfs4_pdev_movi_rp_get_op


 ; =============== S U B R O U T I N E =======================================


                 EXPORT Tfs4PdevSDReadSector4UMS
 Tfs4PdevSDReadSector4UMS
                 STMFD   SP!, {R4-R6,LR}
                 MOV     R4, R0
                 MOV     R5, R1
                 MOV     R6, R2
                 MOV     R3, #0
                 MOV     R2, R6
                 MOV     R1, R5
                 MOV     R0, R4
                 BL      Tfs4PdevSDReadSector
                 LDMFD   SP!, {R4-R6,PC}
 ; End of function Tfs4PdevSDReadSector4UMS


 ; =============== S U B R O U T I N E =======================================


                 EXPORT Tfs4PdevSDWriteSector4UMS
 Tfs4PdevSDWriteSector4UMS
                 STMFD   SP!, {R4-R6,LR}
                 MOV     R4, R0
                 MOV     R5, R1
                 MOV     R6, R2
                 MOV     R3, #0
                 MOV     R2, R6
                 MOV     R1, R5
                 MOV     R0, R4
                 BL      Tfs4PdevSDWriteSector
                 LDMFD   SP!, {R4-R6,PC}
 ; End of function Tfs4PdevSDWriteSector4UMS







}