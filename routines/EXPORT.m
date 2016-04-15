EXPORT	;gri,,,;01:48 PM  16 Jan 2002
	;=======================================================
	; Virgo Accounts - Export Data
	;
	; Copyright Graham R Irwin 1997-2002
	;
	; Screens:       1066
	; Files updated: DOS files (see documentation)
	; Subroutines:   X0^XSXS, ^INPUT, ^GETX, H2DMY^DATE
	;
	;=======================================================

	; N.B. Day-end must be run first as Daybook file is not exported

	D X0^XSXS S YES="Y",NO="N"
	S (SC,SM,SB,AB,ML,CL,SW,TE,AY,CB,SF,SA,SD,SV,SZ)=YES

E01	S %S=1066 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 EXPORT Q
E02	W /C(0,22),@P1,"Update or Quit ? ",/EL,@P2 D ^GETX S X=$zconvert(X,"U")
	I X="Q"!(X=%) G EXPORT
	I X="U" G U01
	G E02

	;Update
U01	I SC="Y" D SC1
	I SM="Y" D SM1
	I SB="Y" D SB1
	I AB="Y" D AB1
	I ML="Y" D ML1
	I CL="Y" D CL1,CI1
	I SW="Y" D SW1
	I TE="Y" D TE1
	I AY="Y" D AY1
	I CB="Y" D CB1
	I SF="Y" D SF1
	I SA="Y" D SA1,SR1
	I SD="Y" D SD1
	I SV="Y" D SV1
	I SZ="Y" D SZ1
	U 0
	Q

	;Client details
SC1	U 0 W /c(0,23),@P1,"Exporting client details",/el
	S CX="",FN="Clients.txt" D OPEN
SC2	S CX=$o(^SC(CX)) I CX="" C 10 Q
	W CX,%,^SC(CX),!
	W ^SC(CX,"A"),!
	W ^SC(CX,"N"),!!
	G SC2

	;Matter details
SM1	U 0 W /c(0,23),@P1,"Exporting matter details",/el
	S (CX,MX)="",FN="Matters.txt" D OPEN
SM2	S CX=$o(^SM(CX)) I CX="" C 10 Q
SM3	S MX=$o(^SM(CX,MX)) I MX="" G SM2
	W CX,%,MX,%,^SM(CX,MX),!
	W ^SM(CX,MX,"N"),!
	W $g(^SM(CX,MX,"O")),%,$g(^SM(CX,MX,"C")),!!
	G SM3

	;Bills
SB1	U 0 W /c(0,23),@P1,"Exporting bill details",/el
	S BX="",FN="BillReg.txt" D OPEN
SB2	S BX=$o(^SB(BX)) I BX="" C 10 Q
	W BX,%,^SB(BX),!
	G SB2

	;Matter ledger
ML1	U 0 W /c(0,23),@P1,"Exporting matter ledger",/el
	S (CX,MX,X3)="",FN="MLedger.txt" D OPEN
ML2	S CX=$o(^ML(CX)) I CX="" C 10 Q
ML3	S MX=$o(^ML(CX,MX)) I MX="" G ML2
	W CX,%,MX,%,^ML(CX,MX),!
ML4	S X3=$o(^ML(CX,MX,X3)) I X3="" W ! G ML3
	W X3,%,^ML(CX,MX,X3),!
	G ML4

	;Client ledger
CL1	U 0 W /c(0,23),@P1,"Exporting client ledger",/el
	S (CX,MX,X3)="",FN="CLedger.txt" D OPEN
CL2	S CX=$o(^CL(CX)) I CX="" C 10 Q
CL3	S MX=$o(^CL(CX,MX)) I MX="" G CL2
	W CX,%,MX,%,^CL(CX,MX),!
CL4	S X3=$o(^CL(CX,MX,X3)) I X3="" W ! G CL3
	W X3,%,^CL(CX,MX,X3),!
	G CL4

	;Client interest
CI1	U 0 W /c(0,23),@P1,"Exporting interest rates",/el
	S IX="",FN="IntRates.txt" D OPEN
CI2	S IX=$o(^CI(IX)) I IX="" C 10 Q
	W IX,%,^CI(IX),!
	G CI2

	;WIP
SW1	U 0 W /c(0,23),@P1,"Exporting Work-in-progress",/el
	S (CX,MX,X3,X4)="",FN="WorkInP.txt" D OPEN
SW2	S CX=$o(^SW(CX)) I CX="" C 10 Q
SW3	S MX=$o(^SW(CX,MX)) I MX="" G SW2
	W CX,%,MX,%,^SW(CX,MX),!
SW4	S X3=$o(^SW(CX,MX,X3)) I X3="" W ! G SW3
SW5	S X4=$o(^SW(CX,MX,X3,X4)) I X4="" G SW4
	W X3,%,X4,%,^SW(CX,MX,X3,X4),!
	G SW5

	;Detailed time entries
TE1	U 0 W /c(0,23),@P1,"Exporting detailed time",/el
	S (CX,MX,X3,X4)="",FN="TimeEnts.txt" D OPEN
