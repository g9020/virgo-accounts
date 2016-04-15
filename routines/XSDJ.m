XSDJ	;GRI,,,;01:53 PM  9 Jul 2002
	;=======================================================
	; Virgo Accounts - Exception Report
	;
	; Copyright Graham R Irwin 1993-2002
	;
	; Screens:       1062
	; Files updated: ^WORK($j)
	; Subroutines:   X0^XSXS, ^INPUT, ^OUTPUT, HEAD^XSXS, END^XSXS
	;
	;=======================================================

	; A1, A2 bills < >		M2, V2 bills balance
	; A3, A4 disbs < >		M1, V1 disbs balance
	; A5, A6 client acct < >	C1, V4 client acct bal
	; A7, A8 WIP < >		W1, V3 WIP balance
	; A9 some/all		A10 'or'/'and'
	; A11, A12 client int		C2, V5 client int

	D X0^XSXS
	S (A5,A6,A11,A12)="",(T1,T2,T3,T4,T5)=0
	S %S=1062 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSDJ Q
	S A10="and" I A9="S" S A10="or"

	W /C(0,22),@P1,"Searching, please wait ..."
	K ^WORK($j) S (CX,MX)="",NC=0
G01	S CX=$o(^SM(CX)) I CX="" G H01
G02	S MX=$o(^SM(CX,MX)) I MX="" G G01
	S ML=$g(^ML(CX,MX)),M1=$p(ML,%,1),M2=$p(ML,%,2),W1=+$g(^SW(CX,MX))
	S CL=$g(^CL(CX,MX)),C1=$p(CL,%,1),C2=$p(CL,%,2)
	I A9="A" G G20

	;Process Some option
	I M2>A1,M2<A2 D SETWK G G02
	I M1>A3,M1<A4 D SETWK G G02
	I $e(H0,1)'="X",C1>A5,C1<A6 D SETWK G G02
	I $e(H0,1)'="X",C2>A11,C2<A12 D SETWK G G02
	I W1>A7,W1<A8 D SETWK G G02
	G G02

	; Handle All option
G20	I M2>A1,M2<A2,M1>A3,M1<A4,($e(H0,1)'="X"&(C1>A5)&(C1<A6)&(C2>A11)&(C2<A12)),W1>A7,W1<A8 D SETWK G G02
	G G02

H01	I NC=0 W /C(0,22),@P1,"No matters found. Press any key to continue " R *X R:'X *X G XSDJ
	W /C(8,16),NC," matter" W:NC>1 "s" W " found"
	D ^OUTPUT G:%OP[% XSDJ S N=99,P=1 D HEAD^XSXS
	W "List of matters with: Bills > ",A1," and < ",A2,!
	W ?18,A10," Disbursements > ",A3," and < ",A4,!
	I $e(H0,1)'="X" W ?18,A10," Client account > ",A5," and < ",A6,!
	I $e(H0,1)'="X" W ?18,A10," Client interest > ",A11," and < ",A12,!
	W ?18,A10," Work-in-Progress > ",A7," and < ",A8,!!
	S (CX,MX)="",N=N+5
H02	S CX=$o(^WORK($j,CX)) I CX="" G J01
H03	S MX=$o(^WORK($j,CX,MX)) I MX="" G H02
	S SC=^SC(CX),C1=$p(SC,%,1),SM=^SM(CX,MX),M1=$P(SM,%,1),ML=$g(^ML(CX,MX)),V1=$p(ML,%,1),V2=$p(ML,%,2),V3=+$g(^SW(CX,MX)),CL=$g(^CL(CX,MX)),V4=$p(CL,%,1),V5=$p(CL,%,2)
	W "Client ",CX,?12,C1,?56,"Bills",$j(V2,12,2),! S T2=T2+V2,N=N+1
	W "Matter ",MX,?12,M1,?56,"Disbs",$j(V1,12,2),! S T1=T1+V1,N=N+1
	I $e(H0,1)'="X" W ?56,"CL",$j(V4,15,2),! S T4=T4+V4,N=N+1
	I $e(H0,1)'="X" W ?56,"C Int",$j(V5,12,2),! S T5=T5+V5,N=N+1
	W ?56,"WIP",$j(V3,14,2),!! S T3=T3+V3,N=N+2 I N>58 D HEAD^XSXS
	G H03

J01	W "Totals for matters listed",?56,"Bills",$j(T2,12,2),!
	W ?56,"Disbs",$j(T1,12,2),!
	I $e(H0,1)'="X" W ?56,"CL",$j(T4,15,2),!
	I $e(H0,1)'="X" W ?56,"C Int",$j(T5,12,2),!
	W ?56,"WIP",$j(T3,14,2),!
	D END^XSXS
	Q

SETWK	I '$d(^WORK($j,CX,MX)) S ^WORK($j,CX,MX)="",NC=NC+1
	Q

	;Validation - Bills <
V02	I X<A1 S ERR="Cannot be less than previous figure"
	Q
	;Disb <
V04	I X<A3 S ERR="Cannot be less than previous figure"
	Q
	;CL <
V06	I X<A5 S ERR="Cannot be less than previous figure"
	Q
	;Client int <
V07	I X<A11 S ERR="Cannot be less than previous figure"
	Q
	;WIP <
V08	I X<A7 S ERR="Cannot be less than previous figure" Q
	I A1="",A2="",A3="",A4="",A5="",A6="",A7="",X="" S ERR="Select one or more of the above options" Q
	Q
	;All/Some
V09	I $d(ERR) Q
	D CASE I "AS"'[X S ERR="Must be 'A' or 'S'"
	Q

CASE	S X=$zconvert(X,"U") Q
