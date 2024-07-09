$NOMOD51
$INCLUDE (8051.MCU)
;========================================================
org   0000h
;cac bien khai bao ban dau
   XUNG_L1 	BIT P0.0
   DL_L1 	BIT P0.1
   CHOT_L1 	BIT P0.2
   XUNG_L2 	BIT P0.3
   DL_L2	BIT P0.4
   XUNG_L3	BIT P0.5
   DL_L3	BIT P0.6
   XUNG_L4	BIT P1.0
   DL_L4	BIT P1.1
   XUNG_R1 	BIT P2.1
   DL_R1 	BIT P2.2
   XUNG_R2 	BIT P2.3
   DL_R2 	BIT P2.4
   XUNG_R3 	BIT P2.5
   DL_R3 	BIT P2.6  
   XUNG_R4 	BIT P1.2
   DL_R4 	BIT P1.3
;===========================
   ;chuyenHU 	BIT P3.2
   ;tangtocHU 	BIT P3.3

jmp   Start
org 0003h
int0_isr:
   INC R3
   CJNE R3,#4,exit_int0
      mov R3,#1
   exit_int0:
RETI
;============
org 0013h
   int1_isr:   
      INC R7 ; Tang giá tri trong R7
      INC R7
      INC R7
      INC R7
      INC R7
      INC R7
      CJNE R7, #3Fh, skip_reset
      MOV R7, #03h 
   skip_reset:
   RETI
;==================================================
org 0100h
Start:
      ;R0 chinh step	
      ;R1 dung dem step
      ;R2 dung de dem 8 bit doc
      ;R3 su dung de chinh toc do
      ;R4 delay
      ;R5 d? 6 dong thi doi HU
      ;R6 khoang cach cac HU
      ;R7 dang su dung de lam nut chuyen HU
      ;lay dia chi dau tien cua MA =======thay doi HU bang cach thay MA=MA2======
      setb EA
      setb EX1
      setb EX0
      setb IT0
      setb IT1

      setb P3.2
      setb P3.3
      
      mov R3,#1 ;toc do
      
LOOP_HU:
;cai nay la set up HU dau tien
mov dptr, #HU1_1
mov R7, DPH
MOV R6,#6  ;doi chuyen HU

MAIN:
MOV R5,#6
      MOV R0,#6	;co 6 gia tri cua MA
      MOV R1,#0
      
      DOC_MA:	; DOC TUNG GIA TRI CUA MANG
	 ACALL LAY_GT_GAN_SOBIT8
	 ACALL DOC_BIT_L1 ;goi ham doc BIT L1
	 INC R1	;R1++
	 
	 ACALL LAY_GT_GAN_SOBIT8
	 ACALL DOC_BIT_L2 ;;goi ham doc BIT L2
	 INC R1	;R1++
	 
	 ACALL LAY_GT_GAN_SOBIT8
	 ACALL DOC_BIT_R1 ;;goi ham doc BIT R1
	 INC R1	;R1++
	 
	 ACALL LAY_GT_GAN_SOBIT8
	 ACALL DOC_BIT_R2 ;goi ham doc BIT R2
	 INC R1	;R1++
	 
	 ACALL LAY_GT_GAN_SOBIT8
	 ACALL DOC_BIT_L3 ;goi ham doc BIT L3
	 INC R1	;R1++
	 
	 ACALL LAY_GT_GAN_SOBIT8
	 ACALL DOC_BIT_L4 ;goi ham doc BIT L4
	 INC R1	;R1++
	 
	 ACALL LAY_GT_GAN_SOBIT8
	 ACALL DOC_BIT_R3 ;goi ham doc BIT R3
	 INC R1	;R1++
	 
	 ACALL LAY_GT_GAN_SOBIT8
	 ACALL DOC_BIT_R4 ;goi ham doc BIT R4
	 INC R1	;R1++
	 
	 
	 ACALL CHOT_ALL ;==========ham chot
	 

	 ACALL DELAY
      DJNZ R0,DOC_MA
DJNZ R5, Doi_dia_chi_DB
ljmp MAIN
;=================================================
LAY_GT_GAN_SOBIT8:
   MOV A,R1
   MOVC A, @A+dptr	
   MOV R2,#8
