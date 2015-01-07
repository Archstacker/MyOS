ML	= ML
LINK	= DOSLNK
RM	= rm
DISK	= LEECHUNG.vhd

ML_FLAG = /c
LINK_FLAG = /TINY ;

%.obj : %.asm
	$(ML) $< $(ML_FLAG)

%.com : %.obj
	$(LINK) $< $(LINK_FLAG)

Loader	: Loader.com
	dd if=$< of=$(DISK) count=1 bs=512 seek=0 conv=notrunc
System	: Sys.com
	dd if=$< of=$(DISK) count=1 bs=512 seek=1 conv=notrunc

All	: Loader System

clean	:
	$(RM) *.com
