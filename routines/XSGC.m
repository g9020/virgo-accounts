XSGC	;GRI,,,;10:09 AM  16 Mar 1999
	;=======================================================
	; Virgo Accounts - Maintain Fee Rate Table
	;
	; Copyright Graham R Irwin 1993-99
	;
	; Screens:       1038, 1043
	; Files updated: ^SR ^SEARCH
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, AMOUNT^INPUT
	;
	;=======================================================

	D X0^XSXS
	L ^SR
	S %J=1,%S=1038 D ^INPUT Q:X[%
	I $D(^SR(X)) S R1=^SR(RX),%J=2 D D^INPUT G E02
	W /C(48,4),"* NEW RECORD *",!
	F %J=2:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSGC
E02	W @P1,!?8,"Activity",?44,"Hourly Rate",?60,"Rate per Item",!! S A1=""
E03	S A1=$O(^SR(RX,A1)) I A1=""!($Y>20) G L01
E04	S SR=^SR(RX,A1),A2=$P(SR,%,1),A3=$P(SR,%,2),B1=$P($G(^SA(A1)),%,1)
	W @P1,?8,A1,?13,B1 W:A2 ?46,$J(A2,6,2) W:A3 ?62,$J(A3,6,2) W ! G E03
L01	W /C(0,22),@P1,"Next, Select, Insert, Amend, Delete or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) G XSGC
	I X="N" G N01
	I X="A" G A51
	I X="S"!(X="Z") G S01
	I X="I" G I01
	I X="D" W @P1,"  Delete entire table ? ",@P2 D ^GETX,CASE I X="Y" K ^SR(RX),^SEARCH("SR",$zconvert(R1,"L"),RX) G XSGC
	G L01

	;Insert item
I01	D CUP S %S=1043 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G I01:%J>1 S A1="" D CUP G L01
E09	W /C(0,22),@P1,"Update, Amend, Delete or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="A" G A01
	I X="U" G U01
	I X="Q"!(X=%) D CUP G L01
	I X="D" W @P1,"  Are you sure ? ",@P2 D ^GETX,CASE I X="Y" K ^SR(RX,A1) S A1="" G N01
	G E09

	;Update item
U01	S ^SR(RX)=R1,^SEARCH("SR",$zconvert(R1,"L"),RX)=""
	S ^SR(RX,A1)=A2_%_A3_% W /C(0,9),/EF,@P1 S A1="" G E03

	;Next
N01	W /C(0,9),/EF,@P1 G E04:A1'="",E03

	;Amend item
A01	D CUP S %S=1043,%J=1 D D^INPUT
	F %J=2:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSGC:%J=2,A01
	G E09

	;Amend charge group
A51	S R1X=R1,%J=2,%S=1038 W /c(0,5) D A^INPUT G XSGC:X[%
	I R1X'=RX S ^SR(RX)=R1,^SEARCH("SR",R1,RX)="" K ^SEARCH("SR",R1X,RX)
	G E02

	;Select item
S01	W @P1,"  Activity ",@P2 D ^GETX,CASE G:X="" L01 I $G(^SR(RX,X))="" G L01
	S A1=X,SR=^SR(RX,A1),A2=$P(SR,%,1),A3=$P(SR,%,2),%S=1043
	S:A2=0 A2="" S:A3=0 A3=""
	D CUP F %J=1:1 D D^INPUT Q:X="END"!(X[%)
	G E09

	;Validation - Activity
V01	I $D(^SR(RX,X)) S ERR="Already used"
	Q
	;Rate per item
V02	I X="",A2="" S ERR="Either hourly rate or rate/item must be defined" Q
	I X'="" D AMOUNT^INPUT Q:$D(ERR)  I A2'="" S ERR="Cannot both be defined"
	Q

CASE	S X=$zconvert(X,"U") Q

CUP	W /C(0,18),/EF Q
