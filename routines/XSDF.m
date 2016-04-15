XSDF	;GRI,,,;02:21 PM  20 Jan 1995
	;=======================================================
	; Virgo Accounts - Balance Sheet
	;
	; Copyright Graham R Irwin 1993-1994
	;
	; Screens:       none
	; Files updated: none
	; Subroutines:   X0^XSXS, ^OUTPUT, HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS,^OUTPUT Q:%OP[%  S N=99,P=1
	D HEAD^XSXS W "As at ",DAT,!?39,"To-date",?56,"Last Year",!,"Fixed Assets",!,"------------",!! S N=N+6

	S AX="A0",(T1,T2)=0
A01	S AX=$O(^AB(AX)) I AX=""!(AX]"A099") G B01
	S AB=^AB(AX),A1=$P(AB,%,1),A2=$P(AB,%,2),A4=$P(AB,%,4) D LINE
	S T1=T1+A2,T2=T2+A4
	G A01

B01	W ! S A1="Total Fixed Assets",A2=T1,A4=T2 D LINE
	W !,"Current Assets",!,"--------------",!! S N=N+5
	S AX="A1",(T4,T5)=0
C01	S AX=$O(^AB(AX)) I AX=""!(AX]"A999") G D01
	S AB=^AB(AX),A1=$P(AB,%,1),A2=$P(AB,%,2),A4=$P(AB,%,4) D LINE
	S T4=T4+A2,T5=T5+A4
	G C01

D01	W ! S A1="Total Current Assets",A2=T4,A4=T5 D LINE
	W !,"Current Liabilities",!,"-------------------",!! S N=N+4
	S AX="L039",(T7,T8)=0
E01	S AX=$O(^AB(AX)) I AX=""!(AX]"L499") G F01
	S AB=^AB(AX),A1=$P(AB,%,1),A2=$P(AB,%,2),A4=$P(AB,%,4) D LINE
	S T7=T7+A2,T8=T8+A4
	G E01

F01	W ! S A1="Total Current Liabilities",A2=T7,A4=T8 D LINE
	W ! S A1="Net Current Assets",A2=T4-T7,A4=T5-T8 D LINE
	W "==================",!
	W ! S A1="Net Assets",A2=T1+T4-T7,A4=T2+T5-T8 D LINE
	W "==========",!
	W !,"Represented by:",!! S N=N+8

	S AX="L500",(T9,T10)=0
G01	S AX=$O(^AB(AX)) I AX=""!(AX]"L999") G H01
	S AB=^AB(AX),A1=$P(AB,%,1),A2=$P(AB,%,2),A4=$P(AB,%,4) D LINE
	S T9=T9+A2,T10=T10+A4
	G G01

H01	W ! S A1="Total Capital",A2=T9,A4=T10 D LINE

	D END^XSXS Q

LINE	W A1,?32,$j($fn(A2,",p",2),15),?51,$j($fn(A4,",p",2),15),! S N=N+1
	Q
