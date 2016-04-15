XSDN	;GRI,,,;01:10 PM  14 Feb 2002;
	;=======================================================
	; Virgo Accounts - Budget Variance Report
	;
	; Copyright Graham R Irwin 1993-2002
	;
	; Screens:       1078
	; Files updated: none
	; Subroutines:   X0^XSXS, ^OUTPUT, HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS
	S %S=1078 F %J=1:1 D ^INPUT Q:X="END"!(X[%)

	D ^OUTPUT Q:%OP[%  S N=99,P=1
	D HEAD^XSXS
	W "Period ",Q1,!! S N=N+2
	W "Account",?40,"Balance",?52,"Budget   Variance   Var %",!! S N=N+2

	;Income
	S AX="I0",(T1,T2)=0
A01	S AX=$O(^AB(AX)) I AX=""!(AX]"I999") G A10
	D DOIT
	G A01

A10	W !,"Total Income" S XX=1 D DTOT

	;Expenses
	S AX="E0",(T1,T2)=0
B01	S AX=$O(^AB(AX)) I AX=""!(AX]"E999") G B10
	D DOIT
	G B01

B10	W !,"Total Expenses" S XX=0 D DTOT

	;Fixed Assets
	S AX="A0",(T1,T2)=0
C01	S AX=$O(^AB(AX)) I AX=""!(AX]"A099") G C10
	D DOIT
	G C01

C10	W !,"Total Fixed Assets" S XX=0 D DTOT

	;Current Assets
	S AX="A1",(T1,T2)=0
D01	S AX=$O(^AB(AX)) I AX=""!(AX]"A999") G D10
	D DOIT
	G D01

D10	W !,"Total Current Assets" D DTOT


	;Current Liabilities
	S AX="L039",(T1,T2)=0
E01	S AX=$O(^AB(AX)) I AX=""!(AX]"L499") G E10
	D DOIT
	G E01

E10	W !,"Total Current Liabilities" S XX=1 D DTOT

	;Long-term Liabilities
	S AX="L500",(T1,T2)=0
F01	S AX=$O(^AB(AX)) I AX=""!(AX]"L999") G F10
	D DOIT
	G F01

F10	W !,"Total Long-term Liabilities" D DTOT

X01	D END^XSXS
	Q

	;Process one account line
DOIT	S AB=^AB(AX),A1=$P(AB,%,1),A3=$P(AB,%,3)
	I AX="L530" S A3=$p(AB,%,2)	;what can I say!
	S B1=$g(^NB(AX))*Q1,V1=B1-A3,V2="--"
	I "IL"[$e(AX,1) S V1=-V1
	I +B1'=0 S V2=V1/B1*100
	W AX," ",A1,?37,$j(A3,10,2),?48,$j(B1,10,2),?59,$j(V1,10,2)
	I V2'="--" W ?70,$j(V2,7,1),!
	I V2="--" W ?74,V2,!
	S N=N+1 I N>56 D HEAD^XSXS
	S T1=T1+A3,T2=T2+B1
	Q

	;Process total line
DTOT	S V1=T2-T1,V2="--"
	I XX S V1=-V1
	I T2'=0 S V2=V1/T2*100
	W ?37,$j(T1,10,2),?48,$j(T2,10,2),?59,$j(V1,10,2)
	I V2'="--" W ?70,$j(V2,7,1),!!
	I V2="--" W ?74,V2,!!
	S N=N+3 I N>56 D HEAD^XSXS
	Q