RET
;=====================================================

;====================================================================
Doi_dia_chi_DB:
    MOV  DPL, #00h      ;Ðat byte thap cua DPTR ve 0      
    INC DPH		;tang gia tri HIgh dia chi dptr
    DJNZ R6, MAIN		;--R6, néu R6 chua =0 thi nhay len main, neu R6=0 thì lap lai HU
    
    MOV R6,#6 		; doi chuyen HU
    MOV DPH, R7
    ljmp MAIN
RET
;====================================================================
DOC_BIT_L1:		;DOC TUNG BIT
	    CLR C
	    RLC A	;Quay trai thanh ghi qua C
	    MOV DL_L1,C
	    SETB XUNG_L1
	    CLR XUNG_L1
	 DJNZ R2, DOC_BIT_L1;
	 RET
DOC_BIT_L2:		;DOC TUNG BIT
	    CLR C
	    RLC A	;Quay trai thanh ghi qua C
	    MOV DL_L2,C
	    SETB XUNG_L2
	    CLR XUNG_L2
	 DJNZ R2, DOC_BIT_L2;
	 RET
DOC_BIT_L3:		;DOC TUNG BIT
	    CLR C
	    RLC A	;Quay trai thanh ghi qua C
	    MOV DL_L3,C
	    SETB XUNG_L3
	    CLR XUNG_L3
	 DJNZ R2, DOC_BIT_L3;
	 RET
DOC_BIT_L4:		;DOC TUNG BIT
	    CLR C
	    RLC A	;Quay trai thanh ghi qua C
	    MOV DL_L4,C
	    SETB XUNG_L4
	    CLR XUNG_L4
	 DJNZ R2, DOC_BIT_L4;
	 RET
DOC_BIT_R1:		;DOC TUNG BIT
	    CLR C
	    RLC A	;Quay trai thanh ghi qua C
	    MOV DL_R1,C
	    SETB XUNG_R1
	    CLR XUNG_R1
	 DJNZ R2, DOC_BIT_R1;
	 RET
DOC_BIT_R2:		;DOC TUNG BIT
	    CLR C
	    RLC A	;Quay trai thanh ghi qua C
	    MOV DL_R2,C
	    SETB XUNG_R2
	    CLR XUNG_R2
	 DJNZ R2, DOC_BIT_R2;
	 RET
DOC_BIT_R3:		;DOC TUNG BIT
	    CLR C
	    RLC A	;Quay trai thanh ghi qua C
	    MOV DL_R3,C
	    SETB XUNG_R3
	    CLR XUNG_R3
	 DJNZ R2, DOC_BIT_R3;
	 RET
DOC_BIT_R4:		;DOC TUNG BIT
	    CLR C
	    RLC A	;Quay trai thanh ghi qua C
	    MOV DL_R4,C
	    SETB XUNG_R4
	    CLR XUNG_R4
	 DJNZ R2, DOC_BIT_R4;
	 RET
;===================================================================

;===================================================================
CHOT_ALL:
   SETB CHOT_L1
   CLR CHOT_L1
RET
;===================================================================
DELAY:
    MOV TMOD, #01H    ; Timer 0, Mode 1 (16-bit Timer)
    mov A,R3
    mov R4,A
    lap_delay:
    MOV TH0, #00h  
    MOV TL0, #00h 
    SETB TR0           ; Start 
       JNB TF0, $      ; 
       CLR TR0            ; Stop Timer 0
       CLR TF0            ; Clear Timer 0 Overflow Flag
   djnz R4, lap_delay
