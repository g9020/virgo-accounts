XSHH	;GRI,,,;11:28 AM  19 Jul 2002;
	;=======================================================
	; Virgo Accounts - Print Bill Register
	;
	; Copyright Graham R Irwin 2002
	;
	; Screens:       none
	; Files updated: none
	; Subroutines:   X0^XSXS, H2DMY^DATE, ^OUTPUT, HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS

	D ^OUTPUT Q:%OP[%  S N=99,P=1
	D HEAD^XSXS
	D HEAD

	S BX=""
B01	S BX=$o(^SB(BX)) I BX="" G END
	S SB=^SB(BX),B1=$p(SB,%,1),B2=$p(SB,%,2),B3=$p(SB,%,3),B4=$p(SB,%,4),B5=$p(SB,%,5),B6=$p(SB,%,6),B7=$p(SB,%,7),B8=$p(SB,%,8),B9=$p(SB,%,9)
	W BX,?7,B1,?18,B2,?23,B3,?27,$j(B4,11,2),$j(B5,11,2),$j(B6,11,2),$j(B8,11,2)," ",B9,! S N=N+1 I N>60 D HEAD^XSXS
	G B01

END	D END^XSXS
	Q

HEAD	W "Bill # Date",?18,"Cl/Matter Fees value Disb value VAT amount O/S amount St",!! S N=N+2
	Q
