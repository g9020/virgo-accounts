XSBE	;GRI,,,;02:07 PM  18 Jun 2004
	;=======================================================
	; Virgo Accounts - Post Bill Credit
	;
	; Copyright Graham R Irwin 1993-2004
	;
	; Screens:       1046, 1047, 1008
	; Files updated: ^ML ^SB ^SD ^SU ^SV ^SW ^SY ^AB ^AY
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, YX^XSXS, UPAB^XSXS
	;
	;=======================================================

	; R2 - Net amount		R3 - VAT amount
	; E3 - Gross amount
	; T0 - Disbs written off	B5 - Disbursements billed
	; B4 - Time billed		B7 - Time removed
	; B8 - O/s amount		B9 - Bill status

	S E5="Bill Credit",TT="BCR",NO="N"
	D X0^XSXS
	S %S=1046,%J=1 D ^INPUT Q:X="END"!(X[%)
	I X[% Q
	S %S=1047 F %J=1:1 D D^INPUT Q:X="END"
	S %S=1008 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSBE
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX,CASE G XSBE:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update...
U01	S E5=C5_" - "_$p(^SC(CX),%,1),E5=$e(E5,1,70)
	;...daybook
	D YX^XSXS S ^SY(DAT,TT,YX)=R1_%_CX_%_MX_%_%_R2_%_R3_%_%_%_%_BX_%_E5
	;...matter ledger
	S ^ML(CX,MX,YX)=R1_%_E3_%_%_TT_%_BX_%_%_C5_%
	S ML=$G(^ML(CX,MX)),M1=$P(ML,%,1),M2=$P(ML,%,2)-E3,M3=$P(ML,%,3,9),^ML(CX,MX)=M1_%_M2_%_M3
	;...bill register
	S B8=B8-E3 S:B8<0 B8=0
	S B9="P" I B8=0 S B9="F" I R6="Y" S B9="C" ;order is important!
	S ^SB(BX)=B1_%_CX_%_MX_%_B4_%_B5_%_B6_%_B7_%_B8_%_B9_%_B10_%
	I "FC"[B9 K ^SU(BX)
	;...VAT records if NOT cash basis
	I ^SZ("VCB")="N" S SV=$G(^SV),V1=$P(SV,%,1),V2=$p(SV,%,2),V3=$P(SV,%,3)-R2,V4=$P(SV,%,4)-R3,^SV=V1_%_V2_%_V3_%_V4,^SV(YX)=BX_%_R1_%_-R2_%_-R3
	;...nominal ledger
	S AX="L040" S:^SZ("VCB")="Y" AX="L140" D UPAB^XSXS(AX,-R3,R1,TT,BX,E5)
	D UPAB^XSXS("A110",-E3,R1,TT,BX,E5)

	;If not reinstating balances
	I $g(R6)="Y" G P00
	D UPAB^XSXS("E330",R2,R1,TT,BX,E5)
	D UPAB^XSXS("N110",E3,R1,TT,BX,E5)
	G E99

	;Reinstate billed disbursements
P00	S X3="",T0=0
P01	S X3=$O(^SD(CX,MX,BX,X3)) I X3="" G P03
	S ML=^SD(CX,MX,BX,X3),T0=T0+$P(ML,%,3)-$P(ML,%,2),^ML(CX,MX,X3)=ML G P01
P03	S ML=$G(^ML(CX,MX)),M1=$P(ML,%,1)+T0,M2=$P(ML,%,2),^(MX)=M1_%_M2
	K ^SD(CX,MX,BX)
	D UPAB^XSXS("A120",T0,R1,TT,BX,E5)
	S T1=B5-T0 D UPAB^XSXS("E280",T1,R1,TT,BX,E5)
	D UPAB^XSXS("N070",-B5,R1,TT,BX,E5)

	;Reinstate removed time
	S SW=$G(^SW(CX,MX,1,"G")),W1=$P(SW,%,1),W2=$P(SW,%,2),W3=$P(SW,%,3),W3=W3+B7,^("G")=W1_%_W2_%_W3
	S SW=$G(^SW(CX,MX)),W1=$P(SW,%,1)+B7,W2=$P(SW,%,2),^SW(CX,MX)=W1_%_W2
	D UPAB^XSXS("N020",B7,R1,TT,BX,E5)
	D UPAB^XSXS("I020",-B4,R1,TT,BX,E5)
	D UPAB^XSXS("N040",-B4,R1,TT,BX,E5)

E99	D UPAB^XSXS("N090",-E3,R1,TT,BX,E5)
	G XSBE

	;Amend
A01	W /C(0,4),/EF S %S=1046 F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSBE
	S %S=1047 F %J=1:1 D D^INPUT Q:X="END"
	S %S=1008 F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	G A01:X[%,E02

	;Validation - Bill number
V01	Q:$D(ERR)  S SB=^SB(X),B1=$P(SB,%,1),CX=$P(SB,%,2),MX=$P(SB,%,3),B4=$P(SB,%,4),B5=$P(SB,%,5),B6=$J($P(SB,%,6),0,2),B7=$P(SB,%,7),B8=$J($P(SB,%,8),0,2),B9=$P(SB,%,9),B10=$P(SB,%,10),E2=$J(B4+B5,0,2),BV=B8-B4-B5-B6
	I B9="F"!'B8 S ERR="Bill has been paid" Q
	I B10="Y" W @P3,?48,"Includes Unpaid Prof Disb"
	Q
	;Net amount
V02	Q:$D(ERR)
	I X>E2!(X<-E2) S ERR="Cannot exceed original net amount"
	Q
	;VAT amount
V03	Q:$D(ERR)
	I X>0,R2<0 S ERR="Must be a negative amount" Q
	I X<0,R2>0 S ERR="Must be a positive amount" Q
	S E3=$J(R2+X,0,2)
	I E3>B8 S ERR="Credit amount cannot exceed O/S amount" Q
	I X>B6 S ERR="Cannot exceed original VAT amount" Q
	I X<0,E3<BV S ERR="Gross amount cannot exceed amount credited"
	Q
	;Reinstate?
V04	Q:$D(ERR)  Q:X="N"  I B9'="U" S ERR="Bill is part paid" Q
	I +R2'=+E2!(+R3'=+B6) S ERR="Must be for the full value of the bill"
	Q

CASE	S X=$zconvert(X,"U") Q
