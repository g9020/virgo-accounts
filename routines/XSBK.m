XSBK	;GRI,,,;10:17 AM  7 Jan 1998
	;=======================================================
	; Virgo Accounts - Disbursement Receipt
	;
	; Copyright Graham R Irwin 1993-98
	;
	; Screens:       1053
	; Files updated: ^CB ^ML ^SY ^AB ^AY
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, YX^XSXS, UPAB^XSXS
	;
	;=======================================================

	S E5="Disbursement Receipt",TT="DSP",ONE=$g(^SZ("DOC"),1)
	D X0^XSXS
	S %S=1053 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSBK Q
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX,CASE G XSBK:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	S E5=D5_" - "_$p(^SC(CX),%,1),E5=$e(E5,1,70)
	D YX^XSXS S ^SY(DAT,TT,YX)=D1_%_CX_%_MX_%_DX_%_D2_%_%_%_%_%_D4_%_E5
	S ^ML(CX,MX,YX)=D1_%_D2_%_%_TT_%_D4_%_%_D5_%
	S ML=$G(^ML(CX,MX)),B1=$P(ML,%,1)-D2,B2=$P(ML,%,2,9),^ML(CX,MX)=B1_%_B2
	S ^CB(DX,YX)=D1_%_%_D2_%_TT_%_D4_%_E5_%_"N"_%
	S CB=^CB(DX),B1=$p(CB,%,1,5),B6=$p(CB,%,6)+D2,^CB(DX)=B1_%_B6_%
	D UPAB^XSXS("A120",-D2,D1,TT,D4,E5)
	D UPAB^XSXS("A130",D2,D1,TT,D4,E5)
	D UPAB^XSXS("N070",D2,D1,TT,D4,E5)
	G XSBK

	;Amend
A01	W /C(0,4),/EF F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSBK:%J=1,A01
	G E02

	;Validation - Amount
V01	S ML=$g(^ML(CX,MX)),B1=$p(ML,%,1)
	I X>B1 W @P3,?48,"Disbursement Balance in Credit",*7
	Q

CASE	S X=$zconvert(X,"U") Q
