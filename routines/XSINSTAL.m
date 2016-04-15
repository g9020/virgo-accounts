XSINSTAL ;GRI,,,;02:14 PM  8 Feb 2002
	;=======================================================
	; Virgo Accounts - Installation Routine
	;
	; Copyright Graham R Irwin 1993-2002
	;
	; Screens:       1099
	; Files updated: all
	; Subroutines:   X0^XSXS, ^DATE, ^INPUT, ^GETX, RECR^XSHB
	;
	;=======================================================

	S PGM="XSINSTAL",H2="Installation Routine",A6="X"
	D X0^XSXS,^DATE
	S %S=1099 F %J=1:1 D ^INPUT Q:X="END"!(X[%)
	I X[% G:%J>1 XSINSTAL H
E02	W /C(0,22),@P1,"Update, Amend or Quit ? ",/EL,@P2 D ^GETX,CASE
	I X="Q"!(X[%) G XSINSTAL
	I X="A" G A01
	I X'="U" G E02

	;Update
	W @P1,"  Please wait - Creating files ..."
	K ^SA,^SB,^SC,^SD,^SF,^SM,^SR,^SU,^SV,^SW,^SY,^SZ,^AB,^AY,^CA,^CB,^CI,^CL,^CN,^ML,^TE,^SO,^SX,^NB

	;Activity codes
	S ^SA("!C")="Carried forward"
	S ^SA("G")="General"
	S ^SA("Z!")="Written Off Time"

	;Charge rates
	S X1=0,X2="Non Legal Aid Work" S:A6="X" X2="Standard Work" D SETSR
	S Y1="G",Y2=A7,Y3=0 D SETSR2

	S ^SY=0
	S ^SZ("VAT")=17.5,^SZ("PN")=A1,^SZ("SW")=A3,^SZ("VCB")=A4,^SZ("TU")=A5,(^SZ("LDE"),^SZ("LPE"))=$H-1,^SZ("ADE")="Y"
	S %DAT=A8 D DMY2H^DATE S ^SZ("NYE")=%H

	;Account Balance File
	S X1="I020",X2="Profit Costs (fees)",X3="Y" D SETAB
	S X1="I030",X2="Interest Received",X3="N" D SETAB
	S X1="I040",X2="Other Income" D SETAB
	S X1="E010",X2="Staff Costs" D SETAB
	S X1="E120",X2="Rent & Rates" D SETAB
	S X1="E130",X2="Heating & Lighting" D SETAB
	S X1="E140",X2="Office Maintenance" D SETAB
	S X1="E150",X2="Equipment Hire & Maint" D SETAB
	S X1="E160",X2="Insurance & Pract Certs" D SETAB
	S X1="E170",X2="Telephone & Fax" D SETAB
	S X1="E180",X2="Stationery & Printing" D SETAB
	S X1="E190",X2="Publications & Books" D SETAB
	S X1="E200",X2="Subscriptions" D SETAB
	S X1="E210",X2="Training" D SETAB
	S X1="E220",X2="Advertising & Promotion" D SETAB
	S X1="E230",X2="Agency Fees" D SETAB
	S X1="E240",X2="Bank Charges" D SETAB
	S X1="E250",X2="Audit & Accountancy Fees" D SETAB
	S X1="E260",X2="Other Fees" D SETAB
	S X1="E270",X2="Office Travelling Expenses" D SETAB
	S X1="E280",X2="Non-recoverable Expenses",X3="Y" D SETAB
	S X1="E290",X2="Motor Expenses",X3="N" D SETAB
	S X1="E300",X2="Bad Debts" D SETAB
	S X1="E310",X2="Sundry Expenses" D SETAB
	S X1="E320",X2="Depreciation" D SETAB
	S X1="E330",X2="Bills Written Off",X3="Y" D SETAB
	S X1="E340",X2="Interest Paid" D SETAB
	S X1="A010",X2="Land & Buildings",X3="N" D SETAB
	S X1="A020",X2="Motor Vehicles" D SETAB
	S X1="A030",X2="Office Equipment" D SETAB
	S X1="A040",X2="Other Assets" D SETAB
	S X1="A110",X2="O/S Unpaid Bills",X3="Y" D SETAB
	S X1="A120",X2="Unbilled Disbursements" D SETAB
	S X1="A130",X2="Office Bank Account" D SETAB
	S X1="L010",X2="Client Control Account" D SETAB
	S X1="L020",X2="Trust Control Account" D SETAB
	;S X1="L030",X2="Stakeholder Control A/c" D SETAB
	S X1="L040",X2="VAT Control Account" D SETAB
	S X1="L050",X2="Claims Reserve",X3="N" D SETAB
	S X1="L070",X2="Office Loans" D SETAB
	S X1="L080",X2="Bad Debt Provision" D SETAB
	S X1="L140",X2="VAT Suspense Account",X3="Y" D SETAB
	S X1="L510",X2="Capital Account" D SETAB
	S X1="L520",X2="Current Account" D SETAB
	S X1="L530",X2="Profit/loss Account" D SETAB
	S X1="N020",X2="Work-in-Progress" D SETAB
	S X1="N030",X2="Time Booked" D SETAB
	S X1="N040",X2="Time Billed" D SETAB
	S X1="N050",X2="Time Written Off" D SETAB
	S X1="N060",X2="Disbursements Booked" D SETAB
	S X1="N070",X2="Disbursements Billed" D SETAB
	S X1="N080",X2="Disbursements Written Off" D SETAB
	S X1="N090",X2="Bills Raised" D SETAB
	S X1="N110",X2="Credits Raised" D SETAB

	;Fee Earner File
	S ^SF(1)=A2

	;Cashbooks
	S ^CB(1)="Office No 1 Account"_%_"00-00-00"_%_%_"N"_%_0_%_0_%
	S ^CB(100)="Client Account"_%_"00-00-00"_%_%_"N"_%_0_%_0_%
	S ^CB(101)="Trust Account"_%_"00-00-00"_%_%_"Y"_%_0_%_0_%

	;Client interest bands
	S ^CN(1000)=56,^(2000)=28,^(10000)=14,^(20000)=7

	;Recreate SEARCH file
	D RECR^XSHB

	W /C(0,4),/EF,@P5,"All system files have now been created. You may now start to set up:",!!
	W "*",?6,"other fee earners (if any)",!!
	W "*",?6,"your clients and matters",!!
	W "*",?6,"other bank accounts",!!
	W "*",?6,"client interest rates",!!
	W "*",?6,"your opening balances",!!
	W "You may also wish to print, review (and if necessary amend) the system",!,"parameters. Run off the System Parameters listing and use the appropriate",!,"function to amend the required details.",!!!
	W "Press ENTER to continue ",@P5 R X
	Q

SETAB	S ^AB(X1)=X2_%_0_%_0_%_0_%_X3_% Q

SETSR	S ^SR(X1)=X2 Q

SETSR2	S ^SR(X1,Y1)=Y2_%_Y3_% Q

CASE	S X=$zconvert(X,"U") Q

	;Amend
A01	W /C(0,4),/EF F %J=1:1 D A^INPUT Q:X="END"!(X[%)
	G XSINSTAL:X[%,E02

	;Validation - London firm
V01	I "YNX"'[X S ERR="Must be 'Y', 'N' or 'X'"
	Q
