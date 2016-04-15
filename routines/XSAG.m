XSAG	;gri;09:29 AM  22 Feb 1999
	;=======================================================
	; Virgo Accounts - List Action Dates
	;
	; Copyright Graham R Irwin 1998
	;
	; Screens:       none
	; Files updated: none
	; Subroutines:   X0^XSXS, ^OUTPUT, HEAD^XSXS, END^XSXS,
	;                DMY2H^DATE
	;
	;=======================================================

	D X0^XSXS
	K ^WORK($j)
	D ^OUTPUT Q:%OP[%  S N=99,P=1 D HEAD^XSXS
	W "Action Date  Client  Matter",!! S N=N+2

	;Find matters with an Action Date
	S (CX,MX)=""
G02	S CX=$o(^SM(CX)) I CX="" G H01
G03	S MX=$o(^SM(CX,MX)) I MX="" G G02
	S SM=$g(^SM(CX,MX)),%DAT=$p(SM,%,2)
	I %DAT'="" D DMY2H^DATE S ^WORK($j,%H,CX,MX)=%DAT
	G G03

	;Now print them
H01	S (X1,CX,MX)=""
H02	S X1=$o(^WORK($j,X1)) I X1="" G J01
H03	S CX=$o(^WORK($j,X1,CX)) I CX="" G H02
H04	S MX=$o(^WORK($j,X1,CX,MX)) I MX="" G H03
	S WK=^WORK($j,X1,CX,MX)
	W WK,?14,CX,?22,MX
	I X1<$H W ?32,"** overdue **"
	W ! S N=N+1 I N>56 D HEAD^XSXS
	G H04

J01
	D END^XSXS
	Q
