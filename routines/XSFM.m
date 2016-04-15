XSFM	;GRI,,,;07:52 AM  25 Jul 2007;
	;=======================================================
	; Virgo Accounts - Cashbook Transfers
	;
	; Copyright Graham R Irwin 1993-2007
	;
	; Screens:       1086
	; Files updated:
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, ^OUTPUT, 
	;                HEAD^XSXS, END^XSXS, DMY2H^DATE
	;
	;=======================================================

	D X0^XSXS
	S %S=1086 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSFM Q
	W @P1 D HEAD

	;Display cashbook transactions
E01	S IX="" W /c(0,10),/ef,@P1
E02	S IX=$O(^CB(DX,IX)),TOT=0 I $Y>19 G E09
	I IX="" G E08
E03	D LINE
	G E02

E08	D TOTAL S (E2,E3)=0,TOT=1

E09	W /C(0,22),@P1 W "Next, Print or Quit ? ",/EL,@P2 D ^GETX S X=$zconvert(X,"U")
	I X="Q"!(X=%) G XSFM
	I X="P" G P01
	I X="N" G N01
	I X="\\" G M01
	G E09

	;Next
N01	W /C(0,10),/EF,@P1
	I TOT G M01
	G E03:IX'="" G E08

	;Home
M01	W /C(0,10),/EF,@P1
	S IX="" G E02

	;Print
P01	D ^OUTPUT G:%OP[% XSFM S N=99,P=1,IX="" D HEAD^XSXS
P1A	W "Cashbook ",DX,?14,$p(^CB(DX),%,1),! D HEAD S N=N+4
P02	S IX=$O(^CB(DX,IX)) I IX="" G P04
	D LINE I N>56 D HEAD^XSXS
	G P02
P04	D TOTAL W !! S N=N+3
	I ALL S DX=$o(^CB(DX)) I DX'="" G P1A
	D END^XSXS
	G XSFM

	;Validation - Cashbook
V01	I X<99 S ERR="Must be a client cashbook"
	Q

	;From date
V02	S %DAT=D1 D DMY2H^DATE S DH1=%H
	S %DAT=X D DMY2H^DATE S DH2=%H
	I DH2<DH1 S ERR="Must not be earlier than to date"
	Q

	;Show heading (display or print)
HEAD	W !?5,"Date",?18,"Ref No   Type",?36,"Receipt",?49,"Payment",!! S (E2,E3)=0 Q

LINE	S CB=^CB(DX,IX) I IX=0 Q
	S C1=$P(CB,%,1) S %DAT=C1 D DMY2H^DATE I %H<DH1 Q
	I %H>DH2 Q
	S C4=$P(CB,%,4) I "COD,COB,TOC,TCO"'[C4 Q
	S C2=$P(CB,%,2),C3=$P(CB,%,3),C5=$P(CB,%,5),C6=$P(CB,%,6),E2=E2+C2,E3=E3+C3
	W ?5,C1,?18,C5,?27,C4 W:C3 ?33,$J(C3,10,2) W:C2 ?46,$J(C2,10,2) W !?6,C6,! I $d(N) S N=N+2
	Q

TOTAL	W ?34,"---------",?47,"---------",!?5,"Total",?33,$j(E3,10,2),?46,$j(E2,10,2) Q
