XSHD	;GRI,,,;04:52 PM  22 Mar 2002
	;=======================================================
	; Virgo Accounts - Period End Processing
	;
	; Copyright Graham R Irwin 1993-2002
	;
	; Screens:       1060
	; Files updated: ^AB ^AY ^SZ
	; Subroutines:   X0^XSXS, ^INPUT, PRINT^XSCE, ^GETX,
	;                ^OUTPUT, HEAD^XSXS, END^XSXS
	;
	;=======================================================

	;S A1=^SZ("LDE") I A1<+$H D ^XSHC
	D X0^XSXS
	L (^SY,^SZ,^SC,^SM)

	;entry point from year-end
AA	W /c(0,4),/ef S NO="N"
	S %S=1060 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSHD Q
	I A2="Y" W !?8,"WARNING: This could be a long report. You are advised to print it",!?8,"to the Spooler or to a File - if unsure please refer to the manual",!?8,"for details.",!

	D ^OUTPUT Q:%OP[%  S N=99,P=1 D HEAD^XSXS

	;Expense accounts
	S X1="E0",T1=0
A02	S X1=$O(^AB(X1)) I X1]"E999"!(X1="") G B01
	S AB=^AB(X1),B1=$P(AB,%,1),T1=T1+$p(AB,%,2),B3=$P(AB,%,3,99),^AB(X1)=B1_%_0_%_B3
	G A02

	;Income accounts
B01	S X1="I0",T2=0
B02	S X1=$O(^AB(X1)) I X1]"I999"!(X1="") G C01
	S AB=^AB(X1),B1=$P(AB,%,1),T2=T2+$p(AB,%,2),B3=$P(AB,%,3,99),^AB(X1)=B1_%_0_%_B3
	G B02

	;Update profit/loss account
C01	S X1="L530",AB=^AB(X1),B1=$p(AB,%,1),B2=$p(AB,%,2),B3=$p(AB,%,3,99),^AB(X1)=B1_%_(B2-T1+T2)_%_B3

	I A2="N" G END

	;Print transactions
	S (AX,X2)=""
E01	S AX=$o(^AY(AX)) I AX=""!($e(AX,1)="N") G F00
	D PRINT^XSCE W !! S N=N+2
	G E01

	;Remove transactions
F00	U 0 W /c(0,22),@P1,"Remove transactions ? ",/el,@P2 D ^GETX S X=$zconvert(X,"U")
	I X="N" G END
	I X'="Y" G F00
	S (AX,X2)=""
F01	S T1=0,AX=$o(^AY(AX)) I AX="" G END
F02	S X2=$o(^AY(AX,X2)) I X2="" G F05
	S AY=^AY(AX,X2),T1=T1+$p(AY,%,2)
	G F02

F05	K ^AY(AX) I $e(AX,1)'="N" S ^AY(AX,0)=DAT_%_T1_%_%_%_"Balance forward"
	G F01

END	S ^SZ("LPE")=+$H
	U %OP W "Period End Processing Run On ",DAT,!!,"Keep This Report For Audit Purposes",!
	D END^XSXS Q

	;Validation
V01	I X'="PDE" S ERR="Wrong confirmation"
	Q
