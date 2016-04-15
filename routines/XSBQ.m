XSBQ	;GRI,,,;01:12 PM  11 May 2004;
	;=======================================================
	; Virgo Accounts - Nominal to Bill Transfer
	;
	; Copyright Graham R Irwin 1998-2004
	;
	; Screens:       1065, 1084, 1085
	; Files updated: ^SY ^ML ^AB ^AY
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, YX^XSXS,
	;                UPAB^XSXS, ^XSBA, ^XSBF & ^XSBJ validation routines
	;
	;=======================================================

	S TT="N2B",F5="Nominal to Bill Transfer",VAT=^SZ("VAT")/100
	D X0^XSXS
	W @P1,?8,"TRANSFER FROM (credit) -------------",!
	S %S=1065 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSBQ Q
	S %S=1084 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSBQ

	W @P1,!?8,"TRANSFER TO (debit) ----------------",!
	S %S=1085 F %J=1:1 D ^INPUT Q:X="END"!(X[%) 
	I X[% G XSBQ

E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX,CASE
o	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX,CASE G XSBQ:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	D YX^XSXS S ^SY(DAT,TT,YX)=D1_%_"Acct:"_%_AX1_%_%_D2_%_D3_%_CX_%_MX_%_%_%_O5
	S X1=$e(AX1,1),O3=E2 I "LI"[X1 S O3=-E2
	;from NL account
	D UPAB^XSXS(AX1,-O3,D1,TT,"",O5)

	S ^ML(CX,MX,YX)=D1_%_E2_%_%_TT_%_D4_%_%_O5_%
	S ML=$G(^ML(CX,MX)),M1=$P(ML,%,1),M2=$P(ML,%,2),M2=M2-E2,^ML(CX,MX)=M1_%_M2

	D UPAB^XSXS("A110",-E2,D1,TT,D4,O5)

	;Update bill register (it may be a reverse transfer)
	S BB8=BB8-E2 S:BB8<0 BB8=0 S BB9="P" S:'BB8 BB9="F" S:BB8=(BB4+BB5+BB6) BB9="U"
	S ^SB(BX)=BB1_%_CX_%_MX_%_BB4_%_BB5_%_BB6_%_BB7_%_BB8_%_BB9_%_BB10_%
	I BB9="F" K ^SU(BX)
	I BB9="U"!(BB9="P") S ^SU(BX)=""

	;Update VAT records if cash basis
	I ^SZ("VCB")'="Y" G NV1
	S SV=$G(^SV),V1=$P(SV,%,1),V2=$p(SV,%,2),V3=$P(SV,%,3)+D2,V4=$P(SV,%,4)+D3,^SV=V1_%_V2_%_V3_%_V4,^SV(YX)=BX_%_D1_%_D2_%_D3
	D UPAB^XSXS("L040",D3,D1,TT,D4,O5)
	D UPAB^XSXS("L140",-D3,D1,TT,D4,O5)

NV1	G XSBQ

	;Amend
A01	W /C(0,5),/EF
	S %S=1065 F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSBQ:%J=1,A01
	S %S=1084 F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G A01

	W @P1,!?8,"TRANSFER TO (debit) ----------------",!
	S %S=1085 F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G A01
	G E02

CASE	S X=$zconvert(X,"U") Q

	;Validation - Net amount
V01	S E1=$J(X*VAT,0,2)
	Q

	;Bill number
V03	Q:$D(ERR)  S SB=^SB(X),BB1=$P(SB,%,1),CX=$P(SB,%,2),MX=$P(SB,%,3),BB4=$P(SB,%,4),BB5=$P(SB,%,5),BB6=$J($P(SB,%,6),0,2),BB7=$P(SB,%,7),BB8=$J($P(SB,%,8),0,2),BB9=$P(SB,%,9),BB10=$P(SB,%,10),R2=$J(BB4+BB5,0,2)
	I BB9="F",-D2>(BB4+BB5+BB6) S ERR="Repayment cannot exceed original bill amount" Q
	I E2>BB8 S ERR="Payment cannot exceed outstanding bill amount" Q
	; VAT amount cannot exceed original VAT amount
	I BB10="Y" W @P3,?48,"Includes Unpaid Prof Disb"
	S D4=X
	Q
