XSHC	;GRI,,,;10:26 AM  13 Dec 2005
	;=======================================================
	; Virgo Accounts - Day End Processing
	;
	; Copyright Graham R Irwin 1993-2002
	;
	; Screens:       none
	; Files updated: ^CL ^SY ^SZ
	; Subroutines:   X0^XSXS, ^OUTPUT, HEAD^XSXS, END^XSXS,
	;                ^GETX, ^XSSTO
	;
	;=======================================================

	; A1 - effective date of last day-end
	; A2 - effective date of this day-end

	D X0^XSXS
	L (^SY,^SZ,^SC,^SM)

	D ^OUTPUT Q:%OP[%  S N=99,P=1 D HEAD^XSXS
	S A1=^SZ("LDE"),A2=+$H S:A2-A1>1 A2=A2-1 S N1=A2-A1

	;Process standing orders
	D ^XSSTO

	;Print Daybook
	I $O(^SY(""))="" W !,"No Daybook Transactions",! S N=N+2 G D01
	S (X1,X2,X3)=""
C02	S X1=$O(^SY(X1)) I X1="" G D01
	W !,"Daybook for ",X1,!!,"Type Date",?16,"Cli-Matter  C/B Net Amount VAT Amount  Cli-Matter  C/B Ref.",!! S N=N+5
C03	S X2=$O(^SY(X1,X2)) I X2="" G C02
C04	S X3=$O(^SY(X1,X2,X3)) I X3="" G C03
	S SY=^SY(X1,X2,X3),B1=$P(SY,%,1),B2=$P(SY,%,2),B3=$P(SY,%,3),B4=$P(SY,%,4),B5=$P(SY,%,5),B6=$P(SY,%,6),B7=$P(SY,%,7),B8=$P(SY,%,8),B9=$P(SY,%,9),B10=$P(SY,%,10),B11=$p(SY,%,11)
	W X2,?4,B1,?16,B2,?22,B3,?28,B4,?32,$J(B5,10,2) W:B6 ?43,$J(B6,10,2) W ?55,B7,?61,B8,?67,B9,?71,B10,!?2,B11,! S N=N+2 I N>53 D HEAD^XSXS
	G C04

	;Calculate CL interest and check for overdrawn CL accounts
D01	I $g(^SZ("ADE"))'="Y" G F09
	i $e(H0,1)="X" G F09
	I '$d(^CI) W !!,"*** No Client Interest Rates Set Up ***",!! S N=N+4 G F09
	S (CX,MX)="",(T1,T2)=0
F01	S CX=$O(^CL(CX)) I CX="" G F08
F02	S MX=$O(^CL(CX,MX)) I MX="" G F01
	S CL=^CL(CX,MX),B1=$P(CL,%,1),B2=$P(CL,%,2),B3=$P(CL,%,3,99)
	I B1<0 W !,"*** WARNING ***  Client ",CX," Matter ",MX,?42,"Client Account Overdrawn",?74,"***",! S N=N+2,T1=1
	S IX="",CI=0
F04	S IX=$O(^CI(IX)) I IX=""!(IX>B1) G F06
	S CI=^CI(IX) G F04
F06	S C1=B1*N1*CI/36500,T2=T2+C1,B2=B2+C1,^CL(CX,MX)=B1_%_B2_%_B3
	G F02

F08	I 'T1 W !!,"No Overdrawn Client Accounts",! S N=N+3
	W !,"Total Nominal Interest Calculated = ",$j(T2,0,2),!! S N=N+3

F09	S ^SZ("LDE")=A2

	;Check credit office accounts
	S (CX,MX)=""
G02	S CX=$o(^ML(CX)) I CX="" G H01
G03	S MX=$o(^ML(CX,MX)) I MX="" G G02
	S ML=$g(^ML(CX,MX)),M1=$p(ML,%,1),M2=$p(ML,%,2)
	I M1<0 W "*** WARNING ***  Client ",CX," Matter ",MX,?42,"Disbursement Balance in Credit",?74,"***",! S N=N+1
	I M2<0 W "*** WARNING ***  Client ",CX," Matter ",MX,?42,"Bills Balance in Credit",?74,"***",! S N=N+1
	G G03

	;Count clients & matters
H01	S CX="",CN=0
H02	S CX=$o(^SC(CX)) I CX="" G H03
	S CN=CN+1 G H02

H03	S MX="",(MNO,MNC)=0
H04	S CX=$o(^SM(CX)) I CX="" G H06
H05	S MX=$o(^SM(CX,MX)) I MX="" G H04
	I $d(^SM(CX,MX,"C")) S MNC=MNC+1
	E  S MNO=MNO+1
	G H05

H06	W !,"Total No of Clients  = ",CN
	W !,"No of Open Matters   = ",MNO
	W !,"No of Closed Matters = ",MNC,!

	D END^XSXS

F99	W /c(0,22),@P1,"Has daybook printed OK ? ",/el,@P2 D ^GETX S X=$zconvert(X,"U")
	I X="N" G XSHC
	I X'="Y" G F99

	;Delete daybook file
	S X1=""
Z02	S X1=$O(^SY(X1)) I X1="" Q
	K ^SY(X1) G Z02

AUTO	S PGM="XSHC",H2="Day End Processing" G XSHC