TE2	S CX=$o(^TE(CX)) I CX="" C 10 Q
TE3	S MX=$o(^TE(CX,MX)) I MX="" G TE2
TE4	S X3=$o(^TE(CX,MX,X3)) I X3="" G TE3
TE5	S X4=$o(^TE(CX,MX,X3,X4)) I X4="" G TE4
	W CX,%,MX,%,X3,%,X4,%,^TE(CX,MX,X3,X4),!
	G TE5

	;Cashbooks
CB1	U 0 W /c(0,23),@P1,"Exporting cashbook details",/el
	S (KX,X2)="",FN="CashBoox.txt" D OPEN
CB2	S KX=$o(^CB(KX)) I KX="" C 10 Q
	W KX,%,^CB(KX),!
CB3	S X2=$o(^CB(KX,X2)) I X2="" W ! G CB2
	W X2,%,^CB(KX,X2),!
	G CB3

	;Account balances and budgets
AB1	U 0 W /c(0,23),@P1,"Exporting account balances",/el
	S AX="",FN="AccBals.txt" D OPEN
AB2	S AX=$o(^AB(AX)) I AX="" C 10 Q
	W AX,%,^AB(AX),$g(^NB(AX)),!
	G AB2

	;Nominal ledger (transactions)
AY1	U 0 W /c(0,23),@P1,"Exporting nominal ledger",/el
	S (AX,X2)="",FN="NLedger.txt" D OPEN
AY2	S AX=$o(^AY(AX)) I AX="" C 10 Q
	W AX,!
AY3	S X2=$o(^AY(AX,X2)) I X2="" W ! G AY2
	W X2,%,^AY(AX,X2),!
	G AY3

	;Historic entries
SD1	U 0 W /c(0,23),@P1,"Exporting historic entries",/el
	S (CX,MX,X3,X4)="",FN="HistDisb.txt" D OPEN
SD2	S CX=$o(^SD(CX)) I CX="" C 10 Q
SD3	S MX=$o(^SD(CX,MX)) I MX="" G SD2
SD4	S X3=$o(^SD(CX,MX,X3)) I X3="" G SD3
SD5	S X4=$o(^SD(CX,MX,X3,X4)) I X4="" G SD4
	W CX,%,MX,%,X3,%,X4,%,^SD(CX,MX,X3,X4),!
	G SD5

	;Fee earners
SF1	U 0 W /c(0,23),@P1,"Exporting fee earners",/el
	S FX="",FN="FeeErnrs.txt" D OPEN
SF2	S FX=$o(^SF(FX)) I FX="" C 10 Q
	W FX,%,^SF(FX),!
	G SF2

	;Fee rates & activities
SA1	U 0 W /c(0,23),@P1,"Exporting fee rates",/el
	S AX="",FN="Activs.txt" D OPEN
SA2	S AX=$o(^SA(AX)) I AX="" C 10 Q
	W AX,%,^SA(AX),!
	G SA2

SR1	S (RX,X2)="",FN="FeeRates.txt" D OPEN
SR2	S RX=$o(^SR(RX)) I RX="" C 10 Q
	W RX,%,^SR(RX),!
SR3	S X2=$o(^SR(RX,X2)) I X2="" W ! G SR2
	W X2,%,^SR(RX,X2),!
	G SR3

	;VAT file
SV1	U 0 W /c(0,23),@P1,"Exporting VAT file",/el
	S FN="VATFile.txt" D OPEN
	W $d(^SV),!
	C 10 Q

	;System parameters
SZ1	U 0 W /c(0,23),@P1,"Exporting system parameters",/el
	S FN="System.txt" D OPEN
	W "Practice name = ",^SZ("PN"),!
	W "Licence no = ",^SZ("SW"),!
	W "Time units = ",^SZ("TU"),!
	W "VAT rate = ",^SZ("VAT"),!
	W "VAT cash basis = ",^SZ("VCB"),!
	W "Matter limits report = ",$g(^SZ("MLR"),"N"),!
	W "Default office cashbook = ",$g(^SZ("DOC"),1),!
	W "Auto day-end = ",^SZ("ADE"),!
	W "30 days date check = ",$g(^SZ("D30"),"Y"),!
	W "Detailed time = ",$g(^SZ("DTE"),"N"),!
	W "Write-off disbs = ",$g(^SZ("WOD"),"Y"),!
	W "Overdraw client = ",$g(^SZ("ODC"),"N"),!
	W "Last day-end = " S %H=^SZ("LDE") D H2DMY^DATE W %DAT,!
	W "Last period-end = " S %H=^SZ("LPE") D H2DMY^DATE W %DAT,!
	W "Next year-end = " S %H=^SZ("NYE") D H2DMY^DATE W %DAT,!
	W "Next item number = ",^SY,!
	W "Next bill number = ",^SB,!
	C 10 Q

OPEN	O 10:(file=FN:mode="w") U 10 Q
