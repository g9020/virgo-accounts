XSAB	;GRI,,,;07:10 PM  12 Apr 2002
	;=======================================================
	; Virgo Accounts - Matter Maintenance
	;
	; Copyright Graham R Irwin 1993-2002
	;
	; Screens:	 1001 1021
	; Files updated: ^SM FILES.TXT
	;     (^SM ^SD ^ML ^CL ^SW ^TE killed if matter deleted)
	; Subroutines:	 X0^XSXS, ^INPUT, ^GETX
	;
	;=======================================================
 
	D X0^XSXS
	L ^SM
	S YES="Y",NO="N",M10="",NEW=0,DCG=$g(^SZ("DCG"))
 
	;Get client and matters codes
E01	S %S=1021 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSAB Q
	S %S=1001
	I $D(^SM(CX,MX)) G D01
 
	;Input
	W /C(48,5),"* NEW RECORD *",! S NEW=1
	F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSAB
 
	;Option prompt
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX,CASE G XSAB:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02
 
	;Update
U01	S ^SM(CX,MX)=M1_%_M2_%_M3_%_M4_%_M5_%_M6_%_RX_"/"_M7B_%_M8_%_M9_%_M10_%_M14
	S ^SM(CX,MX,"N")=M11_%_M12_%_M13_%
	I SMO1'="" S ^SM(CX,MX,"O")=SMO1
	I NEW,$e(H0,5)="4" D AAOUT
	G XSAB
 
	;Display
D01	S SM=^SM(CX,MX),M1=$P(SM,%,1),M2=$P(SM,%,2),M3=$P(SM,%,3),M4=$P(SM,%,4),M5=$P(SM,%,5),M6=$P(SM,%,6),M7=$P(SM,%,7),M8=$P(SM,%,8),M9=$P(SM,%,9),M10=$P(SM,%,10),M14=$P(SM,%,11),RX=$p(M7,"/",1),M7B=$p(M7,"/",2)
	S SMN=^SM(CX,MX,"N"),M11=$P(SMN,%,1),M12=$P(SMN,%,2),M13=$P(SMN,%,3)
	S SMO1=$g(^SM(CX,MX,"O"))
	S DEL=1,AMD=0
	S A1=$g(^ML(CX,MX)),A2=$g(^CL(CX,MX)),A3=$g(^SW(CX,MX))
	I $p(A1,%,1)!$p(A1,%,2)!$p(A2,%,1)!$p(A2,%,2)!A3 S DEL=0
D02	F %J=1:1 D D^INPUT Q:X="END"
 
	;Option prompt
D03	W /C(0,22),@P1,"Amend" W:DEL ", Delete, Remove" W " or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) G XSAB:'AMD W @P1,"  Quit without update ? ",@P2 D ^GETX,CASE G XSAB:X="Y",D03
	I X="A" G A01
	I X="D",DEL W @P1,"  Are you sure ? ",@P2 D ^GETX,CASE I X="Y" K ^SM(CX,MX) D REM G XSAB
	I X="R"!(X="Z"),DEL W @P1,"  Remove transactions ? ",@P2 D ^GETX,CASE I X="Y" D REM G XSAB
	G D03
 
	;Amend
A01	S AMD=1 W /C(0,6),/EF F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSAB:%J=1,A01
	G E02

	;Remove all transactions
REM	K ^ML(CX,MX),^CL(CX,MX),^SW(CX,MX),^TE(CX,MX),^SD(CX,MX)
	Q
 
	;Validation ------------------------------------------
	;Client ledger cashbook
V01	I $D(ERR) Q
	I X<100 S ERR="Must be a client cashbook" Q
	S CB=^CB(X),CBA4=$p(CB,%,4),CLB1=+$g(^CL(CX,MX))
	I CBA4'=M5 S ERR="Client cashbook must be same status as matter" Q
	I %I,X'=M10,CLB1'=0 S ERR="C/L balance is not zero" W /C(0,22),@P1,"C/L balance is not zero - Are you sure ? ",/EL,@P2 R Y S Y=$zconvert(Y,"U") Q:Y'="YESSIR"  K ERR
	Q
	;Trust matter
V02	I %I,M5'=X,$D(^CL(CX,MX)) S ERR="Client account exists, cannot amend" Q
	S Q10=100 S:X="Y" Q10=101
	Q
	;Matter code
V03	I X="*" K ERR D AUTONUM Q
	I X=0 S ERR="Cannot be zero" Q
	Q

	;Auto numbering
AUTONUM	S G1=0,G2=""
ANEXT	S G2=$o(^SM(CX,G2)) I G2="" G AEND
	I G2>G1 S G1=+G2
	G ANEXT
AEND	S X=G1+1
	Q

CASE	S X=$zconvert(X,"U") Q

	;Create record for Amicus
AAOUT	O 10:(file="files.txt":mode="a") u 10
	S p2=$c(9)
	S SCA=^SC(CX),SCA1=$p(SCA,%,1),SCA2=$p(SCA,%,2),SCA3=$p(SCA,%,3)
	S SCB=$tr(^SC(CX,"A"),%," "),SCC=$tr(^SC(CX,"N"),%," ")
	W CX,p2,MX,p2,SCA1,p2,M1,p2,SMO1,p2,p2,SCA1,p2,SCB,p2,SCA2,p2,SCA3,p2,SCC,!
	c 10 q
