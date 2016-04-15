XSBP	;GRI,,,;03:40 PM  11 Nov 2002;
	;=======================================================
	; Virgo Accounts - Post Creditor Invoice
	;
	; Copyright Graham R Irwin 1993-2002
	;
	; Screens:       1082
	; Files updated: ^SV ^SY ^AB ^AY
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, YX^XSXS, 
	;                UPAB^XSXS, ^XSBF validation routines
	;
	;=======================================================

	S TT="CRI",VAT=^SZ("VAT")/100
	D X0^XSXS
	S %S=1082 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSBP Q
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX D CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX D CASE G XSBP:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	I ^SZ("VCB")'="N" S O3="*",E2=O2
	D YX^XSXS S ^SY(DAT,TT,YX)=O1_%_"Acct:"_%_AX2_%_%_O2_%_O3_%_"Acct:"_%_AX1_%_%_O4_%_O5
	S T2=O2 I "IL"[$e(AX1,1) S T2=-O2
	D UPAB^XSXS(AX1,T2,O1,TT,O4,O5)
	D UPAB^XSXS(AX2,E2,O1,TT,O4,O5)

	;Update VAT records
	I O3="*"!(^SZ("VCB")="X") G NV1
	S SV=$G(^SV),V1=$P(SV,%,1)+O2,V2=$P(SV,%,2)+O3,V3=$P(SV,%,3,99),^SV=V1_%_V2_%_V3,^SV("P"_YX)="Payment"_%_O1_%_O2_%_O3
	D UPAB^XSXS("L040",-O3,O1,TT,O4,O5)

NV1
	G XSBP

	;Amend
A01	W /C(0,4),/EF F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSBP:%J=1,A01
	G E02

	;Validation - Creditor account
V01	Q:$D(ERR)
	I $e(X)'="L" S ERR="Must be a liability account" Q
	S A3=$j($p(^AB(X),%,3),0,2)
	Q
	;Expense account
V03	Q:$D(ERR)  I X=AX2 S ERR="Cannot be the same account" Q
	S A3=$j($p(^AB(X),%,3),0,2)
	Q

CASE	S X=$zconvert(X,"U") Q
