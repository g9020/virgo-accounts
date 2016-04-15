XSAH	;GRI,,,;01:56 PM  24 Jul 2002;
	;=======================================================
	; Virgo Accounts - Detailed Matter Listing
	;
	; Copyright Graham R Irwin 1993-2002
	;
	; Screens:       1002, 1076, 1081
	; Files updated: ^WORK($j)
	; Subroutines:	 X0^XSXS, ^INPUT, ^OUTPUT, HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS S YES="Y",NO="N"
	S %S=1002 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSAH Q
	S %S=1076 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSAH Q
	S %S=1081 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSAH Q

	D ^OUTPUT I %OP[% G XSAH
	S N=99,P=1 D HEAD^XSXS
	W "Matters with:"
	I A2'="" W ?15,$$^NEWNAME("@F1@")," = ",A2,! S N=N+1
	I A1'="" W ?15,$$^NEWNAME("@F2@")," = ",A1,! S N=N+1
	I A3'="" W ?15,$$^NEWNAME("@F3@")," = ",A3,! S N=N+1
	I A6'="" W ?15,"Charge Group = ",A6,! S N=N+1
	I A4'="" W ?15,$$^NEWNAME("@F7@")," = ",A4,! S N=N+1
	I A5'="" W ?15,$$^NEWNAME("@F8@")," = ",A5,! S N=N+1

	S (CX,MX)=""
G01	S CX=$o(^SM(CX)) I CX="" G J01
G02	S MX=$o(^SM(CX,MX)) I MX="" G G01
	S SCA=^SC(CX),SCA1=$p(SCA,%,1),SCA2=$p(SCA,%,2),SCA3=$p(SCA,%,3)
	S SCB=^SC(CX,"A"),SCB1=$p(SCB,%,1),SCB2=$p(SCB,%,2),SCB3=$p(SCB,%,3),SCB4=$p(SCB,%,4),SCB5=$p(SCB,%,5)
	S SCN=^SC(CX,"N"),SCN1=$p(SCN,%,1),SCN2=$p(SCN,%,2),SCN3=$p(SCN,%,3)
	S SMA=^SM(CX,MX),SMA1=$p(SMA,%,1),SMA2=$p(SMA,%,2),SMA3=$p(SMA,%,3),SMA4=$p(SMA,%,4),SMA5=$p(SMA,%,5),SMA6=$p(SMA,%,6),SMA7A=$p($p(SMA,%,7),"/",1),SMA8=$p(SMA,%,8),SMA9=$p(SMA,%,9)
	S SMN=^SM(CX,MX,"N"),SMN1=$p(SMN,%,1),SMN2=$p(SMN,%,2),SMN3=$p(SMN,%,3)
	I A9="Y",$d(^SM(CX,MX,"C")) G G02
	I A1'="",A1'=SMA4 G G02
	I A2'="",A2'=SMA3 G G02
	I A3'="",A3'=SMA5 G G02
	I A4'="",A4'=SMA8 G G02
	I A5'="",A5'=SMA9 G G02
	I A6'="",A6'=SMA7A G G02

	I A10="Y" G G10
	W !,"Client ",CX,?12,SCA1,?67,"=========="
	W !,"Address",?12,SCB1,! S N=N+3
	I SCB2'="" W ?12,SCB2,! S N=N+1
	I SCB3'="" W ?12,SCB3,! S N=N+1
	I SCB4'="" W ?12,SCB4,! S N=N+1
	I SCB5'="" W ?12,SCB5,! S N=N+1
	W "Phone",?12,SCA2,! S N=N+1
	W "Fax",?12,SCA3,! S N=N+1 I N>55 D HEAD^XSXS
	W "Comments",?12,SCN1,! S N=N+1
	I SCN2'="" W ?12,SCN2,! S N=N+1
	I SCN3'="" W ?12,SCN3,! S N=N+1
	I N>55 D HEAD^XSXS
	W !,"........",?12,"Matter ",MX,?24,SMA1,!
	W ?12,"Action Date",?24,SMA2,!
	W ?12,"Comments",?24,SMN1,! S N=N+4
	I SMN2'="" W ?24,SMN2,! S N=N+1
	I SMN3'="" W ?24,SMN3,! S N=N+1
	I N>55 D HEAD^XSXS
	G G02

	;Client only
G10	W !,SCA1
	W !,SCB1,! S N=N+3
	I SCB2'="" W SCB2,! S N=N+1
	I SCB3'="" W SCB3,! S N=N+1
	I SCB4'="" W SCB4,! S N=N+1
	I SCB5'="" W SCB5,! S N=N+1
	W SCN1,! S N=N+1
	I SCN2'="" W SCN2,! S N=N+1
	I SCN3'="" W SCN3,! S N=N+1
	I N>55 D HEAD^XSXS
	G G02

J01	D END^XSXS
	Q

	;Validation
V05	I A1="",A2="",A3="",A6="",A4="",X="" S ERR="Select one or more of the above options"
	Q
