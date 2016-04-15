XSCF	;GRI,,,;10:51 AM  31 Jan 2002;
	;=======================================================
	; Virgo Accounts - Transaction Search
	;
	; Copyright Graham R Irwin 1998-2002
	;
	; Screens:       1069
	; Files updated: ^WORK
	; Subroutines:   X0^XSXS, ^INPUT, ^OUTPUT,
	;                HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS
	S %S=1069 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSCF Q
	S S3=$zconvert(S1,"L")

	W @P1
	K ^WORK($j) S NX=0

	;Search matter ledger
	S (CX,MX,IX)=""
E02	S CX=$o(^ML(CX)) I CX="" G F01
E03	S MX=$o(^ML(CX,MX)) I MX="" G E02
E04	S IX=$o(^ML(CX,MX,IX)) I IX="" G E03
	S ML=^ML(CX,MX,IX),S2=$zconvert(ML,"L")
	I S2'[S3 G E04
	S NX=NX+1,^WORK($j,NX)="ML"_%_CX_"/"_MX_%_ML
	W /c(0,8),NX," item(s) found",!
	G E04

	;Search client ledger
F01	S (CX,MX,IX)=""
F02	S CX=$o(^CL(CX)) I CX="" G G01
F03	S MX=$o(^CL(CX,MX)) I MX="" G F02
F04	S IX=$o(^CL(CX,MX,IX)) I IX="" G F03
	S CL=^CL(CX,MX,IX),S2=$zconvert(CL,"L")
	I S2'[S3 G F04
	S NX=NX+1,^WORK($j,NX)="CL"_%_CX_"/"_MX_%_CL
	W /c(0,8),NX," item(s) found",!
	G F04

	;Search nominal ledger
G01	S (AX,IX)=""
G02	S AX=$o(^AY(AX)) I AX="" G H01
G04	S IX=$o(^AY(AX,IX)) I IX="" G G02
	S AY=^AY(AX,IX),S2=$zconvert(AY,"L")
	I S2'[S3 G G04
	S NX=NX+1,^WORK($j,NX)="NL"_%_AX_%_AY
	W /c(0,8),NX," item(s) found",!
	G G04

	;Search cashbooks
H01	S (KX,IX)=""
H02	S KX=$o(^CB(KX)) I KX="" G J01
H04	S IX=$o(^CB(KX,IX)) I IX="" G H02
	S CB=^CB(KX,IX),S2=$zconvert(CB,"L")
	I S2'[S3 G H04
	S NX=NX+1,^WORK($j,NX)="CB"_%_KX_%_CB
	W /c(0,8),NX," item(s) found",!
	G H04

	;Search archived disbursements
J01	S (CX,MX,BX,IX)=""
J02	S CX=$o(^SD(CX)) I CX="" G K01
J03	S MX=$o(^SD(CX,MX)) I MX="" G J02
J04	S BX=$o(^SD(CX,MX,BX)) I BX="" G J03
J05	S IX=$o(^SD(CX,MX,BX,IX)) I IX="" G J04
	S SD=^SD(CX,MX,BX,IX),S2=$zconvert(SD,"L")
	I S2'[S3 G J05
	S NX=NX+1,^WORK($j,NX)="SD"_%_CX_"/"_MX_%_SD
	W /c(0,8),NX," item(s) found",!
	G J05

	;Search archived cashbooks
K01	S (KX,IX)=""
K02	S KX=$o(^CA(KX)) I KX="" G L01
K04	S IX=$o(^CA(KX,IX)) I IX="" G K02
	S CA=^CA(KX,IX),S2=$zconvert(CA,"L")
	I S2'[S3 G K04
	S NX=NX+1,^WORK($j,NX)="CA"_%_KX_%_CA
	W /c(0,8),NX," item(s) found",!
	G K04

	;Done searching
L01	I NX=0 W /C(0,22),@P1,"Nothing Found. Press any key to continue ",/EL R *X R:'X *X G XSCF
	D ^OUTPUT I %OP[% G XSCF
	S N=99,P=1 D HEAD^XSXS
	W "Searching for ",S1,!!
	S WX=""
L02	S WX=$o(^WORK($j,WX)) I WX="" G M01
	S WK=^WORK($j,WX)
	W $tr(WK,%," "),!
	G L02

M01	W !,"Prefix:",!,"ML = matter ledger",!,"CL = client ledger",!,"NL = nominal ledger",!,"CB = cashbooks",!,"SD = historic disbursements",!,"CA = archived cashbooks"
	D END^XSXS
	Q
