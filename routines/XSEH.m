XSEH	;GRI,,,;01:26 PM  6 Dec 2007;
	;=======================================================
	; Virgo Accounts - Summarise Detailed Time
	;
	; Copyright Graham R Irwin 1993-2007
	;
	; Screens:       1024
	; Files updated: ^WORK($j)
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, ^OUTPUT, 
	;                HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS
	S %S=1024 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSEH Q
	k ^WORK($j)

	;Get detailed transactions
D01	S (X3,X4)=""
D02	S X3=$O(^TE(CX,MX,X3)) I X3="" G P01
D03	S X4=$O(^TE(CX,MX,X3,X4)) I X4="" G D02
	S TE=^TE(CX,MX,X3,X4),E1=$p(TE,%,1),E2=$p(TE,%,2),E3=$P(TE,%,3),E4=$P(TE,%,4),E5=$P(TE,%,5)
	S WK=$g(^WORK($j,X3,E2)),W1=$p(WK,%,1),W2=$p(WK,%,2),W3=$p(WK,%,3)
	S ^WORK($j,X3,E2)=(W1+E3)_%_(W2+E4)_%_(W3+E5)
	G D03

	;Print
P01	D ^OUTPUT G:%OP[% XSEH S N=99,P=1 D HEAD^XSXS
	W "Client ",CX,?12,$P(^SC(CX),%,1),!
	W "Matter ",MX,?12,$P(^SM(CX,MX),%,1),!
	W "WIP Balance",?12,M1 S N=N+2,(X3,X4)=""

P02	S X3=$O(^WORK($j,X3)) I X3="" G P09
	W !!?5,"Fee Earner ",X3,?19,$p($g(^SF(X3)),%,1),!!?5,"Activity",?43,"Time",?52,"Items",?65,"Value",!! S N=N+6
P03	S X4=$O(^WORK($j,X3,X4)) I X4="" G P02
	S SW=^WORK($j,X3,X4),D1=$P(SW,%,1),D2=$P(SW,%,2),D3=$P(SW,%,3),T0=D1
	S A=T0\60_":",T0=T0#60 S:T0<10 T0=0_T0 S T0=A_T0
	W ?5,X4,?8,$P($G(^SA(X4)),%,1) W:D1 ?47-$L(T0),T0 W:D2 ?52,$J(D2,5,0) W ?60,$J(D3,10,2),!
	S N=N+1 I N>56 D HEAD^XSXS
	G P03

P09	W !!,"Please note that if any time has been billed or any detailed time entries",!,"removed the total shown will not equal the WIP balance."
	D END^XSXS
	Q

	;Validation - Matter code
V01	Q:$D(ERR)  I '$d(^SW(CX,X)),'$d(^TE(CX,X)) S ERR="No W.I.P details for this matter" Q
	S SW=$g(^SW(CX,X)),M1=$J($P(SW,%,1),0,2),M2=$J($P(SW,%,2),0,2) Q

CASE	S X=$zconvert(X,"U") Q
