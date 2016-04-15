XSBC	;GRI,,,;04:54 PM  28 Jun 2013
	;=======================================================
	; Virgo Accounts - Post Bill
	;
	; Copyright Graham R Irwin 1998-2003
	;
	; Screens:       1006
	; Files updated: ^ML ^SB ^SD ^SU ^SV ^SW ^SY ^AB ^AY
	;                ^WORK($j) and DOS file XSBILL.SPS
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, YX^XSXS, UPAB^XSXS
	;
	;=======================================================

	; B0 - Default bill no		B1 - Bill date
	; B2 - Time billed		B3 - Time removed
	; B4 - Disbursements billed	B5 - VAT amount
	; E2 - Gross amount		G2 - Net billed (=B2+B4)
	; L0 - Default disbs billed	L1 - Disbursements written off

	D X0^XSXS
	S E5="Bill",E8="N",TT="BIL",VAT=^SZ("VAT")/100,B0=$G(^SB)+1
	S %S=1006 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSBC G QUIT

	;Get all disbursements
	S X3="",WX=1 K ^WORK($j)
	S (L1,WK7)=0 I $g(^SZ("WOD"),"Y")="Y" S L1=+$g(^ML(CX,MX)),WK7=1
G01	S X3=$O(^ML(CX,MX,X3)) I X3="" G E02
	S ML=^ML(CX,MX,X3),M4=$P(ML,%,4)
	I "DIS,DSW,DSP,DSA,TOC,COD,OMT,N2D"[M4 S ^WORK($j,WX)=X3_%_$P(ML,%,1,5)_%_WK7_%_$P(ML,%,7,99),WX=WX+1
	G G01

E02	W /C(0,22),@P1,"Disbursements, Update, Amend or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX,CASE G XSBC:X="Y",E02
	I X="A" G A01
	I X="D"!(X="Z") G M01
	I X="U" G U01
	G E02

	;Update...
U01	S F5=C5_" - "_$p(^SC(CX),%,1),F5=$e(F5,1,70)
	;... Daybook
	D YX^XSXS S ^SY(DAT,TT,YX)=B1_%_CX_%_MX_%_%_G2_%_B5_%_%_%_%_BX_%_F5
	;... Matter Ledger (bills)
	S ^ML(CX,MX,YX)=B1_%_%_E2_%_TT_%_BX_%_%_C5_%
	S ML=$G(^ML(CX,MX)),M1=$P(ML,%,1),M2=$P(ML,%,2)+E2,^ML(CX,MX)=M1_%_M2
	;... Bill Register
	I BX'=0 S ^SB(BX)=B1_%_CX_%_MX_%_B2_%_B4_%_B5_%_B3_%_E2_%_"U"_%_E8_%
	I BX'<B0 S ^SB=BX
	I BX'=0 S ^SU(BX)=""
	;... VAT records if NOT cash basis
	I ^SZ("VCB")="N" S SV=$G(^SV),V1=$P(SV,%,1),V2=$p(SV,%,2),V3=$P(SV,%,3)+G2,V4=$P(SV,%,4)+B5,^SV=V1_%_V2_%_V3_%_V4,^SV(YX)=BX_%_B1_%_G2_%_B5
	;... Nominal
	S AX="L040" S:^SZ("VCB")="Y" AX="L140" D UPAB^XSXS(AX,B5,B1,TT,BX,F5)
	D UPAB^XSXS("A110",E2,B1,TT,BX,F5)
	S T2=-L1 S:L1<B4 T2=-B4 D UPAB^XSXS("A120",T2,B1,TT,BX,F5)
	D UPAB^XSXS("I020",B2,B1,TT,BX,F5)
	S T1=L1-B4 S:L1<B4 T1=0 D UPAB^XSXS("E280",T1,B1,TT,BX,F5)
	D UPAB^XSXS("N090",E2,B1,TT,BX,F5)
	D UPAB^XSXS("N020",-B3,B1,TT,BX,F5)
	D UPAB^XSXS("N070",B4,B1,TT,BX,F5)
	D UPAB^XSXS("N040",B2,B1,TT,BX,F5)
	;... Billed Disbs and Matter Ledger (disbs)
	S WX=""
P01	S WX=$O(^WORK($j,WX)) I WX="" G P04
	S ML=^WORK($j,WX),X3=$P(ML,%,1),M6=$P(ML,%,7)
	I M6=1 S ^SD(CX,MX,BX,X3)=$P(ML,%,2,99) K ^ML(CX,MX,X3)
	G P01
P04	S ML=^ML(CX,MX),M1=$P(ML,%,1)+T2,M2=$P(ML,%,2),^ML(CX,MX)=M1_%_M2_%
	I L1<B4 S ^ML(CX,MX,YX+.1)=B1_%_(B4-L1)_%_%_"DSA"_%_BX_%_%_"Anticipated disb"_%
	;... Time Records
	S SW=$g(^SW(CX,MX)),W1=$p(SW,%,1)-B3,W2=$p(SW,%,2,99) K ^SW(CX,MX)
	I W1 S ^SW(CX,MX,1,"!C")=%_%_W1,^SW(CX,MX)=W1_%_W2

	;Write merge file
	zetrap ERR^XSBC
	o 10:(file="xsbill.sps":mode="a") u 10
	s SCA=^SC(CX,"A") w $p(^SC(CX),%,1),%,$p(SCA,%,1),%,$p(SCA,%,2),%,$p(SCA,%,3),%,$p(SCA,%,4),%,$p(SCA,%,5),%,B1,%,BX,%,B2,%,B4,%,VAT*100,%,B5,%,E2,!
	c 10 u 0
	G XSBC

	;Error trap if unable to write to XSBILL.SPS
ERR	i $zerr=219!($zerr=302) u 0 w *7,!,"Warning: Merge File Not Created - " S x=$$^Cont(0) G XSBC
	zquit

	;Amend
A01	W /C(0,4),/EF F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSBC:%J=1,A01
	G E02

	;Disbursements (second screen) -----------------------------
	;Display disbursements
M01	S WX="" W /C(0,4),/EF,@P1,"Item Date",?16,"Description",?63,"Amount",?72,"W/O?",!!
M02	S WX=$O(^WORK($j,WX)) I WX=""!($Y>19) G M09
M03	S ML=^WORK($j,WX),D1=$P(ML,%,2),D2=$P(ML,%,3),D3=$P(ML,%,4),D4=$P(ML,%,5),D5=$P(ML,%,6),D6=$P(ML,%,7),D7=$P(ML,%,8),F2=D3-D2
	W:D6 @P5 W WX,?4,D1,?16,$e(D7,1,40),?60,$J(F2,10,2),?73,$S(D6:"Yes",'D6:"No"),@P1,!
	G M02
M09	W /C(0,22),@P1,"Mark/unmark, Next, Update or Back ? ",/EL,@P2 D ^GETX,CASE
	I X="U" G U01
	I X="N" G N01
	I X="B" G B01
	I X="M"!(X="Z") G S01
	G M09

	;Back
B01	W /C(0,4),/EF F %J=1:1 D D^INPUT Q:X="END"
	G E02

	;Select
S01	W @P1,"  Mark/unmark item ",@P2 D ^GETX I $G(^WORK($j,+X))="" G M09
	S WK=^WORK($j,X),W1=$P(WK,%,1,2),W3=$P(WK,%,3),W4=$P(WK,%,4),W5=$P(WK,%,5,6),W7=$P(WK,%,7),W8=$P(WK,%,8,99)
	S W7=1-W7,F2=W3-W4 S:W7 L1=L1-F2 S:'W7 L1=L1+F2
	S ^WORK($j,X)=W1_%_W3_%_W4_%_W5_%_W7_%_W8_%
	G M01

	;Next
N01	W /C(0,6),/EF,@P1 G M03:WX'="",M02

QUIT	Q

	;Validation routines ---------------------------------------
	;Matter code
V01	Q:$D(ERR)  S SM=^SM(CX,X),M6=$P(SM,%,6),SW=$J($G(^SW(CX,X)),0,2)
	S ML=$P($G(^ML(CX,X)),%,1),L0=$J($P(ML,%,1),0,2)
	Q
	;VAT amount
V02	I BX=0,X>0 S ERR="Must be zero" Q
	S E2=$J(G2+X,0,2)
	Q
	;Disbursements
V03	Q:$D(ERR)  I BX=0,X>0 S ERR="Must be zero" Q
	S G2=B2+X,E3=$J(G2*VAT*(M6="Y"),0,2)
	Q
	;Fees billed
V04	I BX=0,X>0 S ERR="Must be zero" Q
	Q
	;Time removed
V05	I $D(ERR) Q
	I X>SW W @P3,?48,"Exceeds WIP booked"
	Q

CASE	S X=$zconvert(X,"U") Q
