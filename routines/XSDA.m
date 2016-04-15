XSDA	;GRI,,,;09:08 AM  18 Jan 2002
	;=======================================================
	; Virgo Accounts - Draft Bill
	;
	; Copyright Graham R Irwin 1993-2002
	;
	; Screens:       1016
	; Files updated: selected DOS file (.txt extension)
	; Subroutines:   X0^XSXS, HEAD^XSXS, END^XSXS,
	;                ^INPUT, ^OUTPUT, ^DOSDEV
	;
	;=======================================================

	D X0^XSXS S PEE="P"
	S %S=1016 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSDA Q
	;get client details
	S SC=^SC(CX),C1=$P(SC,%,1),C7=$P(SC,%,2),C8=$P(SC,%,3)
	S SCA=^SC(CX,"A"),C2=$P(SCA,%,1),C3=$P(SCA,%,2),C4=$P(SCA,%,3),C5=$P(SCA,%,4),C6=$P(SCA,%,5)
	S SCN=^SC(CX,"N"),C9=$P(SCN,%,1),C10=$P(SCN,%,2),C11=$P(SCN,%,3)
	;get matter details
	S SM=^SM(CX,MX),M1=$P(SM,%,1),M2=$P(SM,%,2),M3=$P(SM,%,3),M4=$P(SM,%,4),M5=$P(SM,%,5),M6=$P(SM,%,6),M7=$P(SM,%,7),M8=$P(SM,%,8),M9=$P(SM,%,9),M10=$P(SM,%,10),M14=$p(SM,%,11)
	S SMN=^SM(CX,MX,"N"),M11=$P(SMN,%,1),M12=$P(SMN,%,2),M13=$P(SMN,%,3)
	I PW="P" D ^OUTPUT G:%OP[% XSDA S N=99,P=1 D HEAD^XSXS
	I PW'="P" D ^DOSDEV G:X[% XSDA S N=0
	W "Ref ",CX," ",MX,"  ",M1,!!,C1,!,C2,!,C3,!,C4,!,C5,!,C6,!!!
	I $e(H0,1)'="X" W "Client Account ",$j($g(^CL(CX,MX)),10,2),! S N=N+1
	W "Unpaid Bills   ",$j($p($g(^ML(CX,MX)),%,2),10,2),!
	I +M14'=0 W "Budget (time+disbursements) ",M14,! S N=N+1

	;Time section
	W !!,"Time:",!,?35,"Hours",?45,"Items" S FX="",(T1,T2,T3)=0,N=N+15
W01	S FX=$O(^SW(CX,MX,FX)) I FX="" G D00
	S X3="" W !,$p($g(^SF(FX)),%,1),!! S N=N+3
W03	S X3=$O(^SW(CX,MX,FX,X3)) I X3="" G W01
	S SW=^SW(CX,MX,FX,X3),W1=$P(SW,%,1),W2=$P(SW,%,2),W3=$P(SW,%,3),S1=$G(^SA(X3)),T0=W1 D TCON
	W X3,?5,S1 W:W1 ?39-$L(T0),T0 W:W2 ?45,$J(W2,5,0) W ?53,$J(W3,10,2),! S N=N+1 I PW="P",N>56 D HEAD^XSXS
	S T1=T1+W1,T2=T2+W2,T3=T3+W3 G W03
D00	S T0=T1 D TCON W !,"Total time",?39-$L(T0),T0,?45,$J(T2,5,0),?53,$J(T3,10,2)

	;Disbursements section
	W !!,"Disbursements:",!! S X3="",T1=0,N=N+5
D01	S X3=$O(^ML(CX,MX,X3)) I X3="" G E00
	S ML=^ML(CX,MX,X3),D1=$P(ML,%,1),D2=$P(ML,%,2),D3=$P(ML,%,3),D4=$P(ML,%,4),D7=$P(ML,%,7)
	I "DIS,DSW,DSP,DSA,TOC,COD,OMT,N2D"'[D4 G D01
	I "DSW,DSP,DSA,COD"[D4 S D3=-D2
	I "OMT"=D4,D3="" S D3=-D2
	S T1=T1+D3
	W D1,?12,$e(D7,1,40),?53,$J(D3,10,2),! S N=N+1 I PW="P",N>56 D HEAD^XSXS
	G D01
E00	W !,"Total disbursements",?53,$J(T1,10,2),!!,"Total time and disbursements",?53,$j((T1+T3),10,2),!!,"Matter is VATable ? "
	W:M6="N" "No" W:M6="Y" "Yes" W !

	I PW="P" D END^XSXS
	E  C 10 U 0
	G XSDA

TCON	S A=T0\60_":",T0=T0#60 S:T0<10 T0=0_T0 S T0=A_T0 Q

	;Validation - Print or WP
V01	S X=$zconvert(X,"U") I "PW"'[X S ERR="Must be 'P' or 'W'"
	Q