RET
;===================================================================
org 0300h
HU1_1: DB 0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,   0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,   0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,   00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,   00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,   00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
org 0400h
HU2_1: DB 0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,   0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,   0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,   00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,   00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,   00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
org 0500h
HU3_1: DB 0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,   0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,   0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,   00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,   00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,   00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
org 0600h
HU4_1: DB 0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,   0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,   0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,   00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,   00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,   00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
org 0700h
HU5_1: DB 0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,   0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,   0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,   00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,   00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,   00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
org 0800h
HU6_1: DB 0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,   0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,   0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,   00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,   00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,   00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
;====================================
org 0900h
HU1_2: DB 01h,00h,00h,00h,01h,00h,00h,00h,   03h,00h,00h,80h,03h,00h,00h,80h,   07h,00h,00h,0c0h,07h,00h,00h,0c0h,    0eh,00h,00h,0e0h,0eh,00h,00h,0e0h,   01Ch,00h,00h,70h,01Ch,00h,00h,70h,   38h,00h,00h,38h,38h,00h,00h,38h
org 0A00h
HU2_2: DB 70h,00h,00h,1ch,70h,00h,00h,1ch,    0e0h,00h,00h,0eh,0e0h,00h,00h,0eh,  0c0h,01h,00h,07h,0c0h,01h,00h,07h,   80h,03h,80h,03h,80h,03h,80h,03h,   00h,07h,0c0h,01h,00h,07h,0c0h,01h,   00h,0eh,0e0h,00h,00h,0eh,0e0h,00h
org 0B00h
HU3_2: DB 00h,1ch,70h,00h,00h,1ch,70h,00h,   00h,38h,38h,00h,00h,38h,38h,00h,   00h,70h,1ch,00h,00h,70h,1ch,00h,   00h,0e0h,0eh,00h,00h,0e0h,0eh,00h,   00h,0c0h,07h,00h,00h,0c0h,07h,00h,   00h,80h,03h,00h,00h,80h,03h,00h 
org 0C00h
HU4_2: DB 00h,00h,01h,00h,00h,00h,01h,00h,   00h,80h,03h,00h,00h,80h,03h,00h,   00h,0c0h,07h,00h,00h,0c0h,07h,00h,   00h,0e0h,0eh,00h,00h,0e0h,0eh,00h,  00h,70h,1ch,00h,00h,70h,1ch,00h,   00h,38h,38h,00h,00h,38h,38h,00h
org 0D00h
HU5_2: DB 00h,1ch,70h,00h,00h,1ch,70h,00h,   00h,0eh,0e0h,00h,00h,0eh,0e0h,00h,  00h,07h,0c0h,01h,00h,07h,0c0h,01h,   80h,03h,80h,03h,80h,03h,80h,03h,   0c0h,01h,00h,07h,0c0h,01h,00h,07h,   0e0h,00h,00h,0eh,0e0h,00h,00h,0eh
org 0E00h
HU6_2: DB 70h,00h,00h,1ch,70h,00h,00h,1ch,   38h,00h,00h,38h,38h,00h,00h,38h,   01Ch,00h,00h,70h,01Ch,00h,00h,70h,   0eh,00h,00h,0e0h,0eh,00h,00h,0e0h,   07h,00h,00h,0c0h,07h,00h,00h,0c0h,   03h,00h,00h,80h,03h,00h,00h,80h
;===================================
;THUC_2
org 0F00h
HU1_3: DB 01h,01h,01h,01h,80h,80h,80h,80h,   02h,02h,02h,02h,40h,40h,40h,40h,   04h,04h,04h,04h,20h,20h,20h,20h,   08h,08h,08h,08h,10h,10h,10h,10h,   10h,10h,10h,10h,08h,08h,08h,08h,   20h,20h,20h,20h,04h,04h,04h,04h
org 1000h
HU2_3: DB 40h,40h,40h,40h,02h,02h,02h,02h,   80h,80h,80h,80h,01h,01h,01h,01h,   40h,40h,40h,40h,02h,02h,02h,02h,   20h,20h,20h,20h,04h,04h,04h,04h,   10h,10h,10h,10h,08h,08h,08h,08h,   08h,08h,08h,08h,10h,10h,10h,10h
org 1100h
HU3_3: DB 04h,04h,04h,04h,20h,20h,20h,20h,   02h,02h,02h,02h,40h,40h,40h,40h,   01h,01h,01h,01h,80h,80h,80h,80h,   03h,03h,03h,03h,0c0h,0c0h,0c0h,0c0h,   07h,07h,07h,07h,0e0h,0e0h,0e0h,0e0h,   0fh,0fh,0fh,0fh,0f0h,0f0h,0f0h,0f0h
org 1200h
HU4_3: DB 1fh,1fh,1fh,1fh,0f8h,0f8h,0f8h,0f8h,   3fh,3fh,3fh,3fh,0fch,0fch,0fch,0fch, 7fh,7fh,7fh,7fh,0feh,0feh,0feh,0feh, 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh, 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh, 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh
org 1300h
HU5_3: DB 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh, 7fh,7fh,7fh,7fh,0feh,0feh,0feh,0feh, 3fh,3fh,3fh,3fh,0fch,0fch,0fch,0fch,  1fh,1fh,1fh,1fh,0f8h,0f8h,0f8h,0f8h,   0fh,0fh,0fh,0fh,0f0h,0f0h,0f0h,0f0h,   07h,07h,07h,07h,0e0h,0e0h,0e0h,0e0h
org 1400h
HU6_3: DB 03h,03h,03h,03h,0c0h,0c0h,0c0h,0c0h,   01h,01h,01h,01h,80h,80h,80h,80h,   00h,00h,00h,00h,00h,00h,00h,00h
;======================================================
;THUC_1
org 1500h
HU1_4: DB 01h,00h,00h,00h,01h,00h,00h,80h,   03h,00h,00h,00h,01h,00h,00h,0c0h,   07h,00h,00h,00h,01h,00h,00h,0e0h,   0eh,00h,00h,00h,00h,00h,00h,70h,   1ch,00h,00h,00h,00h,00h,00h,38h,   38h,00h,00h,00h,00h,00h,00h,1ch
org 1600h
HU2_4: DB 70h,00h,00h,00h,00h,00h,00h,0eh,   0e0h,00h,00h,00h,00h,00h,00h,07h,   0c0h,01h,00h,00h,00h,00h,80h,03h,   80h,03h,00h,00h,00h,00h,0c0h,01h,   00h,07h,00h,00h,00h,00h,0e0h,00h,   00h,0eh,00h,00h,00h,00h,70h,00h
org 1700h
HU3_4: DB 00h,1ch,00h,00h,00h,00h,38h,00h,   00h,38h,00h,00h,00h,00h,1ch,00h,   00h,70h,00h,00h,00h,00h,0eh,00h,   00h,0e0h,00h,00h,00h,00h,07h,00h,   00h,0c0h,01h,00h,00h,80h,03h,00h,   00h,80h,03h,00h,00h,0c0h,01h,00h
org 1800h
HU4_4: DB 00h,00h,07h,00h,00h,0e0h,00h,00h,   00h,00h,0eh,00h,00h,70h,00h,00h,   00h,00h,1ch,00h,00h,38h,00h,00h,   00h,00h,38h,00h,00h,1ch,00h,00h,   00h,00h,70h,00h,00h,0eh,00h,00h,   00h,00h,0e0h,00h,00h,07h,00h,00h
org 1900h
HU5_4: DB 00h,00h,0c0h,01h,80h,03h,00h,00h,   00h,00h,80h,03h,0c0h,01h,00h,00h,   00h,00h,00h,07h,0e0h,00h,00h,00h,   00h,00h,00h,0eh,70h,00h,00h,00h,   00h,00h,00h,1ch,38h,00h,00h,00h,   00h,00h,00h,38h,1ch,00h,00h,00h
org 1A00h
HU6_4: DB 00h,00h,00h,70h,0eh,00h,00h,00h,   00h,00h,00h,0e0h,07h,00h,00h,00h,   01h,00h,00h,0c0h,03h,00h,00h,00h,   01h,00h,00h,80h,01h,00h,00h,00h,   01h,00h,00h,00h,00h,00h,00h,00h,   00h,00h,00h,00h,00h,00h,00h,00h
;========================================
;Thanh_1
org 1B00h
HU1_5: DB 01h,00h,00h,00h,01h,00h,00h,80h,   03h,00h,00h,00h,01h,00h,00h,0c0h,   07h,00h,00h,00h,01h,00h,00h,0e0h,   0fh,00h,00h,00h,01h,00h,00h,0f0h,   1fh,00h,00h,00h,01h,00h,00h,0f8h,   3fh,00h,00h,00h,01h,00h,00h,0fch
org 1C00h
HU2_5: DB 7fh,00h,00h,00h,01h,00h,00h,0feh,   0ffh,00h,00h,00h,01h,00h,00h,0ffh,   0ffh,01h,00h,00h,01h,00h,80h,0ffh,   0ffh,03h,00h,00h,01h,00h,0c0h,0ffh,   0ffh,07h,00h,00h,01h,00h,0e0h,0ffh,   0ffh,0fh,00h,00h,01h,00h,0f0h,0ffh
org 1D00h
HU3_5: DB 0ffh,1fh,00h,00h,01h,00h,0f8h,0ffh,   0ffh,3fh,00h,00h,01h,00h,0fch,0ffh,   0ffh,7fh,01h,00h,01h,00h,0feh,0ffh,   0ffh,0ffh,01h,00h,01h,00h,0ffh,0ffh,   0ffh,0ffh,01h,00h,01h,00h,0ffh,0ffh,   0ffh,0ffh,01h,00h,01h,00h,0ffh,0ffh
org 1E00h
HU4_5: DB 0ffh,0ffh,01h,00h,01h,00h,0ffh,0ffh,   01h,00h,0ffh,0ffh,0ffh,0ffh,01h,00h,   01h,00h,0ffh,0ffh,0ffh,0ffh,01h,00h,   01h,00h,0ffh,0ffh,0ffh,0ffh,01h,00h,   01h,00h,0ffh,0ffh,0ffh,0ffh,01h,00h,   0ffh,0ffh,01h,00h,01h,00h,0ffh,0ffh
org 1F00h
HU5_5: DB 0ffh,0ffh,01h,00h,01h,00h,0ffh,0ffh,   0ffh,0ffh,01h,00h,01h,00h,0ffh,0ffh,  0ffh,0ffh,01h,00h,01h,00h,0ffh,0ffh,   01h,00h,0ffh,0ffh,0ffh,0ffh,01h,00h,   01h,00h,0ffh,0ffh,0ffh,0ffh,01h,00h,    01h,00h,0ffh,0ffh,0ffh,0ffh,01h,00h
org 2000h
HU6_5: DB 01h,00h,0ffh,0ffh,0ffh,0ffh,01h,00h,   01h,00h,0ffh,0ffh,0ffh,0ffh,01h,00h
;Thanh_2
org 2100h
HU1_6: DB 00h,80h,01h,00h,01h,00h,00h,80h,   00h,0c0h,01h,00h,01h,00h,00h,0c0h,   00h,0e0h,01h,00h,01h,00h,00h,0e0h,   00h,0f0h,01h,00h,01h,00h,00h,0f0h,   00h,0f8h,01h,00h,01h,00h,00h,0f8h,   00h,0fch,01h,00h,01h,00h,00h,0fch
org 2200h
HU2_6: DB 00h,0feh,01h,00h,01h,00h,00h,0feh,   00h,0ffh,01h,00h,01h,00h,00h,0ffh,   00h,0ffh,01h,00h,01h,00h,00h,0ffh,   80h,00h,00h,00h,00h,00h,80h,00h,   0c0h,00h,00h,00h,00h,00h,0c0h,00h,   0e0h,00h,00h,00h,00h,00h,0e0h,00h  
org 2300h
HU3_6: DB 0f0h,00h,00h,00h,00h,00h,0f0h,00h,   0f8h,00h,00h,00h,00h,00h,0f8h,00h,   0fch,00h,00h,00h,00h,00h,0fch,00h,   0feh,00h,00h,00h,00h,00h,0feh,00h,   0ffh,00h,00h,00h,00h,00h,0ffh,00h,    0ffh,00h,00h,00h,00h,00h,0ffh,00h   
org 2400h
HU4_6: DB 01h,00h,00h,80h,00h,80h,01h,00h,    01h,00h,00h,0c0h,00h,0c0h,01h,00h,   01h,00h,00h,0e0h,00h,0e0h,01h,00h,   01h,00h,00h,0f0h,00h,0f0h,01h,00h,   01h,00h,00h,0f8h,00h,0f8h,01h,00h,   01h,00h,00h,0fch,00h,0fch,01h,00h   
org 2500h
HU5_6: DB 01h,00h,00h,0feh,00h,0feh,01h,00h,   01h,00h,00h,0ffh,00h,0ffh,01h,00h,   01h,00h,00h,0ffh,00h,0ffh,01h,00h,  00h,00h,80h,00h,80h,00h,00h,00h,   00h,00h,0c0h,00h,0c0h,00h,00h,00h,   00h,00h,0e0h,00h,0e0h,00h,00h,00h
org 2600h
HU6_6: DB 00h,00h,0f0h,00h,0f0h,00h,00h,00h,   00h,00h,0f8h,00h,0f8h,00h,00h,00h,   00h,00h,0fch,00h,0fch,00h,00h,00h,    00h,00h,0feh,00h,0feh,00h,00h,00h,   00h,00h,0ffh,00h,0ffh,00h,00h,00h
;thanh_3
org 2700h
HU1_7: DB 03h,00h,00h,80h,03h,00h,00h,80h,   07h,00h,00h,0c0h,07h,00h,00h,0c0h,   0fh,00h,00h,0e0h,0fh,00h,00h,0e0h,   1fh,00h,00h,0f0h,1fh,00h,00h,0f0h,   3fh,00h,00h,0f8h,3fh,00h,00h,0f8h,   7fh,00h,00h,0fch,7fh,00h,00h,0fch
org 2800h
HU2_7: DB 0ffh,00h,00h,0feh,0ffh,00h,00h,0feh,   0ffh,00h,00h,0ffh,0ffh,00h,00h,0ffh,   7fh,00h,00h,0feh,0ffh,01h,80h,0ffh,   3fh,00h,00h,0fch,0ffh,03h,0c0h,0ffh,   1fh,00h,00h,0f8h,0ffh,07h,0e0h,0ffh,   0fh,00h,00h,0f0h,0ffh,0fh,0f0h,0ffh
org 2900h
HU3_7: DB 07h,00h,00h,0e0h,0ffh,1fh,0f8h,0ffh,   03h,00h,00h,0c0h,0ffh,3fh,0fch,0ffh,   01h,00h,00h,80h,0ffh,7fh,0feh,0ffh,   00h,00h,00h,00h,0ffh,0ffh,0ffh,0ffh,   00h,00h,00h,00h,0ffh,0ffh,0ffh,0ffh,   00h,00h,00h,00h,0ffh,0ffh,0ffh,0ffh
org 2A00h
HU4_7: DB 00h,00h,00h,00h,0ffh,0ffh,0ffh,0ffh,   0ffh,0ffh,0ffh,0ffh,00h,00h,00h,00h,   0ffh,0ffh,0ffh,0ffh,00h,00h,00h,00h,   0ffh,0ffh,0ffh,0ffh,00h,00h,00h,00h,   0ffh,0ffh,0ffh,0ffh,00h,00h,00h,00h,   00h,00h,00h,00h,0ffh,0ffh,0ffh,0ffh
org 2B00h
HU5_7: DB 00h,00h,00h,00h,0ffh,0ffh,0ffh,0ffh,   00h,00h,00h,00h,0ffh,0ffh,0ffh,0ffh,  00h,00h,00h,00h,0ffh,0ffh,0ffh,0ffh,   0ffh,0ffh,0ffh,0ffh,00h,00h,00h,00h,   0ffh,0ffh,0ffh,0ffh,00h,00h,00h,00h,     0ffh,0ffh,0ffh,0ffh,00h,00h,00h,00h
org 2C00h
HU6_7: DB 0ffh,0ffh,0ffh,0ffh,00h,00h,00h,00h,   00h,00h,00h,00h,0ffh,0ffh,0ffh,0ffh,   00h,00h,00h,00h,0ffh,0ffh,0ffh,0ffh,    00h,00h,00h,00h,0ffh,0ffh,0ffh,0ffh,   00h,00h,00h,00h,0ffh,0ffh,0ffh,0ffh
;====================================================================
;Thuan_1
org 2D00h
HU1_8: DB 01h,00h,00h,00h,03h,00h,00h,80h,   03h,00h,00h,80h,07h,00h,00h,0c0h,   07h,00h,00h,0c0h,0fh,00h,00h,0e0h,    0eh,00h,00h,0e0h,1fh,00h,00h,0f0h,   01Ch,00h,00h,70h,3fh,00h,00h,0f8h,   38h,00h,00h,38h,7fh,00h,00h,0fch
org 2E00h
HU2_8: DB 70h,00h,00h,1ch,0ffh,00h,00h,0feh,   0e0h,00h,00h,0eh,0ffh,00h,00h,0ffh,  0c0h,01h,00h,07h,0ffh,01h,80h,0ffh,   80h,03h,80h,03h,0ffh,03h,0c0h,0ffh,   00h,07h,0c0h,01h,0ffh,07h,0e0h,0ffh,   00h,0eh,0e0h,00h,0ffh,0fh,0f0h,0ffh
org 2F00h
HU3_8: DB 00h,1ch,70h,00h,0ffh,1fh,0f8h,0ffh,  00h,38h,38h,00h,0ffh,3fh,0fch,0ffh,   00h,70h,1ch,00h,0ffh,7fh,0feh,0ffh,   00h,0e0h,0eh,00h,0ffh,0ffh,0ffh,0ffh,   00h,0c0h,07h,00h,0ffh,0ffh,0ffh,0ffh,   00h,80h,03h,00h,0ffh,0ffh,0ffh,0ffh
org 3000h
HU4_8: DB 03h,00h,00h,80h,01h,00h,00h,00h,   07h,00h,00h,0c0h,03h,00h,00h,80h,   0fh,00h,00h,0e0h,07h,00h,00h,0c0h,    1fh,00h,00h,0f0h,0eh,00h,00h,0e0h,   3fh,00h,00h,0f8h,01Ch,00h,00h,70h,   7fh,00h,00h,0fch,38h,00h,00h,38h
org 3100h
HU5_8: DB 0ffh,00h,00h,0feh,70h,00h,00h,1ch,   0ffh,00h,00h,0ffh,0e0h,00h,00h,0eh,  0ffh,01h,80h,0ffh,0c0h,01h,00h,07h,   0ffh,03h,0c0h,0ffh,80h,03h,80h,03h,   0ffh,07h,0e0h,0ffh,00h,07h,0c0h,01h,   0ffh,0fh,0f0h,0ffh,00h,0eh,0e0h,00h
org 3200h
HU6_8: DB 0ffh,1fh,0f8h,0ffh,00h,1ch,70h,00h,  0ffh,3fh,0fch,0ffh,00h,38h,38h,00h,   0ffh,7fh,0feh,0ffh,00h,70h,1ch,00h,   0ffh,0ffh,0ffh,0ffh,00h,0e0h,0eh,00h,   0ffh,0ffh,0ffh,0ffh,00h,0c0h,07h,00h, 0ffh,0ffh,0ffh,0ffh,00h,80h,03h,00h
;====================================================================
;Thuan_2
org 3300h
HU1_9: DB 0FFh,0FFh,00h,00h,00h,00h,00h,00h,   0FFh,0FFh,0FFh,0FFh,00h,00h,00h,00h,   0FFh,0FFh,0FFh,0FFh,0FFh,0FFh,00h,00h,   00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,   00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,   00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh
org 3400h
HU2_9: DB 00h,00h,01h,00h,00h,00h,01h,00h,   00h,80h,03h,00h,00h,80h,03h,00h,   00h,0c0h,07h,00h,00h,0c0h,07h,00h,   00h,0e0h,0eh,00h,00h,0e0h,0eh,00h,  00h,70h,1ch,00h,00h,70h,1ch,00h,   00h,38h,38h,00h,00h,38h,38h,00h
org 3500h
HU3_9: DB 00h,1ch,70h,00h,00h,1ch,70h,00h,   00h,0eh,0e0h,00h,00h,0eh,0e0h,00h,  00h,07h,0c0h,01h,00h,07h,0c0h,01h,   80h,03h,80h,03h,80h,03h,80h,03h,   0c0h,01h,00h,07h,0c0h,01h,00h,07h,   0e0h,00h,00h,0eh,0e0h,00h,00h,0eh
org 3600h
HU4_9: DB 70h,00h,00h,1ch,70h,00h,00h,1ch,   38h,00h,00h,38h,38h,00h,00h,38h,   01Ch,00h,00h,70h,01Ch,00h,00h,70h,   0eh,00h,00h,0e0h,0eh,00h,00h,0e0h,   07h,00h,00h,0c0h,07h,00h,00h,0c0h,   03h,00h,00h,80h,03h,00h,00h,80h
org 3700h
HU5_9: DB 00h,00h,01h,00h,00h,00h,01h,00h,   00h,80h,03h,00h,00h,80h,03h,00h,   00h,0c0h,07h,00h,00h,0c0h,07h,00h,   00h,0e0h,0eh,00h,00h,0e0h,0eh,00h,  00h,70h,1ch,00h,00h,70h,1ch,00h,   00h,38h,38h,00h,00h,38h,38h,00h
org 3800h
HU6_9: DB 00h,1ch,70h,00h,00h,1ch,70h,00h,   00h,0eh,0e0h,00h,00h,0eh,0e0h,00h,  00h,07h,0c0h,01h,00h,07h,0c0h,01h,   80h,03h,80h,03h,80h,03h,80h,03h,   0c0h,01h,00h,07h,0c0h,01h,00h,07h;,   0e0h,00h,00h,0eh,0e0h,00h,00h,0eh

