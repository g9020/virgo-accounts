XSHE	;GRI;10:32 AM  16 Mar 1999
	;=======================================================
	; Virgo Accounts - Year End Processing
	;
	; Copyright Graham R Irwin 1993-99
	;
	; Screens:       1061
	; Files updated: ^AB
	; Subroutines:   X0^XSXS, AA^XSHD, H2DMY^DATE, DMY2H^DATE,
	;                ^INPUT, ^OUTPUT, HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS
	L (^SY,^SZ,^SC,^SM)
	S A1=^SZ("LPE")
	I A1<+$H S PSV=PGM,PGM="XSHD" D AA^XSHD Q:'$d(%OP)  Q:%OP[%  S PGM=PSV
	S %H=^SZ("NYE") D H2DMY^DATE S A2=%DAT
	W /C(0,4),/EF S %S=1061 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSHE Q
	D ^OUTPUT Q:%OP[%  S N=99,P=1 D HEAD^XSXS

	;Expense accounts
	S X1="E0",T1=0
A02	S X1=$O(^AB(X1)) I X1]"E999"!(X1="") G B01
	S AB=^AB(X1),B1=$P(AB,%,1,2),B3=$P(AB,%,3),B5=$P(AB,%,5,99),^AB(X1)=B1_%_0_%_B3_%_B5,T1=T1+B3
	G A02

	;Income accounts
B01	S X1="I0",T2=0
B02	S X1=$O(^AB(X1)) I X1]"I999"!(X1="") G C01
	S AB=^AB(X1),B1=$P(AB,%,1,2),B3=$P(AB,%,3),B5=$P(AB,%,5,99),^AB(X1)=B1_%_0_%_B3_%_B5,T2=T2+B3
	G B02

	;Asset accounts
C01	S X1="A0"
C02	S X1=$O(^AB(X1)) I X1]"A999"!(X1="") G D01
	S AB=^AB(X1),B1=$P(AB,%,1,2),B3=$P(AB,%,3),B5=$P(AB,%,5,99),^AB(X1)=B1_%_B3_%_B3_%_B5
	G C02

	;Liability accounts
D01	S X1="L0"
D02	S X1=$O(^AB(X1)) I X1]"L999"!(X1="") G E01
	S AB=^AB(X1),B1=$P(AB,%,1,2),B3=$P(AB,%,3),B5=$P(AB,%,5,99),^AB(X1)=B1_%_B3_%_B3_%_B5
	G D02

	;Non-financial accounts
E01	S X1="N0"
E02	S X1=$O(^AB(X1)) I X1]"N999"!(X1="") G F01
	S AB=^AB(X1),B1=$P(AB,%,1,2),B3=$P(AB,%,3),B5=$P(AB,%,5,99),B2=0
	I X1="N020" S B2=B3
	S ^AB(X1)=B1_%_B2_%_B3_%_B5
	G E02

	;Update capital, current and p&l accounts
F01	S X1="L530",AB=^AB(X1),B1=$p(AB,%,1),B5=$p(AB,%,5,99),^AB(X1)=B1_%_0_%_0_%_(T2-T1)_%_B5
	S X1="L520",AB=^AB(X1),B1=$p(AB,%,1),B3=$p(AB,%,3),B5=$p(AB,%,5,99),^AB(X1)=B1_%_0_%_0_%_B3_%_B5,B3X=B3
	S X1="L510",AB=^AB(X1),B1=$p(AB,%,1),B2=$p(AB,%,2),B5=$p(AB,%,5,99),B2X=T2-T1+B3X+B2,^AB(X1)=B1_%_B2X_%_B2X_%_B2_%_B5

	;Recreate nominal ledger
	K ^AY D ^XSXA

	W "Year End Processing Run On ",DAT," effective date ",A2,!!,"Keep This Report For Audit Purposes",!
	S %DAT=$p(A2,"/",1,2)_"/"_($p(A2,"/",3)+1) D DMY2H^DATE S ^SZ("NYE")=%H

	D END^XSXS Q

	;Validation - y/e confirm
V01	I X'="YRE" S ERR="Wrong confirmation"
	Q
