XSGK	;GRI,,,;04:43 PM  16 Jan 1995;
	;=======================================================
	; Virgo Accounts - Input Historic Bills
	;
	; Copyright Graham R Irwin 1993-95
	;
	; Screens:       1056
	; Files updated: ^SB
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX
	;
	;=======================================================

	S H2="Input Historic Bills",DFF="F",NIL="0.00"
	D X0^XSXS
	S %S=1056,%J=1 D ^INPUT Q:X[%
	I $D(^SB(X)) G D01
	W /C(48,4),"* NEW RECORD *",!
	S B7=0,B10="N"
	F %J=2:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSGK
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX D CASE G XSGK:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	S ^SB(BX)=B1_%_B2_%_B3_%_B4_%_B5_%_B6_%_B7_%_B8_%_B9_%_B10
	G XSGK

	;Display
D01	S SB=^SB(X),B1=$p(SB,%,1),B2=$p(SB,%,2),B3=$p(SB,%,3),B4=$p(SB,%,4),B5=$p(SB,%,5),B6=$p(SB,%,6),B7=$p(SB,%,7),B8=$p(SB,%,8),B9=$p(SB,%,9),B10=$p(SB,%,10)
	S AMD=0,E0=$j(B4+B5+B6,0,2)
D02	F %J=2:1 D D^INPUT Q:X="END"
D03	W /C(0,22),@P1,"Amend, Delete or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) G XSGK:'AMD W @P1,"  Quit without update ? ",@P2 D ^GETX D CASE G XSGK:X="Y",D03
	I X="A" G A01
	I X="D" W @P1,"  Are you sure ? ",@P2 D ^GETX D CASE I X="Y" K ^SB(BX) G XSGK
	G D03

	;Amend
A01	S AMD=1 W /C(0,5),/EF F %J=2:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSGK:%J=2,A01
	G E02

QUIT	Q

	;Validation -----------------------------------
	;VAT amount
V01	S E0=$j(B4+B5+X,0,2) Q

CASE	S X=$zconvert(X,"U") Q
