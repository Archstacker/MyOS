	.model tiny

CNT	 = 1
ReadSector proto C mseg:word,moffset:word,sector:byte,sector_count:byte,line:byte,driver:byte
	.code
start:	mov ax, cs
	mov ds, ax
	
	mov ax, 600H
	mov ss, ax
	mov sp, 0
	
	; read sectors from sector 2
	invoke ReadSector, 800H, 100H, 2, CNT, 0, 80H
	
	mov ax, 800H
	push ax
	mov ax, 100H
	push ax
	retf		; jmp to 800H:100H

ReadSector proc C uses ax bx cx dx es mseg:word,moffset:word,sector:byte,sector_count:byte,line:byte,driver:byte
	mov ax, mseg
	mov es, ax
	mov bx, moffset
	mov al, sector_count
	mov ch, line
	mov cl, sector
	mov dl, driver
	mov dh, 0
	mov ah, 2
	int 13h
	
	ret
ReadSector endp
	db  (510 - ($ - offset start)) dup(0)
	db 55H, 0AAH
	end start