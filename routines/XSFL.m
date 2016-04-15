XSFL	;GRI,,,;08:39 AM  18 Jun 2004;
	;=======================================================
	; Virgo Accounts - Post CL Correction (one-sided CL entry)
	;
	; Copyright Graham R Irwin 1993-2004
	;
	; Screens:       1083
	; Files updated: ^CL ^SY
	; Subroutines:   X0^XSXS, ^INPASSW, ^INPUT, ^GETX, YX^XSXS
	;
	;=======================================================

	S H2="Client Ledger Correction",A4="Adjustment/correction",TT="CLR"
	D X0^XSXS W @P1
	D ^INPASSW I x'="WOZZAP" Q
	S %S=1083 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSFL Q
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX,CASE G XSFL:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	D YX^XSXS S ^SY(DAT,TT,YX)=DAT_%_CX_%_MX_%_%_A2_%_%_%_%_%_%_A5
	S ^CL(CX,MX,YX)=DAT_%_%_A2_%_TT_%_%_A5
	Q

	;Amend
A01	W /C(0,4),/EF F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSFL:%J=1,A01
	G E02

	;Validation - Matter
V02	Q:$D(ERR)  I '$D(^CL(CX,X)) S ERR="No ledger details for this matter" Q
	S CL=^CL(CX,X),E1=$j($p(CL,%,1),0,2)
	Q

CASE	S X=$zconvert(X,"U") Q
