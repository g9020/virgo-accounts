XSGJ	;GRI,,,;03:07 PM  20 Nov 2001
	;=======================================================
	; Virgo Accounts - Post Correction (one-sided NL entry)
	;
	; Copyright Graham R Irwin 1993-1994
	;
	; Screens:       1019
	; Files updated: ^AB ^AY ^SY
	; Subroutines:   X0^XSXS, ^INPASSW, ^INPUT, ^GETX, YX^XSXS
	;
	;=======================================================

	S TT="ADJ",H2="Post Correction",A4="Adjustment/correction"
	D X0^XSXS W @P1
	D ^INPASSW I x'="ELECTRA" Q
	S %S=1019 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSGJ Q
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX,CASE G XSGJ:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	D YX^XSXS S ^SY(DAT,TT,YX)=DAT_%_"Acct:"_%_AX_%_%_A2_%_%_%_%_%_%_A5
	S T1=A2 D UPAB
	Q

	;Amend
A01	W /C(0,4),/EF F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSGJ:%J=1,A01
	G E02

	;Validation - Period/year
V02	I "PYBL"'[X S ERR="Must be 'P' 'Y' 'B' or 'L'"
	Q
	;Account code
V03	Q:$D(ERR)  S A0=$j($p(^AB(X),%,3),0,2)
	Q

UPAB	S AB=^AB(AX),AB1=$p(AB,%,1),AB2=$p(AB,%,2),AB3=$p(AB,%,3),AB4=$p(AB,%,4),AB5=$p(AB,%,5,99) S:"PB"[A3 AB2=AB2+T1 S:"YB"[A3 AB3=AB3+T1 S:A3="L" AB4=AB4+T1 S ^AB(AX)=AB1_%_AB2_%_AB3_%_AB4_%_AB5
	S S1=T1 I A3="L" S S1=0,A5=A5_": last yr adj = "_T1
	S ^AY(AX,YX)=DAT_%_S1_%_TT_%_%_A5
	Q

CASE	S X=$zconvert(X,"U") Q
