XSCE	;GRI,,,;02:24 PM  31 Mar 1999
	;=======================================================
	; Virgo Accounts - Nominal Account Enquiry
	;
	; Copyright Graham R Irwin 1993-99
	;
	; Screens:       1064
	; Files updated: none
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, ^OUTPUT, 
	;                HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS
	S %S=1064 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSCE Q
	S IX="" W @P1 D HEAD
E02	S IX=$O(^AY(AX,IX)) I IX=""!($Y>19) G E09
E03	S AY=^AY(AX,IX),D1=$P(AY,%,1),D2=$P(AY,%,2),D3=$P(AY,%,3),D4=$P(AY,%,4),D5=$P(AY,%,5),E4=E4+D2
	D LINE G E02

E09	W /C(0,22),@P1,"Next, Print or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) G XSCE
	I X="P" G P01
	I X="N" G N01
	I X="\\" G H01
	G E09

	;Next
N01	W /C(0,9),/EF,@P1 G E03:IX'="" S E4=0 G E02

	;Home
H01	W /C(0,9),/EF,@P1 S IX="",E4=0 G E02

	;Print
P01	D ^OUTPUT G:%OP[% XSCE S N=99,P=1 D HEAD^XSXS
	D PRINT,END^XSXS
	G XSCE

	;Print routine
PRINT	W "Account ",AX," : ",$P(^AB(AX),%,1),?49,"Balance ",$j($p(^AB(AX),%,3),0,2),! D HEAD S N=N+4,IX=""
P02	S IX=$O(^AY(AX,IX)) I IX="" Q
P03	S AY=^AY(AX,IX),D1=$P(AY,%,1),D2=$P(AY,%,2),D3=$P(AY,%,3),D4=$P(AY,%,4),D5=$P(AY,%,5),E4=E4+D2
	D LINE S N=N+2 I N>56 D HEAD^XSXS
	G P02

	;Validation - A/c code
V01	Q:$D(ERR)  S A3=$j($p(^AB(X),%,3),0,2)
	Q

CASE	S X=$zconvert(X,"U") Q

HEAD	W !?5,"Date",?18,"Ref No   Type",?49,"Amount",?62,"Balance",!! S E4=0 Q

LINE	W ?5,D1,?18,D4,?27,D3,?46,$J(D2,10,2),?59,$J(E4,10,2),!?6,D5,! Q
