ASM = nasm
CC = gcc
CFLAGS = -Wall -m32 -Wno-implicit-function-declaration
LDFLAGS = -m32

.PHONY: all clean

all: cross_add

cross_add: cross_add.o

cross_add.o: cross_add.asm
	$(ASM) -f elf32 -o $@ $<

clean:
	-rm -f *~
	-rm -f cross_add.o cross_add
