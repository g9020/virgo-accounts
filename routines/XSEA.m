XSEA	;GRI,,,;02:46 PM  9 Jun 1997
	;=======================================================
	; Virgo Accounts - Post Time Sheet
	;
	; Copyright Graham R Irwin 1993-1997
	;
	; Screens:       1022, 1045
	; Files updated: ^SW ^TE ^WORK($j) ^AB ^AY
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, DMY2H^DATE, 
	;                YX^XSXS, UPAB^XSXS
	;
	;=======================================================

	D X0^XSXS
	S TT="TS",D5="Time sheet",ONE=1
	S %S=1022 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% Q:%J=1  G XSEA

	W @P1,!?8,"Client Matter Activity",?52,"Units",?60,"Items",!!
	S WS=1 K ^WORK($j)
I01	W /C(0,16),/EF S WX=WS,F1=1,(A4,A5)=""
	S %S=1045 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G I01:%J>1 S WS=WX,A1="",F1=0 G N01
E09	W /C(0,22),@P1,"Update, Amend, Delete or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) S A1="" G N01
	I X="A" G A01
	I X="U" G U01
	I X="D" W @P1,"  Are you sure ? ",@P2 D ^GETX,CASE I X="Y" K ^WORK($j,WX) S A1="" G N01
	G E09

	;Update individual time entry
U01	S ^WORK($j,WX)=CX_%_MX_%_A3_%_A4_%_A5_%_RX,WS=WS+1
	W /C(0,9),/EF,@P1 S A1=WX-6
U03	S A1=$O(^WORK($j,A1)) I A1=""!($Y>20) G I01:F1,L01
U04	S WK=^WORK($j,A1),CX=$P(WK,%,1),MX=$P(WK,%,2),A3=$P(WK,%,3),A4=$P(WK,%,4),A5=$P(WK,%,5),B1=$P($G(^SA(A3)),%,1)
	W @P1,A1,?9,CX,?16,MX,?22,A3,?25,B1,?53,A4,?61,A5,!
	G U03

L01	W /C(0,22),@P1,"Next, Select, Insert, Update or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) W @P1,"  Forget entire batch ? ",@P2 D ^GETX,CASE G XSEA:X="Y",L01
	I X="N" G N01
	I X="S"!(X="Z") G S01
	I X="I" G I01
	I X="U" G U11
	G L01

	;Update time records
U11	S WX="",T0=0,U1=^SZ("TU")
U20	S WX=$O(^WORK($j,WX)) I WX="" G U99
	S WK=^WORK($j,WX),CX=$P(WK,%,1),MX=$P(WK,%,2),W3=$P(WK,%,3),W4=$P(WK,%,4),W5=$P(WK,%,5),RX=$p(WK,%,6)
	S SR=^SR(RX,W3),S1=$P(SR,%,1),S2=$P(SR,%,2)
	S SW=$G(^SW(CX,MX,FX,W3)),T1=$P(SW,%,1),T2=$P(SW,%,2),T3=$P(SW,%,3)
	S W4=W4*U1,T9=$J(W4*S1/60+(W5*S2),0,2),T1=T1+W4,T2=T2+W5,T3=T3+T9,T0=T0+T9,^SW(CX,MX,FX,W3)=T1_%_T2_%_T3_%
	S SW=$G(^SW(CX,MX)),W1=$P(SW,%,1)+T9,(W2,%DAT)=$P(SW,%,2) D DMY2H^DATE
	S AY=%H,%DAT=A0 D DMY2H^DATE S:%H>AY W2=A0 S ^SW(CX,MX)=W1_%_W2_%
	;detailed time?
	I $g(^SZ("DTE"))="Y" S IX=$g(^TE)+1,^TE=IX,^TE(CX,MX,FX,IX)=A0_%_W3_%_W4_%_W5_%_T9
	G U20

U99	D YX^XSXS
	D UPAB^XSXS("N020",T0,A0,TT,"",D5)
	D UPAB^XSXS("N030",T0,A0,TT,"",D5)
	G XSEA

	;Next
N01	W /C(0,9),/EF,@P1 G U04:A1'="",U03

	;Amend
A01	W /C(0,16),/EF F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G N01:%J=1,A01
	G E09

	;Select
S01	W @P1,"  Select item ",@P2 D ^GETX S WX=+X I $G(^WORK($j,WX))="" G L01
	S WK=^WORK($j,WX),CX=$P(WK,%,1),MX=$P(WK,%,2),A3=$P(WK,%,3),A4=$P(WK,%,4),A5=$P(WK,%,5),RX=$p(WK,%,6)
	W /C(0,16),/EF F %J=1:1 D D^INPUT Q:X="END"!(X[%)
	G E09

	;Validation ----------------------------------------
	;Matter code
V01	Q:$D(ERR)  S SM=^SM(CX,X),M7=$P(SM,%,7),M7A=$p(M7,"/",1),M7B=$p(M7,"/",2)
	Q
	;Activity
V02	Q:$D(ERR)  I '$D(^SR(RX,X)) S ERR="Not defined for this charge group" Q
	S SR=^SR(RX,X),S1=$P(SR,%,1),S2=$P(SR,%,2),SA=^SA(X)
	Q
	;No of units
V03	S A5=""
	Q
	;No of items
V04	S A4=""
	Q

CASE	S X=$zconvert(X,"U") Q
