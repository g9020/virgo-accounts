XSFD	;GRI,,,;11:37 AM  17 Nov 1996
	;=======================================================
	; Virgo Accounts - Office to Client Transfer
	;
	; Copyright Graham R Irwin 1993-1994
	;
	; Screens:       1028
	; Files updated: ^CB ^CL ^ML ^SY ^AB ^AY
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, YX^XSXS, UPAB^XSXS
	;
	;=======================================================

	S E5="Office-Client Transfer",TT="TOC",ONE=$g(^SZ("DOC"),1)
	D X0^XSXS
	S %S=1028 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSFD Q
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX D CASE G XSFD:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	S E5=D5_" - "_$p(^SC(CX),%,1),E5=$e(E5,1,70)
	D YX^XSXS S ^SY(DAT,TT,YX)=D1_%_CX_%_MX_%_DX1_%_D2_%_%_%_%_%_D4_%_E5
	;update client ledger
	S ^CL(CX,MX,YX)=D1_%_%_D2_%_TT_%_D4_%_D5_%
	S CLB=$g(^CL(CX,MX)),CLB1=$p(CLB,%,1)+D2,CLB2=$p(CLB,%,2,9),^CL(CX,MX)=CLB1_%_CLB2
	;update to cashbook
	S ^CB(DX1,YX)=D1_%_%_D2_%_TT_%_D4_%_E5_%_"N"_%
	S CB=^CB(DX1),B1=$P(CB,%,1,5),B6=$P(CB,%,6)+D2,^CB(DX1)=B1_%_B6_%
	;update matter ledger
	S ^ML(CX,MX,YX)=D1_%_%_D2_%_TT_%_D4_%_%_D5_%
	S ML=$g(^ML(CX,MX)),M1=$p(ML,%,1)+D2,M2=$p(ML,%,2),^ML(CX,MX)=M1_%_M2
	;update from cashbook
	S ^CB(DX,YX)=D1_%_D2_%_%_TT_%_D4_%_E5_%_"N"_%
	S CB=^CB(DX),B1=$P(CB,%,1,5),B6=$P(CB,%,6)-D2,^CB(DX)=B1_%_B6_%
	;update nominal ledger
	S AX="L010" S:M5="Y" AX="L020" D UPAB^XSXS(AX,D2,D1,TT,D4,E5)
	D UPAB^XSXS("A130",-D2,D1,TT,D4,E5)
	D UPAB^XSXS("A120",D2,D1,TT,D4,E5)
	G XSFD

	;Amend
A01	W /C(0,4),/EF F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSFD:%J=1,A01
	G E02

	;Validation - Matter number
V01	Q:$D(ERR)  S SM=^SM(CX,X),M5=$P(SM,%,5),DX1=$P(SM,%,10)
	S ERR="No cashbook defined for this matter" Q:DX1=""  Q:'$D(^CB(DX1))  K ERR
	S MLB=$g(^ML(CX,X)),MLB1=$j($p(MLB,%,1),0,2),MLB2=$p(MLB,%,2,9) Q
	;CL Balance
V02	I M5="Y" W @P3,?48,"Trust Matter"
	Q
	;From Cashbook
V03	Q:$d(ERR)  I X>99 S ERR="Must be an office cashbook"
	Q

CASE	S X=$zconvert(X,"U") Q
