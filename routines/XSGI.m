XSGI	;GRI,,,;10:11 AM  16 Mar 1999
	;=======================================================
	; Virgo Accounts - Maintain Activity Codes
	;
	; Copyright Graham R Irwin 1993-1994
	;
	; Screens:       1044
	; Files updated: ^SA
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX
	;
	;=======================================================

	D X0^XSXS
	L ^SA
	S %J=1,%S=1044 D ^INPUT Q:X[%  I $D(^SA(X)) G D01
	W /C(48,4),"* NEW RECORD *",!
	F %J=2:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSGI
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX D CASE G XSGI:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	S ^SA(SX)=A1
	G XSGI

	;Display
D01	S SA=^SA(X),A1=$P(SA,%,1),A1X=A1,DEL=0,AMD=0,RX=""
D02	F %J=2:1 D D^INPUT Q:X="END"
	I SX["!" G D03
D2A	S RX=$o(^SR(RX)) I RX="" S DEL=1 G D03
	I $d(^SR(RX,SX)) G D03
	G D2A
D03	W /C(0,22),@P1,"Amend" W:DEL ", Delete" W " or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) G XSGI:'AMD W @P1,"  Quit without update ? ",@P2 D ^GETX D CASE G XSGI:X="Y",D03
	I X="A" G A01
	I X="D",DEL W @P1,"  Are you sure ? ",@P2 D ^GETX D CASE I X="Y" K ^SA(SX) G XSGI
	G D03

	;Amend
A01	S AMD=1 W /C(0,5),/EF F %J=2:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSGI:%J=2,A01
	G E02

CASE	S X=$zconvert(X,"U") Q
