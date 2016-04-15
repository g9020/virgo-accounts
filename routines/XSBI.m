XSBI	;GRI,,,;11:51 AM  6 Jun 2002
	;=======================================================
	; Virgo Accounts - Bank Reconciliation
	;
	; Copyright Graham R Irwin 1993-2002
	;
	; Screens:       1012
	; Files updated: ^CB ^WORK($j) ^WORK2($j), ^WORK3($j)
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, ^OUTPUT, 
	;                HEAD^XSXS, END^XSXS
	;
	;=======================================================

	; ^WORK($j,i=1:1) - all transactions sorted by date
	; ^WORK2($j,0=unmatched/1=matched,item no) - all transactions
	;            split into matched and unmatched
	; ^WORK3($j,date,i=1:1) - initial file for sorting by date

	S MFL=0 ;set Mark mode flag off
	D X0^XSXS
	S ONE=$g(^SZ("DOC"),1)
	S %S=1012 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSBI Q

	; Get all the transactions ---------
	S X3="",WX=1,DT=0 K ^WORK3($j)
G01	S X3=$O(^CB(DX,X3)) I X3="" G G02
	S CB=^CB(DX,X3),%DAT=$p(CB,%,1),D2=$p(CB,%,2),D3=$p(CB,%,3),D7=+$p(CB,%,7),DT=D3-D2*D7+DT D DMY2H^DATE
	I X3=0 S %H=0 ;if there's an o/bal keep it first
	S ^WORK3($j,%H,WX)=X3_%_CB,WX=WX+1
	G G01

	; Now sort them --------------------
G02	S (X2,X3)="",WX=1 K ^WORK($j)
G03	S X2=$o(^WORK3($j,X2)) I X2="" G M01
G04	S X3=$o(^WORK3($j,X2,X3)) I X3="" G G03
	S ^WORK($j,WX)=^WORK3($j,X2,X3),WX=WX+1
	G G04

	;Display items
M01	S WX="" D WRDT W /C(0,7),/EF,@P1,"Item Date",?20,"Amount  Ref     Narrative",?74,"Match?",!!
M02	S WX=$O(^WORK($j,WX)) I WX=""!($Y>20) G M09
M03	S CB=^WORK($j,WX),D1=$P(CB,%,2),D2=$P(CB,%,3),D3=$P(CB,%,4),D4=$P(CB,%,5),D5=$P(CB,%,6),D6=$P(CB,%,7),D7=+$P(CB,%,8),F2=D3-D2
	W:D7 @P5 W WX,?4,D1,?15,$j(F2,11,2),?28,D5,?36,$e(D6,1,38),?76,$s(D7:"Yes",'D7:"No"),@P1,!
	G M02

M09	I MFL G S01 ;if Mark mode go to Select prompt
	W /C(0,22),@P1,"Mark/unmark, Next, Update or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX,CASE G XSBI:X="Y",M09
	I X="U" G U01
	I X="N" G N01
	I X="\\" G H01
	I X="M"!(X="Z") S MFL=1 G S01
	G M09

	;Select
S01	W @P1,/c(39,22),"Mark/unmark item ",@P2 D ^GETX
	I X="*" D S10 G M01
	I X="N" G N01
	I X="\\" G H01
	S X=+X I $g(^WORK($j,X))="" S MFL=0 G M09
	S WK=^WORK($j,X),W1=$p(WK,%,1,2),W3=$p(WK,%,3),W4=$p(WK,%,4),W5=$p(WK,%,5,7),W8=$p(WK,%,8),W8=1-W8,^WORK($j,X)=W1_%_W3_%_W4_%_W5_%_W8,T1=W4-W3
	S:W8 DT=DT+T1 S:'W8 DT=DT-T1
	D WRDT S WX=X-6 W /C(0,9),/EF,@P1
	G M02

	;Mark all
S10	S WX=""
S11	S WX=$o(^WORK($j,WX)) I WX="" Q
	S WK=^WORK($j,WX),^WORK($j,WX)=$p(WK,%,1,7)_%_1,DT=+B6
	G S11

	;Next
N01	W /C(0,9),/EF,@P1 G M03:WX'="",M02

	;Home
H01	W /C(0,9),/EF,@P1 S WX="" G M02

	;Update
U01	S WX="" K ^WORK2($j)
U02	S WX=$O(^WORK($j,WX)) I WX="" G U04
	S WK=^WORK($j,WX),X3=$P(WK,%,1),CB=$P(WK,%,2,99),D7=+$P(WK,%,8)
	S ^CB(DX,X3)=CB,^WORK2($j,D7,WX)=CB
	G U02

	;Print report
U04	D ^OUTPUT G:%OP[% XSBI S N=99,P=1 D HEAD^XSXS
	W "Cashbook ",DX,?14,B1,?50,"Balance ",B6,!!
	W "Matched (Presented) Items:-",!!
	W "Date",?15,"Amount",?23,"Type  Ref",?37,"Narrative",!!
	S N=N+6,T1=0,WX=""
U05	S WX=$O(^WORK2($j,1,WX)) I WX="" G U06
	S WK=^WORK2($j,1,WX) D WRITE S T1=T1+F2
	G U05
U06	W !,"Total",?12,$j(T1,10,2),!!
	W "Unmatched (Unpresented) Items:-",!!
	W "Date",?15,"Amount",?23,"Type  Ref",?37,"Narrative",!!
	S N=N+7,T1=0
U07	S WX=$O(^WORK2($j,0,WX)) I WX="" G END
	S WK=^WORK2($j,0,WX) D WRITE S T1=T1+F2
	G U07

END	W !,"Total",?12,$j(T1,10,2),!
	D END^XSXS

	;Remove/archive transactions
W00	W /C(0,22),@P1,"Remove or Archive matched transactions (R/A/N) ? ",/EF,@P2 D ^GETX,CASE
	I X="N" Q
	I X'="R",X'="A" G W00

	S X2=0,T1=0
W01	S X2=$o(^CB(DX,X2)) I X2="" G W09
	S CB=^CB(DX,X2),C7=$p(CB,%,7)
	I C7 S C2=$p(CB,%,2),C3=$p(CB,%,3),T1=T1+C3-C2 K ^CB(DX,X2) I X="A" S ^CA(DX,X2)=CB
	G W01
W09	S CB=$g(^CB(DX,0)),C2=$p(CB,%,2),C3=$p(CB,%,3)
	S T1=T1+C3-C2,(C2,C3)=0 S:T1>0 C3=T1 S:T1<0 C2=-T1
	S ^CB(DX,0)=DAT_%_C2_%_C3_%_""_%_%_"Balance forward"_%_0
	Q

	;Validation - Cashbook
V01	Q:$D(ERR)  S B1=$P(^CB(X),%,1),B6=$J($P(^(X),%,6),0,2)
	Q

	;Print line item
WRITE	S D1=$P(WK,%,1),D2=$P(WK,%,2),D3=$P(WK,%,3),D4=$P(WK,%,4),D5=$P(WK,%,5),D6=$P(WK,%,6),D7=+$P(WK,%,7),F2=D3-D2
	W D1,?12,$J(F2,10,2),?24,D4,?29,D5,?37,$e(D6,1,40),!
	S N=N+1 I N>56 D HEAD^XSXS
	Q

	;display total matched amount
WRDT	W @P5,/C(48,5),$j(DT,0,2),@P1,/EL Q

CASE	S X=$zconvert(X,"U") Q
