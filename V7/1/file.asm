%include "utils/printf32.asm"
extern printf

section .data

M dd 0xF0F1F071

arr dd 0x11223344, 0xFF11FF11, 0x12AA12AA, 0xAABBCCDD, 0x10C010C0, 0x17272727, 0x97979797, 0xA1A1A1A1, 0xB2B2B2B2, 0xC4C4C4
len equ 10

msj db "%d ", 0

section .bss

;TODO c: Declarati vectorul `res` cu elemente de tip intreg si dimensiunea egala cu `len`

res resd 10

section .text
global main

numberoct:
    push ebp
    mov ebp, esp

    mov edi, [ebp+8]
    mov ebx, edi
    xor esi, esi
    xor ecx, ecx
    xor edx, edx

next_byte:
    shl edi, 24
    shr edi, 24
    shl edi, 31
    shr edi, 31
    cmp edi, dword 0
    je par
    jmp next

par:
    inc ecx
next:
    mov edi, ebx
    shr edi, 8
    mov ebx, edi
    inc edx
    cmp edx, dword 4
    jl next_byte

    mov eax, ecx

    leave
    ret

main:
    push ebp
    mov ebp, esp

    ; TODO a: Afișați în binar numărul întreg definit de variabila M.
    ; Cel mai semnificativ bit va fi afișat primul (e.g 0x0000000F -> 0b00000000000000000000000000001111)
    ; Pentru simplificare, se vor afișa 32 de cifre binare chiar dacă biții cei mai semnificativi sunt zero

    mov edi, [M]
    mov ebx, edi
    xor esi, esi

next_bit:
    shr edi, 31
    push edi
    push msj
    call printf
    add esp, 8

    inc esi

    mov edi, ebx
    shl edi, 1
    mov ebx, edi
    cmp esi, dword 32
    jl next_bit

    PRINTF32 `\n\x0`


    ; TODO b: Afișați numărul octetilor pari din reprezentarea numărului întreg M (e.g 0x12131415 -> are 2 octeți pari 0x12, 0x14)


    ; TODO c: Completati fiecare element al vectorului `res` cu numărul octetilor pari corespunzator fiecarui element din vectorul `arr`
    ; e.g: elementul `j` al vectorului `res` va contine numarul octetilor pari al intregului de pe pozitia `j` din vectorul `arr`
    ; res [2] = octeti_pari(arr[2]) = octeti_pari(0x12AA12AA) = 4

    xor ecx, ecx

next_number:

    ;PRINTF32 `%d\n\x0`, ecx
    mov ebx, [arr+4*ecx]

    push ecx

    push ebx
    call numberoct
    add esp, 4

    pop ecx

    mov [res+4*ecx], eax

    inc ecx
    cmp ecx, len
    jl next_number


    ; TODO d: Afisati elementele vectorului `res` pe aceeasi linie separate de spatii.

    xor ecx, ecx

next_print:

    push ecx

    push dword[res+4*ecx]  
    push msj
    call printf
    add esp, 8

    pop ecx

    inc ecx

    cmp ecx, len
    jl next_print 

    ; Return 0.
    xor eax, eax
    leave
    ret
