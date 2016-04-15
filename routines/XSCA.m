XSCA	;GRI,,,;02:56 PM  4 Feb 1999
	;=======================================================
	; Virgo Accounts - Matter Ledger Enquiry
	;
	; Copyright Graham R Irwin 1993-99
	;
	; Screens:       1013
	; Files updated: none
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, ^GETPGM(XSFG),
	;                ^OUTPUT, HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS
	S %S=1013 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSCA Q
	S DET=0 I $d(^SD(CX,MX)) S DET=1
	W @P1 D HEAD

	;Display matter ledger
E01	S IX="",E4=0,MOD=0 W /C(0,11),/EF,@P1
E02	S IX=$O(^ML(CX,MX,IX)) I IX=""!($Y>19) G E09
E03	D LINE
	G E02

E09	W /C(0,22),@P1,"Next, "
	W:DET&'MOD "History, " W:MOD "Current, "
	W "Print or Quit ? ",/EL,@P2 D ^GETX S X=$zconvert(X,"U")
	I X="Q"!(X=%) G XSCA
	I X="P" G P01
	I DET,'MOD,X="H" G H01
	I MOD,X="C" G E01
	I X="N" G N01
	I X="\\" G M01
	I X="Z" D ^GETPGM(3,5) G ^@PGM
	G E09

	;Display history
H01	S (X3,X4)="",E4=0,MOD=1 W /C(0,11),/EF,@P1
H02	S X3=$o(^SD(CX,MX,X3)) I X3=""!($Y>19) G E09
H03	S X4=$o(^SD(CX,MX,X3,X4)) G:X4="" H02 I $Y>19 G E09
H04	D HLINE
	G H03

	;Next
N01	W /C(0,11),/EF,@P1
	I MOD G H04:X3'=""&(X4'="") S E4=0 G H03:X3'="" G H02
	G E03:IX'="" S E4=0 G E02

	;Home
M01	W /C(0,11),/EF,@P1
	I MOD S (X3,X4)="",E4=0 G H02
	S IX="",E4=0 G E02

	;Print
P01	D ^OUTPUT G:%OP[% XSCA S N=99,P=1 D HEAD^XSXS
	D PRINT
	D END^XSXS
	G XSCA

	;Validation - Matter number
V01	Q:$D(ERR)  I '$D(^ML(CX,X)) S ERR="No ledger details for this matter" Q
	S ML=^ML(CX,X),M1=$J($P(ML,%,1),0,2),M2=$J($P(ML,%,2),0,2)
	Q

	;Print routine - May be called by other programs

	; needs the following variables defined:-
	; CX, MX (client and matter codes)
	; MOD =0 for current =1 for historic entries
	; M1, M2 (disb and bills balances)

PRINT	W "Client ",CX,?12,$p(^SC(CX),%,1),!
	W "Matter ",MX,?12,$p(^SM(CX,MX),%,1),!
	W "Disb Balance  ",$j(M1,12,2),!
	W "Bills Balance ",$j(M2,12,2)
	I MOD W ?50,"* Historic Entries *"
	W ! D HEAD
	S E4=0,N=N+7,(IX,X3,X4)=""
	I MOD G P12

	;current transactions
P02	S IX=$O(^ML(CX,MX,IX)) I IX="" Q
	D LINE S N=N+2 I N>56 D HEAD^XSXS
	G P02

	;historic transactions
P12	S X3=$o(^SD(CX,MX,X3)) I X3="" Q
P13	S X4=$o(^SD(CX,MX,X3,X4)) I X4="" G P12
	D HLINE S N=N+2 I N>56 D HEAD^XSXS
	G P13

	;Show heading (for print or display)
HEAD	W !?5,"Date",?18,"Ref No   Type",?37,"Debit",?49,"Credit",?62,"Balance",!! Q

LINE	S ML=^ML(CX,MX,IX) D DATA Q

HLINE	S ML=^SD(CX,MX,X3,X4) D DATA Q

DATA	S D1=$P(ML,%,1),D2=$P(ML,%,2),D3=$P(ML,%,3),D4=$P(ML,%,4),D5=$P(ML,%,5),D7=$P(ML,%,7),E4=E4-D2+D3
	W ?5,D1,?18,D5,?27,D4 W:D3 ?33,$J(D3,10,2) W:D2 ?46,$J(D2,10,2) W ?59,$J(E4,10,2),!?6,D7,!
	Q
