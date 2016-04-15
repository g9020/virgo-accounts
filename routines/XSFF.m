XSFF	;GRI,,,;04:53 PM  5 Jun 2002
	;=======================================================
	; Virgo Accounts - Client A/c Reconciliation
	;
	; Copyright Graham R Irwin 1993-2002
	;
	; Screens:	 1067
	; Files updated: ^WORK($j)
	; Subroutines:	 X0^XSXS, ^INPUT, ^OUTPUT, HEAD^XSXS,
	;                END^XSXS
	;
	;=======================================================

	D X0^XSXS S YES="Y"
	S %S=1067 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% Q

	D ^OUTPUT I %OP[% G XSFF
	S N=99,P=1 D HEAD^XSXS
	K ^WORK($j) S (CX,MX)=""
A01	S CX=$O(^CL(CX)) I CX="" G B01
A02	S MX=$O(^CL(CX,MX)) I MX="" G A01
	S C1=+^CL(CX,MX),DX=$P(^SM(CX,MX),%,10)
	S ^WORK($j,DX,CX,MX)=C1
	G A02

B01	S DX=99,T2=0
B02	S DX=$O(^CB(DX)) I DX="" G END
	S CB=^CB(DX),C1=$P(CB,%,1),C6=$P(CB,%,6)
	W "Cashbook ",DX,"  ",C1,?50,"Balance ",$J(C6,10,2),!! S N=N+2
	S (CX,MX)="",T1=0
B05	S CX=$O(^WORK($j,DX,CX)) I CX="" G B08
B06	S MX=$O(^WORK($j,DX,CX,MX)) I MX="" G B05
	S W1=^WORK($j,DX,CX,MX),T1=T1+W1
	I A1="N"!(+W1'=0) W ?2,CX,"/",MX,?12,$p(^SC(CX),%,1),?44,$j(W1,10,2),! S N=N+1 I N>58 D HEAD^XSXS
	G B06

B08	W ?44,"----------",!," Total for cashbook ",DX,?44,$j(T1,10,2)
	I C6=T1 W ?56,"Cashbook balances",!!!
	E  W ?56,"DOES NOT BALANCE",!!!
	S T2=T2+T1,N=N+4 I N>58 D HEAD^XSXS
	G B02

END	W ?44,"==========",!," TOTAL CLIENT MONEY HELD",?44,$j(T2,10,2),!
	D END^XSXS
	Q
