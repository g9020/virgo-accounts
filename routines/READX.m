READX	;GRI,,,;09:07 AM  27 Aug 1999
	;=======================================================
	; Input subroutine
	; read a value into variable X until <return> or <tab>
	;
	; Copyright Graham R Irwin 1994-99
	;
	; X - input variable
	; j - character position
	;
	; key values:-
	;  4 = end
	;  8 = backspace
	;  9 = return
	; 13 = tab
	; 14 = cursor left
	; 18 = cursor right
	; 21 = F1
	; 22 = F2
	; 27 = Esc
	; 28 = F7
	; 127 = delete
	; 142 = ctrl+left arrow
	; 146 = ctrl+right arrow
	; 156 = pound
	; 0,71 = Home
	; 0,147 = ctrl+delete
	;
	;=======================================================

	s j=1,X=""
	;if amend mode get original value
	i $d(%I),%I s X=@%S4

read	r *a s c=$c(a)
	i a=13!(a=9) s j=$l(X)+1 d move w /ef q
	i c=% s X=% r *a q
	i c?1anp d ins g read
	i a=156 d ins g read
	i a=14 i j>1 s j=j-1 d move g read
	i a=18 i j'>$l(X) s j=j+1 d move g read
	i a=127 s X=$e(X,1,j-1)_$e(X,j+1,999) d show g read
	i a=8 s X=$e(X,1,j-2)_$e(X,j,999) s:j>1 j=j-1 d show g read
	i a=4 s j=$l(X)+1 d move g read
	i a=142 d ctll,move g read
	i a=146 d ctlr,move g read
	i a=21 s X="?" q
	i a=22 s X="??" q
	i a=27 s X="^" q
	i a=28 s X="^" q
	i a=0 d next i end q
	g read

ins	i $l(X)'<%S2 w *7 q
	s X=$e(X,1,j-1)_c_$e(X,j,999) d show s j=j+1 w /c($x+1,$y)
	q

move	w /c(X1+j-1,Y1) q

show	w /c(X1+j-1,$y),$e(X,j,999),$e(PU,1,%S2-$l(X)),/c(X1+j-1,$y) q

	;Control + left arrow
ctll	i j=1 q
	f j=j-1:-1:1 q:$e(X,j)'=" "
	i j=1 q
	f j=j-1:-1:1 q:$e(X,j)=" "
	i j>1 s j=j+1
	q

	;Control + right arrow
ctlr	s j=$f(X," ",j)
	i j=0 s j=$l(X)+1 q
	f  q:$e(X,j)'=" "  s j=j+1
	q

	;Extended character
next	r *a s end=0
	i a=71 s j=1 d move q
	i a=147 s X=$e(X,1,j-1) s:%I @%S4=X d show q
	;i a=134 d ^XSY ;F12
	s end=1
	q
