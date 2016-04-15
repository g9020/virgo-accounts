XSFE	;GRI,,,;01:47 PM  3 Nov 1994
	;=======================================================
	; Virgo Accounts - Client to Client Transfer
	;
	; Copyright Graham R Irwin 1993-1994
	;
	; Screens:	 1029, 1051
	; Files updated: ^CB ^CL ^SY ^AB ^AY
	; Subroutines:	 X0^XSXS, ^INPUT, ^GETX, ^XSFX,
	;                YX^XSXS, UPAB^XSXS
	;
	;=======================================================

	S E5="Client-Client Transfer",TT="TCC"
	D X0^XSXS
	W @P1,?8,"TRANSFER FROM ----------------------",!
	S %S=1029 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSFE Q
	W @P1,!?8,"TRANSFER TO ------------------------",!
	S %S=1051 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSFE
E01	I DX1'=DX2 W !!?8,"Remember to instruct the bank to make the transfer"
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX D CASE G XSFE:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	D YX^XSXS S ^SY(DAT,TT,YX)=D1_%_CX1_%_MX1_%_DX1_%_D2_%_%_CX2_%_MX2_%_DX2_%_D4_%_D5
	S ^CL(CX1,MX1,YX)=D1_%_D2_%_%_TT_%_D4_%_D5_%
	S B11=B11-D2,^CL(CX1,MX1)=B11_%_B12
	S ^CL(CX2,MX2,YX)=D1_%_%_D2_%_TT_%_D4_%_D5_%
	S B21=B21+D2,^CL(CX2,MX2)=B21_%_B22
	I DX1=DX2 G XSFE
	S ^CB(DX1,YX)=D1_%_D2_%_%_TT_%_D4_%_D5_%_"N"_%
	S CB=^CB(DX1),B1=$P(CB,%,1,5),B6=$P(CB,%,6)-D2,^CB(DX1)=B1_%_B6_%
	S ^CB(DX2,YX)=D1_%_%_D2_%_TT_%_D4_%_D5_%_"N"_%
	S CB=^CB(DX2),B1=$P(CB,%,1,5),B6=$P(CB,%,6)+D2,^CB(DX2)=B1_%_B6_%
	I M15=M25 G XSFE
	S AX="L010" S:M15="Y" AX="L020" D UPAB^XSXS(AX,-D2,D1,TT,D4,D5)
	S AX="L010" S:M25="Y" AX="L020" D UPAB^XSXS(AX,D2,D1,TT,D4,D5)
	G XSFE

	;Amend
A01	W /C(0,5),/EF S %S=1029 F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSFE:%J=1,A01
	W @P1,!?8,"TRANSFER TO ------------------------",!
	S %S=1051 F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G A01
	G E01

	;Validation - From matter code
V01	Q:$D(ERR)  S SM=^SM(CX1,X),M15=$P(SM,%,5),DX1=$P(SM,%,10)
	S ERR="No cashbook defined for this matter" Q:DX1=""  Q:'$D(^CB(DX1))  K ERR
	S CL=$G(^CL(CX1,X)),B11=$J($P(CL,%,1),0,2),B12=$P(CL,%,2,9) Q
	;CL Balance
V09	I M15="Y" W @P3,?48,"Trust Matter"
	Q
	;To matter code
V04	Q:$D(ERR)  S SM=^SM(CX2,X),M25=$P(SM,%,5),DX2=$P(SM,%,10)
	S ERR="No cashbook defined for this matter" Q:DX2=""  Q:'$D(^CB(DX2))  K ERR
	I CX1=CX2,MX1=X S ERR="Cannot be the same matter" Q
	S CL=$G(^CL(CX2,X)),B21=$J($P(CL,%,1),0,2),B22=$P(CL,%,2,9) Q
	;CL Balance
V05	I M25="Y" W @P3,?48,"Trust Matter"
	Q

CASE	S X=$zconvert(X,"U") Q
