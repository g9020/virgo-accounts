XSDH	;GRI,,,;01:47 PM  28 Sep 2000
	;=======================================================
	; Virgo Accounts - Unpaid Disbursements List
	;
	; Copyright Graham R Irwin 1993-98
	;
	; Screens:       none
	; Files updated: none
	; Subroutines:   X0^XSXS, ^OUTPUT, HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS,^OUTPUT Q:%OP[%
	S N=99,P=1 D HEAD^XSXS,HEAD
	S E4=0,(CX,MX,IX)=""
P02	S CX=$o(^ML(CX)) I CX="" G END
P03	S MX=$o(^ML(CX,MX)) I MX="" G P02
P04	S IX=$o(^ML(CX,MX,IX)) I IX="" G P03
	S ML=^ML(CX,MX,IX),D1=$P(ML,%,1),D2=$P(ML,%,2),D3=$P(ML,%,3),D4=$P(ML,%,4),D7=$P(ML,%,7),C1=$p(^SC(CX),%,1)
	I "DIS,DSW,DSP,DSA,TOC,COD,OMT,N2D"[D4 D LINE
	G P04

END	D END^XSXS
	Q

	;Write header line
HEAD	W !,"  Client Matter  Date",?32,"Type",?42,"Debit",?54,"Credit",?67,"Balance",!!
	Q
	;Write detail line
LINE	S E4=E4+D3-D2 W ?3,CX,?10,MX,?17,D1,?32,D4 W:D3 ?38,$J(D3,10,2) W:D2 ?51,$J(D2,10,2) W ?64,$J(E4,10,2),!?2,C1," - ",D7,!!
	S N=N+3 I N>56 D HEAD^XSXS,HEAD
	Q
