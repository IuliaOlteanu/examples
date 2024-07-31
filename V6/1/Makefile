ASM = nasm
CC = gcc
CFLAGS = -Wall -m32 -Wno-implicit-function-declaration
LDFLAGS = -m32

.PHONY: all clean

all: num_bits

num_bits: num_bits.o

num_bits.o: num_bits.asm
	$(ASM) -f elf32 -o $@ $<

clean:
	-rm -f *~
	-rm -f num_bits.o num_bits
