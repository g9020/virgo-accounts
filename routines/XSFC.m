XSFC	;GRI,,,;11:04 AM  12 Feb 2002
	;=======================================================
	; Virgo Accounts - Client to Office Transfer
	;
	; Copyright Graham R Irwin 1993-2002
	;
	; Screens:	 1027, 1048
	; Files updated: ^CB ^CL ^ML ^SY ^AB ^AY ^SB ^SD ^SV
	; Subroutines:	 X0^XSXS, ^INPUT, ^GETX, ^XSFX,
	;                YX^XSXS, UPAB^XSXS
	;
	;=======================================================

	S E5="Client-Office Transfer",NO="N",(BX,A2)="",ONE=$g(^SZ("DOC"),1)
	D X0^XSXS
	S %S=1027 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSFC Q
	I A1="N" G E02

	;If transfer is to pay a bill
	S %S=1048 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSFC

E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX D CASE G XSFC:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	S E5=D5_" - "_$p(^SC(CX),%,1),E5=$e(E5,1,70)
	S TT="COB" I A1="N" S TT="COD"
	D YX^XSXS S ^SY(DAT,TT,YX)=D1_%_CX_%_MX_%_DX1_%_D2_%_%_%_%_%_D4_%_E5

	S ^CL(CX,MX,YX)=D1_%_D2_%_%_TT_%_D4_%_D5_%
	S B1=B1-D2,^CL(CX,MX)=B1_%_B2

	S ^CB(DX1,YX)=D1_%_D2_%_%_TT_%_D4_%_E5_%_"N"_%
	S CB=^CB(DX1),B1=$P(CB,%,1,5),B6=$P(CB,%,6)-D2,^CB(DX1)=B1_%_B6_%

	S ^ML(CX,MX,YX)=D1_%_D2_%_%_TT_%_D4_%_%_D5_%
	S ML=$G(^ML(CX,MX)),M1=$P(ML,%,1),M2=$P(ML,%,2)
	S:A1="Y" M2=M2-D2 S:A1="N" M1=M1-D2 S ^ML(CX,MX)=M1_%_M2

	S ^CB(DX,YX)=D1_%_%_D2_%_TT_%_D4_%_E5_%_"N"_%
	S CB=^CB(DX),C1=$P(CB,%,1,5),C6=$P(CB,%,6)+D2,^CB(DX)=C1_%_C6_%

	S AX="L010" S:M5="Y" AX="L020" D UPAB^XSXS(AX,-D2,D1,TT,D4,E5)
	D UPAB^XSXS("A130",D2,D1,TT,D4,E5)
	I A1="N" D UPAB^XSXS("N070",D2,D1,TT,D4,E5)
	S AX="A110" S:A1="N" AX="A120" D UPAB^XSXS(AX,-D2,D1,TT,D4,E5)

	;If transfer is to pay a bill, update bill register
	;(it may be a reverse transfer)
	I A1="N" G XSFC
	S BB8=BB8-D2 S:BB8<0 BB8=0 S BB9="P" S:'BB8 BB9="F" S:BB8=(BB4+BB5+BB6) BB9="U"
	S ^SB(BX)=BB1_%_CX_%_MX_%_BB4_%_BB5_%_BB6_%_BB7_%_BB8_%_BB9_%_BB10_%
	I BB9="F" K ^SU(BX)
	I BB9="U"!(BB9="P") S ^SU(BX)=""

	;Update VAT records if cash basis
	I ^SZ("VCB")'="Y" G NV1
	S SV=$G(^SV),V1=$P(SV,%,1),V2=$p(SV,%,2),V3=$P(SV,%,3)+R2,V4=$P(SV,%,4)+R3,^SV=V1_%_V2_%_V3_%_V4,^SV(YX)=BX_%_D1_%_R2_%_R3
	D UPAB^XSXS("L040",R3,D1,TT,D4,E5)
	D UPAB^XSXS("L140",-R3,D1,TT,D4,E5)

NV1	G XSFC

	;Amend
A01	W /C(0,4),/EF S %S=1027 F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSFC:%J=1,A01
	I A1="N" G E02
	S R3=$g(R3),%S=1048 F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	G A01:X[%,E02

	;Validation - Matter number
V01	Q:$D(ERR)  S SM=^SM(CX,X),M5=$P(SM,%,5),DX1=$P(SM,%,10)
	S ERR="No cashbook defined for this matter" Q:DX1=""  Q:'$D(^CB(DX1))  K ERR
	S CL=$G(^CL(CX,X)),B1=$J($P(CL,%,1),0,2),B2=$P(CL,%,2,9)
	Q
	;CL Balance
V09	I M5="Y" W @P3,?48,"Trust Matter"
	Q
	;Bill number
V03	Q:$D(ERR)  S SB=^SB(X),BB1=$P(SB,%,1),BCX=$P(SB,%,2),BMX=$P(SB,%,3),BB4=$P(SB,%,4),BB5=$P(SB,%,5),BB6=$J($P(SB,%,6),0,2),BB7=$P(SB,%,7),BB8=$J($P(SB,%,8),0,2),BB9=$P(SB,%,9),BB10=$P(SB,%,10),E2=$J(BB4+BB5,0,2)
	I BCX'=CX!(BMX'=MX) S ERR="Wrong client matter" Q
	I BB9="F",-D2>(BB4+BB5+BB6) S ERR="Cannot exceed original bill amount" Q
	I D2>BB8 S ERR="Cannot exceed outstanding bill amount" Q
	I BB10="Y" W @P3,?48,"Includes Unpaid Prof Disb"
	Q
	;VAT Amount
V04	I D2<0,X>0 S ERR="Must be negative or zero" Q
	I X>BB6 S ERR="Cannot exceed original VAT amount" Q
	I D2>0,X>D2 S ERR="Cannot exceed amount of transfer" Q
	I D2<0,X<D2 S ERR="Cannot exceed amount of transfer" Q
	S R2=D2-X
	Q
	;To cashbook
V05	Q:$d(ERR)  I X>99 S ERR="Must be an office cashbook"
	Q
	;To pay bill?
V06	S ML=$g(^ML(CX,MX)),M1=$p(ML,%,1)
	I X="N",D2>M1 W @P3,?48,"Disbursement Balance in Credit",*7
	Q
CASE	S X=$zconvert(X,"U") Q
