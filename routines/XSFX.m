XSFX(S1,S2)	;GRI,,,;01:20 PM  11 Dec 2002;
	;=======================================================
	; Virgo Accounts - Subroutine to check amount of
	;                    withdrawal from client account
	;
	; Copyright Graham R Irwin 1993-1994
	;
	; Files updated: none
	; Subroutines:   none
	;
	;=======================================================

	; Parameters:-
	;  S1 - client code
	;  S2 - matter code
	;  X  - amount of withdrawal

	; if there's already an error, quit
	I $d(ERR) Q

	I $e(H0,1,2)="SS" G C00

	; Normal check
	I X'>+$g(^CL(S1,S2)) Q
	S ERR="Cannot overdraw client account"
	I $g(^SZ("ODC"))="Y" W /C(0,22),@P1,"Overdraw client account - Are you sure ? ",/el,@P2 R Y S Y=$zconvert(Y,"U") Q:Y'="Y"  K ERR
	Q

	; Scottish solicitors - check all matters
C00	S S3="",S9=0
C01	S S3=$o(^CL(S1,S3)) I S3="" G C02
	S S9=S9+^CL(S1,S3)
	G C01
C02	I X>S9 S ERR="Cannot overdraw client account"
	Q
