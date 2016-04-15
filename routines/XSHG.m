XSHG	;GRI,,,;12:51 PM  8 Feb 2002;
	;=======================================================
	; Virgo Accounts - Print Standing Entries
	;
	; Copyright Graham R Irwin 1999-2002
	;
	; Screens:       none
	; Files updated: none
	; Subroutines:   X0^XSXS, H2DMY^DATE, ^OUTPUT, HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS
	D ^OUTPUT Q:%OP[%  S N=99,P=1
	D HEAD^XSXS
	W "ID",?8,"--Start--- ---End----   Freq C/B Net",?52,"VAT",?63,"Ref    Acct",!! S N=N+2

	S D0=""
D01	S D0=$o(^SO(D0)) I D0="" G END
	S SO=^SO(D0),D1=$P(SO,%,1),D2=$P(SO,%,2),D3=$P(SO,%,3),D4=$P(SO,%,4),DX=$P(SO,%,5),O2=$P(SO,%,6),O3=$P(SO,%,7),O4=$P(SO,%,8),AX=$P(SO,%,9),O5=$P(SO,%,10),%H=$p(SO,%,11),E2=$j(O2+O3,0,2)
	D H2DMY^DATE
	W D0,?8,D1,?19,D2,?30,D3,?32,D4,?37,DX,?41,O2,?52,O3,?63,O4,?70,AX,!?4,O5,?54,"Next due: ",%DAT,!! S N=N+3 I N>60 D HEAD^XSXS
	G D01

END	D END^XSXS
	Q
