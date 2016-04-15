XSFK	;GRI,,,;04:44 PM  22 Mar 2002
	;=======================================================
	; Virgo Accounts - List All Client Ledger Transactions
	;
	; Copyright Graham R Irwin 1993-2002
	;
	; Screens:       1063
	; Files updated: none
	; Subroutines:   X0^XSXS, ^INPUT, ^OUTPUT, HEAD^XSXS,
	;                END^XSXS, DMY2H^DATE
	;
	;=======================================================

	D X0^XSXS S NO="N"
	S %S=1063 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSFK Q
	W !?8,"WARNING: This could be a long report. You are advised to print it",!?8,"to the Spooler or to a File - if unsure please refer to the manual",!?8,"for details.",!

	D ^OUTPUT I %OP[% G XSFK
	S N=99,P=1 D HEAD^XSXS
	S (CX,MX)=""
	W ?5,"Transactions from ",A2 W:A2="" "Start" W " to ",A3 W:A4="Y" " - interest only" W !! S N=N+2

A01	S CX=$o(^CL(CX)) I CX="" G END
A02	S MX=$o(^CL(CX,MX)) I MX="" G A01
	S SMA=^SM(CX,MX),SMA1=$p(SMA,%,1),KX=$p(SMA,%,10),CBA1=$p(^CB(KX),%,1),CLB=$g(^CL(CX,MX)),CLB1=$j($p(CLB,%,1),0,2)
	U 0 W /c(0,23),@P1,"Processing ",CX," / ",MX,/el U %OP
	D PRINT I NT=0 W ?5,"(no relevant transactions)",! S N=N+1
	W ! S N=N+1
	G A02

END	D END^XSXS
	Q

	;Print all details for a client
PRINT	W "Client ",CX,?12,$P(^SC(CX),%,1),?72,"-----",!
	W "Matter ",MX,?12,SMA1,!
	W "Current balance ",CLB1,?34,"Cashbook ",KX,?47,CBA1,!!
	W ?5,"Date",?18,"Ref No   Type",?36,"Receipt",?49,"Payment",?62,"Balance",!!
	S N=N+6,IX="",(E4,NT)=0
P02	S IX=$O(^CL(CX,MX,IX)) I IX="" Q
	D LINE I N>56 D HEAD^XSXS
	G P02

	;print a transaction
LINE	S CL=^CL(CX,MX,IX),D1=$P(CL,%,1),D2=$P(CL,%,2),D3=$P(CL,%,3),D4=$P(CL,%,4),D5=$P(CL,%,5),D6=$P(CL,%,6),E4=E4-D2+D3
	I A4="Y",D4'="CLI" Q
	S %DAT=D1 D DMY2H^DATE S E1=%H
	I E1'<B1,E1'>B2 W ?5,D1,?18,D5,?27,D4 W:D3 ?33,$J(D3,10,2) W:D2 ?46,$J(D2,10,2) W ?59,$J(E4,10,2),!?6,D6,! S N=N+2,NT=NT+1
	Q

	;Validation - Confirm
V01	I X'="ALL" S ERR="Wrong confirmation"
	Q
	;From date
V02	I X="" K ERR
	I $d(ERR) Q
	S %DAT=X D DMY2H^DATE S B1=%H S:X="" B1=0
	Q
	;To date
V03	I $d(ERR) Q
	S %DAT=X D DMY2H^DATE S B2=%H
	I B2<B1 S ERR="Cannot be earlier than From Date"
	Q
