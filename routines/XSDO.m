XSDO	;GRI,,,;05:14 PM  2 Nov 2000;
	;=======================================================
	; Virgo Accounts - Cash Received Analysis
	;
	; Copyright Graham R Irwin 1993-2000
	;
	; Screens:       1018, 1041
	; Files updated: ^WORK($j)
	; Subroutines:	 X0^XSXS, ^INPUT, DMY2H^DATE, ^OUTPUT,
	;                HEAD^XSXS, END^XSXS, ^NEWNAME
	;
	;=======================================================

	D X0^XSXS
	S %S=1018 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSDO Q

	W !?8,@P1,"Do you wish to analyse cash received by:-"
	W !!?8,"A - ",$$^NEWNAME("@F7@")
	W !?8,"B - ",$$^NEWNAME("@F8@")
	W !?8,"C - Client",!!
	S %S=1041 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSDO

	W /C(0,22),@P1,"Sorting, please wait ..."
	;walk the matter ledger and create work file
	K ^WORK($j) S (CX,MX,X3)=""
G01	S CX=$o(^ML(CX)) I CX="" G H01
G02	S MX=$o(^ML(CX,MX)) I MX="" G G01
G03	S X3=$o(^ML(CX,MX,X3)) I X3="" G G02
	S ML=^ML(CX,MX,X3),MLA1=$p(ML,%,1),MLA2=$p(ML,%,2),MLA4=$p(ML,%,4)
	I "COB;BPY"'[MLA4 G G03
	S SM=^SM(CX,MX),M8=$p(SM,%,8),M9=$p(SM,%,9)
	S:A3="A" X1=M8 S:A3="B" X1=M9 S:A3="C" X1=CX S:X1="" X1="null"
	S %DAT=MLA1 D DMY2H^DATE
	I D1'>%H,%H'>D2 D ADDIN
	G G03

	;Print
H01	D ^OUTPUT G:%OP[% XSDO
	S T1=0,N=99,P=1 D HEAD^XSXS
	W "From ",A1," to ",A2,!!
	W ?2,"Date",?14,"Client/Matter",?66,"Amount",!
	S N=N+3,X1=""

H02	S X1=$o(^WORK($j,X1)) I X1="" G J01
	S WK=^WORK($j,X1),W1=$p(WK,%,1)
	W !
	I A3="A" W $$^NEWNAME("@F7@")," = ",X1
	I A3="B" W $$^NEWNAME("@F8@")," = ",X1
	I A3="C" W "Client ",X1 I $d(^SC(X1)) W " - ",$p(^SC(X1),%,1) 
	W ?49,"Total",?62,$j($fn(W1,",",2),12),?31,!!
	S T1=T1+W1,N=N+3 I N>56 D HEAD^XSXS
H10	S CX=$o(^WORK($j,X1,CX)) I CX="" G H02
H11	S MX=$o(^WORK($j,X1,CX,MX)) I MX="" G H10
H12	S X3=$o(^WORK($j,X1,CX,MX,X3)) I X3="" G H11
	S WKA=^WORK($j,X1,CX,MX,X3),WKA1=$p(WKA,%,1),WKA2=$p(WKA,%,2)
	S CLA1=$p(^SC(CX),%,1)
	W ?2,WKA1,?14,CX,"/",MX,?25,CLA1,?60,$j($fn(WKA2,",",2),12),! S N=N+1 I N>56 D HEAD^XSXS
	G H12

J01	W !?62,"------------",!
	W ?49,"TOTAL",?62,$j($fn(T1,",",2),12),?31,!
	D END^XSXS
	Q

	;Add to work file
	; ^WORK($j,X1) = W1 where:
	; X1 = client code, analysis A or analysis B
	; W1 = total fees
ADDIN	S WK=$g(^WORK($j,X1))
	S W1=$p(WK,%,1)+MLA2
	S ^WORK($j,X1)=W1,^WORK($j,X1,CX,MX,X3)=MLA1_%_MLA2
	Q
