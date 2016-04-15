GETPGM(M,N)	;gri;01:41 PM  28 Apr 1997
	;=======================================================
	; Routine to get program name
	;
	; Copyright Graham R Irwin 1994
	;
	; Screens:	
	; Files updated:
	; Subroutines:
	;
	;=======================================================

	Q:M=""  Q:N=""
	Q:'$d(^MENU(M,N))
	S X=^MENU(M,N),H2=$p(X,%,1),PGM=$p(X,%,2)
	Q
