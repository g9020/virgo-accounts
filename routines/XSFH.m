XSFH	;GRI,,,;11:38 AM  17 Nov 1996
	;=======================================================
	; Virgo Accounts - Post Client Interest
	;
	; Copyright Graham R Irwin 1993-1994
	;
	; Screens:	 1033
	; Files updated: ^CB ^CL ^SY ^AB ^AY
	; Subroutines:	 X0^XSXS, ^INPUT, ^GETX, YX^XSXS, UPAB^XSXS
	;
	;=======================================================

	S D5="Client Interest",TT="CLI",ONE=$g(^SZ("DOC"),1)
	D X0^XSXS
	S %S=1033 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSFH Q
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX D CASE G XSFH:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	S E5=D5_" - "_$p(^SC(CX),%,1),E5=$e(E5,1,70)
	D YX^XSXS S ^SY(DAT,TT,YX)=D1_%_CX_%_MX_%_DX1_%_D2_%_%_%_%_1_%_%_E5
	S ^CL(CX,MX,YX)=D1_%_%_D2_%_TT_%_D4_%_D5_%
	S B1=B1+D2,^CL(CX,MX)=B1_%_0_%_DAT_%
	S ^CB(DX1,YX)=D1_%_%_D2_%_TT_%_D4_%_E5_%_"N"_%
	S CB=^CB(DX1),B1=$P(CB,%,1,5),B6=$P(CB,%,6)+D2,^CB(DX1)=B1_%_B6_%
	S ^CB(DX,YX)=D1_%_D2_%_%_TT_%_D4_%_E5_%_"N"_%
	S CB=^CB(DX),B1=$P(CB,%,1,5),B6=$P(CB,%,6)-D2,^CB(DX)=B1_%_B6_%
	S AX="L010" S:M5="Y" AX="L020" D UPAB^XSXS(AX,D2,D1,TT,D4,E5)
	D UPAB^XSXS("A130",-D2,D1,TT,D4,E5)
	D UPAB^XSXS("E340",D2,D1,TT,D4,E5)
	G XSFH

	;Amend
A01	W /C(0,4),/EF F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSFH:%J=1,A01
	G E02

	;Validation - Matter code
V01	Q:$D(ERR)  S SM=^SM(CX,X),M5=$P(SM,%,5),DX1=$P(SM,%,10)
	S ERR="NO CASHBOOK DEFINED FOR THIS MATTER" Q:DX1=""  Q:'$D(^CB(DX1))  K ERR
	I '$D(^CL(CX,X)) S ERR="No client account defined for this matter" Q
	S CL=^CL(CX,X),B1=$J($P(CL,%,1),0,2),B2=$J($P(CL,%,2),0,2),B3=$P(CL,%,3) Q
	;CL Balance
V02	I M5="Y" W @P3,?48,"Trust Matter"
	Q
	;From cashbook
V03	I X>99 S ERR="Must be an office cashbook"
	Q

CASE	S X=$zconvert(X,"U") Q 
