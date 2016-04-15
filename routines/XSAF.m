XSAF	;GRI,,,;11:23 AM  18 Mar 2003
	;=======================================================
	; Virgo Accounts - Matter Limits Report
	;
	; Copyright Graham R Irwin 1993-2003
	;
	; Screens:       1020
	; Files updated: ^SZ
	; Subroutines:   X0^XSXS, ^INPUT, H2DMY^DATE, DMY2H^DATE,
	;                ^OUTPUT, HEAD^XSXS, END^XSXS
	;
	;=======================================================

	S AUTO=0

A00	D X0^XSXS
	S X=$g(^SZ("MLR")),A1=$p(X,%,1),A2=$p(X,%,2),A3=$p(X,%,3)

	I AUTO G A01
	S %S=1020 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSAF Q

A01	S (B2,%H)=$H+A2 D H2DMY^DATE
	D ^OUTPUT G:%OP[% XSAF S N=99,P=1 D HEAD^XSXS
	W "Matters with Action date < ",%DAT," and/or Disbursements+WIP > ",A3,"%",!! S N=N+2

	S (CX,MX)=""
G01	S CX=$o(^SM(CX)) I CX="" G J01
G02	S MX=$o(^SM(CX,MX)) I MX="" G G01
	S SM=^SM(CX,MX),ML=$g(^ML(CX,MX)),D1=$p(ML,%,1),W1=+$g(^SW(CX,MX)),L1=D1+W1,M1=$p(SM,%,1),(M2,%DAT)=$p(SM,%,2),M11=+$p(SM,%,11) D DMY2H^DATE S B1=%H,L2=M11*(100-A3/100)
	;print matter if Budget is not zero and disb+time > A3% of Budget
	I M11'=0,L1>L2 D WRITE G G02
	;print matter if Action date is not null and today+A2 >= Action date
	I M2'="",B1<B2 D WRITE G G02
	G G02

J01	D END^XSXS
	S ^SZ("MLR")=A1_%_A2_%_A3_%_+$H
	Q

WRITE	W "Client ",CX,?12,$p(^SC(CX),%,1),?50,"Disbursements",$j(D1,12,2),!
	W "Matter ",MX,?12,M1,?50,"Work-in-Prog.",$j(W1,12,2),!
	W ?50,"Budget value",$j(M11,13,2),!
	W ?50,"Remaining   ",$j(M11-D1-W1,13,2),!
	W ?50,"Action date    ",M2,!! S N=N+5 I N>56 D HEAD^XSXS
	Q

AUTO	S PGM="XSAF",H2="Matter Limits Report",AUTO=1 G A00

CASE	S X=$zconvert(X,"U") Q
