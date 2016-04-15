XSCD	;GRI,,,;11:41 AM  26 Jan 2000
	;=======================================================
	; Virgo Accounts - Matter Accounts Enquiry
	;
	; Copyright Graham R Irwin 1993-2000
	;
	; Screens:       1015
	; Files updated: ^WORK($j)
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, ^OUTPUT, 
	;                HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS
	S %S=1015 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSCD Q
	I MX'="*" G S00

	;Option prompt if matter is *
E08	W /C(0,22),@P1,"Next or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) Q
	I X="N" G XSCD
	G E08

	;Get ML and CL transactions
S00	K ^WORK($j) S IX=""
S01	S IX=$o(^ML(CX,MX,IX)) I IX="" G S03
	S ML=^ML(CX,MX,IX),D1=$p(ML,%,1),D2=$p(ML,%,2),D3=$p(ML,%,3),D4=$p(ML,%,4),D5=$p(ML,%,5),D7=$p(ML,%,7)
	S ^WORK($j,IX)=D1_%_(D3-D2)_%_%_D4_%_D5_%_D7
	G S01

S03	S IX=$o(^CL(CX,MX,IX)) I IX="" G E00
	S ML=^CL(CX,MX,IX),D1=$p(ML,%,1),D2=$p(ML,%,2),D3=$p(ML,%,3),D4=$p(ML,%,4),D5=$p(ML,%,5),D6=$p(ML,%,6)
	S E2="" I $d(^WORK($j,IX)) S E2=$p(^WORK($j,IX),%,2)
	S ^WORK($j,IX)=D1_%_E2_%_(D3-D2)_%_D4_%_D5_%_D6
	G S03

	;Display transactions
E00	W @P1 D HEAD
E02	S IX=$o(^WORK($j,IX)) I IX=""!($Y>20) G E09
E03	D LINE
	G E02

	;Option prompt
E09	W /C(0,22),@P1,"Next, Print or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) G XSCD
	I X="P" G P01
	I X="N" G N01
	I X="\\" G H01
	G E09

	;Next
N01	W /c(0,13),/ef,@P1 G E03:IX'="" S (T1,T2)=0 G E02

	;Home
H01	W /c(0,13),/ef,@P1 S IX="",(T1,T2)=0 G E02

	;Print
P01	D ^OUTPUT G:%OP[% XSCD S N=99,P=1,IX="" D HEAD^XSXS
	W "Client ",CX,?12,$P(^SC(CX),%,1),?47,"Unpaid Bills",?67,$j(M2,10,2),!
	W "Matter ",MX,?12,$P(^SM(CX,MX),%,1),?47,"Unbilled Disb",?67,$j(M1,10,2),!
	W ?47,"Client Ledger",?67,$j(C1,10,2),!
	W ?47,"Work-in-Progress",?67,$j(W1,10,2),!! D HEAD S N=N+7
P02	S IX=$o(^WORK($j,IX)) I IX="" G END
	D LINE S N=N+1 I N>56 D HEAD^XSXS
	G P02

END	D END^XSXS
	G XSCD

HEAD	W ?31,"------ Office ------",?57,"------ Client ------",!,"Date",?13,"Ref No   Type",?33,"Value",?44,"Balance",?59,"Value",?70,"Balance",!! S (T1,T2)=0 Q

LINE	S ML=^WORK($j,IX),D1=$P(ML,%,1),D2=$P(ML,%,2),D3=$P(ML,%,3),D4=$P(ML,%,4),D5=$P(ML,%,5),D6=$P(ML,%,6),T1=T1+D2,T2=T2+D3
	W D1,?13,D5,?22,D4 W:D2 ?28,$J(D2,10,2),?41,$J(T1,10,2) W:D3 ?54,$J(D3,10,2),?67,$J(T2,10,2) W !
	Q

	;Validation - Matter code (also used by XSCJ)
V01	I X="*" K ERR G V1A
	I $D(ERR) Q
	;get all header info
	S ML=$G(^ML(CX,X)),M1=$J($P(ML,%,1),0,2),M2=$J($P(ML,%,2),0,2)
	S SM=$g(^SM(CX,X)),M8=$p(SM,%,8),M9=$p(SM,%,9)
	S CL=$G(^CL(CX,X)),C1=$J($P(CL,%,1),0,2),C2=$j($p(CL,%,2),0,2)
	S SW=$G(^SW(CX,X)),W1=$J($P(SW,%,1),0,2)
	Q
	;matter code="*"
V1A	S XX="",(M1,M2,C1,W1)=0
V1B	S XX=$o(^SM(CX,XX)) I XX="" G V1C
	S ML=$g(^ML(CX,XX)),M1=M1+$p(ML,%,1),M2=M2+$p(ML,%,2),CL=$g(^CL(CX,XX)),C1=C1+$p(CL,%,1),SW=$g(^SW(CX,XX)),W1=W1+$p(SW,%,1)
	G V1B
V1C	S M1=$j(M1,0,2),M2=$j(M2,0,2),C1=$j(C1,0,2),W1=$j(W1,0,2)
	W ?48,"Total for all matters" Q

CASE	S X=$zconvert(X,"U") Q
