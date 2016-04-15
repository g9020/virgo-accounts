XSEC	;GRI,,,;01:06 PM  3 May 2000
	;=======================================================
	; Virgo Accounts - WIP Enquiry
	;
	; Copyright Graham R Irwin 1993-99
	;
	; Screens:       1024
	; Files updated: none
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, ^OUTPUT, 
	;                HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS
	S %S=1024 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSEC Q
	S DET=0 I $d(^TE(CX,MX)) S DET=1

	;Summary display
E01	S (X3,X4)="",MOD=0 W /c(0,7),/ef,@P1,!?5,"Activity",?43,"Time",?52,"Items",?65,"Value",!
E02	S X3=$O(^SW(CX,MX,X3)) I X3=""!($Y>19) G E09
	W !?5,"Fee Earner ",X3,?19,$p($g(^SF(X3)),%,1),!!
E03	S X4=$O(^SW(CX,MX,X3,X4)) I X4="" G E02
E04	D LINE I $Y>19 G E09
	G E03

E09	W /C(0,22),@P1,"Next, " W:DET&'MOD "Detail, " W:MOD "Summary, " W "Print or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) G XSEC
	I X="P" G P01
	I DET,'MOD,X="D" G D01
	I MOD,X="S" G E01
	I X="N" G N01
	I X="\\" G H01
	G E09

	;Detail display
D01	S (X3,X4)="",MOD=1 W /c(0,7),/ef,@P1,!?2,"Date",?14,"Description",?56,"Time",?63,"Items",?72,"Value",!
D02	S X3=$O(^TE(CX,MX,X3)) I X3=""!($Y>19) G E09
	W !?2,"Fee Earner ",X3,?16,$p($g(^SF(X3)),%,1),!!
D03	S X4=$O(^TE(CX,MX,X3,X4)) I X4="" G D02
D04	D DLINE I $Y>19 G E09
	G D03

	;Next
N01	W /c(0,9),/ef,@P1
	I MOD G D02:X3="" W ! G D03
	G E02:X3="" W ! G E03

	;Home
H01	W /c(0,9),/ef,@P1
	I MOD G D01
	G E01

	;Print
P01	D ^OUTPUT G:%OP[% XSEC S N=99,P=1 D HEAD^XSXS
	D PRINT
	D END^XSXS
	G XSEC

	;Validation - Matter code
V01	Q:$D(ERR)  I '$d(^SW(CX,X)),'$d(^TE(CX,X)) S ERR="No W.I.P details for this matter" Q
	S SW=$g(^SW(CX,X)),M1=$J($P(SW,%,1),0,2),M2=$J($P(SW,%,2),0,2) Q

CASE	S X=$zconvert(X,"U") Q

	;Print details
	;may be called by other programs (?unlikely)
	;needs CX, MX, M1 and MOD defined
PRINT	W "Client ",CX,?12,$P(^SC(CX),%,1),!
	W "Matter ",MX,?12,$P(^SM(CX,MX),%,1),!
	W "WIP Balance",?12,M1 S N=N+2,(X3,X4)=""
	I MOD G P12
	;summary
P02	S X3=$O(^SW(CX,MX,X3)) I X3="" Q
	W !!?5,"Fee Earner ",X3,?19,$p($g(^SF(X3)),%,1),!!?5,"Activity",?43,"Time",?52,"Items",?65,"Value",!! S N=N+6
P03	S X4=$O(^SW(CX,MX,X3,X4)) I X4="" G P02
	D LINE S N=N+1 I N>56 D HEAD^XSXS
	G P03
	;detail
P12	S X3=$O(^TE(CX,MX,X3)) I X3="" Q
	W !!?5,"Fee Earner ",X3,?19,$p($g(^SF(X3)),%,1),!!?2,"Date",?14,"Description",?56,"Time",?63,"Items",?72,"Value",!! S N=N+6
P13	S X4=$O(^TE(CX,MX,X3,X4)) I X4="" G P12
	D DLINE S N=N+1 I N>56 D HEAD^XSXS
	G P13

TCON	S A=T0\60_":",T0=T0#60 S:T0<10 T0=0_T0 S T0=A_T0 Q

LINE	S SW=^SW(CX,MX,X3,X4),D1=$P(SW,%,1),D2=$P(SW,%,2),D3=$P(SW,%,3),T0=D1 D TCON
	W ?5,X4,?8,$P($G(^SA(X4)),%,1) W:D1 ?47-$L(T0),T0 W:D2 ?52,$J(D2,5,0) W ?60,$J(D3,10,2),! Q

DLINE	S TE=^TE(CX,MX,X3,X4),E1=$p(TE,%,1),E2=$p(TE,%,2),D1=$P(TE,%,3),D2=$P(TE,%,4),D3=$P(TE,%,5),T0=D1 D TCON
	W ?2,E1,?14,E2," ",$g(^SA(E2)) W:D1 ?60-$L(T0),T0 W:D2 ?62,$J(D2,5,0) W ?67,$J(D3,10,2),! Q
