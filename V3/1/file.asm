%include "printf32.asm"

extern printf

section .bss
    results resw 9

section .data
    lap_times dw 0x37E, 0x321, 0x3FD, 0x3A5, 0x357, 0x385, 0x39B, 0x36F, 0x3E5, 0x31A
    lap_times_len equ $ - lap_times
    c_results_len equ 9
    d_results_len equ 8
    print_newline db 10, 0
    print_bit db "%d", 0

section .text
global main

main:
    push ebp
    mov ebp, esp

    ; TODO a: Aflați timpul minim și timpul maxim din vectorul lap_times.
    ; Salvați timpul minim pe prima poziție din vectorul results, iar timpul
    ; maxim pe cea de-a doua poziție.
    mov ax, word[lap_times] ; eax = lap_times[0]
    mov ecx, 10
for_min:
    mov dx, word[lap_times + ecx * 2 - 2]
    cmp ax, dx
    jl end_min
    mov ax, dx
end_min:
    loop for_min

; resetare reg 
    mov word[results], ax
    xor eax, eax
    mov ax, word[lap_times] ; eax = lap_times[0]
    mov ecx, 10
for_max:
    mov dx, word[lap_times + ecx * 2 - 2]
    cmp ax, dx
    jg end_max
    mov ax, dx
end_max:
    loop for_max

    mov word[results + 2], ax
    ; Afișare rezultat pentru subpunctul a). Nu modificați!
    PRINTF32 `%hd %hd\n\x0`, word [results], word [results + 2]

    ; TODO b: Aflați câtul și restul împărțirii sumei timpilor din prima
    ; jumătate de antrenament la suma timpilor din cea de-a doua jumătate de
    ; antrenament.
    ; Salvați câtul împărțirii pe prima poziție din vectorul results, iar restul
    ; împărțirii pe cea de-a doua poziție.

; suma prima jumatate
    xor edx, edx
    xor ecx, ecx
    mov ecx, 5
first_sum:
    mov bx, word[lap_times + ecx * 2 - 2]
    add dx, bx
    cmp cx, 0
    loop first_sum

    PRINTF32 `Prima suma : %d\n\x0`, edx


    xor ebx, ebx
    xor eax, eax
    xor ecx, ecx
    mov ecx, 9
second_sum:
    mov ax, word[lap_times + ecx * 2]
    add bx, ax
    dec ecx
    cmp ecx, 5
    jge second_sum

    PRINTF32 `A doua jumatate : %d\n\x0`, ebx

    ; edx % ebx
    mov eax, edx
    xor edx, edx
    xor ecx, ecx
    mov ecx, ebx
    div ecx



    mov word[results], ax
    mov word[results + 2], dx

    ; Afișare rezultat pentru subpunctul b). Nu modificați!
    PRINTF32 `%hd %hd\n\x0`, word [results], word [results + 2]


    ; TODO c: Aflați diferențele dintre timpi, doi câte doi.
    ; Plasați rezultatele în vectorul results.
    xor ecx, ecx
    xor ecx, ecx
    xor ebx, ebx
    xor eax, eax
calcul:
    mov bx, word[lap_times + ecx * 2] ;v[i]
    mov dx, word[lap_times + ecx * 2 + 2] ;v[i+1]
    sub bx, dx
    mov word[results + ecx * 2], bx
    inc ecx
    cmp ecx, 10
    jl calcul


    ; Afișare rezultat pentru subpunctul c). Nu modificați!
    mov edx, results
    mov ecx, c_results_len

print_c_loop:
    PRINTF32 `%hd \x0`, word [edx]
    add edx, 2
    loop print_c_loop

    PRINTF32 `\n\x0`


    ; TODO d: Aflați în binar numărul de timpi de antrenament care au al treilea
    ; cel mai puțin semnificativ bit setat.
    ; Numărul de timpi de antrenament care au al treilea cel mai puțin
    ; semnificativ bit setat încape garantat într-un octet.
    ; Testați fiecare bit din acest număr și salvați pe poziții succesive în
    ; vectorul "results" valoarea 0 dacă bitul testat este 0, sau valoarea 1
    ; dacă bitul testat este 1.
    ; Cel mai semnificativ bit se va afla pe prima poziție din vectorul results,
    ; iar ce cel mai puțin semnificativ bit se va afla pe cea de-a opta poziție
    ; din vector.

    xor ecx, ecx
    xor eax, eax
    xor ebx, ebx
    xor edx, edx
for_nr:
    mov bx, word[lap_times + ecx * 2] ; bx = lap_times[i]
    ;set(nr)
    push ebx
    call set
    add esp, 4

    cmp eax, 1
    jne increment
    inc edx

increment:
    inc ecx
    cmp ecx, 10
    jl for_nr

    PRINTF32 `nr : %d\n\x0`, edx
    push edx

    push edx
    call show_bit
    add esp, 4
    
    pop edx
    xor eax, eax
    ;xor ecx, ecx
    mov ecx, 8
for_bit:
    mov ebx, edx ;copie
    and ebx, 1 ;ebi = bit
    mov word[results + ecx * 2 - 2], bx
    shr edx, 1
    loop for_bit



    ; Afișare rezultat pentru subpunctul d). Nu modificați!
    mov edx, results
    mov ecx, d_results_len

print_d_loop:
    PRINTF32 `%hd\x0`, word [edx]
    add edx, 2
    loop print_d_loop

    PRINTF32 `\n\x0`

    ; Return 0.
    xor eax, eax
    leave
    ret

; int set(short nr)
; nr & (1 << 2)
set:
    push ebp
    mov ebp, esp

    mov ebx, dword[ebp + 8]
    and ebx, 4

    cmp ebx, 0
    jne rez_final
    mov eax, 0
    jmp end_set

rez_final:
    mov eax, 1
    jmp end_set

end_set:
    mov esp, ebp
    pop ebp
    ret


show_bit:
    push ebp
    mov ebp, esp
    
    mov ecx, 8
    mov ebx, 1
    shl ebx, 7

print:
    mov edx, [ebp + 8]
    and edx, ebx

    ;eddx 1 sau 0
    cmp edx, 0
    je bit_0
    mov edx, 1
    jmp bit_1
bit_0:
    mov edx, 0

bit_1:    
    ;save ebx, ecx
    push ebx
    push ecx

    ;print bit
    push edx
    push print_bit
    call printf
    add esp, 8

    ;restore ebx, ecx
    pop ecx
    pop ebx

    shr ebx, 1
    loop print

    push print_newline
    call printf
    add esp, 4

    leave
    ret