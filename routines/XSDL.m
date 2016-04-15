XSDL	;GRI,,,;11:33 AM  16 Mar 1999;
	;=======================================================
	; Virgo Accounts - Legal Aid Work Analysis
	;
	; Copyright Graham R Irwin 1993-99
	;
	; Screens:       1018, 1041
	; Files updated: ^WORK($j)
	; Subroutines:	 X0^XSXS, ^INPUT, DMY2H^DATE, ^OUTPUT,
	;                HEAD^XSXS, END^XSXS, ^NEWNAME
	;
	;=======================================================

	D X0^XSXS
	S %S=1018 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSDL Q

	W !?8,@P1,"Do you wish to analyse bills by:-"
	W !!?8,"A - ",$$^NEWNAME("@F7@")
	W !?8,"B - ",$$^NEWNAME("@F8@")
	W !?8,"C - Client",!!
	S %S=1041 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSDL

	W /C(0,22),@P1,"Sorting, please wait ..."
	;walk the bills register and create work file
	K ^WORK($j) S BX=""
G01	S BX=$o(^SB(BX)) I BX="" G H01
	S SB=^SB(BX),B1=$p(SB,%,1),CX=$p(SB,%,2),MX=$p(SB,%,3),B4=$p(SB,%,4),B5=$p(SB,%,5),B9=$p(SB,%,9)
	I B9="C" G G01
	I '$d(^SM(CX,MX)) S (M3,M8,M9)="??"
	E  S SM=^SM(CX,MX),M8=$p(SM,%,8),M9=$p(SM,%,9),M3=$p(SM,%,3)
	I M3'="Y" G G01
	S Q1=$g(^SM(CX,MX,"C")) I Q1="" G G01
	S:A3="A" X1=M8 S:A3="B" X1=M9 S:A3="C" X1=CX S:X1="" X1="null"
	S %DAT=Q1 D DMY2H^DATE
	I D1'>%H,%H'>D2 D ADDIN
	G G01

	;Print
H01	D ^OUTPUT G:%OP[% XSDL
	S (T1,T2,T3)=0,N=99,P=1 D HEAD^XSXS
	W "From ",A1," to ",A2,?40,$$^NEWNAME("@F1@")," = Y",!!
	W ?19,"Billed Time  Billed Disb  Total Bills  No Bills    Average",!
	W ?59,"Matters",!
	S N=N+4,X1=""
H02	S X1=$o(^WORK($j,X1)) I X1="" G J01
	S WK=^WORK($j,X1),W1=$p(WK,%,1),W2=$p(WK,%,2),W3=$p(WK,%,3),W4=$p(WK,%,4)
	I A3="A" W $$^NEWNAME("@F7@")," = ",X1
	I A3="B" W $$^NEWNAME("@F8@")," = ",X1
	I A3="C" W "Client ",X1 I $d(^SC(X1)) W " - ",$p(^SC(X1),%,1) 
	W !?18,$j($fn(W1,",",2),12),?31,$j($fn(W2,",",2),12),?44,$j($fn(W1+W2,",",2),12),?64-$l(W3),W3,?65,$j($fn(W1+W2/W3,",",2),12),!
	W ?64-$l(W4),W4,?65,$j($fn(W1+W2/W4,",",2),12),!
	S T1=T1+W1,T2=T2+W2,T3=T3+W3,N=N+3 I N>56 D HEAD^XSXS
	G H02

J01	W ?19,"-----------  -----------  -----------  ------",!
	W "Totals",?18,$j($fn(T1,",",2),12),?31,$j($fn(T2,",",2),12),?44,$j($fn(T1+T2,",",2),12),?64-$l(T3),T3,!
	D END^XSXS
	Q

	;Add to work file
	; ^WORK($j,X1) = W1, W2, W3 where:
	; X1 = client code, analysis A or analysis B
	; W1 = total fees, W2 = total disbs, W3 = no of bills
ADDIN	S WK=$g(^WORK($j,X1))
	S W1=$p(WK,%,1)+B4,W2=$p(WK,%,2)+B5,W3=$p(WK,%,3)+1,W4=$p(WK,%,4)
	I '$d(^WORK($j,X1,CX,MX)) S W4=W4+1
	S ^WORK($j,X1)=W1_%_W2_%_W3_%_W4,^WORK($j,X1,CX,MX)=""
	Q

	;Validation - From date
V01	Q:$d(ERR)  S %DAT=X D DMY2H^DATE S D1=%H
	I %H>+$H S ERR="May not be in the future"
	Q
	;To date
V02	Q:$d(ERR)  S %DAT=X D DMY2H^DATE S D2=%H
	I D1>%H S ERR="May not be earlier than From date"
	Q
	;Option
V03	I "ABC"'[X S ERR="Must be 'A', 'B' or 'C'"
	Q
