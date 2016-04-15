DCHECK	;GRI,,,;08:46 PM  16 Feb 1999;
	;=======================================================
	; Copyright Graham R Irwin 1993-99
	;
	; Screens:       1018
	;
	;=======================================================

	D X0^XSXS
	S %S=1018 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 DCHECK Q

	W !,@P1,?8,"Difference",@P2,?25,D2-D1,!!
	s x=$$^Cont(1)
	Q

	;Validation - From date
V01	Q:$d(ERR)  S %DAT=X D DMY2H^DATE S D1=%H
	I %H>+$H S ERR="May not be in the future"
	Q
	;To date
V02	Q:$d(ERR)  S %DAT=X D DMY2H^DATE S D2=%H
	I D1>%H S ERR="May not be earlier than From date"
	Q
