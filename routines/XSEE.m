XSEE	;GRI,,,;02:25 PM  3 Nov 1994;
	;=======================================================
	; Virgo Accounts - Remove Historic Time
	;
	; Copyright Graham R Irwin 1993-1994
	;
	; Screens:       1040
	; Files updated: ^TE
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, YX^XSXS, UPAB^XSXS
	;
	;=======================================================

	D X0^XSXS
	S %S=1040 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSEE Q
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX D CASE G XSEE:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	

	G XSEE

	;Amend
A01	W /C(0,4),/EF F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSEE:%J=1,A01
	G E02

	;Validation - Client code
V01	I X="*" K ERR
	Q:$d(ERR)
	Q

CASE	S X=$zconvert(X,"U") Q
