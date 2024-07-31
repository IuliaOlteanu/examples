ASM = nasm
CC = gcc
LDFLAGS = -m32

.PHONY: all clean

all: goldbach

goldbach: goldbach.o

goldbach.o: goldbach.asm
	$(ASM) -f elf32 -o $@ $<

clean:
	-rm -f *~
	-rm -f goldbach.o goldbach
