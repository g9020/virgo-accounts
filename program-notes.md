# Virgo Accounts Program Notes

The source code for Virgo Accounts is supplied in two files VIRGO.RSA and VIRGO.GSA. The former contains all the routines (plus a few strays) in routine save format, and the latter contains the required globals (^HELP, ^MENU, ^MENU1, ^NAMES and ^SCREEN) in global save format.

Whilst DTM supports multi-user applications, Virgo Accounts does not include any file and/or record locking and so is a single-user system.

This brief (and possibly incomplete) notes describe the development and maintenance tools, and the subroutines used in Virgo Accounts. E&OE

## Standard Utilities, Subroutines and Globals

### Utilities:

KILLPW - delete system password

SCRDEF - screen definition maintenance

SCRDFP - screen definition print

SETPW - set system password

XSX - main menu

XSY - enquiries menu

### Subroutines:

Cont(x) - wait for key press

DATE - date and time processing routine

DOSDEV - get a DOS file name

GETX - read X value for Option prompt

INPASSW - password input routine

INPUT - standard input routine

OUTPUT - open a printer or DOS file for reports

READX - input field (subroutine for INPUT)

### Globals:

^SCREEN - screen definitions

^SEARCH - search facility

^HELP - help text

^MENU - main menu

^MENU1 - enquiries menu

^NAMES - pseudonyms

^Access - passwords

^SYS - parameters

### Utilities

#### Routine: SCRDEF

Purpose: Program to input, amend and delete screen definitions.

Variables: Stand-alone routine - all variables locally defined/used

Globals: ^SCREEN, ^SCREEN(0) contains the prompts for screen definitions

Subroutines: Contains a modified version of INPUT for screen input, which allows entry of a ^ in the validation prompt

#### Routine: SCRDFP

Purpose: Program to print a range of screen definitions.

Variables: Stand-alone routine - all variables locally defined/used

Globals: ^SCREEN, ^SCREEN(1) prompts for "From screen" and "To screen"

Subroutines: OUTPUT, XSXS

#### Routine: SETPW

Purpose: Sets or changes the system password.

Variables: all variables are local

Globals: ^Access

Subroutines: INPASSW

#### Routine: XSX

Purpose: Main menu, started automatically when Virgo Accounts starts.

Variables:

% - field delimiter "^"

P1-P5 - escape sequences for, respectively, prompt text, input text, error messages, screen headers and other text

PU - a row of 80 underscores

PX - sub-menu number

H0 - type of firm

H1 - system name

H2 - program description

PGM - program name

Globals: ^Access, ^MENU, ^SYS

Subroutines: DATE, INPASSW, XSINIT

### Subroutines

#### Subroutine: DATE

Purpose: Routine to convert dates and time. Converts $H format to or from DD/MM/YYYY format.

Variables:

DAT - the date in DD/MM/YYYY format

%DAT - the date in DD/MM/YYYY format

TIM - the time in HH:MM format

%H - the date and time (or date only) in $H format

Entry points:

