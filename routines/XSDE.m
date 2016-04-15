XSDE	;GRI,,,;02:22 PM  20 Jan 1995
	;=======================================================
	; Virgo Accounts - P&L Account
	;
	; Copyright Graham R Irwin 1993-94
	;
	; Screens:       none
	; Files updated: none
	; Subroutines:   X0^XSXS, ^OUTPUT, HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS,^OUTPUT Q:%OP[%  S N=99,P=1
	D HEAD^XSXS S XX="--------------"
	W "Period Ending ",DAT,!?34,"This Period",?49,"Year-to-Date",?64,"Last Yr Total",!!,"Income",!,"======",!! S N=N+6
	S AX="I0",(T1,T2,T3)=0
A01	S AX=$O(^AB(AX)) I AX=""!(AX]"I999") G B01
	S AB=^AB(AX),A1=$P(AB,%,1),A2=$P(AB,%,2),A3=$P(AB,%,3),A4=$P(AB,%,4)
	D LINE
	S T1=T1+A2,T2=T2+A3,T3=T3+A4
	G A01

B01	W ! S A1="Total Income",A2=T1,A3=T2,A4=T3
	D LINE
	W !,"Expenses",!,"========",!! S N=N+4
	S AX="E0",(T4,T5,T6)=0
C01	S AX=$O(^AB(AX)) I AX=""!(AX]"E999") G D01
	S AB=^AB(AX),A1=$P(AB,%,1),A2=$P(AB,%,2),A3=$P(AB,%,3),A4=$P(AB,%,4)	D LINE
	S T4=T4+A2,T5=T5+A3,T6=T6+A4
	G C01

D01	W ! S A1="Total Expenses",A2=T4,A3=T5,A4=T6
	D LINE
	W !?31,XX,?47,XX,?63,XX,!
	S A1="Profit",A2=T1-T4,A3=T2-T5,A4=T3-T6
	D LINE

	D END^XSXS Q

LINE	W A1,?30,$j($fn(A2,",p",2),15),?46,$j($fn(A3,",p",2),15),?62,$j($fn(A4,",p",2),15),! S N=N+1
	Q
