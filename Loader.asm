	.model tiny

CNT	 = 1
	.code
org 7c00h

start:	jmp real_start
DAPACK  db 10h
        db 0
        dw 255
        dw 8000h
        dw 0
        dd 1
        dd 0

real_start:
        mov ax, cs
	mov ds, ax
	
	mov ax, 0
	mov ss, ax
	mov sp, 7c00h
	
	; read sectors from sector 2
        mov si,offset DAPACK
        mov ah,42h
        mov dl,80h
        int 13h
	
	mov ax, 800H
	push ax
	mov ax, 0H
	push ax
	retf		; jmp to 800H:000H

	db  (510 - ($ - offset start)) dup(0)
	db 55H, 0AAH
	end start