;===================================================================
;Thuan_3
org 3900h
HU1_10: DB 00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,   00h,00h,00h,0FFh,0FFh,0FFh,00h,00h,   00h,00h,0FFh,0FFh,0FFh,00h,00h,00h,   00h,0FFh,0FFh,0FFh,00h,00h,00h,00h,   0FFh,0FFh,0FFh,00h,00h,00h,00h,00h,   0FFh,0FFh,00h,00h,00h,00h,00h,00h
org 3A00h
HU2_10: DB 0FFh,00h,00h,00h,00h,00h,00h,00h,   0FFh,0FFh,00h,00h,00h,00h,00h,00h,   0FFh,0FFh,0FFh,00h,00h,00h,00h,00h,   00h,0FFh,0FFh,0FFh,00h,00h,00h,00h,   00h,00h,0FFh,0FFh,0FFh,00h,00h,00h,   00h,00h,00h,0FFh,0FFh,0FFh,00h,00h
org 3B00h
HU3_10: DB 00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,   00h,00h,00h,0FFh,0FFh,0FFh,00h,00h,   00h,00h,0FFh,0FFh,0FFh,00h,00h,00h,   00h,0FFh,0FFh,0FFh,00h,00h,00h,00h,   0FFh,0FFh,0FFh,00h,00h,00h,00h,00h,   0FFh,0FFh,00h,00h,00h,00h,00h,00h
org 3C00h
HU4_10: DB 0FFh,00h,00h,00h,00h,00h,00h,00h,   0FFh,0FFh,00h,00h,00h,00h,00h,00h,   0FFh,0FFh,0FFh,00h,00h,00h,00h,00h,   00h,0FFh,0FFh,0FFh,00h,00h,00h,00h,   00h,00h,0FFh,0FFh,0FFh,00h,00h,00h,   00h,00h,00h,0FFh,0FFh,0FFh,00h,00h
org 3D00h
HU5_10: DB 00h,00h,00h,00h,0FFh,0FFh,0FFh,0FFh,   00h,00h,00h,0FFh,0FFh,0FFh,00h,00h,   00h,00h,0FFh,0FFh,0FFh,00h,00h,00h,   00h,0FFh,0FFh,0FFh,00h,00h,00h,00h,   0FFh,0FFh,0FFh,00h,00h,00h,00h,00h,   0FFh,0FFh,00h,00h,00h,00h,00h,00h
org 3E00h
HU6_10: DB 0FFh,00h,00h,00h,00h,00h,00h,00h,   0FFh,0FFh,00h,00h,00h,00h,00h,00h,   0FFh,0FFh,0FFh,00h,00h,00h,00h,00h,   00h,0FFh,0FFh,0FFh,00h,00h,00h,00h,   00h,00h,0FFh,0FFh,0FFh,00h,00h,00h,   00h,00h,00h,0FFh,0FFh,0FFh,00h,00h
;===================================================================
END
