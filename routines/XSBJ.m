XSBJ	;GRI,,,;07:52 PM  18 Aug 1998
	;=======================================================
	; Virgo Accounts - Journal Transfer
	;
	; Copyright Graham R Irwin 1998
	;
	; Screens:       1017, 1052, 1065
	; Files updated: ^SY ^AB ^AY
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, YX^XSXS,
	;                UPAB^XSXS, ^XSBF validation routines
	;
	;=======================================================

	S TT="JRN",F5="Journal Transfer"
	D X0^XSXS
	W @P1,?8,"TRANSFER FROM (credit) -------------",!
	S %S=1065 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSBJ Q
	S %S=1017 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSBJ

	W @P1,!?8,"TRANSFER TO (debit) ----------------",!
	S %S=1052 F %J=1:1 D ^INPUT Q:X="END"!(X[%) 
	I X[% G XSBJ

E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX,CASE G XSBJ:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	D YX^XSXS S ^SY(DAT,TT,YX)=D1_%_"Acct:"_%_AX1_%_%_O2_%_%_"Acct:"_%_AX2_%_%_%_O5
	S X1=$e(AX1,1),X2=$e(AX2,1),O3=O2 
	I "AE"[X1,"LI"[X2 S O3=-O2
	I "LI"[X1 S (O2,O3)=-O2 I "AE"[X2 S O3=-O2
	;from NL account
	D UPAB^XSXS(AX1,-O2,D1,TT,"",O5)
	;to NL account
	D UPAB^XSXS(AX2,O3,D1,TT,"",O5)
	G XSBJ

	;Amend
A01	W /C(0,5),/EF
	S %S=1065 F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSBJ:%J=1,A01
	S %S=1017 F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G A01

	W @P1,!?8,"TRANSFER TO (debit) ----------------",!
	S %S=1052 F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G A01
	G E02

	;Validation - From account
V01	Q:$D(ERR)  S A3=$j($p(^AB(X),%,3),0,2)
	Q
	;To account
V03	Q:$D(ERR)  I X=AX1 S ERR="Cannot be the same account" Q
	S A3=$j($p(^AB(X),%,3),0,2)
	Q

CASE	S X=$zconvert(X,"U") Q
