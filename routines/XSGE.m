XSGE	;GRI,,,;12:45 PM  12 May 1999
	;=======================================================
	; Virgo Accounts - Maintain Cashbooks
	;
	; Copyright Graham R Irwin 1993-99
	;
	; Screens:       1030
	; Files updated: ^CB ^CA ^SEARCH
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX
	;
	;=======================================================

	D X0^XSXS
	L ^CB
	S (C4,NO)="N"
	S %J=1,%S=1030 D ^INPUT Q:X[%
	I $D(^CB(X)) G D01

	W /C(48,4),"* NEW RECORD *",!
	F %J=2:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSGE

	S (C5,C6)=0
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX,CASE G XSGE:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	S ^CB(DX)=C1_%_C2_%_C3_%_C4_%_C5_%_C6_%
	S C1L=$zconvert(C1,"L"),^SEARCH("CB",C1L,DX)=""
	I $d(C1X) S C1XL=$zconvert(C1X,"L") I C1L'=C1XL K ^SEARCH("CB",C1XL,DX)
	G XSGE

	;Display
D01	S CB=^CB(DX),C1=$P(CB,%,1),C2=$P(CB,%,2),C3=$P(CB,%,3),C4=$P(CB,%,4),C5=$P(CB,%,5),C6=$P(CB,%,6),C1X=C1,DEL=0,AMD=0,REM=0
	;allow deletion if balance is zero, there are no transactions other
	;than a balance forward trans. and it is not cashbook 1, 100 or 101
	I C6=0,$o(^CB(DX,0))="",DX'=1,DX'=100,DX'=101 S DEL=1
	I $d(^CA(DX)) S REM=1
D02	F %J=2:1 D D^INPUT Q:X="END"
D03	W /C(0,22),@P1,"Amend" W:DEL ", Delete" W:REM ", Remove" W " or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) G XSGE:'AMD W @P1,"  Quit without update ? ",@P2 D ^GETX,CASE G XSGE:X="Y",D03
	I X="A" G A01
	I X="D",DEL W @P1,"  Are you sure ? ",@P2 D ^GETX,CASE I X="Y" K ^CB(DX),^CA(DX),^SEARCH("CB",$zconvert(C1,"L"),DX) G XSGE
	I X="R",REM W @P1,"  Are you sure ? ",@P2 D ^GETX,CASE I X="Y" K ^CA(DX) G XSGE
	G D03

	;Amend
A01	S AMD=1 W /C(0,5),/EF F %J=2:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSGE:%J=2,A01
	G E02

	;Validation - Trust account
V01	D CASE I "YN"'[X S ERR="Must be 'Y' or 'N'" Q
	I DX<100,X'="N" S ERR="Must be 'N'" Q
	I %I,C4'=X S ERR="May not be amended"
	Q

CASE	S X=$zconvert(X,"U") Q
