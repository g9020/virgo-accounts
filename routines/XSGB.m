XSGB	;GRI,,,;10:09 AM  16 Mar 1999
	;=======================================================
	; Virgo Accounts - Maintain Fee Earners
	;
	; Copyright Graham R Irwin 1993-99
	;
	; Screens:       1037
	; Files updated: ^SF ^SEARCH
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX
	;
	;=======================================================

	D X0^XSXS
	L ^SF
	S %J=1,%S=1037 D ^INPUT Q:X[%  I $D(^SF(X)) G D01
	W /C(48,4),"* NEW RECORD *",!
	F %J=2:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSGB
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX D CASE G XSGB:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	S ^SF(FX)=F1_%
	S F1L=$zconvert(F1,"L"),^SEARCH("SF",F1L,FX)=""
	I $d(F1X) S F1XL=$zconvert(F1X,"L") I F1L'=F1XL K ^SEARCH("SF",F1XL,FX)

	G XSGB

	;Display
D01	S SF=^SF(X),F1=$P(SF,%,1),F1X=F1,DEL=1,AMD=0 S:X=1 DEL=0
D02	F %J=2:1 D D^INPUT Q:X="END"
D03	W /C(0,22),@P1,"Amend" W:DEL ", Delete" W " or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) G XSGB:'AMD W @P1,"  Quit without update ? ",@P2 D ^GETX D CASE G XSGB:X="Y",D03
	I X="A" G A01
	I X="D",DEL W @P1,"  Are you sure ? ",@P2 D ^GETX D CASE I X="Y" K ^SF(FX),^SEARCH("SF",$zconvert(F1,"L"),FX) G XSGB
	G D03

	;Amend
A01	S AMD=1 W /C(0,5),/EF F %J=2:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSGB:%J=2,A01
	G E02

CASE	S X=$zconvert(X,"U") Q
