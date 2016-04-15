XSGD	;GRI,,,;05:19 PM  1 Oct 2004
	;=======================================================
	; Virgo Accounts - Maintain Account Codes
	;
	; Copyright Graham R Irwin 1993-2004
	;
	; Screens:       1039
	; Files updated: ^AB ^SEARCH ^NB
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX
	;
	;=======================================================

	D X0^XSXS
	L ^AB
	S (A2,A3,A4)=0,A5="N"
	S %J=1,%S=1039 D ^INPUT Q:X[%  I $D(^AB(X)) G D01
	W /C(48,4),"* NEW RECORD *",!
	F %J=2:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSGD
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX D CASE G XSGD:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	S ^AB(AX)=A1_%_A2_%_A3_%_A4_%_A5_%
	S A1L=$zconvert(A1,"L"),^SEARCH("AB",A1L,AX)=""
	I $d(A1X) S A1XL=$zconvert(A1X,"L") I A1L'=A1XL K ^SEARCH("AB",A1XL,AX)
	I B1="" K ^NB(AX)
	I B1'="" S ^NB(AX)=B1
	G XSGD

	;Display
D01	S AB=^AB(X),A1=$P(AB,%,1),A2=$P(AB,%,2),A3=$J($P(AB,%,3),0,2),A4=$P(AB,%,4),A5=$P(AB,%,5),A1X=A1,DEL=0,AMD=0
	S B1=$g(^NB(X))
	;allow deletion if not a system account and both current balance and
	;year-to-date balances are zero and there are no transactions
	I A5'="Y",A2=0,+A3=0,'$d(^AY(AX)) S DEL=1
D02	F %J=2:1 D D^INPUT Q:X="END"
D03	W /C(0,22),@P1,"Amend" W:DEL ", Delete" W " or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) G XSGD:'AMD W @P1,"  Quit without update ? ",@P2 D ^GETX D CASE G XSGD:X="Y",D03
	I X="A" G A01
	I X="D",DEL W @P1,"  Are you sure ? ",@P2 D ^GETX,CASE I X="Y" K ^AB(AX),^SEARCH("AB",$zconvert(A1,"L"),AX) G XSGD
	G D03

	;Amend
A01	S AMD=1 W /C(0,5),/EF F %J=2:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSGD:%J=2,A01
	G E02

	;Validation - Account code
V01	D CASE I "EIALN"'[$E(X,1) S ERR="First character must be 'I', 'A', 'E' or 'L'" Q
	;I $E(X,4)'=0 S ERR="Last character must be 0"
	Q

	;Budget
V02	I X="" K ERR
	Q

CASE	S X=$zconvert(X,"U") Q
