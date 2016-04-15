XSBG	;GRI,,,;09:04 AM  3 Feb 2003
	;=======================================================
	; Virgo Accounts - Post Office Payment
	;
	; Copyright Graham R Irwin 1993-2003
	;
	; Screens:       1010
	; Files updated: ^CB ^SV ^SY ^AB ^AY
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, YX^XSXS, 
	;                UPAB^XSXS, ^CHEQUE, ^XSBF validation routines
	;
	;=======================================================

	S TT="OFP",VAT=^SZ("VAT")/100,ONE=$g(^SZ("DOC"),1)
	D X0^XSXS
	S %S=1010 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSBG Q
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX D CASE G XSBG:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	D YX^XSXS S ^SY(DAT,TT,YX)=O1_%_%_%_DX_%_O2_%_O3_%_"Acct:"_%_AX_%_%_O4_%_O5
	S ^CB(DX,YX)=O1_%_E2_%_%_TT_%_O4_%_O5_%_"N"_%
	S CB=^CB(DX),B1=$P(CB,%,1,5),B6=$P(CB,%,6)-E2,^CB(DX)=B1_%_B6_%
	S T1=O2 S:"LI"[$e(AX,1) T1=-O2 D UPAB^XSXS(AX,T1,O1,TT,O4,O5)

	;Update VAT records
	I O3="*"!(^SZ("VCB")="X") G NV1
	S SV=$G(^SV),V1=$P(SV,%,1)+O2,V2=$P(SV,%,2)+O3,V3=$P(SV,%,3,99),^SV=V1_%_V2_%_V3,^SV("P"_YX)="Payment"_%_O1_%_O2_%_O3
	D UPAB^XSXS("L040",-O3,O1,TT,O4,O5)

NV1	D UPAB^XSXS("A130",-E2,O1,TT,O4,O5)
	;Write check
	D ^CHEQUE(DX,"",AX,O1,E2,O4,O5,TT)
	G XSBG

	;Amend
A01	W /C(0,4),/EF F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSBG:%J=1,A01
	G E02

CASE	S X=$zconvert(X,"U") Q
