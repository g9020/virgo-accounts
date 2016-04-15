XSBD	;GRI,,,;09:16 AM  5 Mar 2003
	;=======================================================
	; Virgo Accounts - Post Bill Receipt
	;
	; Copyright Graham R Irwin 1993-94
	;
	; Screens:       1007, 1046, 1047
	; Files updated: ^ML ^CB ^CL ^SB ^SU ^SY ^SV ^AB ^AY
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, YX^XSXS, UPAB^XSXS
	;
	;=======================================================

	; R2 - Net amount
	; R3 - VAT amount
	; E3 - Gross amount

	D X0^XSXS
	S E5="Bill Receipt",TT="BPY",ONE=$g(^SZ("DOC"),1)
	S %S=1046,%J=1 D ^INPUT Q:X="END"!(X[%)
	I X[% G QUIT
	S %S=1047 F %J=1:1 D D^INPUT Q:X="END"
	S %S=1007 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSBD
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX D CASE G XSBD:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update...
U01	S E5=C5_" - "_$p(^SC(CX),%,1),E5=$e(E5,1,70)
	;...daybook
	D YX^XSXS S ^SY(DAT,TT,YX)=R1_%_CX_%_MX_%_DX_%_R2_%_R3_%_%_%_%_BX_%_E5

	;...client ledger if appropriate
	I DX>99 S ^CL(CX,MX,YX)=R1_%_%_E3_%_TT_%_BX_%_C5_%,CL=$G(^CL(CX,MX)),C1=$P(CL,%,1)+E3,C2=$P(CL,%,2),^CL(CX,MX)=C1_%_C2_% G NV1

	;...or matter ledger & bill register
	S ^ML(CX,MX,YX)=R1_%_E3_%_%_TT_%_BX_%_%_C5_%
	S ML=$G(^ML(CX,MX)),M1=$P(ML,%,1),M2=$P(ML,%,2)-E3,^ML(CX,MX)=M1_%_M2
	S B8=B8-E3 S:B8<0 B8=0 S B9="P" S:(B4+B5+B6)=B8 B9="U" S:'B8 B9="F"
	S ^SB(BX)=B1_%_CX_%_MX_%_B4_%_B5_%_B6_%_B7_%_B8_%_B9_%_B10_%
	I B9="F" K ^SU(BX)

	;...VAT records if cash basis
	I ^SZ("VCB")'="Y" G NV1
	S SV=$G(^SV),V1=$P(SV,%,1),V2=$p(SV,%,2),V3=$P(SV,%,3)+R2,V4=$P(SV,%,4)+R3,^SV=V1_%_V2_%_V3_%_V4,^SV(YX)=BX_%_R1_%_R2_%_R3
	D UPAB^XSXS("L040",R3,R1,TT,BX,E5)
	D UPAB^XSXS("L140",-R3,R1,TT,BX,E5)

	;...cashbook
NV1	S ^CB(DX,YX)=R1_%_%_E3_%_TT_%_BX_%_E5_%_%
	S CB=^CB(DX),C1=$P(CB,%,1,5),C6=$P(CB,%,6)+E3,^CB(DX)=C1_%_C6_%
	;...cashbook control account
	S AX="A130" I DX>99 S AX="L010" S:$P(^SM(CX,MX),%,5)="Y" AX="L020"
	D UPAB^XSXS(AX,E3,R1,TT,BX,E5)
	I DX<100 S AX="A110" D UPAB^XSXS(AX,-E3,R1,TT,BX,E5)

	G XSBD

	;Amend
A01	W /C(0,4),/EF S %S=1046,%J=1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSBD
	S %S=1047 F %J=1:1 D D^INPUT Q:X="END"
	S %S=1007 F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	G A01:X[%,E02

QUIT	
	Q

	;Validation - Bill number
V01	Q:$D(ERR)  S SB=^SB(X),B1=$P(SB,%,1),CX=$P(SB,%,2),MX=$P(SB,%,3),B4=$P(SB,%,4),B5=$P(SB,%,5),B6=$J($P(SB,%,6),0,2),B7=$P(SB,%,7),B8=$J($P(SB,%,8),0,2),B9=$P(SB,%,9),B10=$P(SB,%,10),E2=$J(B4+B5,0,2),BV=B8-B4-B5-B6
	;I B9="F"!'B8 S ERR="Bill has been paid" Q
	I B10="Y" W @P3,?48,"Includes Unpaid Prof Disb"
	Q
	;Net amount
V02	I X>0,B9="F"!'B8 S ERR="Must be a negative amount" Q
	I X<0,X<BV S ERR="Cannot exceed amount paid" Q
	Q
	;VAT amount
V03	Q:$D(ERR)  I X>B6 S ERR="Cannot exceed original VAT amount" Q
	I X>0,R2<0 S ERR="Must be a negative amount" Q
	S E3=$J(R2+X,0,2)
	I X<0,E3<BV S ERR="Gross amount cannot exceed amount paid" Q
	Q
	;Gross amount
V09	I E3>B8 W @P3,?48,"Exceeds outstanding amount"
	Q
	;Cashbook
V04	Q:$D(ERR)  I E3'>B8 Q
	I X<100 S ERR="Overpayment must be to a client cashbook" Q
	S K=$P(^SM(CX,MX),%,10),ERR="No client cashbook defined for this matter" Q:K=""  Q:'$D(^CB(K))  K ERR
	I K'=X S ERR="Must be same as client cashbook"
	Q

CASE	S X=$zconvert(X,"U") Q
