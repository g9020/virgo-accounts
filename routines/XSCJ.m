XSCJ	;GRI,,,;01:29 PM  12 Jan 2001;
	;=======================================================
	; Virgo Accounts - Matter Transactions Enquiry
	;
	; Copyright Graham R Irwin 1998-2001
	;
	; Screens:       1015
	; Files updated: ^WORK($j)
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, ^OUTPUT, 
	;                HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS
	S %S=1015 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSCJ Q
	I MX'="*" G S00

	;Option prompt if matter is *
E08	W /C(0,22),@P1,"Next or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) Q
	I X="N" G XSCJ
	G E08

	;Get ^ML ^SD and ^CL transactions
S00	K ^WORK($j) S IX=""
S01	S IX=$o(^ML(CX,MX,IX)) I IX="" G S03
	S ML=^ML(CX,MX,IX),D1=$p(ML,%,1),D2=$p(ML,%,2),D3=$p(ML,%,3),D4=$p(ML,%,4),D5=$p(ML,%,5),D7=$p(ML,%,7)
	S ^WORK($j,IX)=D1_%_(D3-D2)_%_%_D4_%_D5_%_D7
	G S01

S03	S (IX,BX)=""
S04	S BX=$o(^SD(CX,MX,BX)) I BX="" G S06
	S T1=0
S05	S IX=$o(^SD(CX,MX,BX,IX)) I IX="" D SX1 G S04
	S SD=^SD(CX,MX,BX,IX),D1=$p(SD,%,1),D2=$p(SD,%,2),D3=$p(SD,%,3),D4=$p(SD,%,4),D5=$p(SD,%,5),D7=$p(SD,%,7),T1=T1+D2-D3,IX1=IX
	S ^WORK($j,IX)=D1_%_(D3-D2)_%_%_D4_%_D5_%_D7
	G S05

SX1	S D1=$p($g(^SB(BX)),%,1)
	S ^WORK($j,IX1+.5)=D1_%_T1_%_%_"DSB"_%_BX_%_"Disbursements billed"
	Q

S06	S IX=""
S07	S IX=$o(^CL(CX,MX,IX)) I IX="" G E00
	S ML=^CL(CX,MX,IX),D1=$p(ML,%,1),D2=$p(ML,%,2),D3=$p(ML,%,3),D4=$p(ML,%,4),D5=$p(ML,%,5),D6=$p(ML,%,6)
	S E2="" I $d(^WORK($j,IX)) S E2=$p(^WORK($j,IX),%,2)
	S ^WORK($j,IX)=D1_%_E2_%_(D3-D2)_%_D4_%_D5_%_D6
	G S07

	;Display transactions
E00	W @P1 D HEAD
E02	S IX=$o(^WORK($j,IX)) I IX=""!($Y>20) G E09
E03	D LINE
	G E02

	;Option prompt
E09	W /C(0,22),@P1,"Next, Print or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) G XSCJ
	I X="P" G P01
	I X="N" G N01
	I X="\\" G H01
	G E09

	;Next
N01	W /c(0,13),/ef,@P1 G E03:IX'="" S (T1,T2)=0 G E02

	;Home
H01	W /c(0,13),/ef,@P1 S IX="",(T1,T2)=0 G E02

	;Print
P01	D ^OUTPUT G:%OP[% XSCJ S N=99,P=1,IX="" D HEAD^XSXS
	W "Client ",CX,?12,$P(^SC(CX),%,1),?47,"Unpaid Bills",?67,$j(M2,10,2),!
	W "Matter ",MX,?12,$P(^SM(CX,MX),%,1),?47,"Unbilled Disb",?67,$j(M1,10,2),!
	W ?47,"Client Ledger",?67,$j(C1,10,2),!
	W $$^NEWNAME("@F7@")," ",M8,?47,"Work-in-Progress",?67,$j(W1,10,2),!
	W $$^NEWNAME("@F8@")," ",M9,?47,"Nominal Interest",?67,$j(C2,10,2),!
	W ! D HEAD S N=N+8
P02	S IX=$o(^WORK($j,IX)) I IX="" G END
	D LINE S N=N+2 I N>56 D HEAD^XSXS
	G P02

END	D END^XSXS
	G XSCJ

HEAD	W ?31,"------ Office ------",?57,"------ Client ------",!,"Date",?13,"Ref No   Type",?33,"Value",?44,"Balance",?59,"Value",?70,"Balance",!! S (T1,T2)=0 Q

LINE	S ML=^WORK($j,IX),D1=$P(ML,%,1),D2=$P(ML,%,2),D3=$P(ML,%,3),D4=$P(ML,%,4),D5=$P(ML,%,5),D6=$P(ML,%,6),T1=T1+D2,T2=T2+D3
	W D1,?13,D5,?22,D4 W:D2 ?28,$J(D2,10,2),?41,$J(T1,10,2) W:D3 ?54,$J(D3,10,2),?67,$J(T2,10,2) W !,?2,D6,!
	Q

CASE	S X=$zconvert(X,"U") Q
