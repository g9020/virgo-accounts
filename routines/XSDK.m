XSDK	;GRI,,,;05:40 PM  29 Mar 1999;
	;=======================================================
	; Virgo Accounts - Matter Balances Analysis
	;
	; Copyright Graham R Irwin 1993-99
	;
	; Screens:       1041, 1067
	; Files updated: ^WORK($j)
	; Subroutines:	 X0^XSXS, ^INPUT, ^OUTPUT, HEAD^XSXS,
	;                END^XSXS, ^NEWNAME
	;
	;=======================================================

	D X0^XSXS S YES="Y"

	W !?8,@P1,"Do you wish to list matters by:-"
	W !!?8,"A - ",$$^NEWNAME("@F7@")
	W !?8,"B - ",$$^NEWNAME("@F8@")
	W !?8,"C - Client",!!
	S %S=1041 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSDK Q
	S %S=1067 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSDK

	W /C(0,22),@P1,"Sorting, please wait ..."
	K ^WORK($j) S (CX,MX)=""
G01	S CX=$o(^SM(CX)) I CX="" G H01
G02	S MX=$o(^SM(CX,MX)) I MX="" G G01
	S SM=^SM(CX,MX),M8=$p(SM,%,8),M9=$p(SM,%,9)
	S:A3="A" X1=M8 S:A3="B" X1=M9 S:A3="C" X1=CX S:X1="" X1="null"
	S ML=$g(^ML(CX,MX)),M1=$p(ML,%,1),M2=$p(ML,%,2),CL=+$g(^CL(CX,MX)),SW=+$g(^SW(CX,MX))
	I A1="N"!(M1!M2!CL!SW) S ^WORK($j,X1,CX,MX)=(M1+M2)_%_CL_%_SW
	G G02

	;Print
H01	D ^OUTPUT G:%OP[% XSDK
	S N=99,P=1 D HEAD^XSXS
	S (X1,CX,MX)="",(T1,T2,T3,T4,T5,T6)=0
	D HEAD
H02	S X1=$o(^WORK($j,X1)) I X1="" G J01
H03	S CX=$o(^WORK($j,X1,CX)) I CX="" G H10
H04	S MX=$o(^WORK($j,X1,CX,MX)) I MX="" G H03
	S WK=^WORK($j,X1,CX,MX),W1=$p(WK,%,1),W2=$p(WK,%,2),W3=$p(WK,%,3)
	W CX,"/",MX,?10,$p(^SC(CX),%,1) D LINE I N>56 D HEAD^XSXS
	S T1=T1+W1,T2=T2+W2,T3=T3+W3
	G H04

H10	F I=1:1:78 W "-"
	W !,"Total for "
	I A3="A" W $$^NEWNAME("@F7@")," = "
	I A3="B" W $$^NEWNAME("@F8@")," = "
	I A3="C" W "Client "
	S W1=T1,W2=T2,W3=T3 W X1 D LINE
	F I=1:1:78 W "="
	W !! S N=N+3,T4=T4+T1,T5=T5+T2,T6=T6+T3,(T1,T2,T3)=0
	;I ... D HEAD^XSXS,HEAD
	I N>56 D HEAD^XSXS
	G H02

J01	W "TOTAL FOR FIRM" S W1=T4,W2=T5,W3=T6 D LINE
	D END^XSXS
	Q

LINE	W ?41,$j($fn(W3,"t",2),12),?53,$j($fn(W1,"t",2),12),?65,$j($fn(W2,"t",2),12),! S N=N+1
	Q

HEAD	W "Client/Matter Code & Client Name",?47,"W-I-P",?58,"Office",?70,"Client",!! S N=N+2
	Q
