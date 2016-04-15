XSDD	;GRI,,,;04:04 PM  1 Aug 2005
	;=======================================================
	; Virgo Accounts - VAT Report
	;
	; Copyright Graham R Irwin 1993-2002
	;
	; Screens:       1077
	; Files updated: ^SV
	; Subroutines:	 X0^XSXS, ^OUTPUT, HEAD^XSXS, END^XSXS,
	;                ^GETX
	;
	;=======================================================

	D X0^XSXS
	S %S=1077 F %J=1:1 D ^INPUT Q:X="END"!(X[%)

	D ^OUTPUT Q:%OP[%
	S N=99,P=1,XX="----------"
	D HEAD^XSXS

	I A1="Y" G C01

	;Print detail
	W "Sales",!,"=====",!!?5,"Bill",?16,"Date",?35,"Net Amount",?55,"VAT Amount",!! S N=N+5
	S VX="",(T3,T4)=0
A01	S VX=$O(^SV(VX)) G:VX]"P" B01 G:VX="" B01
	S SV=^SV(VX),V1=$P(SV,%,1),V2=$P(SV,%,2),V3=$P(SV,%,3),V4=$P(SV,%,4)
	W ?5,V1,?16,V2,?35,$J(V3,10,2),?55,$J(V4,10,2),! S N=N+1 I N>58 D HEAD^XSXS
	S T3=T3+V3,T4=T4+V4 G A01
B01	W ?35,XX,?55,XX,!?35,$J(T3,10,2),?55,$J(T4,10,2),!! S N=N+3 I N>58 D HEAD^XSXS

	W "Purchases",!,"=========",!!?5,"Ref",?16,"Date",?35,"Net Amount",?55,"VAT Amount",!! S N=N+5 I N>58 D HEAD^XSXS
	S VX="P",(T3,T4)=0
P01	S VX=$O(^SV(VX)) I VX="" G Q01
	S SV=^SV(VX),V1=$P(SV,%,1),V2=$P(SV,%,2),V3=$P(SV,%,3),V4=$P(SV,%,4)
	W ?5,V1,?16,V2,?35,$J(V3,10,2),?55,$J(V4,10,2),! S N=N+1 I N>58 D HEAD^XSXS
	S T3=T3+V3,T4=T4+V4 G P01
Q01	W ?35,XX,?55,XX,!?35,$J(T3,10,2),?55,$J(T4,10,2),!
	D HEAD^XSXS

	;print VAT summary
C01	S SV=$G(^SV),V1=$P(SV,%,1),V2=$P(SV,%,2),V3=$P(SV,%,3),V4=$P(SV,%,4)
	W "VAT Summary",!,"==========="
	W !!," [1]   VAT on Sales",?35,$j($fn(V4,",p",2),16)
	W !!," [2] *",?46,"0.00"
	W !!," [3]   Total VAT due",?35,$j($fn(V4,",p",2),16)
	W !!," [4]   VAT on Purchases",?35,$j($fn(V2,",p",2),16)
	W !!," [5]   Net VAT to be Paid",?37,"-------------"
	W !?7,"(or Reclaimed)",?35,$j($fn(V4-V2,",p",2),16)
	W !?37,"============="
	W !!," [6]   Total Value of Sales",?35,$j($fn(V3,",p",2),16)
	W !!," [7]   Total Value of Purchases",?35,$j($fn(V1,",p",2),16)
	W !!,"* Please note Virgo Accounts does not identify acquisitons or supplies from/to",!,"other EU member states. You must maintain a separate record for these.",!!

	D END^XSXS

E01	W /C(0,22),@P1,"Delete VAT file ? ",/el,@P2 D ^GETX S X=$zconvert(X,"U")
	I X="Y" K ^SV Q
	I X="N" Q
	G E01
