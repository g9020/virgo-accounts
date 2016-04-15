XSXS	;GRI,,,;09:50 AM  1 Nov 2007
	;=======================================================
	; Virgo Accounts - Common Routines
	;
	; Copyright Graham R Irwin 1993-2003
	;
	; Files updated: ^AB ^AY ^SY
	; Subroutines:   ^%video, ^Cont, ^GETX
	;
	;=======================================================

	; Matter Search  * * * * * * * * * * * * * * * * * * * *

	; Note: client code = CX

S	d uwo^%video(6,18)
	W #,@P1 S %K=1,S3=""
	;I '$D(^SM(CX)) W "No Matters for this Client" S X="" G S99
S01	S S3=$O(^SM(CX,S3)) I S3=""!($Y>13) G S03
S02	S S2=$P(^SM(CX,S3),%,1)
	;I $d(^SM(CX,S3,"C")) G S01
	W %K,?10,S3,?20,S2,! S SS(%K)=S3,%K=%K+1 G S01
S03	W /C(0,15),"Select an entry " D ^GETX I X[% G S99
	I X,$G(SS(X))="" G S03
	I 'X G S99:S3="" W # K SS G S02
	S X=SS(X)
S99	K S2,S3,SS
	d uwc^%video()
	Q

	; Start routine  * * * * * * * * * * * * * * * * * * * *

X0	W #,@P4,PGM,?80-$L(H1)\2,H1,!?80-$L(H2)\2,H2,!!!
	Q

	; Matter Code Validation * * * * * * * * * * * * * * * *

	; Note: client code = CX

EX	I '$D(^SM(CX,X)) S ERR="Does not exist" Q
	S XZ=$p(^(X),%,1)
	W:$e(XZ,$l(XZ))="$" @P3,*7 W ?48,XZ,/el
	Q

	; Get Item Number (used by all posting programs) * * * *

	; Updates ^SY

YX	L ^SY
	S YX=^SY+1,^SY=YX
	L  Q

	; Date Validation 1  * * * * * * * * * * * * * * * * * *

DAT	Q:$D(ERR)  S %DAT=X D DMY2H^DATE
	I %H>+$H S ERR="May not be in the future" Q
	I $g(^SZ("D30"))="N" Q
	I +$H-30>%H S ERR="May not be more than 30 days ago"
	Q

	; Date Validation 2  * * * * * * * * * * * * * * * * * *

DAT1	Q:$D(ERR)  S %DAT=X D DMY2H^DATE
	I %H>+$H S ERR="May not be in the future" Q
	Q

	; Update Nominal Ledger  * * * * * * * * * * * * * * * *

	; Updates ^AB and ^AY

UPAB(AX,T1,V2,V3,V4,V5)

	; Parameters:-
	; account code, amount, date, trans type, ref, narrative

	I +T1=0 Q  ;don't bother if amount is zero

	; update account balances
	S AB=^AB(AX),AB1=$P(AB,%,1),AB2=$P(AB,%,2),AB3=$P(AB,%,3),AB4=$P(AB,%,4,99),AB2=AB2+T1,AB3=AB3+T1,^AB(AX)=AB1_%_AB2_%_AB3_%_AB4

	; update nominal except for statistical accounts
	I $e(AX,1)="N" Q
	S ^AY(AX,YX)=V2_%_T1_%_V3_%_V4_%_V5
	Q

	; Report Heading * * * * * * * * * * * * * * * * * * * *

	; Note: page no = P; line no = N; prog name = PGM; prog title = H2

HEAD	D ^DATE
	I $g(^WRITE($j))="WB" Q:P>1  W "<html><head><title>Virgo Accounts: ",H2,"</title></head><body><pre>"
	I P>1 W #
	W !,PGM,?80-$L(^SZ("PN"))\2,^SZ("PN"),?61,DAT," ",TIM,!?80-$L(H2)\2,H2,?70,"Page ",P,!,$e(PU,1,78),!!! S N=6,P=P+1
	Q

	; Report Ending  * * * * * * * * * * * * * * * * * * * *

END	I %OP=1 d ^Cont(0)
	U %OP W !!,"** End of Report **"
	I $g(^WRITE($j))="WB" W !,"</pre></body></html>" K ^WRITE($j)
	E  W #
	I %OP>1 C %OP
	Q

	; Activity Search  * * * * * * * * * * * * * * * * * * *

	; Note: charge group = RX

SA	d uwo^%video(6,18)
	W #,@P1 S %K=1,S3=""
A01	S S3=$O(^SR(RX,S3)) I S3=""!($Y>13) G A03
A02	S S2=$G(^SA(S3))
	W %K,?10,S3,?20,S2,! S SS(%K)=S3,%K=%K+1 G A01
A03	W /C(0,15),"Select an entry " D ^GETX I X[% G A99
	I X,$G(SS(X))="" G A03
	I 'X G A99:S3="" W # K SS G A02
	S X=SS(X)
A99	K S2,S3,SS
	d uwc^%video()
	Q

	; Unpaid Bills Search  * * * * * * * * * * * * * * * * *

UB	d uwo^%video(6,18)
	W #,@P1 S %K=1,S3=""
B01	S S3=$O(^SU(S3)) I S3=""!($Y>13) G B03
B02	S S2=$G(^SB(S3))
	W %K,?10,S3,?20,$p(S2,%,1),?32,$j($p(S2,%,4)+$p(S2,%,5)+$p(S2,%,6),10,2),?44,$p(^SC($p(S2,%,2)),%,1),! S SS(%K)=S3,%K=%K+1 G B01
B03	W /C(0,15),"Select an entry " D ^GETX I X[% G B99
	I X,$G(SS(X))="" G B03
	I 'X G B99:S3="" W # K SS G B02
	S X=SS(X)
B99	K S2,S3,SS
	d uwc^%video()
	Q
