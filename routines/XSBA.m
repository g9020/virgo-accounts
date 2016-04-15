XSBA	;GRI,,,;09:52 AM  16 Feb 2003
	;=======================================================
	; Virgo Accounts - Post Disbursement Item
	;
	; Copyright Graham R Irwin 1993-2003
	;
	; Screens:       1004
	; Files updated: ^ML ^CB ^SY ^SV ^AB ^AY
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, YX^XSXS
	;                UPAB^XSXS, CHEQUE
	;
	;=======================================================

	D X0^XSXS
	S E5="Disbursement",TT="DIS",VAT=^SZ("VAT")/100,ONE=$g(^SZ("DOC"),1)
	S %S=1004 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSBA G QUIT
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX D CASE G XSBA:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	S E5=D5_" - "_$p(^SC(CX),%,1),E5=$e(E5,1,70)
	D YX^XSXS S ^SY(DAT,TT,YX)=D1_%_CX_%_MX_%_DX_%_D2_%_D3_%_%_%_%_D4_%_E5
	S ^ML(CX,MX,YX)=D1_%_%_D2_%_TT_%_D4_%_%_D5_%
	S ML=$G(^ML(CX,MX)),B1=$P(ML,%,1)+D2,B2=$P(ML,%,2,9),^ML(CX,MX)=B1_%_B2

	S ^CB(DX,YX)=D1_%_E2_%_%_TT_%_D4_%_E5_%_"N"_%
	S CB=^CB(DX),B1=$P(CB,%,1,5),B6=$P(CB,%,6)-E2,^CB(DX)=B1_%_B6_%

	;Update VAT records
	I D3="*"!(^SZ("VCB")="X") G NV1
	S SV=$G(^SV),V1=$P(SV,%,1)+D2,V2=$P(SV,%,2)+D3,V3=$P(SV,%,3,99),^SV=V1_%_V2_%_V3,^SV("P"_YX)="Disbm't"_%_D1_%_D2_%_D3
	D UPAB^XSXS("L040",-D3,D1,TT,D4,E5)

NV1	D UPAB^XSXS("A120",D2,D1,TT,D4,E5)
	D UPAB^XSXS("N060",D2,D1,TT,D4,E5)
	D UPAB^XSXS("A130",-E2,D1,TT,D4,E5)
	;Write cheque
	D ^CHEQUE(DX,CX,MX,D1,E2,D4,E5,TT)
	G XSBA

	;Amend
A01	W /C(0,4),/EF F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSBA:%J=1,A01
	G E02

QUIT	
	Q

	;Validation - Net amount
V01	S M6=$P(^SM(CX,MX),%,6),E1=$J(X*VAT*(M6="Y"),0,2)
	Q
	;VAT amount
V02	I X="*" K ERR
	I X<0,D2>0 S ERR="Must be a positive amount" Q
	I X>0,D2<0 s ERR="Must be a negative amount" Q
	S E2=$J(D2+X,0,2)
	Q
	;Cashbook
V03	Q:$D(ERR)  I X>99 S ERR="Must be an office cashbook" Q
	S B6=$J($P(^CB(X),%,6),0,2)
	Q

CASE	S X=$zconvert(X,"U") Q
