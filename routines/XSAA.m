XSAA	;GRI,,,;09:41 AM  15 Apr 2002
	;=======================================================
	; Virgo Accounts - Maintain Client Details
	;
	; Copyright Graham R Irwin 1993-2002
	;
	; Screens:       1000
	; Files updated: ^SC ^SEARCH
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX
	;
	;=======================================================

	D X0^XSXS
	L ^SC
	S %S=1000,%J=1 D ^INPUT Q:X[%
	I $D(^SC(X)) G D01
	W /C(48,4),"* NEW RECORD *",!
	F %J=2:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSAA
E02	W /C(0,22),@P1,"Update, Matter, Amend or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX,CASE G XSAA:X="Y",E02
	I X="A" G A01
	I X="U" D U01 G XSAA
	I X="M"!(X="Z") S PGM="XSAB",H2="Maintain Matter Details" D U01 G ^XSAB
	G E02

	;Update
U01	S ^SC(CX)=C1_%_C7_%_C8_%
	S ^SC(CX,"A")=C2_%_C3_%_C4_%_C5_%_C6_%
	S ^SC(CX,"N")=C9_%_C10_%_C11_%
	S C1L=$zconvert(C1,"L"),^SEARCH("SC",C1L,CX)=""
	I $d(C1X) S C1XL=$zconvert(C1X,"L") I C1L'=C1XL K ^SEARCH("SC",C1XL,CX)
	Q

	;Display
D01	S SC=^SC(X),C1=$P(SC,%,1),C7=$P(SC,%,2),C8=$P(SC,%,3)
	S SCA=^SC(X,"A"),C2=$P(SCA,%,1),C3=$P(SCA,%,2),C4=$P(SCA,%,3),C5=$P(SCA,%,4),C6=$P(SCA,%,5)
	S SCN=^SC(X,"N"),C9=$P(SCN,%,1),C10=$P(SCN,%,2),C11=$P(SCN,%,3)
	S C1X=C1,DEL='$D(^SM(CX)),AMD=0
D02	F %J=2:1 D D^INPUT Q:X="END"
D03	W /C(0,22),@P1,"Amend" W:DEL ", Delete" W " or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) G XSAA:'AMD W @P1,"  Quit without update ? ",@P2 D ^GETX,CASE G XSAA:X="Y",D03
	I X="A" G A01
	I X="D",DEL W @P1,"  Are you sure ? ",@P2 D ^GETX D CASE I X="Y" K ^SC(CX),^SEARCH("SC",$zconvert(C1,"L"),CX) G XSAA
	G D03

	;Amend
A01	S AMD=1 W /C(0,5),/EF F %J=2:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSAA:%J=2,A01
	G E02

QUIT	Q

	;Validation -----------------------------------
	;Client code
V01	I X["*" D AUTONUM
	I X'?.UN S ERR="Must be alpha-numeric"
	Q

AUTONUM	S (G0,G1)=$p(X,"*",1),G2=0
ANEXT	S G1=$o(^SC(G1)) I G1="" G AEND
	S G3=$p(G1,G0,2,9) S:G0="" G3=G1 I G3>G2 S G2=G3
	G ANEXT
AEND	S X=G0_(G2+1)
	Q

CASE	S X=$zconvert(X,"U") Q
