XSBM	;GRI,,,;08:56 AM  9 May 2003;
	;=======================================================
	; Virgo Accounts - Batch Disbursements
	;
	; Copyright Graham R Irwin 1993-1998
	;
	; Screens:       1042, 1057
	; Files updated: ^CB ^ML ^SV ^SY ^AB ^AY ^WORK($j)
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, YX^XSXS, UPAB^XSXS
	;
	;=======================================================

	D X0^XSXS
	S TT="DIS",B5="Disbursement",VAT=^SZ("VAT")/100,ONE=$g(^SZ("DOC"),1)
	S %S=1042 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% Q:%J=1  G XSBM
	W @P1,!?4,"Client Matter Net Amount VAT Amount Narrative",!! S WS=1 K ^WORK($j)

I01	W /C(0,16),/EF S WX=WS,F1=1
	S %S=1057 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G I01:%J>1 G XSBM:WX=1 S WS=WX,W1="",F1=0 G N01
E09	W /C(0,22),@P1,"Update, Amend, Delete or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) S W1="" G N01
	I X="A" G A01
	I X="U" G U01
	I X="D" W @P1,"  Are you sure ? ",@P2 D ^GETX,CASE I X="Y" K ^WORK($j,WX) S W1="" G N01
	G E09

	;Update individual entry
U01	S ^WORK($j,WX)=CX_%_MX_%_B3_%_B4_%_B5,WS=WS+1,W1="",(T1,T2)=0
U02	S W1=$o(^WORK($j,W1)) I W1="" G U04
	S WK=^WORK($j,W1),T1=T1+$p(WK,%,3),T2=T2+$p(WK,%,4)
	G U02
U04	W /C(48,5),/EL,@P5,$j(T1+T2,0,2)
	W /C(0,11),/EF,@P1 S W1=WX-5
E03	S W1=$O(^WORK($j,W1)) I W1=""!($Y>20) G I01:F1,L01
E04	S WK=^WORK($j,W1),CX=$p(WK,%,1),MX=$p(WK,%,2),B3=$j($p(WK,%,3),10,2),B4=$p(WK,%,4),B5=$p(WK,%,5) S:B4'="*" B4=$j(B4,10,2) S:B4="*" B4="         *"
	W @P1,W1,?5,CX,?12,MX,?18,B3,?29,B4,?40,B5,! G E03

L01	S UPD=+A1=(T1+T2)
	W /C(0,22),@P1,"Next, Select, Insert" W:UPD ", Update" W " or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) W @P1,"  Forget entire batch ? ",@P2 D ^GETX,CASE G XSBM:X="Y",L01
	I X="N" G N01
	I X="S"!(X="Z") G S01
	I X="I" G I01
	I UPD,X="U" G U11
	G L01

	;Update records
U11	S WX=""
U30	S WX=$O(^WORK($j,WX)) I WX="" G U99
	S WK=^WORK($j,WX),CX=$P(WK,%,1),MX=$P(WK,%,2),B3=$P(WK,%,3),B4=$P(WK,%,4),B5=$P(WK,%,5)
	D YX^XSXS
	S ^SY(DAT,TT,YX)=A2_%_CX_%_MX_%_DX_%_B3_%_B4_%_%_%_%_A3_%_B5
	S ^ML(CX,MX,YX)=A2_%_%_B3_%_TT_%_A3_%_%_B5
	S MLB=$g(^ML(CX,MX)),MLB1=$p(MLB,%,1)+B3,MLB29=$p(MLB,%,2,9),^ML(CX,MX)=MLB1_%_MLB29
	G U30

U99	S A0="Disbursements batch"
	S ^CB(DX,YX)=A2_%_A1_%_%_TT_%_A3_%_A0_%_"N"_%
	S CBA=^CB(DX),CBA15=$p(CBA,%,1,5),CBA6=$p(CBA,%,6)-A1,^CB(DX)=CBA15_%_CBA6_%
	S SVA=$g(^SV),SVA1=$p(SVA,%,1)+T1,SVA2=$p(SVA,%,2)+T2,SVA39=$p(SVA,%,3,9),^SV=SVA1_%_SVA2_%_SVA39,^SV("P"_YX)="Disb'ts"_%_A2_%_T1_%_T2
	D UPAB^XSXS("L040",-T2,A2,TT,A3,A0)
	D UPAB^XSXS("A120",T1,A2,TT,A3,A0)
	D UPAB^XSXS("N060",T1,A2,TT,A3,A0)
	D UPAB^XSXS("A130",-A1,A2,TT,A3,A0)
	G XSBM

	;Next
N01	W /C(0,11),/EF,@P1 G E04:W1'="",E03

	;Amend
A01	W /C(0,16),/EF F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G N01:%J=1,A01
	G E09

	;Select
S01	W @P1,"  Select item ",@P2 D ^GETX S WX=+X I $G(^WORK($j,WX))="" G L01
	S WK=^WORK($j,WX),CX=$P(WK,%,1),MX=$P(WK,%,2),B3=$P(WK,%,3),B4=$P(WK,%,4),B5=$P(WK,%,5)
	W /C(0,16),/EF F %J=1:1 D D^INPUT Q:X="END"!(X[%)
	G E09

	;Validation ----------------------------------------
	;Cashbook
V01	Q:$d(ERR)  I X>99 S ERR="Must be an Office cashbook"
	Q
	;Net amount
V04	Q:$D(ERR)  S SMA6=$p(^SM(CX,MX),%,6),E4=$j(X*VAT*(SMA6="Y"),0,2)
	Q
	;VAT amount
V05	I X="*" K ERR
	I X<0,B3>0 S ERR="Must be a positive number" Q
	I X>0,B3<0 S ERR="Must be a negative number" Q
	Q

CASE	S X=$zconvert(X,"U") Q
