OUTPUT ;GRI,,,;12:52 PM  5 Jun 2007
	;=======================================================
	; Routine to select print device
	;
	; Copyright Graham R Irwin 1993-2003
	;
	; Screens:       none
	; Files updated: ^WRITE
	; Subroutines:   ^printstat, ^GETX, ^Cont
	;
	;=======================================================

E01	S X=^SYS("PTR"),FN=$p(X,%,1)
	K ^WRITE($j)
	W /C(0,22),@P1,"Ready to print to ",FN," ? (Press F1 for Help) ",/EF,@P2
	D ^GETX,CASE
	I X="?" D HELP G E01
	I X="N"!(X[%) S %OP=% Q
	I $e(X,1,2)="F:" G F01
	I X="SPOOL"!(X="SP") G S01
	I X="WB"!(X="Y"&(FN="WB")) G W01
	I X?3A1N,"LPT1;LPT2;LPT3;LPT4"[X S FN=X G E09
	I X'="Y" G E01

	;Check parallel port
E09	S X=$$^printstat(FN) I X["Printer-Selected",X["Ready" G F02
	U 0 W @P1,/c(0,23),*7,"Printer Not Ready "
	;s x=$$^Cont(1) w @P1 i x=27 S %OP=% Q
	W "- [R]etry, [I]gnore or [A]bort? " D ^GETX,CASE I X="A"!(X[%) S %OP=% Q
	I X="I" G F02
	G E09

	;Open spooler
S01	S %OP=20 O %OP U %OP
	Q

	;Write to web browser
W01	S FN=$g(^SYS("WBD"),"c:\docume~1\alluse~1\desktop\")_"virgo000.htm"
	S ^WRITE($j)="WB"
	G F02

	;Write to file
F01	S FN=$e(X,3,99) I FN'?1.8an G E01
	S FN=$g(^SYS("WTF"))_FN_".txt"

	;Open device
F02	S %OP=10 O %OP:(file=FN:mode="w") U %OP
	Q

	;Help routine
HELP	W @P5
	d uwo^%video(8,16)
	S %K="",%H1="R2PRINT",%H2=1
	I '$d(^HELP(%H1,%H2)) S %H1=$e(PGM,1,2)
	I '$d(^HELP(%H1,%H2)) S %H2=0
H01	W #
H02	S %K=$o(^HELP(%H1,%H2,%K)) I %K="" w /c(0,13) s %X=$$^Cont(0) G QHLP
	W ^(%K),! I $y<13 G H02
	w /c(0,13) s %X=$$^Cont(1) w @P5 i %X=27 g QHLP
	G H01
QHLP	d uwc^%video()
	q

CASE	S X=$zconvert(X,"U") Q
