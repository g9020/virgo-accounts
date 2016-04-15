XSHB	;GRI,,,;03:42 PM  18 May 2004
	;=======================================================
	; Virgo Accounts - Consistency
	;
	; Copyright Graham R Irwin 1993-2004
	;
	; Screens:       1050
	; Files updated: ^CB ^CL ^ML ^SU ^SV ^SW ^AB ^SEARCH
	; Subroutines:   X0^XSXS, ^INPUT, ^%mdslist, ^%dsverify,
	;                ^%now, ^OUTPUT, HEAD^XSXS, END^XSXS
	;
	;=======================================================

	D X0^XSXS
	L (^SY,^SZ,^SC,^SM)
	S YES="Y",NO="N",NC=0,XXX="* BALANCE AMENDED *"
	W @P2,?8,"** HAVE YOU REMEMBERED TO TAKE A BACKUP? **",!!
	S %S=1050 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSHB Q
	D ^OUTPUT Q:%OP[%  S N=99,P=1 D HEAD^XSXS

	W "Part 1 : checking five datasets for data errors...",!,$$^%now
	s dsid=$$^%mdslist,dslist=""
	f i=1:1 s ds=$p(dsid,",",i) q:ds=""  s dslist=dslist_$p(ds,":",2)_":"_$p(ds,":",1)_","
	s res=$$results^%dsverify(dslist,0,%OP)
	w !!,"IMPORTANT: If any errors are shown above, please report these to the support",!,"desk and DO NOT continue with any further inputting.",!!

	I C1="N" G H01
	W !,"Part 2 : checking integrity of accounts data...",!,$$^%now,!
	;Cashbooks ----------------------------------------------------------
	S (CX,X2)="",(T1,T2,T3)=0
C01	S (A2,A3)=0,CX=$O(^CB(CX)) I CX="" G C07
	S CB=$g(^CB(CX)),B1=$P(CB,%,1,3),B4=$P(CB,%,4),B5=$P(CB,%,5),B6=$P(CB,%,6),B7=$P(CB,%,7,99)
	I CX<100 S T1=T1+B6
	I CX>99 S:B4="N" T2=T2+B6 S:B4="Y" T3=T3+B6
C03	S X2=$O(^CB(CX,X2)) I X2="" G C05
	S CB=$g(^CB(CX,X2)),A2=$P(CB,%,2)+A2,A3=$P(CB,%,3)+A3
	G C03
C05	S Q6=A3-A2 I Q6=+B6 G C01
	W !,"Cashbook ",CX," balance does not equal sum of transactions",?60,XXX,!?2,"Balance = ",B6,?25," Sum of trans = ",Q6,?55," Diff = ",B6-Q6,! D CHK S ^CB(CX)=B1_%_B4_%_B5_%_Q6_%_B7,NC=NC+1
	G C01

C07	S XXY="CB",AX="A130",X=T1 D ACNEQ
	S AX="L010",X=T2 D ACNEQ
	S AX="L020",X=T3 D ACNEQ

	;Matter Ledger ------------------------------------------------------
	S (CX,MX,X3)="",(T3,T4)=0
D01	S CX=$O(^ML(CX)) I CX="" G D08
D02	S (T1,T2)=0,MX=$O(^ML(CX,MX)) I MX="" G D01
	S ML=$g(^ML(CX,MX)),B1=$p(ML,%,1),B2=$p(ML,%,2)
	d checkit
D04	S X3=$O(^ML(CX,MX,X3)) I X3="" G D06
	S ML=$g(^ML(CX,MX,X3)),A2=$p(ML,%,2),A3=$p(ML,%,3),A4=$p(ML,%,4)
	I "BIL,BPY,BCR,TCO,COB,N2B"[A4 S T2=T2+A3-A2
	I "DIS,DSW,DSP,DSA,TOC,COD,OMT,N2D"[A4 S T1=T1+A3-A2
	G D04
D06	I T1'=+B1 W !,"Matter ",CX,"/",MX," disbs balance not equal to sum of trans",?60,XXX,!?2,"Balance = ",B1,?25," Sum of trans = ",T1,?55," Diff = ",B1-T1,! D CHK S ^ML(CX,MX)=T1_%_B2_%,NC=NC+1
	I T2'=+B2 W !,"Matter ",CX,"/",MX," bills balance not equal to sum of trans",?60,XXX,!?2,"Balance = ",B2,?25," Sum of trans = ",T2,?55," Diff = ",B2-T2,! D CHK S ^ML(CX,MX)=T1_%_T2_%,NC=NC+1
	S T3=T3+T1,T4=T4+T2
	G D02
D08	S XXY="ML",AX="A120",X=T3 D ACNEQ
	S AX="A110",X=T4 D ACNEQ

	;W-I-P --------------------------------------------------------------
	S (CX,MX,FX,X4)="",T4=0
E01	S CX=$O(^SW(CX)) I CX="" G E08
E02	S T2=0,MX=$O(^SW(CX,MX)) I MX="" G E01
	S SW=$g(^SW(CX,MX)),S1=$P(SW,%,1),S2=$P(SW,%,2)
	d checkit
E04	S FX=$O(^SW(CX,MX,FX)) I FX="" G E06
E05	S X4=$O(^SW(CX,MX,FX,X4)) I X4="" G E04
	S SW=$g(^SW(CX,MX,FX,X4)),W1=$P(SW,%,1,2),W3=$P(SW,%,3),T2=T2+W3
	G E05
E06	I T2'=S1 W !,"Matter ",CX,"/",MX," WIP balance not equal to sum of trans",?60,XXX,!?2,"Balance = ",S1,?25," Sum of trans = ",T2,?55," Diff = ",S1-T2,! D CHK S ^SW(CX,MX)=T2_%_S2_%,NC=NC+1
	S T4=T4+T2
	G E02
E08	S XXY="WIP",AX="N020",X=T4 D ACNEQ

	;Client Ledger ------------------------------------------------------
	S (CX,MX,X3)="",(T3,T4)=0
F01	S CX=$O(^CL(CX)) I CX="" G F08
F02	S T1=0,MX=$O(^CL(CX,MX)) I MX="" G F01
	S CL=$g(^CL(CX,MX)),B1=$P(CL,%,1),B2=$P(CL,%,2,99)
	d checkit
F04	S X3=$O(^CL(CX,MX,X3)) I X3="" G F06
	S CL=$g(^CL(CX,MX,X3)),A1=$P(CL,%,1),A2=$P(CL,%,2),A3=$P(CL,%,3),A4=$P(CL,%,4,99)
	S T1=T1+A3-A2
	G F04
F06	I T1'=B1 W !,"Matter ",CX," / ",MX," client balance not equal to sum of trans",?60,XXX,!?2,"Balance = ",B1,?25," Sum of trans = ",T1,?55," Diff = ",B1-T1,! D CHK S ^CL(CX,MX)=T1_%_B2,NC=NC+1
	I $P($g(^SM(CX,MX)),%,5)="Y" S T4=T4+T1
	E  S T3=T3+T1
	G F02
F08	S XXY="CL",AX="L010",X=T3 D ACNEQ
	S AX="L020",X=T4 D ACNEQ

	;VAT File -----------------------------------------------------------
	;S SV=$g(^SV),V1=$P(SV,%,1,2),V3=$P(SV,%,3),V4=$P(SV,%,4),(T3,T4)=0,X1=""
G01	;S X1=$O(^SV(X1)) I X1="" G G08
	;S SV=^SV(X1),T3=T3+$P(SV,%,3),T4=T4+$P(SV,%,4)
	;G G01
G08	;I T3'=+V3 W !,"VAT o/p not equal to sum of transactions",?60,XXX,!?2,"Balance = ",V3,?25," Sum of trans = ",T3,?55," Diff = ",V3-T3,! D CHK S NC=NC+1
	;I T4'=+V4 W !,"Outputs not equal to sum of transactions",?60,XXX,!?2,"Balance = ",V4,?25," Sum of trans = ",T4,?55," Diff = ",V4-T4,! D CHK S NC=NC+1
	;S ^SV=V1_%_T3_%_T4

	;Nominal ledger -----------------------------------------------------
	S AX=""
J01	S AX=$o(^AB(AX)) I AX=""!(AX]"M999") G J09 ;ignore non-financial a/cs
	S X2="",T1=0,AB=$g(^AB(AX)),A14=$p(AB,%,1,4),A5=$p(AB,%,5)
	;check for system a/cs
	i "A110;A120;A130;E280;E330;E340;I020;L010;L020;L040;L140;L510;L520;L530"[AX,A5'="Y" S ^AB(AX)=A14_%_"Y"_%
J02	S X2=$o(^AY(AX,X2)) I X2="" G J04
	S AY=^AY(AX,X2),T1=T1+$p(AY,%,2)
	G J02
J04	S XXY="AY",X=T1 D ACNEQ
	G J01
J09
	;Bill register ------------------------------------------------------
	S BX=""
K01	S BX=$o(^SB(BX)) I BX="" G K09
	S SB=$g(^SB(BX)),B1=$p(SB,%,1),CX=$p(SB,%,2),MX=$p(SB,%,3),B4=$p(SB,%,4,7),B8=$p(SB,%,8)
	I $d(^SM(CX,MX))!(+B8=0) G K01
	W !,"Unpaid bill ",BX," matter unknown",?60,"* MARKED AS PAID *",!?5,"Client ",CX," matter ",MX,! D CHK S NC=NC+1
	S ^SB(BX)=B1_%_CX_%_MX_%_B4_%_0_%_"F"_%_"N"_%
	G K01
K09
	;Standing orders ----------------------------------------------------
	S (X1,X2)=""
L02	S X1=$o(^SX(X1)) I X1="" G L09
L03	S X2=$o(^SX(X1,X2)) I X2="" G L02
	I '$d(^SO(X2)) K ^SX(X1,X2)
	G L03
L09
	;Check clients without matters
	S CX=""
M01	S CX=$o(^SC(CX)) I CX="" G M09
	I '$d(^SM(CX)) W !,"Warning: client ",CX," has no matters",! D CHK
	G M01
M09

Z99	W ! W:NC=0 "No" W:NC>0 NC W " consistency error" W:NC'=1 "s"
	I NC>0 W " - Please report th" W:NC=1 "is" W:NC'=1 "ese" W " to the support desk",!

H01	I C2="N" G I01
	;Recreate SEARCH file -----------------------------------------------
	D CHK W !!,"Part 3 : recreating index files...",!,$$^%now
	D RECR W !,"Index files recreated",!

I01	I C3="N" G END
	;Compress database --------------------------------------------------
	D CHK W !!,"Part 4 : compressing database...",!,$$^%now
	u 0 w @P5,/c(0,12) d ^XSCOMPACT
	u %OP
	w !,"Database compressed",!

END	S (CX,MX)=""
	D END^XSXS
	Q

	;Subroutine to check account balance
ACNEQ	S AB=^AB(AX),A1=$P(AB,%,1),A2=$P(AB,%,2),A3=$P(AB,%,3),A4=$P(AB,%,4,99) I +A3=X Q
	W !,"Account ",AX," balance not equal to sum of ",XXY," transactions",?60,XXX,!?2,"Balance = ",A3,?25," Sum of trans = ",X,?55," Diff = ",A3-X,! D CHK S NC=NC+1
	I "AL"[$e(AX,1)!(AX="N020") S A2=X
	S ^AB(AX)=A1_%_A2_%_X_%_A4
	Q

	;Subroutine to recreate SEARCH files (also used by XSINSTAL)
RECR	F X="SC","AB","CB","SR","SF" D SCH
	K ^SEARCH("SM") S ^SEARCH("SM")="D S^XSXS"
	K ^SEARCH("SA") S ^SEARCH("SA")="D SA^XSXS"
	K ^SEARCH("SB") S ^SEARCH("SB")="D UB^XSXS"
	;Recreate unpaid bills index
	S BX="" K ^SU
R03	S BX=$o(^SB(BX)) I BX="" Q
	I +$p(^SB(BX),%,8) S ^SU(BX)=""
	G R03

SCH	K ^SEARCH(X) S XX=""
S01	S XX=$O(@("^"_X_"(XX)")) I XX="" Q
	S X1=$P(@("^"_X_"(XX)"),%,1),^SEARCH(X,$zconvert(X1,"L"),XX)=""
	G S01

	;Check for end of page
CHK	I $Y>60 D HEAD^XSXS
	Q

	;Check if matter and client exist
checkit	i '$d(^SM(CX,MX)) s ^SM(CX,MX)="Dummy"_%_%_%_%_%_%_0_%_%_%_%,^SM(CX,MX,"N")=%_%_%
	i '$d(^SC(CX)) s ^SC(CX)="Dummy"_%_%_%,^SC(CX,"A")=%_%_%_%_%,^SC(CX,"N")=%_%_%
	q
