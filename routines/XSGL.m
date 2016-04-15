XSGL	;GRI,,,;10:21 AM  19 Aug 2003;
	;=======================================================
	; Virgo Accounts - Post ML Correction (one-sided ML entry)
	;
	; Copyright Graham R Irwin 1993-2003
	;
	; Screens:       1080
	; Files updated: ^ML ^SY
	; Subroutines:   X0^XSXS, ^INPASSW, ^INPUT, ^GETX, YX^XSXS
	;
	;=======================================================

	S H2="Matter Ledger Correction",A4="Adjustment/correction"
	D X0^XSXS W @P1
	D ^INPASSW I x'="WOZZAP" Q
	S %S=1080 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSGL Q
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX,CASE G XSGL:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	D YX^XSXS S ^SY(DAT,TT,YX)=DAT_%_CX_%_MX_%_%_A2_%_%_%_%_%_%_A5
	S ^ML(CX,MX,YX)=DAT_%_%_A2_%_TT_%_%_%_A5
	Q

	;Amend
A01	W /C(0,4),/EF F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSGL:%J=1,A01
	G E02

	;Validation - Matter
V02	Q:$D(ERR)  I '$D(^ML(CX,X)) S ERR="No ledger details for this matter" Q
	S ML=^ML(CX,X),E1=$j($p(ML,%,1),0,2),E2=$j($p(ML,%,2),0,2)
	Q

	;Disb/bill
V03	I "DB"'[X S ERR="Must be 'D' or 'B'"
	S TT="DIS" I X="B" S TT="BIL"
	Q

CASE	S X=$zconvert(X,"U") Q
