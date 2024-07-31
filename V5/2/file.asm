extern printf
extern scanf
extern strrchr
extern calloc
extern read
extern free
extern strlen
%include "printf32.asm"
section .rodata
  scanf_str: db "%s", 0
  printf_str: db "%s", 0
  printf_int: db "%d", 0xA, 0xD, 0

section .data
    search_char: db 'a'

section .bss
  ptr_s resd 1


section .text
global main

; TODO a: Implementati functia char* read_string(int len) care citeste de la
;         tastatură un sir de caractere alfabetic de lungime maxima len
;         (inclusiv terminatorul de sir) si il stochează intr-o zonă
;         de memorie alocată dinamic pe heap de aceeasi lungime.
;
;         Apelati functia in programul principal si afișați sirul de caractere
;         introdus.
;
;         Hint: Se poate utiliza functia "read" a crărei apel echivalent ı̂n C este
;               read(0, str, 128); pentru a citi un sir de maxim 128 de caractere.
;
;         Observatie: Functiile de biblioteca modifca o parte din registre - CDECL
read_string:
    push ebp
    mov ebp, esp

    mov ebx, dword[ebp + 8] ; len

    ;apel calloc(len, 1)
    push 1
    push ebx
    call calloc
    add esp, 8

    push ebx
    mov ecx, eax

    ;read(0, str, len)
    push eax
    push 0
    call read
    add esp, 8

    mov eax, ecx
    pop ebx

    mov esp, ebp
    pop ebp
    ret


; TODO b: Implementati functia a carei antent ı̂n C este:
;         int get_char_pos(char*str, char chr). Functia intoarce indexul ultimei
;         aparitii a caracterului chr ı̂n sirul str. In cazul ı̂n care caracterul
;         nu există ı̂n sir, functia va ı̂ntoarce valoarea -1.
;
;         Apelati functia in progmaul principal pentru sirul citit de la tastatura
;         si variabila search_char, apoi afisati rezultatul acesteia pe o line separată.
;
;         Hint: Pentru a obtine un pointer către ultima aparitie a unui caracter
;               dintr-un sir puteti utiliza functia strrchr care arecu apelul
;               echivalent ı̂n C: char *p = strrchr(str, search_char);
;
;         Observatie: Functiile de biblioteca modifca o parte din registre - CDECL
get_char_pos:
    push ebp
    mov ebp, esp

    ; strrchr(str, search_chr)
    push dword[ebp + 12]
    push dword[ebp + 8]
    call strrchr
    add esp, 8

    ; rez in edx
    mov edx, eax
    mov ecx, eax
    sub ecx, dword[ebp + 8]
    mov eax, -1
    test edx, edx
    cmovne eax, ecx

    mov ebp, esp
    pop ebp
    ret

; TODO c: Implementati functia a carei antent ı̂n C este:
;         void upper_to_pos(char *str, char chr).
;         Functia transforma in-place caracterele sirului str ı̂n litere mari
;         pana la ultima apararitie a caracterului chr, inclusiv, iar restul
;         le lasa neschimbate.
;
;         Observatie: Functiile de biblioteca modifca o parte din registre - CDECL
;void upper_to_pos(char *str, char chr)

upper_to_pos:
    push ebp
    mov ebp, esp

    ; aflare index
    ; int get_char_pos(char*str, char chr)
    push dword[ebp + 12]
    push dword[ebp + 8]
    call get_char_pos
    add esp, 8
    
    ; index = edx
    mov edx, eax
    mov eax, dword[ebp + 8]
    xor ecx, ecx
    
check_byte:
    mov bl, byte[eax]
    test bl, bl
    je out
    sub bl, 0x20
    mov byte[eax], bl
    inc eax
    inc ecx
    cmp ecx, edx
    jle check_byte

out:
    mov esp, ebp
    
    pop ebp
    ret

main:
    push ebp
    mov ebp, esp

    ; TODO a: Apelati functia read_string pentru o lungime maxima de 64 de caractere
    ;         si afișați sirul de caractere introdus.
    push 64
    call read_string
    add esp, 4

    mov dword[ptr_s], eax

    push dword[ptr_s]
    push printf_str
    call printf
    add esp, 8
    ; TODO b: Apelati functia get_char_pos pentru sirul citit de la tastatura
    ;         si variabila search_char, apoi afisati rezultatul acesteia pe o
    ;         line separată.
    push dword[search_char]
    push dword[ptr_s]
    call get_char_pos
    add esp, 8

    push eax
    push printf_int
    call printf
    add esp, 8
    ; TODO d: Apelati functia void upper_to_pos(char *str, char chr) pentru sirul
    ;         citit de la tastatură si variabila search_char.
    ;
    ;         Afisati sirul rezultat pe o line separata si de-alocati corespunzator
    ;         sirul anterior alocat pe heap.
    
    ; xor eax, eax

    push dword[search_char]
    push dword[ptr_s]
    call upper_to_pos
    add esp, 8

    push dword[ptr_s]
    push printf_str
    call printf
    add esp, 8

    push dword[ptr_s]
    call free
    add esp, 4

    PRINTF32 `dupa free :\n\x0`
    push dword[ptr_s]
    push printf_str
    call printf
    add esp, 8
    ; Return 0.
    xor eax, eax
    leave
    ret
