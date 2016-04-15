XSCC	;GRI,,,;10:18 AM  1 Nov 2001
	;=======================================================
	; Virgo Accounts - Unpaid Bills Enquiry
	;
	; Copyright Graham R Irwin 1993-2001
	;
	; Screens:       none
	; Files updated: none
	; Subroutines:   X0^XSXS, ^GETX, ^OUTPUT, DMY2H^DATE,
	;                HEAD^XSXS, END^XSXS
	;
	;=======================================================

	; Note, this uses the bill register not the unpaid bill index file

	D X0^XSXS
	W @P1 D HEAD
	S IX=""
E02	S IX=$O(^SB(IX)) I IX=""!($Y>19) G E09
E03	D GET
	I D8=0 G E02
	D LINE
	G E02

E09	W /C(0,22),@P1,"Next, Print or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) Q
	I X="P" G P01
	I X="N" W /C(0,6),/EF,@P1 G E03:IX'="" S E4=0 G E02
	G E09

	;Print
P01	D ^OUTPUT G:%OP[% XSCC S N=99,P=1,IX="",(T1,T2,T3)=0 D HEAD^XSXS
	D HEAD S N=N+2
P02	S IX=$O(^SB(IX)) I IX="" G END
P03	D GET
	I D8=0 G P02
	D LINE W ! S N=N+3 I N>56 D HEAD^XSXS
	S T1=T1+D4+D5,T2=T2+D6,T3=T3+D8
	G P02

END	W "TOTAL",?19,$j(T1,10,2),?31,$j(T2,10,2),?43,$j(T1+T2,10,2),?56,$j(T3,10,2),!
	D END^XSXS
	Q

CASE	S X=$zconvert(X,"U") Q

	;Get bill details
GET	S SB=^SB(IX),D1=$p(SB,%,1),D2=$p(SB,%,2),D3=$p(SB,%,3),D4=$p(SB,%,4),D5=$p(SB,%,5),D6=$p(SB,%,6),D7=$p(SB,%,7),D8=+$p(SB,%,8)
	S %DAT=D1 D DMY2H^DATE S D0=$H-%H
	Q

	;Print/display column headings
HEAD	W "Date",?11,"Bill No",?24,"Net",?36,"VAT",?47,"Gross",?56,"O/S amount  C/L  Age",!!
	Q

	;Print/display bill details (2 lines)
	;get client and matter description
LINE	S E1=$e($p(^SC(D2),%,1),1,30),E2=$e($p(^SM(D2,D3),%,1),1,35)
	;check if client account has funds
	S F1=($g(^CL(D2,D3))>0),F1=$e(" *",F1+1)
	;print/display
	W D1,?12,IX,?19,$J(D4+D5,10,2),?31,$J(D6,10,2),?43,$J(D4+D5+D6,10,2),?56,$J(D8,10,2),?69,F1,?73,D0,!?1,E1,"; ",E2,!
	Q
