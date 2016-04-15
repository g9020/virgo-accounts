XSDG	;GRI,,,;02:13 PM  30 Sep 2001
	;=======================================================
	; Virgo Accounts - Trial Balance
	;
	; Copyright Graham R Irwin 1993-94
	;
	; Screens:       none
	; Files updated: none
	; Subroutines:   X0^XSXS, ^OUTPUT, HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS
	D ^OUTPUT Q:%OP[%  S N=99,P=1
	D HEAD^XSXS
	W "Account",?44,"Period",?55,"Year-to-Date",!! S N=N+2

	;Income
	S AX="I0",(T1,T2)=0
A01	S AX=$O(^AB(AX)) I AX=""!(AX]"I999") G A10
	D DOIT
	G A01

A10	W ! S N=N+1

	;Expenses
	S AX="E0"
B01	S AX=$O(^AB(AX)) I AX=""!(AX]"E999") G B10
	D DOIT
	G B01

B10	W ! S N=N+1

	;Fixed Assets
	S AX="A0"
C01	S AX=$O(^AB(AX)) I AX=""!(AX]"A099") G C10
	D DOIT
	G C01

C10	W ! S N=N+1

	;Current Assets
	S AX="A1"
D01	S AX=$O(^AB(AX)) I AX=""!(AX]"A999") G D10
	D DOIT
	G D01

D10	W ! S N=N+1

	;Current Liabilities
	S AX="L039"
E01	S AX=$O(^AB(AX)) I AX=""!(AX]"L499") G E10
	D DOIT
	G E01

E10	W ! S N=N+1

	;Long-term Liabilities
	S AX="L500"
F01	S AX=$O(^AB(AX)) I AX=""!(AX]"L999") G X01
	D DOIT
	G F01

X01	W !,"Total:",?40,$J(T1,10,2),?55,$J(T2,10,2),!
	D END^XSXS
	Q

	;Process one account line
DOIT	S AB=^AB(AX),A1=$P(AB,%,1),A2=$P(AB,%,2),A3=$P(AB,%,3)
	W AX," ",A1,?40,$j(A2,10,2),?55,$J(A3,10,2),!
	S N=N+1 I N>56 D HEAD^XSXS
	I "IL"[$e(AX,1) S A2=-A2,A3=-A3
	S T1=T1+A2,T2=T2+A3
	Q
