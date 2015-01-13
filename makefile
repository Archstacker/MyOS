ML	= ML
LINK	= DOSLNK
RM	= rm
DISK	= LEECHUNG.vhd
QEMU	= qemu-system-i386
TERMINAL= konsole

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

all	: Loader System

debug	:
	$(TERMINAL) -e "$(QEMU) -S -s -monitor stdio -hda $(DISK) -serial null"
	sleep 1
	$(TERMINAL) -e "gdb -x gdbinit"

clean	:
	$(RM) *.com
