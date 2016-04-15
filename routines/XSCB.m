XSCB	;GRI,,,;11:12 AM  13 Mar 2000
	;=======================================================
	; Virgo Accounts - Cashbook Enquiry
	;
	; Copyright Graham R Irwin 1993-99
	;
	; Screens:       1014
	; Files updated:
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, ^OUTPUT, 
	;                HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS
	S %S=1014 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSCB Q
	S DET=0 I $d(^CA(DX)) S DET=1
	W @P1 D HEAD

	;Display cashbook transactions
E01	S IX="",MOD=0,E4=0 W /c(0,9),/ef,@P1
E02	S IX=$O(^CB(DX,IX)) I IX=""!($Y>19) G E09
E03	D LINE
	G E02

E09	W /C(0,22),@P1,"Next, "
	W:DET&'MOD "History, " W:MOD "Current, "
	W "Print or Quit ? ",/EL,@P2 D ^GETX S X=$zconvert(X,"U")
	I X="Q"!(X=%) G XSCB
	I X="P" G P01
	I DET,'MOD,X="H" G H01
	I MOD,X="C" G E01
	I X="N" G N01
	I X="\\" G M01
	G E09

	;Display history
H01	S IX="",MOD=1,E4=0 W /c(0,9),/ef,@P1
H02	S IX=$O(^CA(DX,IX)) I IX=""!($Y>19) G E09
H03	D HLINE
	G H02

	;Next
N01	W /C(0,9),/EF,@P1
	I MOD G H03:IX'="" S E4=0 G H02
	G E03:IX'="" S E4=0 G E02

	;Home
M01	W /C(0,9),/EF,@P1
	I MOD S IX="",E4=0 G H02
	S IX="",E4=0 G E02

	;Print
P01	D ^OUTPUT G:%OP[% XSCB S N=99,P=1,IX="" D HEAD^XSXS
	D PRINT
	D END^XSXS
	G XSCB

	;Validation - Cashbook
V01	I $D(ERR) Q
	S B6=$J($P(^CB(X),%,6),0,2)
	Q

	;Print routine
PRINT	W "Cashbook ",DX,?14,$p(^CB(DX),%,1),!
	W "Balance ",$j(B6,12,2)
	I MOD W ?50,"* Historic Entries *"
	W ! D HEAD S N=N+4
	I MOD G P12

	;current transactions
P02	S IX=$O(^CB(DX,IX)) I IX="" Q
	D LINE S N=N+2 I N>56 D HEAD^XSXS
	G P02

	;historic transactions
P12	S IX=$O(^CA(DX,IX)) I IX="" Q
	D HLINE S N=N+2 I N>56 D HEAD^XSXS
	G P12

	;Show heading (display or print)
HEAD	W !?5,"Date",?18,"Ref No   Type",?36,"Receipt",?49,"Payment",?62,"Balance",!! S E4=0 Q

LINE	S CB=^CB(DX,IX) D DATA Q

HLINE	S CB=^CA(DX,IX) D DATA Q

DATA	S C1=$P(CB,%,1),C2=$P(CB,%,2),C3=$P(CB,%,3),C4=$P(CB,%,4),C5=$P(CB,%,5),C6=$P(CB,%,6),E4=E4-C2+C3
	W ?5,C1,?18,C5,?27,C4 W:C3 ?33,$J(C3,10,2) W:C2 ?46,$J(C2,10,2) W ?59,$J(E4,10,2),!?6,C6,!
	Q
