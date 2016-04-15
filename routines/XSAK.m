XSAK	;GRI,,,;03:38 PM  12 Jan 2001;
	;=======================================================
	; Virgo Accounts - Opened/Closed Matters List
	;
	; Copyright Graham R Irwin 1993-2001
	;
	; Screens:       1018, 1073, 1041, 1070
	; Files updated: ^WORK($j)
	; Subroutines:	 X0^XSXS, ^INPUT, DMY2H^DATE, ^OUTPUT,
	;                HEAD^XSXS, END^XSXS, ^NEWNAME
	;
	;=======================================================

	D X0^XSXS
	;from date & to date
	S %S=1018 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSAK Q
	;opened/closed
	S %S=1073 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSAK
	;option
	W !?8,@P1,"Do you wish to list matters by:-"
	W !!?8,"A - ",$$^NEWNAME("@F7@")
	W !?8,"B - ",$$^NEWNAME("@F8@")
	W !?8,"C - Client",!!
	S %S=1041 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSAK
	;legal aid
	S %S=1070 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSAK
	I A4="" S A4="YN"

	W /C(0,22),@P1,"Sorting, please wait ..."
	;walk matter file and create work file
	K ^WORK($j) S (CX,MX)=""
M01	S CX=$o(^SM(CX)) I CX="" G P00
M02	S MX=$o(^SM(CX,MX)) I MX="" G M01
	I '$d(^SM(CX,MX,X3)) G M02
	S SMA=^SM(CX,MX),SMA8=$p(SMA,%,8),SMA9=$p(SMA,%,9),SMA3=$p(SMA,%,3)
	I A4'[SMA3 G M02
	S:A3="A" X1=SMA8 S:A3="B" X1=SMA9 S:A3="C" X1=CX I X1="" S X1="null"
	S %DAT=^SM(CX,MX,X3) D DMY2H^DATE S D0=%H
	I D1'>D0,D0'>D2 S ^WORK($j,X1,CX,MX)=""
	G M02

	;Print
P00	D ^OUTPUT G:%OP[% XSAK
	S N=99,P=1 D HEAD^XSXS
	W "Matters " W:X3="O" "open" W:X3="C" "clos" W "ed between ",A1," and ",A2," - ",$$^NEWNAME("@F1@")," = " W:$l(A4)=1 A4 W:$l(A4)=2 "Y or N" W !! S N=N+2
	S (X1,CX,MX)=""
P01	S X1=$o(^WORK($j,X1)) I X1="" G P99
	I A3="A" W $$^NEWNAME("@F7@")," = ",X1
	I A3="B" W $$^NEWNAME("@F8@")," = ",X1
	I A3="C" W "Client ",X1
	W !! S N=N+2
P02	S CX=$o(^WORK($j,X1,CX)) I CX="" G P01
P03	S MX=$o(^WORK($j,X1,CX,MX)) I MX="" G P02
	S C1=$p(^SC(CX),%,1),M1=$p(^SM(CX,MX),%,1)
	W CX,?6,C1,!,MX,?6,M1,?55 W:X3="O" "Open" W:X3="C" "Clos" W "ed ",^SM(CX,MX,X3),!!
	S N=N+3 I N>56 D HEAD^XSXS
	G P03

P99	D END^XSXS
	Q

	;Validation - Opened/closed
V01	I $d(ERR) Q
	D CASE I "OC"'[X S ERR="Must be 'O' or 'C'"
	Q

CASE	S X=$zconvert(X,"U") Q
