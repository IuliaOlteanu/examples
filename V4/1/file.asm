%include "printf32.asm"

section .bss
	index resd 1
	result resd 0

section .data
	string db "abcdefd", 0
	STRING_SIZE equ $-string
	chr db 'd'


section .text
extern printf
global main

main:

	push ebp
	mov ebp, esp

; TODO1: Aflați indexul primei apariții a caracterului in string și afișați-l
	xor eax, eax
	mov edx, dword string
get_index:
	cmp byte [edx + eax], 100
	je end
	inc eax
	cmp eax, STRING_SIZE
	jne get_index

end:
	mov dword[index], eax
	PRINTF32 `Indexul este %u\n\x0`, [index]



; TODO2: Înlocuiți toate aparițiile caracterelor din intervalul [0:index] cu rot13 și afisați-l în această formă
	mov eax, dword[index]
	xor ecx, ecx
	xor ebx, ebx
rot_13:
	mov bl, byte[string + ecx]
	add bl, 13
	cmp bl, 122
	jl increment
	sub bl, 26

increment:
	mov byte[string + ecx], bl
	inc ecx
	cmp ecx, eax
	jle rot_13
	
	PRINTF32 `Stringul este  %s\n\x0`, string

; TODO3: Faceți reversul stringului și afișați-l
	xor eax, eax
	mov eax, string
	mov edx, eax
last:
	mov ch, [edx]
	inc edx
	test ch, ch
	jnz last
	sub edx, 2

swap:
	cmp eax, edx
	jg end_rev
	mov cl, [eax]
	mov ch, [edx]
	mov [edx], cl
	mov [eax], ch
	inc eax
	dec edx
	jmp swap
end_rev:
	PRINTF32 `Stringul inversat este %s\n\x0`, string


    leave
    ret
