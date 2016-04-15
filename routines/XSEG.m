XSEG	;GRI,,,;04:54 PM  5 Jun 2002;
	;=======================================================
	; Virgo Accounts - Time Recorded by F/E
	;
	; Copyright Graham R Irwin 1993-2002
	;
	; Screens:       1018, 1041
	; Files updated: ^WORK ^WORK2
	; Subroutines:   X0^XSXS, ^INPUT, DMY2H^DATE, ^OUTPUT,
	;                HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS
	K ^WORK($j),^WORK2($j)
	S %S=1018 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSEG Q
	S %DAT=A1 D DMY2H^DATE S D1=%H
	S %DAT=A2 D DMY2H^DATE S D2=%H

	W !?8,@P1,"Do you wish to sort by:-"
	W !!?8,"A - ",$$^NEWNAME("@F7@")
	W !?8,"B - ",$$^NEWNAME("@F8@")
	W !?8,"C - Client",!!
	S %S=1041 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSEG Q

	;Create work files
	W /C(0,22),@P1,"Sorting, please wait ..."
	S (CX,MX,X3,X4)=""
D02	S CX=$o(^TE(CX)) I CX="" G E01
D03	S MX=$o(^TE(CX,MX)) I MX="" G D02
D04	S X3=$o(^TE(CX,MX,X3)) I X3="" G D03
D05	S X4=$o(^TE(CX,MX,X3,X4)) I X4="" G D04
	S TEA=^TE(CX,MX,X3,X4),%DAT=$p(TEA,%,1) D DMY2H^DATE S D3=%H
	I D1>D3 G D05
	I D2<D3 G D05
	S WK=$g(^WORK($j,X3,CX,MX))
	S SM=^SM(CX,MX),M8=$p(SM,%,8),M9=$p(SM,%,9)
	S:A3="A" X1=M8 S:A3="B" X1=M9 S:A3="C" X1=CX S:X1="" X1="null"
	S TEA3=$p(TEA,%,3),TEA4=$p(TEA,%,4),TEA5=$p(TEA,%,5)
	S WK1=$p(WK,%,1)+TEA3,WK2=$p(WK,%,2)+TEA4,WK3=$p(WK,%,3)+TEA5
	S ^WORK($j,X3,CX,MX)=WK1_%_WK2_%_WK3
	S WKA=$g(^WORK2($j,X1))
	S WK1=$p(WKA,%,1)+TEA3,WK2=$p(WKA,%,2)+TEA4,WK3=$p(WKA,%,3)+TEA5
	S ^WORK2($j,X1)=WK1_%_WK2_%_WK3
	G D05

	;Print report
E01	D ^OUTPUT G:%OP[% XSEG S N=99,P=1 D HEAD^XSXS
	W ?25,"From ",A1," to ",A2,!! S N=N+2
	S (X3,CX,MX)=""
E03	S X3=$o(^WORK($j,X3)) I X3="" G F01
	W !?6,"Fee Earner ",X3," ",$p($g(^SF(X3)),%,1),!! S N=N+3,(T1,T2,T3)=0
E04	S CX=$o(^WORK($j,X3,CX)) I CX="" G E10
E05	S MX=$o(^WORK($j,X3,CX,MX)) I MX="" G E04
	S WK=^WORK($j,X3,CX,MX),WK1=$p(WK,%,1),WK2=$p(WK,%,2),WK3=$p(WK,%,3)
	S T1=T1+WK1,T2=T2+WK2,T3=T3+WK3,T0=WK1 D TCON
	W ?6,"Client/matter ",CX,"/",MX,?33,"Hours ",T0,?47,"Items ",WK2,?60,"Value ",$j(WK3,0,2),!! S N=N+2 I N>58 D HEAD^XSXS
	G E05
E10	S T0=T1 D TCON
	W ?6,"Totals F/e ",X3,?33,"Hours ",T0,?47,"Items ",T2,?60,"Value ",$j(T3,0,2),!! S N=N+2 I N>58 D HEAD^XSXS
	G E03

	;Print summary
F01	D HEAD^XSXS
	W ?29,"Summary by " W:A3="A" $$^NEWNAME("@F7@") W:A3="B" $$^NEWNAME("@F8@") W:A3="C" "Client" W !!! S N=N+3
	S X1=""
F02	S X1=$o(^WORK2($j,X1)) I X1="" G G01
	S WKA=^WORK2($j,X1),WK1=$p(WKA,%,1),WK2=$p(WKA,%,2),WK3=$p(WKA,%,3)
	S T0=WK1 D TCON
	W ?6 W:A3="A" $$^NEWNAME("@F7@")," = " W:A3="B" $$^NEWNAME("@F8@")," = " W:A3="C" "Client " W X1,?33,"Hours ",T0,?47,"Items ",WK2,?60,"Value ",$j(WK3,0,2),!! S N=N+2 I N>58 D HEAD^XSXS
	G F02

G01	D END^XSXS
	Q

	;convert time subroutine
TCON	S A=T0\60_":",T0=T0#60 S:T0<10 T0=0_T0 S T0=A_T0
	Q
