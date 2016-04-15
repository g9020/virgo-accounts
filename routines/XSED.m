XSED	;GRI,,,;03:40 PM  12 Jan 2001;
	;=======================================================
	; Virgo Accounts - WIP Analysis
	;
	; Copyright Graham R Irwin 1993-2001
	;
	; Screens:       1041, 1070
	; Files updated: ^WORK($j)
	; Subroutines:	 X0^XSXS, ^INPUT, ^OUTPUT, HEAD^XSXS,
	;                END^XSXS, ^NEWNAME
	;
	;=======================================================

	D X0^XSXS

	W !?8,@P1,"Do you wish to analyse WIP by:-"
	W !!?8,"A - ",$$^NEWNAME("@F7@")
	W !?8,"B - ",$$^NEWNAME("@F8@")
	W !?8,"C - Client",!!
	S %S=1041 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSED Q
	S %S=1070 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSED
	I A4="" S A4="YN"

	W /C(0,22),@P1,"Sorting, please wait ..."
	K ^WORK($j) S (CX,MX)="",NC=0
G01	S CX=$o(^SM(CX)) I CX="" G H01
G02	S MX=$o(^SM(CX,MX)) I MX="" G G01
	S SM=^SM(CX,MX),M8=$p(SM,%,8),M9=$p(SM,%,9),M3=$p(SM,%,3)
	I A4'[M3 G G02
	S:A3="A" X1=M8 S:A3="B" X1=M9 S:A3="C" X1=CX S:X1="" X1="null"
	S SWB=$g(^SW(CX,MX)),SWB1=$p(SWB,%,1)
	S ^WORK($j,X1)=$g(^WORK($j,X1))+SWB1
	G G02

	;Print
H01	D ^OUTPUT G:%OP[% XSED
	S T1=0,N=99,P=1 D HEAD^XSXS
	W "Unbilled Work-in-Progress - ",$$^NEWNAME("@F1@")," = " W:$l(A4)=1 A4 W:$l(A4)=2 "Y or N" W !!! S N=N+3,X1=""
H02	S X1=$o(^WORK($j,X1)) I X1="" G J01
	S WK=^WORK($j,X1)
	I A3="C",+WK=0 G H02	;ignore if total by client=0
	W ?8 W:A3="A" $$^NEWNAME("@F7@")," = " W:A3="B" $$^NEWNAME("@F8@")," = " W:A3="C" "Client " W X1 W:A3="C" "  ",$p(^SC(X1),%,1) W ?50,$j(WK,10,2),!!
	S T1=T1+WK,N=N+2 I N>56 D HEAD^XSXS
	G H02

J01	W ?50,"----------",!?8,"Total",?50,$j(T1,10,2),!
	D END^XSXS
	Q

	;Validation - option
V03	I "ABC"'[X S ERR="Must be 'A', 'B' or 'C'"
	Q
