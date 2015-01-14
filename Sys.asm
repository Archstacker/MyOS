	.model tiny

SetTime		proto C row:byte, column:byte, flag:byte
ShowTime	proto C row:byte, column:byte, flag:byte
SetGuang	proto C row:byte, column:byte
ShowStr		proto C row:byte, column:byte, sseg1:word, soffset1:word
SetTimeFl	proto C 
ShowStrFl	proto C
ShowTimeFl	proto C
SetClean	proto C
	
	.code
	org 100H
start:	jmp real_start
szPlease	db	"Hello,  Please Input your Choose!", 0
szChoose1	db	"a.     Show  Time",0
szChoose2	db	"b.     Set   Time",0
szChoose3	db	"c.     Ret       ",0
szChoose4	db	"d.     Lucky     ",0
szChoose5	db	"e.     Exit      ",0
szGang		db	" /",0
szMao		db	" :",0
szNow		db	"Now  Time: ",0
szSet		db	"Please Input Time!",0
szClean		db	"                                     ",0
szGreat		db	"Yeah  Great!!",0
;stack 		db 	128 dup(0)
data  		dw 	0,0
real_start:
	main:	
		invoke SetGuang,0,0
		invoke SetClean
		invoke ShowStrFl
		mov ah,0
		int 16h
		cmp al,'a'
		je ca
		cmp al,'b'
		je cb
		cmp al,'c'
		je cc
		cmp al,'d'
		je cd
		cmp al,'e'
		je ce
		jmp main
	ca:	invoke SetClean
		;mov ax,offset stack
		;mov es:[9*4+2],cs
	s:	invoke ShowTimeFl
		mov ah,01
		int 16h
		jz s
		jmp main
	cb: 	invoke SetClean
		invoke SetTimeFl
	ncb:	mov ah,0
		int 16h
		cmp al,'r'
		jne ncb
		invoke ShowStr, 12, 20, cs, addr szGreat
		invoke SetGuang,12,34
		mov ah,0
		int 16h
		jmp main
	cc:	mov ax,0ffffh
		push ax
		mov ax,0
		push ax
		retf
		;jmp dword ptr ds:[0]
		;jmp main
	cd:	mov al,13h
		mov ah,0h
		int 10h
	        xor ax,ax
        	mov si,ax
        	mov ax,0a000h
        	mov ds,ax
        	mov ax,890h
        	mov es,ax
        	mov bx,0
        	mov cx,0fa00h
	@@:     mov al,byte ptr es:[bx]
        	mov byte ptr ds:[bx],al
        	inc bx
        	loop @b
		
	fin:	mov ah,01
		int 16h
		jz fin
		jmp cc
		jmp main
	ce:	mov    ax,5301H
		xor    bx,bx
		xor    cx,cx
		int    15H
		mov    ax,530EH
		xor    bx,bx
		mov    cx,102H
		int    15H
		mov    ax,5307H
		mov    bx,1
		mov    cx,3
		int    15H

SetTime	proc C uses es di row:byte, column:byte, flag:byte
	
	mov al,	flag
	out 70h,al
	mov ah,	0
	int 16h
	sub al,	30h
	mov bl,	al
	mov cl, 4
	shl bl, cl
	mov ah, 0
	int 16h
	sub al, 30h
	add al, bl
	out 71h, al
	invoke ShowTime, row, column, flag
	
	ret

SetTime endp

ShowTime	proc C uses es di row:byte, column:byte, flag:byte

	mov ax, 0b800h 
	mov es, ax
	mov al, 160
	mul row
	mov di, ax
	mov al, column
	mov ah, 0
	shl ax, 1
	add di, ax
	
	mov al,flag
	out 70h,al
	in al,	71h
	mov ah,	al
	mov cl,	4
	shr ah,	cl
	and al,	00001111b
	add	ah,30h
	add al,30h
	mov byte ptr es:[di],ah
	inc di
	inc di
	mov byte ptr es:[di],al
	
	ret

