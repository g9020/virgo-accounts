XSFG	;GRI,,,;08:25 AM  18 Jun 2004
	;=======================================================
	; Virgo Accounts - Client Account Enquiry
	;
	; Copyright Graham R Irwin 1993-2004
	;
	; Screens:       1032
	; Files updated: none
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, ^GETPGM(XSCA),
	;                ^OUTPUT, HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS
	S %S=1032 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSFG Q
	S IX="" W @P1 D HEAD
E02	S IX=$O(^CL(CX,MX,IX)) I IX=""!($Y>19) G E09
E03	D LINE
	G E02

E09	W /C(0,22),@P1,"Next, Print, Export or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) G XSFG
	I X="P" G P01
	I X="N" G N01
	I X="E" G EXPORT
	I X="\\" G H01
	I X="Z" D ^GETPGM(3,1) G ^@PGM
	G E09

	;Next
N01	W /C(0,11),/EF,@P1 G E03:IX'="" S E4=0 G E02

	;Home
H01	W /C(0,11),/EF,@P1 S IX="",E4=0 G E02

	;Print
P01	D ^OUTPUT G:%OP[% XSFG S N=99,P=1 D HEAD^XSXS
	D PRINT
	D END^XSXS
	G XSFG

	;Print a client account
	;may be called by another program (needs CX, MX defined)
PRINT	W "Client ",CX,?12,$P(^SC(CX),%,1),!,"Matter ",MX,?12,$P(^SM(CX,MX),%,1),!,"Current balance ",B1,?34,"Cashbook ",KX,?47,CBA1,!
	D HEAD S N=N+6,IX=""
P02	S IX=$O(^CL(CX,MX,IX)) I IX="" Q
	D LINE S N=N+2 I N>56 D HEAD^XSXS
	G P02

HEAD	W !?5,"Date",?18,"Ref No   Type",?36,"Payment",?49,"Receipt",?62,"Balance",!! S E4=0
	Q

LINE	S CL=^CL(CX,MX,IX),D1=$P(CL,%,1),D2=$P(CL,%,2),D3=$P(CL,%,3),D4=$P(CL,%,4),D5=$P(CL,%,5),D6=$P(CL,%,6),E4=E4-D2+D3
	W ?5,D1,?18,D5,?27,D4 W:D2 ?33,$J(D2,10,2) W:D3 ?46,$J(D3,10,2) W ?59,$J(E4,10,2),!?6,D6,!
	Q

	;Export
EXPORT	W @P1,"  File name: ",/ef,@P2
	D ^GETX,CASE
	I X'?1.8an G E09
	S FN=X_".txt",X3=""
	S %OP=10 O %OP:(file=FN:mode="w") U %OP
	W "Date^Payment^Receipt^Type^Ref No^Narrative",!
EX4	S X3=$o(^CL(CX,MX,X3)) I X3="" C %OP U 0 G XSFG
	W ^CL(CX,MX,X3),!
	G EX4

	;Validation - Matter number
V01	Q:$D(ERR)  I '$D(^CL(CX,X)) S ERR="No Client Ledger details for this matter" Q
	S SM=^SM(CX,X),M5=$p(SM,%,5),KX=$p(SM,%,10),CBA1=$p(^CB(KX),%,1)
	S CL=$g(^CL(CX,X)),B1=$j($p(CL,%,1),0,2),B2=$j($p(CL,%,2),0,2)
	Q
	;CL Balance
V02	I M5="Y" W @P3,?48,"Trust Matter"
	Q
	;Nominal int
V03	W @P2,?48,CBA1
	Q

CASE	S X=$zconvert(X,"U") Q
