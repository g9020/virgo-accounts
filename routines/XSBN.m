XSBN	;GRI,,,;07:51 PM  18 Aug 1998;
	;=======================================================
	; Virgo Accounts - Nominal to Disb Transfer
	;
	; Copyright Graham R Irwin 1998
	;
	; Screens:       1017, 1065, 1068
	; Files updated: ^SY ^ML ^AB ^AY
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, YX^XSXS,
	;                UPAB^XSXS, ^XSBF & ^XSBJ validation routines
	;
	;=======================================================

	S TT="N2D",F5="Nominal to Disb Transfer"
	D X0^XSXS
	W @P1,?8,"TRANSFER FROM (credit) -------------",!
	S %S=1065 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSBN Q
	S %S=1017 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSBN

	W @P1,!?8,"TRANSFER TO (debit) ----------------",!
	S %S=1068 F %J=1:1 D ^INPUT Q:X="END"!(X[%) 
	I X[% G XSBN

E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX,CASE G XSBN:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	D YX^XSXS S ^SY(DAT,TT,YX)=D1_%_"Acct:"_%_AX1_%_%_O2_%_%_CX_%_MX_%_%_%_O5
	S X1=$e(AX1,1),O3=O2
	I "LI"[X1 S O3=-O2
	;from NL account
	D UPAB^XSXS(AX1,-O3,D1,TT,"",O5)
	;to account
	D UPAB^XSXS("A120",O2,D1,TT,"",O5)
	S ^ML(CX,MX,YX)=D1_%_%_O2_%_TT_%_%_%_O5_%
	S ML=$g(^ML(CX,MX)),B1=$p(ML,%,1)+O2,B2=$p(ML,%,2,99),^ML(CX,MX)=B1_%_B2
	G XSBN

	;Amend
A01	W /C(0,5),/EF
	S %S=1065 F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSBN:%J=1,A01
	S %S=1017 F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G A01

	W @P1,!?8,"TRANSFER TO (debit) ----------------",!
	S %S=1068 F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G A01
	G E02

CASE	S X=$zconvert(X,"U") Q
