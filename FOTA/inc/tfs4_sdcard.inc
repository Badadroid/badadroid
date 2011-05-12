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
locret_4249BB9C:
	LDMFD   SP!, {R2-R6,PC}
loc_4249BBA0:
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
locret_4249BC34
LDMFD   SP!, {R2-R4,PC}
loc_4249BC38
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

loc_4249BC6C
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
BL      __Tfs4PdevMoviWaitHwReset
MOV     R0, 0xFFFFFFFB
B       locret_4249BC34

loc_4249BCB4
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

loc_4249BCE4
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
; End of function __Tfs4PdevMoviInitEx



}