GETX	;GRI,,,;01:46 PM  13 Sep 2002;
	;=======================================================
	; Input Routine for Option prompt &c
	;
	; Copyright Graham R Irwin 1994-2002
	;
	;=======================================================

	s j=1,X="",x1=$x,y1=$y
read	r *a s c=$c(a)
	i a=13 s j=$l(X)+1 d move w /ef q  ;return
	i c=% s X=% r *a q
	i c?1anp d ins g read
	;i a=156 d ins g read ;pound sign
	i a=14 i j>1 s j=j-1 d move g read ;cursor left
	i a=18 i j'>$l(X) s j=j+1 d move g read ;cursor right
	i a=127 s X=$e(X,1,j-1)_$e(X,j+1,999) d show g read ;delete
	i a=8 s X=$e(X,1,j-2)_$e(X,j,999) s:j>1 j=j-1 d show g read ;backspace
	i a=4 s j=$l(X)+1 d move g read ;end
	i a=21 s X="?" q  ;F1
	i a=23 s X="I" q  ;F3
	i a=24 s X="A" q  ;F4
	i a=25 s X="U" q  ;F5
	i a=26 s X="D" q  ;F6
	i a=27 s X="^" q  ;Esc
	i a=28 s X="^" q  ;F7
	i a=29 s X="P" q  ;F8
	i a=30 s X="N" q  ;F9
	i a=31 s X="Z" q  ;F10
	i a=12 s X="N" q  ;PgDn
	i a=5 s X="V" q  ;PgUp
	i a=130 s X="****" q  ;Alt+F4
	i a=0 d next i end q  ;extended char
	g read

ins	i $l(X)'<55 w *7 q
	s X=$e(X,1,j-1)_c_$e(X,j,999) d show s j=j+1 w /c($x+1,$y)
	q

move	w /c(x1+j-1,y1) q

show	w /c(x1+j-1,$y),/el,$e(X,j,999),/c(x1+j-1,$y) q

	;extended character
next	r *a s end=0
	i a=71 s X="\\",end=1 q  ;home
	i a=147 s X="",j=1 d show q  ;ctrl+delete
	;i a=133 s X="" ;F11
	i a=134 s X="Y" ;F12
	s end=1
	q
