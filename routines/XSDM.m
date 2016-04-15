XSDM	;GRI,,,;09:33 AM  4 Jun 2003;
	;=======================================================
	; Virgo Accounts - Matter Balances Listing
	;
	; Copyright Graham R Irwin 1993-2002
	;
	; Screens:       1076
	; Files updated: ^WORK($j)
	; Subroutines:   X0^XSXS, ^INPUT, ^OUTPUT, HEAD^XSXS, END^XSXS
	;
	;=======================================================

	S YES="Y" D X0^XSXS
	S %S=1076 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSDM Q
	D ^OUTPUT I %OP[% Q
	S N=99,P=1 D HEAD^XSXS

	S (CX,MX)="",(T1,T2,T3,T4)=0

G01	S CX=$o(^SM(CX)) I CX="" G END
G02	S MX=$o(^SM(CX,MX)) I MX="" G G01
	I A9="Y",$d(^SM(CX,MX,"C")) G G02
	S SC=^SC(CX),C1=$p(SC,%,1),SM=^SM(CX,MX),M1=$p(SM,%,1)
	S ML=$g(^ML(CX,MX)),V1=$p(ML,%,1),V2=$p(ML,%,2),V3=+$g(^SW(CX,MX)),V4=+$g(^CL(CX,MX))
	W "Client ",CX,?12,C1,?49,"Bills Balance",$j($fn(V2,",t",2),14),! S T2=T2+V2,N=N+1
	W "Matter ",MX,?12,M1,?49,"Disbursements",$j($fn(V1,",t",2),14),! S T1=T1+V1,N=N+1
	I $e(H0,1)'="X" W ?49,"Client Ledger",$j($fn(V4,",t",2),14),! S T4=T4+V4,N=N+1
	W ?49,"Work-in-Progr",$j($fn(V3,",t",2),14),! S T3=T3+V3,N=N+1
	D DATECHK
	W ?49,"Last movement   " W:DL'=0 %DAT W !! S N=N+2 I N>58 D HEAD^XSXS
	G G02

END	D END^XSXS
	Q

	;get date of last movement
DATECHK	S DL=0,X3=""
D01	S X3=$o(^ML(CX,MX,X3)) I X3="" G D11
	S ML=^ML(CX,MX,X3),%DAT=$p(ML,%,1) D DMY2H^DATE I %H>DL S DL=%H
	G D01
D11	S X3=$o(^CL(CX,MX,X3)) I X3="" G D21
	S CL=^CL(CX,MX,X3),%DAT=$p(CL,%,1) D DMY2H^DATE I %H>DL S DL=%H
	G D11
D21	S %H=DL D H2DMY^DATE
	Q

CASE	S X=$zconvert(X,"U") Q
