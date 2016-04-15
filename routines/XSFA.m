XSFA	;GRI,,,;01:28 PM  3 Nov 1994
	;=======================================================
	; Virgo Accounts - Post Client Receipt
	;
	; Copyright Graham R Irwin 1993-1994
	;
	; Screens:	 1025
	; Files updated: ^CB ^CL ^SY ^AB ^AY
	; Subroutines:	 X0^XSXS, ^INPUT, ^GETX, YX^XSXS, UPAB^XSXS
	;
	;=======================================================

	D X0^XSXS
	S E5="Client Receipt",TT="CLR"

	i '$d(^CI),$g(^SZ("ADE"))'="N" w @P5,!?8,"Cannot post client money until Interest Rate Table is set up",!?8,"Please refer to your manual",!!?8,"Press any key to continue " R *X R:'X *X Q

	S %S=1025 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSFA Q
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX D CASE G XSFA:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	S E5=D5_" - "_$p(^SC(CX),%,1),E5=$e(E5,1,70)
	D YX^XSXS S ^SY(DAT,TT,YX)=D1_%_CX_%_MX_%_DX_%_D2_%_%_%_%_%_D4_%_E5
	S ^CL(CX,MX,YX)=D1_%_%_D2_%_TT_%_D4_%_D5_%
	S B1=B1+D2,^CL(CX,MX)=B1_%_B2
	S ^CB(DX,YX)=D1_%_%_D2_%_TT_%_D4_%_E5_%_"N"_%
	S CB=^CB(DX),B1=$P(CB,%,1,5),B6=$P(CB,%,6)+D2,^CB(DX)=B1_%_B6_%
	S AX="L010" S:M5="Y" AX="L020" D UPAB^XSXS(AX,D2,D1,TT,D4,E5)
	G XSFA

	;Amend
A01	W /C(0,4),/EF F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSFA:%J=1,A01
	G E02

	;Validation - Matter code
V01	Q:$D(ERR)  S SM=^SM(CX,X),M5=$P(SM,%,5),DX=$P(SM,%,10)
	S ERR="No cashbook defined for this matter" Q:DX=""  Q:'$D(^CB(DX))  K ERR
	S CL=$G(^CL(CX,X)),B1=$J($P(CL,%,1),0,2),B2=$P(CL,%,2,9) Q
	;CL Balance
V02	I M5="Y" W @P3,?48,"Trust Matter"
	Q

CASE	S X=$zconvert(X,"U") Q
