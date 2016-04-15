XSEF	;GRI,,,;10:03 AM  6 Dec 2007;
	;=======================================================
	; Virgo Accounts - Remove Detailed Time
	;
	; Copyright Graham R Irwin 1993-1995
	;
	; Screens:       1058

	; Files updated: ^TE
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, DMY2H^DATE
	;
	;=======================================================

	D X0^XSXS
	S %S=1058 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSEF Q
	S %DAT=A1 D DMY2H^DATE S A2=%H

E09	W /C(0,22),@P1,"Update or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) G XSEF
	I X="U" G D01
	G E09

	;Remove transactions
D01	S (X3,X4)=""
D02	S X3=$O(^TE(CX,MX,X3)) I X3="" G XSEF
D03	S X4=$O(^TE(CX,MX,X3,X4)) I X4="" G D02
	S TE=^TE(CX,MX,X3,X4),%DAT=$p(TE,%,1) D DMY2H^DATE S D2=%H
	I A2'<D2 K ^TE(CX,MX,X3,X4)
	G D03

	;Validation - Matter code
V01	Q:$D(ERR)  I '$d(^TE(CX,X)) S ERR="No details for this matter"
	Q

CASE	S X=$zconvert(X,"U") Q
