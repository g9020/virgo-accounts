XSINIT	;GRI,,,;03:35 PM  4 Jan 1999
	;=======================================================
	; Virgo Accounts - Initialisation
	;
	; Copyright Graham R Irwin 1998
	;
	; Screens:       none
	; Files updated: ^SYS("COL")
	; Subroutines:   ^XSINSTAL, AUTO^XSAF, AUTO^XSHC
	;
	;=======================================================

	D V

	;if no parameters do install
	I '$D(^SZ) D ^XSINSTAL

	;if day-end was not run yesterday do it now
	I $g(^SZ("ADE"))'="N",+$H-^SZ("LDE")>1 D EOD

	;check and run auto matter limits report
	I $d(^SZ("MLR")) S X=^SZ("MLR"),A1=$p(X,%,1),A4=$p(X,%,4) I A1="Y",A4<+$H D AUTO^XSAF

	;check if year-end has been run
	I $d(^SZ("NYE")),^SZ("NYE")<$h W !!,@P3,"Year-end Processing has not yet been run",!!,"Press any key to continue " R *X R:'X *X
	Q

	;Initialise variables
V	S $zp="^",%=$zp,(CX,MX)="",PU="" F J=1:1:80 S PU=PU_"_"
	I '$D(^SYS("COL")) S ^SYS("COL")=7_%_7_%_7_%_7_%_7
	S X=^SYS("COL"),P1=$p(X,%,1),P2=$p(X,%,2),P3=$p(X,%,3),P4=$p(X,%,4),P5=$p(X,%,5),p=+$p(X,%,6),j="/color(",k=","_p_")",P1=j_P1_k,P2=j_P2_k,P3=j_P3_k,P4=j_P4_k,P5=j_P5_k
	S H0=$g(^SZ("SW")),H1="Virgo Accounts"
	W @P1,#
	Q

EOD	D AUTO^XSHC I $G(%OP)=% H
	Q
