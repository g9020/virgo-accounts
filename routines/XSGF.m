XSGF	;GRI,,,;05:36 PM  18 Dec 2000;
	;=======================================================
	; Virgo Accounts - Maintain Standing Entries
	;
	; Copyright Graham R Irwin 1999-2000
	;
	; Screens:       1075
	; Files updated: ^SO ^SX
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, DMY2H^DATE
	;
	;=======================================================

	D X0^XSXS
	L ^SO
	S VAT=^SZ("VAT")/100,ONE=$g(^SZ("DOC"),1),TT="STO",NEW=0,AMD=0
	S %J=1,%S=1075 D ^INPUT Q:X[%
	I $D(^SO(X)) G D01

	W /C(48,4),"* NEW RECORD *",! S NEW=1
	F %J=2:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSGF

E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX,CASE G XSGF:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	S %DAT=D1 D DMY2H^DATE
	I NEW S XH=%H
	I 'NEW,D1X'=D1 K ^SX(XH,D0) S XH=%H
	S ^SO(D0)=D1_%_D2_%_D3_%_D4_%_DX_%_O2_%_O3_%_O4_%_AX_%_O5_%_XH_%
	S ^SX(XH,D0)=""
	G XSGF

	;Display
D01	S SO=^SO(D0),(D1,D1X)=$P(SO,%,1),D2=$P(SO,%,2),D3=$P(SO,%,3),D4=$P(SO,%,4),DX=$P(SO,%,5),O2=$P(SO,%,6),O3=$P(SO,%,7),O4=$P(SO,%,8),AX=$P(SO,%,9),O5=$P(SO,%,10),XH=$p(SO,%,11),E2=$j(O2+O3,0,2),AMD=0
D02	F %J=2:1 D D^INPUT Q:X="END"
D03	W /C(0,22),@P1,"Amend, Delete or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) G XSGF:'AMD W @P1,"  Quit without update ? ",@P2 D ^GETX,CASE G XSGF:X="Y",D03
	I X="A" G A01
	I X="D" W @P1,"  Are you sure ? ",@P2 D ^GETX,CASE I X="Y" K ^SO(D0) D KSX G XSGF
	G D03

	;Amend
A01	S AMD=1 W /C(0,5),/EF F %J=2:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSGF:%J=2,A01
	G E02

	;Validation - End date
V01	I $d(ERR) Q
	S %DAT=X D DMY2H^DATE S XX=%H,%DAT=D1 D DMY2H^DATE
	I XX<%H S ERR="Cannot be earlier than start date" Q
	Q
	;Payment/receipt
V02	D CASE
	I "PR"'[X S ERR="Must be 'P' or 'R'"
	Q
	;Frequency
V03	D CASE
	I X'?1.3N1U S ERR="Wrong format" Q
	I "DM"'[$e(X,$l(X)) S ERR="Must be days or months"
	Q
	;Net amount
V04	S E3=$J(X*VAT,0,2)
	Q
	;VAT amount
V05	I X="*" K ERR
	S E2=$J(O2+X,0,2)
	Q

CASE	S X=$zconvert(X,"U") Q

	;Kill off index entry
KSX	S (X1,X2)=""
KSX1	S X1=$o(^SX(X1)) I X1="" Q
KSX2	S X2=$o(^SX(X1,X2)) I X2="" G KSX1
	I X2=D0 K ^SX(X1,X2)
	G KSX2
