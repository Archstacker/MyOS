	.model tiny

ShowStr	proto C row:byte, column:byte, sseg1:word, soffset1:word
	
	.code
	org 000H
start:	jmp real_start
szHello	db	"Hello, My boot loader!", 0

real_start:
	invoke ShowStr, 10, 20, cs, addr szHello
        mov al,13h
        mov ah,0h
        int 10h
        xor ax,ax
        mov si,ax
        mov ax,0a000h
        mov ds,ax
        mov ax,880h
        mov es,ax
        mov bx,0
        mov cx,0fa00h
@@:     mov al,byte ptr es:[bx]
        mov byte ptr ds:[bx],al
        inc bx
        loop @b
	
	jmp $


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

	end start
