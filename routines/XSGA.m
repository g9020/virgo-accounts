XSGA	;GRI,,,;07:07 PM  12 Apr 2002
	;=======================================================
	; Virgo Accounts - Maintain System Parameters
	;
	; Copyright Graham R Irwin 1993-2002
	;
	; Screens:       1036
	; Files updated: ^SZ
	; Subroutines:   X0^XSXS, H2DMY^DATE, DMY2H^DATE, 
	;                ^INPUT, ^GETX
	;
	;=======================================================

	D X0^XSXS
	L ^SZ
	S A1=^SZ("PN")			; Practise name
	S A3=^SZ("SW")			; S/W licence
	S A4=^SZ("VCB")			; VAT cash basis Y/N
	S A5=^SZ("TU")			; Time units
	S A9=^SZ("VAT")			; VAT rate
	S A10=$g(^SZ("ADE"),"Y")	; Auto day-end Y/N
	S A11=$g(^SZ("DTE"),"N")	; Detailed time Y/N
	S A12=$g(^SZ("D30"),"Y")	; 30 day check Y/N
	S A13=$g(^SZ("DOC"),1)		; Default office CB
	S A14=^SY			; Last item number
	S A15=$g(^SZ("ODC"),"N")	; Overdraw client Y/N
	S A16=$g(^SZ("WOD"),"Y")	; Write-off disb Y/N
	S A17=$g(^SZ("DCG"))		; Default charge group
	S %H=^SZ("LDE") D H2DMY^DATE S A6=%DAT	; Last day-end
	S %H=^SZ("LPE") D H2DMY^DATE S A7=%DAT	; Last period-end
	S %H=^SZ("NYE") D H2DMY^DATE S A8=%DAT	; Next year-end

	S AMD=0
	S %S=1036 F %J=1:1 D D^INPUT Q:X="END"!(X[%)

	;Option prompt
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X=%) Q:'AMD  W @P1,"  Quit without update ? ",@P2 D ^GETX,CASE Q:X="Y"  G E02
	I X="A" G A01
	I X="U" G U01
	G E02

	;Update
U01	S ^SZ("PN")=A1
	S (^SZ("SW"),H0)=A3
	S ^SZ("VCB")=A4
	S ^SZ("TU")=A5
	S ^SZ("VAT")=A9
	S ^SZ("ADE")=A10
	S ^SZ("DTE")=A11
	S ^SZ("D30")=A12
	S ^SZ("DOC")=A13
	S ^SZ("ODC")=A15
	S ^SZ("WOD")=A16
	S ^SZ("DCG")=A17
	S %DAT=A8 D DMY2H^DATE S ^SZ("NYE")=%H
	Q

	;Amend
A01	S AMD=1 W /C(0,4),/EF F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	I X[% G XSGA:%J=1,A01
	G E02

	;Validation - VAT cash base
V01	Q:$D(ERR)  I $D(^SV),A4'=X S ERR="Cannot amend, VAT file exists"
	Q
	;Licence no (also used by XSINSTAL)
V02	I X'?2U3UN4N1UN S ERR="Invalid licence no"
	I $e(X,10)'=$$^gtest($e(X,1,9)) S ERR="Invalid licence no"
	Q
	;Cashbook
V03	Q:$D(ERR)  I X>99 S ERR="Must be an office cashbook"
	Q

CASE	S X=$zconvert(X,"U") Q
