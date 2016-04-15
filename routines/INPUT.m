INPUT	;GRI;02:43 PM  10 Jun 2003
	;=======================================================
	; Simple Screen Input Routine
	;
	; Copyright Graham R Irwin 1993-99
	;
	; Files updated: none
	; Subroutines:   ^READX, ^GETX, ^NEWNAME, ^H2DMY^DATE,
	;                ^Cont, ^%video
	;
	;=======================================================

	;-------------------------------------------------------------------
	; Parameters:-
	;
	; %S1 - Prompt text	%S2 - Max length	%S3 - Min length
	; %S4 - Variable name	%S5 - Search file	%S6 - Default
	; %S7 - Validation      %S8 - Condition (optional)
	;-------------------------------------------------------------------

	S %I=0
IN1	S X=^SCREEN(%S,%J),%S1=$P(X,%,1),%S2=$P(X,%,2),%S3=$P(X,%,3),%S4=$P(X,%,4),%S5=$P(X,%,5),%S6=$P(X,%,6),%S7=$P(X,%,7,99) Q:X="END"
	S %S8=$g(^SCREEN(%S,%J,"IF")) I %S8'="",@%S8 S X="" Q
	I $e(%S1,1)="@" S %S1=$$^NEWNAME(%S1) ;check pseudonyms
	W @P1,?8,%S1,@P2,?25 S X1=$X,Y1=$Y ;display prompt
	;if it's not a display field show underscores ------
IN2	I %S2 W /C(X1,Y1),@P2,$E(PU,1,%S2)
	;if not amend mode show default --------------------
	I '%I,%S6'="" W /C(X1,Y1),@%S6
	;if it's a display field show the value ------------
	I '%S2,%S4'="" W /C(X1,Y1),@%S4 S X=@%S4 G IN7
	;if we're in amend mode show original value --------
	I %I W /C(X1,Y1),@%S4
	W /c(0,22),/el,@P1,"Esc - Quit; F1 - Help" W:%S5'="" "; F2 - Search" W:%I ?72,"[amend]"
	W /c(X1,Y1),@P2 K ERR D ^READX Q:X[%
	I X="?" D HELP G IN2
	I X="??" D SEARCH G IN2:X=""!(X[%) S @%S4=X W /C(X1,Y1),@P2,X,/ef G IN7
	I X="",%S6'="" S X=@%S6
	I $L(X)<%S3 S ERR="Min length is "_%S3 G ERR
IN7	I %S7'="" X %S7
	S X2=$y,Y2=$y W /C(X1,Y1),@P2,X I X2*80+Y2>($x*80+$y) W /C(X2,Y2)
	I $g(ERR)="" S @%S4=X W ! Q
ERR	W /C(0,23),*7,@P3,"Invalid input - ",ERR,/EF W @P2 G IN2

	;Amend mode
A	S %I=1 G IN1

	;Display mode
D	S X=^SCREEN(%S,%J) Q:X="END"  S %S1=$P(X,%,1),%S4=$P(X,%,4),%S5=$P(X,%,5),%S7=$P(X,%,7,99),X=@%S4
	S %S8=$g(^SCREEN(%S,%J,"IF")) I %S8'="",@%S8 S X="" Q
	I $e(%S1,1)="@" S %S1=$$^NEWNAME(%S1)
	W @P1,?8,%S1,@P2,?25,@%S4
	I %S5'="",%S7'="" X %S7
	W ! Q

	;Help routine
HELP	W @P5,/C(69,23),PGM,"/",%S4
	d uwo^%video(8,16)
	S %K="",%H1=PGM,%H2=%S4
	I '$d(^HELP(%H1,%H2)) S %H1=$e(PGM,1,2)
	I '$d(^HELP(%H1,%H2)) S %H2=0
H01	W #
H02	S %K=$o(^HELP(%H1,%H2,%K)) I %K="" w /c(0,13) s %X=$$^Cont(0) G QHLP
	W ^(%K),! I $y<13 G H02
	w /c(0,13) s %X=$$^Cont(1) w @P5 i %X=27 g QHLP
	G H01
QHLP	d uwc^%video()
	q

	;Search routine
SEARCH	S X="" I %S5="" Q
	I '$d(^SEARCH(%S5)) Q
	S %K=$g(^SEARCH(%S5)) I %K'="" X %K Q
	d uwo^%video(6,18)
	W #,@P1,/EF,"Search for " R %X,!! S %X=$zconvert(%X,"L"),%K=1,S3="",S2=%X
S01	S S2=$o(^SEARCH(%S5,S2)) I S2=""!(%X'=$e(S2,1,$l(%X))) G S03
S02	S S3=$o(^SEARCH(%S5,S2,S3)) I S3="" G S01
	W %K,?10,S2,?45,S3,! S SS(%K)=S3,%K=%K+1 I $Y>13 G S03
	G S02

S03	i '$d(SS) g QSCH
	W /c(0,15),"Select an entry " D ^GETX I X[% G QSCH
	I X,$g(SS(X))="" G S03
	I 'X G QSCH:S2=""!(%X'=$e(S2,1,$l(%X))) W # K SS G S02
	S X=SS(X)
QSCH	K S2,S3,%X,SS
	d uwc^%video()
	Q

	;Validation Routines --------------------------------

DATE	I X?1"-".N!(X?1"+".N) S %H=$H+X D H2DMY^DATE S X=%DAT
	I X?6N S X=$e(X,1,2)_"/"_$e(X,3,4)_"/"_$e(X,5,6)
	S X=$tr(X,".-","//")
	S ERR="Invalid date" I X'?1.2N1"/"1.2N1"/"1.4N,X'?1.2N1"/"1.2N Q
	S %D=+X,%M=$P(X,"/",2),%Y=$P(X,"/",3) I '%M!(%M>12)!'%D Q
	I %Y="" S %Y=$P(DAT,"/",3)
	S %P=31_(%Y#4=0+28)_"31303130313130313031" I %D>$E(%P,%M+%M-1,%M+%M) Q
	S:$L(%D)=1 %D=0_%D S:$L(%M)=1 %M=0_%M S:%Y<80 %Y=2000+%Y S:%Y<100 %Y=1900+%Y S X=%D_"/"_%M_"/"_%Y K ERR,%D,%M,%Y,%P Q

TIME	S ERR="Invalid time",%H=+X S:X[":" %M=$P(X,":",2) I X>24!(%M>59) K %M,%H Q
	K ERR,%M,%H Q

EXIST	I '$D(@("^"_%S5_"(X)")) S ERR="Does not exist"
	Q

EXDISP	I '$D(@("^"_%S5_"(X)")) S ERR="Does not exist" Q
	W ?48,$p(^(X),%,1),/ef Q

NOTEX	I $D(@("^"_%S5_"(X)")) S ERR="Already exists"
	Q

YESNO	D CASE I "YN"'[X S ERR="Must be 'Y' or 'N'"
	Q

AMOUNT	I $e(X,1)="-" S ERR="May not be negative" Q
	I X'?1.7N,X'?.7N1"."1.2N S ERR="Amount required" Q
	I X'="*" S X=$J(X,0,2)
	Q

AMOUNTN	I X'?1.N,X'?1"-"1.N,X'?.7N1"."1.2N,X'?1"-".7N1"."1.2N S ERR="Amount required" Q
	I X'="*" S X=$J(X,0,2)
	Q

NUMBER	I X'?.N S ERR="Must be a number"
	Q

ALPHNUM	I X'?.AN S ERR="Must be alphanumeric"
	Q

CASE	S X=$zconvert(X,"U") Q