ShowTime endp

SetGuang	proc C uses es di row:byte, column:byte

	mov ah, 2
	mov bh, 0
	mov dh, row
	mov dl, column
	int 10h
	
	ret

SetGuang endp

SetTimeFl	proc C uses es di 
	invoke ShowStr,  8, 20, cs, addr szSet
	invoke SetGuang,10,19 
	invoke SetTime, 10, 19, 9
	invoke SetGuang,10,21
	mov ah, 0
	int 16h
	invoke ShowStr,  10, 21, cs, addr szGang
	invoke SetGuang,10,23
	invoke SetTime, 10, 23, 8
	invoke SetGuang,10,25
	mov ah, 0
	int 16h
	invoke ShowStr,  10, 25, cs, addr szGang
	invoke SetGuang,10,27
	invoke SetTime, 10, 27, 8
	invoke SetGuang,10,29
	mov ah, 0
	int 16h
	invoke SetGuang,10,31
	invoke SetTime, 10, 31, 8
	invoke SetGuang,10,33
	mov ah, 0
	int 16h
	invoke ShowStr,  10, 33, cs, addr szMao
	invoke SetGuang,10,35
	invoke SetTime, 10, 35, 8
	invoke SetGuang,10,37
	mov ah, 0
	int 16h
	invoke ShowStr,  10, 37, cs, addr szMao
	invoke SetGuang,10,39
	invoke SetTime, 10, 39, 8
	invoke SetGuang,10,41 
	
	ret

SetTimeFl endp

ShowStr	proc C uses ds es di si row:byte, column:byte, sseg1:word, soffset1:word

	mov ax, 0B800H
	mov es, ax
	
	mov ax, sseg1
	mov ds, ax
	mov si, soffset1
	
	mov al, 160
	mul row
	mov di, ax
	mov al, column
	mov ah, 0
	shl ax, 1
	add di, ax
	
	.repeat
		mov al, ds:[si]
		mov es:[di], al
		inc si
		inc di
		inc di
	.until	byte ptr ds:[si] == 0
	
	ret

ShowStr endp

ShowStrFl	proc C uses ds es di si 

	invoke ShowStr, 7, 20, cs, addr szPlease
	invoke ShowStr, 10, 22, cs, addr szChoose1
	invoke ShowStr, 12, 22, cs, addr szChoose2
	invoke ShowStr, 14, 22, cs, addr szChoose3
	invoke ShowStr, 16, 22, cs, addr szChoose4
	invoke ShowStr,	18, 22, cs, addr szChoose5
	
	ret

ShowStrFl endp

ShowTimeFl	proc C uses ds es di si 
	invoke ShowStr,	 8,  19, cs, addr szNow	
	invoke ShowTime, 10, 19, 9
	invoke ShowStr,  10, 21, cs, addr szGang
	invoke ShowTime, 10, 23, 8
	invoke ShowStr,  10, 25, cs, addr szGang
	invoke ShowTime, 10, 27, 7
	invoke ShowTime, 10, 31, 4
	invoke ShowStr,  10, 33, cs, addr szMao
	invoke ShowTime, 10, 35, 2
	invoke ShowStr,  10, 37, cs, addr szMao
	invoke ShowTime, 10, 39, 0
	invoke SetGuang, 0, 0
	ret

ShowTimeFl endp

SetClean	proc C uses ds es di si 
	invoke ShowStr, 7, 19, cs, addr szClean
	invoke ShowStr, 8, 19, cs, addr szClean
	invoke ShowStr, 9, 20, cs, addr szClean
	invoke ShowStr, 10,19, cs, addr szClean
	invoke ShowStr, 12, 20, cs, addr szClean
	invoke ShowStr, 14, 22, cs, addr szClean
	invoke ShowStr, 16, 22, cs, addr szClean
	invoke ShowStr, 18, 20, cs, addr szClean
	ret

SetClean endp

	end start
