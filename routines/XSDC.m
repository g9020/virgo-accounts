XSDC	;GRI,,,;05:08 PM  15 Aug 1994
	;=======================================================
	; Virgo Accounts - Financial Status Report
	;
	; Copyright Graham R Irwin 1993-94
	;
	; Screens:       none
	; Files updated: none
	; Subroutines:   X0^XSXS, ^OUTPUT, HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS,^OUTPUT Q:%OP[%  S N=99,P=1
	D HEAD^XSXS S XX="----------" W "As at ",DAT,!?36,"Year-to-Date",?58,"Last Year Total",!!
	S AX="N0",(T2,T3)=0
A01	S AX=$O(^AB(AX)) I AX=""!(AX]"N999") G B01
	S AB=^AB(AX),A1=$P(AB,%,1),A3=$P(AB,%,3),A4=$P(AB,%,4)
	W A1,?36,$J(A3,10,2),?60,$J(A4,10,2),!
	S T2=T2+A3,T3=T3+A4 G A01

B01	S CX="" W !!,"Cashbook Balances",!!
B02	S CX=$O(^CB(CX)) I CX="" G END
	S CB=^CB(CX),A1=$P(CB,%,1),A6=$P(CB,%,6)
	W CX,?5,A1,?32,$J(A6,10,2),! G B02

END	D END^XSXS
	Q
