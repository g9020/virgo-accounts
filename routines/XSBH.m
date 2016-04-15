XSBH	;GRI,,,;11:48 AM  6 Jun 2002
	;=======================================================
	; Virgo Accounts - Cashbook Transfer
	;
	; Copyright Graham R Irwin 1993-2002
	;
	; Screens:       1011, 1049
	; Files updated: ^CB ^SY
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, YX^XSXS
	;
	;=======================================================

	D X0^XSXS
	S E1=1,E5="Cashbook Transfer",TT="TOO",ONE=$g(^SZ("DOC"),1)
	W @P1,?8,"TRANSFER FROM ----------------------",!
	S %S=1011 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSBH Q
	W @P1,!?8,"TRANSFER TO ------------------------",!
	S %S=1049 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSBH

E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX,CASE G XSBH:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	D YX^XSXS S ^SY(DAT,TT,YX)=O1_%_%_%_DX_%_O2_%_%_%_%_DX2_%_O4_%_O5
	S ^CB(DX,YX)=O1_%_O2_%_%_TT_%_O4_%_O5_%_"N"_%
	S CB=^CB(DX),B1=$P(CB,%,1,5),B6=$P(CB,%,6)-O2,^CB(DX)=B1_%_B6_%
	S ^CB(DX2,YX)=O1_%_%_O2_%_TT_%_O4_%_O5_%_"N"_%
	S CB=^CB(DX2),B1=$P(CB,%,1,5),B6=$P(CB,%,6)+O2,^CB(DX2)=B1_%_B6_%
	G XSBH

	;Amend
A01	W /C(0,5),/EF S %S=1011 F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSBH:%J=1,A01
	W @P1,!?8,"TRANSFER TO ------------------------",!
	S %S=1049 F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G A01
	G E02

	;Validation - From cashbook
V03	Q:$D(ERR)  I X>99 S ERR="Must be an office cashbook" Q
	S B6=$j($p(^CB(X),%,6),0,2)
	Q
	;To cashbook
V06	Q:$D(ERR)  I X>99 S ERR="Must be an office cashbook" Q
	I X=DX S ERR="Cannot be the same account" Q
	S B6=$j($p(^CB(X),%,6),0,2)
	Q

CASE	S X=$zconvert(X,"U") Q