^DATE - returns DAT and TIM for $H (i.e. today's date and the present time)

H2DMY^DATE - converts %H (or $H) to %DAT

DMY2H^DATE - converts DAT to %H

#### Subroutine: DOSDEV

Purpose: Request a DOS file name and open a DOS device for output.

Variables: all variables are local

Globals: ^SCREEN(9) requests the file name

Subroutines: INPUT

#### Subroutine: INPASSW

Purpose: Requests input of a password.

Variables: ...

Globals: ^Access

#### Subroutine: INPUT

Purpose: General screen input and amendment routine, giving one prompt per line. To be called from within a program, usually used in a for loop.

Variables:

%S - screen number (must be defined on entry)

%J - field number (must be defined on entry)

X - input variable

ERR - an error message (only defined if the input fails a validation check)

other % variables used internally

Globals: ^SCREEN, ^HELP, ^SEARCH

Entry points:

A^INPUT - for amendment

D^INPUT - to display

INPUT includes the following validation routines:

DATE - Checks for a valid date. May be input as D/M/Y or D/M or -N where N is an offset from today, and is converted to DD/MM/YYYY format

TIME - Checks for a valid time. May be input as H:M and is converted to HH:MM

EXIST - Checks for the existence of a record

NOTEX - Checks that a record does not exist

EXDISP - Checks for the existence of a record and displays the description of the relevant field

AMOUNT - Checks that the value input is an amount (up to 7 numeric digits optionally followed by a decimal point and one or two further digits); * is also valid

AMOUNTN - Checks that the value input is either an amount optionally preceded by a minus sign; * is also valid

NUMBER - Checks for a valid number

YESNO - Checks that the value input is either a "Y" or "N"

INPUT also includes HELP and SEARCH routines.

Entry of "?" in any field invokes HELP, which displays text from the ^HELP global.

Entry of "??" invokes SEARCH if the field has been defined as a searchable field.

#### Subroutine: OUTPUT

Purpose: Opens the printer (or a DOS file).

Variables: all variables are local

Globals: none

Subroutines: none

### Standard Global Layouts

Kn indicates a key field

```
--------------------------------------------------------------
| ^SCREEN - Screen layout                                    |
|------------------------------------------------------------|
|Field| Description  |Type|Max |Min | Comments               |
|------------------------------------------------------------|
|  K1 | Screen no    | AN |  4 |  1 |                        |
|------------------------------------------------------------|
|  K2 | Field no     |  N |  2 |  1 |                        |
|------------------------------------------------------------|
|   1 | Prompt       |  E | 12 |  1 |                        |
|------------------------------------------------------------|
|   2 | Max length   |  N |  2 |  1 | =0 display only        |
|------------------------------------------------------------|
|   3 | Min length   |  N |  2 |  1 |                        |
|------------------------------------------------------------|
|   4 | Variable     | AN |  4 |  0 |                        |
|------------------------------------------------------------|
|   5 | Search file  | AN |  4 |  0 |                        |
|------------------------------------------------------------|
|   6 | Default      |  E | 10 |  0 |                        |
|------------------------------------------------------------|
|   7 | Validation   |  E | 40 |  0 | No delimiter           |
|------------------------------------------------------------|
|  K3 | "IF"         |  A |  2 |  0 |                        |
|------------------------------------------------------------|
|   1 | Omit         |  X | 40 |  0 | MUMPS expression       |
--------------------------------------------------------------
```
```
--------------------------------------------------------------
| ^SEARCH - Search file                                      |
|------------------------------------------------------------|
|Field| Description  |Type|Max |Min | Comments               |
|------------------------------------------------------------|
|  K1 | Key 1        | AN |  4 |  1 | Search file ID         |
|------------------------------------------------------------|
|  K2 | Key 2        |  E | 20 |  1 | Field description      |
|------------------------------------------------------------|
|  K3 | Key 3        |  E | 10 |  1 | Field key/index        |
|------------------------------------------------------------|
|   1 | Null record  |  E |  0 |  0 |                        |
--------------------------------------------------------------
```
```
--------------------------------------------------------------
| ^HELP                                                      |
|------------------------------------------------------------|
|Field| Description  |Type|Max |Min | Comments               |
|------------------------------------------------------------|
|  K1 | Key 1        |  A |  4 |  4 | Program name           |
|------------------------------------------------------------|
|  K2 | Key 2        | AN |  6 |  2 | Field (variable) name  |
|------------------------------------------------------------|
|  K3 | Key 3        |  N |  2 |  1 | Line number            |
|------------------------------------------------------------|
|   1 | Help text    |  E |    |  1 |                        |
--------------------------------------------------------------
```
```
--------------------------------------------------------------
| ^MENU / ^MENU1                                             |
|------------------------------------------------------------|
|Field| Description  |Type|Max |Min | Comments               |
|------------------------------------------------------------|
|  K1 | Key 1        |  N |  3 |  1 | Option                 |
|------------------------------------------------------------|
|   1 | Description  | AN | 40 |  1 | Sub-menu description   |
|------------------------------------------------------------|
|  K2 | Key 2        |  N |  3 |  1 | Sub option             |
|------------------------------------------------------------|
|   1 | Prog descr   | AN | 40 |  1 | Program description    |
|------------------------------------------------------------|
|   2 | Prog name    |  A |  8 |  4 | Program name           |
-------------------------------------------------------------- 
```
