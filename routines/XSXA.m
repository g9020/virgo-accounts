XSXA	;gri;08:57 AM  30 Apr 2002
	;=======================================================
	; Virgo Accounts - recreate the Nominal ledger at yrend
	;
	; Copyright Graham R Irwin 1993
	;=======================================================	;

	i $d(^AY) q
	s AX=""
A01	s AX=$o(^AB(AX)) i AX="" g A99
	s AB=^AB(AX),A3=$p(AB,%,3)
	i A3'=0 s ^AY(AX,0)=DAT_%_A3_%_%_%_"Balance forward"
	g A01

A99	q
