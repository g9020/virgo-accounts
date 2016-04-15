XSBL	;GRI,,,;04:26 PM  4 Nov 1994
	;=======================================================
	; Virgo Accounts - Matter Transfer
	;
	; Copyright Graham R Irwin 1993-94
	;
	; Screens:       1054, 1055
	; Files updated: ^ML ^SW
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, YX^XSXS
	;
	;=======================================================

	S E5="Matter Transfer",TT="OMT"
	D X0^XSXS
	W @P1,?8,"TRANSFER FROM ----------------------",!
	S %S=1054 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSBL Q
	W @P1,!?8,"TRANSFER TO ------------------------",!
	S %S=1055 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSBL
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX D CASE G XSBL:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update...
U01	D YX^XSXS S ^SY(DAT,TT,YX)=D1_%_CX1_%_MX1_%_%_A1_%_%_CX2_%_MX2_%_%_%_D5
	;...from matter ledger
	S ^ML(CX1,MX1,YX)=D1_%_A1_%_%_TT_%_%_%_D5_%
	S ML=$g(^ML(CX1,MX1)),B1=$p(ML,%,1)-A1,B2=$p(ML,%,2,99),^ML(CX1,MX1)=B1_%_B2
	;...to matter ledger
	S ^ML(CX2,MX2,YX)=D1_%_%_A1_%_TT_%_%_%_D5_%
	S ML=$g(^ML(CX2,MX2)),B1=$p(ML,%,1)+A1,B2=$p(ML,%,2,99),^ML(CX2,MX2)=B1_%_B2
	;...from WIP
	S SW=$g(^SW(CX1,MX1,1,"G")),T1=$p(SW,%,1),T2=$p(SW,%,2),T3=$p(SW,%,3)-A2,^SW(CX1,MX1,1,"G")=T1_%_T2_%_T3_%
	S SW=$g(^SW(CX1,MX1)),W1=$p(SW,%,1)-A2,W2=$p(SW,%,2),^SW(CX1,MX1)=W1_%_W2_%
	;...to WIP
	S SW=$g(^SW(CX2,MX2,1,"G")),T1=$p(SW,%,1),T2=$p(SW,%,2),T3=$p(SW,%,3)+A2,^SW(CX2,MX2,1,"G")=T1_%_T2_%_T3_%
	S SW=$g(^SW(CX2,MX2)),W1=$p(SW,%,1)+A2,W2=$p(SW,%,2),^SW(CX2,MX2)=W1_%_W2_%
	G XSBL

	;Amend
A01	W /C(0,5),/EF S %S=1054 F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSBL:%J=1,A01
	W @P1,!?8,"TRANSFER TO ------------------------",!
	S %S=1055 F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G A01
	G E02

	;Validation - From matter code
V01	Q:$D(ERR)  S ML1=$g(^ML(CX1,X)),M1=$j($p(ML1,%,1),0,2),SW1=$g(^SW(CX1,X)),S1=$j($p(SW1,%,1),0,2)
	Q
	;Disbursements
V02	I X>M1 S ERR="Cannot exceed disb balance"
	Q
	;Work-in-progress
V03	I X>S1 S ERR="Cannot exceed WIP balance"
	Q
	;To matter code
V04	Q:$D(ERR)
	I CX1=CX2,MX1=X S ERR="Cannot be the same matter"
	Q

CASE	S X=$zconvert(X,"U") Q
