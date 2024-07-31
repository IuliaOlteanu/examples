%include "printf32.asm"
extern printf

section .data

M dw 1000
N dw 700

arr1 dw 1000, 1000, 30, 40, 50, 60, 70, 80, 90, 100
arr2 dw 90, 100, 90, 50, 40, 30, 20, 10, 60, 100
len equ 10
p dd 0

section .bss
    res dw 0
; TODO c: Alocati memorie pentru vectorul `res` cu elemente de tip double word si dimensiunea egala cu `len`
    
section .text
    
global main

main:
    push ebp
    mov ebp, esp

    ; TODO a: Calculati si afisati produsul numerelor reprezentate pe 2 octeti (word) M si N.
    ; Sugestie: Pentru inmultire puteti folosi instructiunea `mul` care:
    ;   - primeste primul operand in registrul AX
    ;   - primeste al doilea operand intr-un registru pe 16 biti / memorie de 16 biti
    ;   - intoarce rezultatul in DX:AX
    ;   - pe scurt, DX : AX = AX * r/m16.
    mov ax, word [M]
    mov bx, word [N]
    mul bx
    
    ; Print result in hexa
    xor ebx, ebx
    mov bx, dx
    PRINTF32 `%hx\x0`, edx
    xor ebx, ebx
    mov bx, ax
    PRINTF32 `%hx\n\x0`, eax


    ; TODO b: Calculati si afisati produsul scalar al vectorilor arr1 si arr2
    ;   - P = arr1[0] * arr2[0] + arr1[1] * arr2[1] + ... arr1[i] * arr2[i] + ...
    ;   - este garantat ca P nu depaseste dimensiunea unui double word (4 octeti)

    xor eax, eax
    xor ebx, ebx
    xor edx, edx
    xor ecx, ecx
    xor esi, esi

for:
    mov ax, word[arr1 + ecx * 2]
    mov bx, word[arr2 + ecx * 2]
    mul bx
    shl edx, 16
    or eax, edx
    add esi, eax
    xor eax, eax
    inc ecx
    cmp ecx, len
    jl for

    PRINTF32 `%d\n\x0`, esi

    ; TODO c: Completati vectorul `res` cu elemente de tip double word de dimensiune `len`  astfel incat
    ; fiecare element sa fie egal cu produsul elementelor corespunzatoare din vectorii `arr1` si `arr2`.
    ; - e.g: res[i] = arr1[i] * arr2[i]
    xor eax, eax
    xor ebx, ebx
    xor edx, edx
    xor ecx, ecx
for2:
    ;xor edx, edx
    mov ax, word[arr1 + ecx * 2]
    mov bx, word[arr2 + ecx * 2]
    mul bx
    shl edx, 16
    or eax, edx
    mov dword[res + ecx * 4], eax
    xor eax, eax
    inc ecx
    cmp ecx, len
    jl for2
    ; TODO d: Afisati vectorul `res` cu elemente de tip double word de dimensiune `len` calculat la punctul c)

    xor eax, eax
    xor ecx, ecx
afisare:
    mov eax, dword[res + ecx * 4]
    PRINTF32 `%d \x0`, eax
    inc ecx
    cmp ecx, len
    jl afisare

    PRINTF32 `\n\x0`
    ; Return 0.
    xor eax, eax
    leave
    ret
