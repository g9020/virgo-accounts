XSAD	;GRI,,,;12:49 PM  10 Jun 2002
	;=======================================================
	; Virgo Accounts - Client/Matter Enquiry
	;
	; Copyright Graham R Irwin 1993-99
	;
	; Screens:	 1000, 1001, 1003, 1031
	; Files updated: none
	; Subroutines:	 X0^XSXS, ^INPUT, ^GETX, ^OUTPUT, 
	;                HEAD^XSXS, END^XSXS, ^NEWNAME
	;
	;=======================================================

	D X0^XSXS S A1=""
	S %S=1003 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSAD Q

	I CX="*" G P01

	D GETC
	;Display client details
	W /C(0,4) S %S=1000 F %J=1:1 D D^INPUT Q:X="END"
E01	W /C(0,22),@P1,"Matters, Print or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="M"!(X="Z") G M01
	I X="P" G P40
	I X="Q"!(X=%) G XSAD
	G E01

	;Display matters
M01 	D S^XSXS G XSAD:X[%,N02:'X S MX=X
M02	D GETM W @P1,/C(0,6),/EF S %S=1001 F %J=1:1 D D^INPUT Q:X="END"
M03	W /C(0,22),@P1,"Next, Print or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="N" G N01
	I X="P" G P50
	I X="Q"!(X=%) G XSAD
	G M03

	;Next
N01	S MX=$O(^SM(CX,MX)) I MX'="" G M02
N02	W /C(0,22),@P1,"No More Matters. Press any key to continue ",/EL R *X R:'X *X G XSAD

	;Print all (ask detail/summary)
P01	S %S=1031 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G XSAD
	I A2="Y" W !?8,"WARNING: This could be a long report. You are advised to print it",!?8,"to the Spooler or to a File - if unsure please refer to the manual",!?8,"for details.",!
	D ^OUTPUT G:%OP[% XSAD S N=99,P=1,(CX,MX)=""
	I A2="N" G P10
	;print all in detail
P07	S CX=$O(^SC(CX)) I CX="" G END
	D CLINE S MX="" I N>55 D HEAD^XSXS
	I '$d(^SM(CX)) W "No Matters for this Client",!! S N=N+2 G P07
	W "List of Matters for this Client:",!! S N=N+2
P08	S MX=$O(^SM(CX,MX)) I MX="" G P07
	D MLINE
	G P08

	;Print all in summary
P10	S CX=$o(^SC(CX)) I CX="" G END
	D GETC
	I N>58 D HEAD^XSXS
	W !,"Client ",CX,?12,C1,?50,"----------",!! S N=N+3
	I '$d(^SM(CX)) W " No matters for this client",!! S N=N+2 I N>58 D HEAD^XSXS
P11	S MX=$o(^SM(CX,MX)) I MX="" G P10
	D GETM
	I A1="OPEN",$d(^SM(CX,MX,"C")) G P11
	W " Matter ",MX,?13,M1,!! S N=N+2 I N>58 D HEAD^XSXS
	G P11

	;Print a single client and its matters
P40	D ^OUTPUT G:%OP[% XSAD S N=99,P=1
	D CLINE S MX="" I N>55 D HEAD^XSXS
	I '$d(^SM(CX)) W "No Matters for this Client",!! S N=N+2 G END
	W "List of Matters for this Client:",!! S N=N+2
P41	S MX=$O(^SM(CX,MX)) I MX="" G END
	D MLINE
	G P41

	;Print a single matter
P50	D ^OUTPUT G:%OP[% XSAD S N=99,P=1
	D CLINE,MLINE

END	D END^XSXS
	G XSAD

	;Subroutines

CLINE	I N>55 D HEAD^XSXS
	S J=1 D GETC,WRC
	Q

MLINE	I N>55 D HEAD^XSXS
	I A1="OPEN",$d(^SM(CX,MX,"C")) Q
	S J=1 D GETM S S1=$g(^SR(RX)),S2="" I M7B'="" S S2=$g(^SA(M7B))
	D WRM
	Q

	;Get client details
GETC	S SC=^SC(CX),C1=$P(SC,%,1),C7=$P(SC,%,2),C8=$P(SC,%,3)
	S SCA=^SC(CX,"A"),C2=$P(SCA,%,1),C3=$P(SCA,%,2),C4=$P(SCA,%,3),C5=$P(SCA,%,4),C6=$P(SCA,%,5)
	S SCN=^SC(CX,"N"),C9=$P(SCN,%,1),C10=$P(SCN,%,2),C11=$P(SCN,%,3)
	Q

	;Get matter details
GETM	S SM=^SM(CX,MX),M1=$P(SM,%,1),M2=$P(SM,%,2),M3=$P(SM,%,3),M4=$P(SM,%,4),M5=$P(SM,%,5),M6=$P(SM,%,6),M7=$P(SM,%,7),M8=$P(SM,%,8),M9=$P(SM,%,9),M10=$P(SM,%,10),M14=$P(SM,%,11),RX=$p(M7,"/",1),M7B=$p(M7,"/",2)
	S SMN=^SM(CX,MX,"N"),M11=$P(SMN,%,1),M12=$P(SMN,%,2),M13=$P(SMN,%,3)
	S SMO1=$g(^SM(CX,MX,"O"))
	Q

	;Write client details
WRC	W "Client ",CX,?13,C1,?44,"-------------------------",!!
	W ?4,C2,!?4,C3,!?4,C4,!
	W ?4,C5,?44,"Telephone ",C7,!
	W ?4,C6,?44,"Facsimile ",C8,!!
	W ?4,C9,!?4,C10,!?4,C11,!! S N=N+12
	Q

	;Write matter details
WRM	W ?1,MX,?6,M1,?44,$$^NEWNAME("@F1@")," ",M3,?60,$$^NEWNAME("@F2@")," ",M4,!
	W ?44,$$^NEWNAME("@F3@")," ",M5,?60,"VATable ",M6,!
	W ?1,"Charge group ",RX,?17,S1,?44,$$^NEWNAME("@F7@")," ",M8,?59," ",$$^NEWNAME("@F8@")," ",M9,!
	W ?1,"Activity ",M7B,?17,S2,?44,"Action date ",M2,!
	W ?44,"Budget ",M14,!
	W ?1,M11,!
	W ?1,M12,!
	W ?1,M13,! S N=N+7
	Q

	;Validation - Client number
V01	Q:X="*"  D CASE I '$D(^SC(X)) S ERR="Does not exist"
	Q
	;Confirm
V02	I X'="ALL",X'="OPEN" S ERR="Wrong confirmation"
	Q

CASE	S X=$zconvert(X,"U") Q
