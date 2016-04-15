XSEB	;GRI,,,;02:24 PM  3 Nov 1994
	;=======================================================
	; Virgo Accounts - Write Off Time
	;
	; Copyright Graham R Irwin 1993-1994
	;
	; Screens:       1023
	; Files updated: ^SW ^AB ^AY
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, YX^XSXS, UPAB^XSXS
	;
	;=======================================================

	S TT="TWO",D5="Time write-off"
	D X0^XSXS
	S %S=1023 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSEB Q
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX D CASE G XSEB:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	S SW=$G(^SW(CX,MX,1,"Z!")),T1=$P(SW,%,1),T2=$P(SW,%,2),T3=$P(SW,%,3)-D1,^SW(CX,MX,1,"Z!")=T1_%_T2_%_T3_%
	S ^SW(CX,MX)=(W1-D1)_%_W2_%
	D YX^XSXS
	D UPAB^XSXS("N020",-D1,DAT,TT,"",D5)
	D UPAB^XSXS("N050",D1,DAT,TT,"",D5)
	G XSEB

	;Amend
A01	W /C(0,4),/EF F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSEB:%J=1,A01
	G E02

	;Validation - Amount
V01	Q:$D(ERR)  S SW=$G(^SW(CX,MX)),W1=$P(SW,%,1),W2=$P(SW,%,2)
	I X>W1 S ERR="Cannot have negative W-I-P"
	Q

CASE	S X=$zconvert(X,"U") Q
