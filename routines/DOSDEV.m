DOSDEV	;GRI;09:03 AM  18 Jan 2002
	;=======================================================
	; Routine to get DOS file name
	;
	; Copyright Graham R Irwin 1993-2002
	;
	; Screens:       9
	; Files updated: none
	; Subroutines:   ^INPUT
	;
	;=======================================================

	S %S=9 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 DOSDEV Q
	O 10:(file=FN:mode="w") U 10

	;Validation - File name
V01	I X'?1.8an S ERR="Illegal file name" Q
	S X=X_".txt" Q
