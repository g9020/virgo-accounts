XSAJ	;GRI,,,;04:53 PM  4 Jun 2003;
	;=======================================================
	; Virgo Accounts - Close Matter
	;
	; Copyright Graham R Irwin 1999-2003
	;
	; Screens:	 1071
	; Files updated: ^SM
	; Subroutines:	 X0^XSXS, ^INPUT, ^GETX
	;
	;=======================================================
 
	D X0^XSXS
 
E01	S %S=1071 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSAJ Q
 
	;Option prompt
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX,CASE G XSAJ:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02
 
	;Update
U01	S SMA=^SM(CX,MX),SMA1=$p(SMA,%,1),SMA299=$p(SMA,%,2,99)
	I D1="*" K ^SM(CX,MX,"C") S L=$l(SMA1) I $e(SMA1,L)="$" S SMA1=$e(SMA1,1,L-2)
	I D1'="*" S ^SM(CX,MX,"C")=D1,SMA1=$e(SMA1,1,38)_" $"
	S ^SM(CX,MX)=SMA1_%_SMA299
	G XSAJ

	;Amend
A01	W /C(0,4),/EF F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSAJ:%J=1,A01
	G E02
 
	;Validation ------------------------------------------
	;Matter code
V02	S E1=$g(^SM(CX,X,"C"),"*")
	Q
	;Date
V03	I X="*" K ERR
	Q

CASE	S X=$zconvert(X,"U") Q
