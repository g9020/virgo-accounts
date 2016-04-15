XSX	;GRI,,,;09:40 AM  15 Apr 2002
	;=======================================================
	; Virgo Accounts - Main Menu
	;
	; Copyright Graham R Irwin 1993-2002
	;
	; Screens:       none
	; Files updated: ^WORK($j) ^WORK2($j) ^WORK3($j)
	; Subroutines:   ^INPASSW, ^XSINIT, ^DATE, ^Cont
	;
	;=======================================================

	; H0 is the Virgo licence number (which indentifies installed
	;	options and type of firm)
	; H1 is the Virgo Accounts descriptor
	; H2 is the program description (from the menu)
	; P1 to P5 are the screen colours
	; PGM is the program name
	; PU is a row of underscores
	; PX is the current sub-menu number
	; DAT is today's date (DD/MM/YYYY format)
	; TIM is the current time
	; CX is the default (or last used) client code
	; MX is the default (or last used) matter code

	W !!,"Virgo Accounts",!!,"Copyright Irwin Associates, 1998-2002",!

	;Check for password
	i $d(^Access) d ^INPASSW i X'=^Access h
XS0	D ^XSINIT

XSX1	S $ZT="ERROR^XSX" D ^DATE
	i $$volspace^%dos<102400 w !!,"Insufficient disk space - Unable to run Virgo Accounts.",*7,! s X=$$^Cont(0) h

	S H2="Main Menu",PX=0 D WRITE
A1	W /C(0,22),@P5,"Always Exit before switching off the computer"
	W /C(0,21),@P1,"Enter option no. (To Exit enter 0 or press Alt+F4) : ",/el D ^GETX S K=X
	I K=0!(K="****") K ^WORK($j),^WORK2($j),^WORK3($j) H
	i K="" w *7 G A1
	i K?1.2n G A2
	S H2="",PGM=K I $zrstatus(K)'="" D ^@K G XS0
	D CASE S PGM=K I $zrstatus(K)'="" D ^@K G XS0
A2	I '$d(^MENU(0,K)) W *7 G A1
	S Q=$g(^MENU(0,K,"IF")) I Q'="",@Q W *7 G A1
	S PX=$p(^MENU(0,K),%,2) G LEVL2

	;Sub-menu
LEVL2	K (%,P1,P2,P3,P4,P5,PU,PX,H0,H1,H2,PGM,DAT,TIM,CX,MX)
	S H2=$P(^MENU(PX),%,1) D ^DATE,WRITE
L2	W /C(0,21),"Enter option number : ",/el R K
	I K=""!(K[%) G XSX1
	I K'?1N.N G L2
	I '$d(^MENU(PX,K)) G L2
	S Q=$g(^MENU(PX,K,"IF")) I Q'="",@Q G L2
	S X=^MENU(PX,K),H2=$p(X,%,1),PGM=$p(X,%,2)
	D ^@PGM
	L  G LEVL2

	;Display menu options
WRITE	W @P4,#,$g(^MENU),?80-$L(H1)\2,H1,?70,DAT,!?80-$L(H2)\2,H2,?75,TIM,!!!
	S PY=""
W1	S PY=$o(^MENU(PX,PY)) I PY="" Q
	S X=^MENU(PX,PY),Q=$g(^MENU(PX,PY,"IF")) I Q'="",@Q G W1
	W ?10,@P5,PY,?15,@P1,$p(X,%,1),!
	G W1

CASE	S K=$zconvert(K,"U") Q

	;Error trap
ERROR	U 0 W @P5,*7,!,"*** An error has occurred during processing, please take a note of",!,"the following message and contact the Support Desk",!,$ZE,!,$ZERR," ",$ZENAME d ^%errlog
	R !!,"Press ENTER when ready",X G XSX1
