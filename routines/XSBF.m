XSBF	;GRI,,,;05:17 PM  11 Dec 2002
	;=======================================================
	; Virgo Accounts - Post Office Receipt
	;
	; Copyright Graham R Irwin 1993-99
	;
	; Screens:       1009
	; Files updated: ^CB ^SV ^SY ^AB ^AY
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, YX^XSXS, UPAB^XSXS
	;
	;=======================================================

	S TT="OFR",VAT=^SZ("VAT")/100,ONE=$g(^SZ("DOC"),1)
	D X0^XSXS
	S %S=1009 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSBF Q
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) W @P1,"  Quit without update ? ",@P2 D ^GETX,CASE G XSBF:X="Y",E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	D YX^XSXS S ^SY(DAT,TT,YX)=O1_%_%_%_DX_%_O2_%_O3_%_"Acct:"_%_AX_%_%_O4_%_O5
	S ^CB(DX,YX)=O1_%_%_E2_%_TT_%_O4_%_O5_%_"N"_%
	S CB=^CB(DX),B1=$P(CB,%,1,5),B6=$P(CB,%,6)+E2,^CB(DX)=B1_%_B6_%
	S T1=O2 S:"AE"[$e(AX,1) T1=-O2 D UPAB^XSXS(AX,T1,O1,TT,O4,O5)

	;Update VAT records
	I O3="*"!(^SZ("VCB")="X") G NV1
	S SV=$g(^SV),V1=$p(SV,%,1),V2=$p(SV,%,2),V3=$p(SV,%,3)+O2,V4=$p(SV,%,4)+O3,^SV=V1_%_V2_%_V3_%_V4,^SV(YX)="Receipt"_%_O1_%_O2_%_O3
	D UPAB^XSXS("L040",O3,O1,TT,O4,O5)

NV1	D UPAB^XSXS("A130",E2,O1,TT,O4,O5)
	G XSBF

	;Amend
A01	W /C(0,4),/EF F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSBF:%J=1,A01
	G E02

	;Validation (also used by XSBG)
	;Net amount
V01	S E3=$J(X*VAT,0,2) Q
	;VAT amount
V02	I X="*" K ERR
	I X<0,O2>0 S ERR="Must be a postive amount" Q
	I X>0,O2<0 S ERR="Must be a negative amount" Q
	S E2=$J(O2+X,0,2) Q
	;Cashbook number
V03	Q:$D(ERR)  I X>99 S ERR="Must be an office cashbook" Q
	S B6=$j($p(^CB(X),%,6),0,2)
	Q
	;Account code (also used by XSBJ, XSGF)
V04	Q:$D(ERR)  I "A110,A120,A130,L010,L020"[X S ERR="Cannot post to this account" Q
	I $E(X,1)="N" S ERR="Cannot be a non-financial account" Q
	I $P(^AB(X),%,5)="Y" S ERR="Cannot be a system account" W /C(0,22),@P1,"This is a system account - Are you sure ? ",/EL,@P2 S Z=X D ^GETX,CASE S Y=X,X=Z Q:Y'="Y"  K ERR
	S E5=$p(^AB(X),%,1)
	Q

CASE	S X=$zconvert(X,"U") Q
