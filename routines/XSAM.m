XSAM	;GRI,,,;02:08 PM  6 Mar 2001;
	;=======================================================
	; Virgo Accounts - Matter Progress Report
	;
	; Copyright Graham R Irwin 1993-2001
	;
	; Screens:       none
	; Files updated: none
	; Subroutines:   X0^XSXS, ^INPUT, ^OUTPUT, HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS

A01	D ^OUTPUT G:%OP[% XSAM S N=99,P=1 D HEAD^XSXS
	W "Client/Matter    Budget        W-I-P        Disbs    Remaining",!! S N=N+2

	S (CX,MX)=""
G01	S CX=$o(^SM(CX)) I CX="" G J01
G02	S MX=$o(^SM(CX,MX)) I MX="" G G01
	S SM=^SM(CX,MX),M1=$p(SM,%,1),M11=+$p(SM,%,11)
	S ML=$g(^ML(CX,MX)),D1=$p(ML,%,1),W1=+$g(^SW(CX,MX)),L1=D1+W1
	I M11=0 G G02
	W CX,"/",MX,?10,$j(M11,13,2),$j(D1,13,2),$j(W1,13,2),$j(M11-L1,13,2),!! S N=N+2 I N>58 D HEAD^XSXS
	G G02

J01	D END^XSXS
	Q
