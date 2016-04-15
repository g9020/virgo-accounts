XSAE	;GRI,,,;08:28 AM  14 Jul 2002
	;=======================================================
	; Virgo Accounts - Matter Search
	;
	; Copyright Graham R Irwin 1993-2002
	;
	; Screens:       1002, 1076
	; Files updated: ^WORK($j)
	; Subroutines:	 X0^XSXS, ^INPUT, ^OUTPUT, HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS S YES="Y"
	S %S=1002 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSAE Q
	S %S=1076 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSAE Q

	W /C(0,13),@P1
	K ^WORK($j) S (CX,MX)="",NC=0
G01	S CX=$o(^SM(CX)) I CX="" G H01
G02	S MX=$o(^SM(CX,MX)) I MX="" G G01
	S SM=^SM(CX,MX),M1=$p(SM,%,1),M3=$P(SM,%,3),M4=$P(SM,%,4),M5=$P(SM,%,5),M6=$P(SM,%,6),M7A=$p($P(SM,%,7),"/",1),M8=$P(SM,%,8),M9=$P(SM,%,9)
	I A9="Y",$d(^SM(CX,MX,"C")) G G02
	I A1'="",A1'=M4 G G02
	I A2'="",A2'=M3 G G02
	I A3'="",A3'=M5 G G02
	I A4'="",A4'=M8 G G02
	I A5'="",A5'=M9 G G02
	I A6'="",A6'=M7A G G02
	I A7'="",M1'[A7,^SM(CX,MX,"N")'[A7 G G02
	S NC=NC+1,SCA1=$p(^SC(CX),%,1),SMA1=$p(^SM(CX,MX),%,1)
	S ^WORK($j,NC)=CX_%_MX_%_SCA1_%_SMA1
	I NC<10 W NC,?5,CX,?10,MX,?16,SMA1,?48,SCA1,!
	I NC>9 S WX=NC-9 D NXTSCR
	G G02

	;Done searching
H01	I '$d(^WORK($j)) W /C(0,22),@P1,"No matters found. Press any key to continue " R *X R:'X *X G XSAE

	;Print
P01	D ^OUTPUT I %OP[% G XSAE
	S N=99,P=1 D HEAD^XSXS
	W "Matters with:"
	I A2'="" W ?15,$$^NEWNAME("@F1@")," = ",A2,! S N=N+1
	I A1'="" W ?15,$$^NEWNAME("@F2@")," = ",A1,! S N=N+1
	I A3'="" W ?15,$$^NEWNAME("@F3@")," = ",A3,! S N=N+1
	I A6'="" W ?15,"Charge group = ",A6,! S N=N+1
	I A4'="" W ?15,$$^NEWNAME("@F7@")," = ",A4,! S N=N+1
	I A5'="" W ?15,$$^NEWNAME("@F8@")," = ",A5,! S N=N+1
	W ! S N=N+1,WX=""
H02	S WX=$o(^WORK($j,WX)) I WX="" G J01
	S WK=^WORK($j,WX),CX=$p(WK,%,1),MX=$p(WK,%,2),SCA1=$p(WK,%,3),SMA1=$P(^SM(CX,MX),%,1)
	W "Client ",CX,?12,SCA1,!,"Matter ",MX,?12,SMA1
	I $d(^SM(CX,MX,"C")) W ?55,"Closed ",^SM(CX,MX,"C")
	W !! S N=N+3 I N>58 D HEAD^XSXS
	G H02

J01	D END^XSXS
	G XSAE

	;Move all up one line and redisplay
NXTSCR	W /C(0,13),/EF
NS1	S WX=$o(^WORK($j,WX)) I WX="" Q
	S WK=^WORK($j,WX),CX=$p(WK,%,1),MX=$p(WK,%,2),SCA1=$p(WK,%,3),SMA1=$P(WK,%,4)
	W WX,?5,CX,?10,MX,?16,SMA1,?48,SCA1,!
	G NS1

	;Validation - Descr/narr
V05	I A1="",A2="",A3="",A6="",A4="",A5="",X="" S ERR="Select one or more of the above options"
	Q

CASE	S X=$zconvert(X,"U") Q
