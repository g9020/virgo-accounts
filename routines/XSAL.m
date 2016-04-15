XSAL	;GRI,,,;09:23 AM  26 Jun 2000;
	;=======================================================
	; Virgo Accounts - Matters With No Transactions
	;
	; Copyright Graham R Irwin 2000
	;
	; Screens:       none
	; Files updated: 
	; Subroutines:	 X0^XSXS, ^OUTPUT, HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS
	D ^OUTPUT I %OP[% Q
	S N=99,P=1 D HEAD^XSXS

	S (CX,MX)=""
M01	S CX=$o(^SM(CX)) I CX="" G P99
M02	S MX=$o(^SM(CX,MX)) I MX="" G M01

	I $d(^ML(CX,MX))>9 G M02
	I $d(^CL(CX,MX))>9 G M02
	I $d(^SW(CX,MX))>9 G M02
	W CX,"/",MX,?10,$e($p(^SC(CX),%,1),1,32)," - ",$e($p(^SM(CX,MX),%,1),1,32),!! S N=N+1 I N>60 D HEAD^XSXS
	G M02

P99	D END^XSXS
	Q
