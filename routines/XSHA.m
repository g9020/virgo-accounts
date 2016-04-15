XSHA	;GRI,,,;04:18 PM  15 Jan 2003
	;=======================================================
	; Virgo Accounts - Print System Parameters
	;
	; Copyright Graham R Irwin 1993-2003
	;
	; Screens:       none
	; Files updated: none
	; Subroutines:   X0^XSXS, H2DMY^DATE, ^OUTPUT, HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS
	S %H=^SZ("LDE") D H2DMY^DATE S A6=%DAT
	S %H=^SZ("LPE") D H2DMY^DATE S A7=%DAT
	S %H=^SZ("NYE") D H2DMY^DATE S A8=%DAT

	D ^OUTPUT Q:%OP[%  S N=99,P=1
	D HEAD^XSXS
	W ?5,"Practice Name",?25,^SZ("PN"),!
	W ?5,"Software Licence No",?25,^SZ("SW")
	W ?45,"Software Version",?65,$g(^MENU),!
	W ?5,"VAT Cash Basis",?25,^SZ("VCB")
	W ?45,"VAT Rate",?65,^SZ("VAT"),"%",!
	W ?5,"Detailed Time",?25,$g(^SZ("DTE"),"N")
	W ?45,"Time Units (mins)",?65,^SZ("TU"),!
	W ?5,"Auto Day-end",?25,$g(^SZ("ADE"),"Y")
	W ?45,"Date Check",?65,$g(^SZ("D30"),"Y"),!
	W ?5,"Last Day-end",?25,A6
	I $e(H0,1)'="X" W ?45,"Overdraw Client",?65,$g(^SZ("ODC"),"N")
	W !
	W ?5,"Last Period-end",?25,A7
	W ?45,"Write-off Disbs",?65,$g(^SZ("WOD"),"Y"),!
	W ?5,"Next Year-end",?25,A8,! S N=N+8

	S FX="" W !,"Fee Earners :",!! S N=N+3
A01	S FX=$O(^SF(FX)) I FX="" G A03
	W ?5,"F/e No ",FX,?15,$P(^SF(FX),%,1),! S N=N+1 D CKLINE
	G A01

A03	S (X1,X2)="" W !,"Fee Rates (* = default) :",! S N=N+2
A04	S X1=$O(^SR(X1)) I X1="" G A08
	W ! I $g(^SZ("DCG"))=X1 W ?3,"*"
	W ?5,"Charge Group ",X1," : ",$P(^SR(X1),%,1),"  " F I=1:1 W "-" Q:$X>65
	W !!?7,"Activity",?37,"Rate/hour  Rate/item",!! S N=N+5
A06	S X2=$O(^SR(X1,X2)) I X2="" G A04
	S SR=^SR(X1,X2),A1=$P(SR,%,1),A2=$P(SR,%,2),B1=$P($G(^SA(X2)),%,1)
	W ?7,X2,?10,B1 W:A1 ?39,$J(A1,6,2) W:A2 ?49,$J(A2,6,2) W ! S N=N+1 D CKLINE G A06

A08	S CX="" W !,"Cashbooks (* = default) :",!
	W ?41,"Sort code  Account No.",?66,$$^NEWNAME("@F3@"),"?",!! S N=N+4
A09	S CX=$O(^CB(CX)) I CX="" G A10
	S CB=^CB(CX),A1=$P(CB,%,1),A2=$P(CB,%,2),A3=$P(CB,%,3),A4=$P(CB,%,4)
	I $g(^SZ("DOC"),1)=CX W ?3,"*"
	W ?5,CX,?10,A1,?42,A2,?52,A3,?69,A4,!! S N=N+2 D CKLINE G A09

A10	

END	D END^XSXS Q
 
CKLINE	I N>56 D HEAD^XSXS
	Q
