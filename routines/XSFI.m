XSFI	;GRI,,,;02:28 PM  3 Nov 1994
	;=======================================================
	; Virgo Accounts - Maintain Client Interest Bands
	;
	; Copyright Graham R Irwin 1993-1994
	;
	; Screens:       1034
	; Files updated: ^CN
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX
	;
	;=======================================================

	D X0^XSXS S %S=1034
	W @P1,!?18,"Min Amount",?35,"No of Days",!! S NX=""
E03	S NX=$O(^CN(NX)) I NX=""!($Y>20) G L01
E04	S A1=^CN(NX) W @P1,?20,NX,?40,A1,! G E03
L01	W /C(0,22),@P1,"Next, Select, Insert or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) Q
	I X="N" G N01
	I X="S"!(X="Z") G S01
	I X="I" G I01
	G L01

	;Insert
I01	W /C(0,18),/EF F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSFI

E09	W /C(0,22),@P1,"Update, Amend, Delete or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX D CASE G XSFI:X="Y",E09
	I X="A" G A01
	I X="U" G U01
	I X="D" W @P1,"  Are you sure ? ",@P2 D ^GETX D CASE I X="Y" K ^CN(NX) S NX="" G N01
	G E09

	;Update
U01	S ^CN(NX)=A1 W /C(0,7),/EF,@P1 S NX="" G E03

	;Next
N01	W /C(0,7),/EF,@P1 G E04:NX'="",E03

	;Amend
A01	W /C(0,18),/EF S %J=1 D D^INPUT
	F %J=2:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSFI:%J=2,A01
	G E09

	;Select
S01	W @P1,"  Amount ",@P2 D ^GETX S NX=+X I $G(^CN(NX))="" G L01
	S A1=^CN(NX)
	W /C(0,18),/EF F %J=1:1 D D^INPUT Q:X="END"!(X[%)
	G E09

CASE	S X=$zconvert(X,"U") Q
