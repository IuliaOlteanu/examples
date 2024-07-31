extern printf
%include "printf32.asm"
section .data


arr dd  1331, 1441, 1551, 1661, 1771, 1881, 1991, 2002, 2022, 1337
len equ 10
int_fmt db '%d ', 0
int_fmt_newline db '%d', 10, 0
NEWLINE db 10, 0
nr1 dd 123456 
nr2 dd 202020

TEN     dd 10

section .bss
ans resd len

section .text
global main

; TODO a: Implementati functia `void print_array(int *arr, int n) care afiseaza
;   elementele numere intregi ale vectorului `arr` de dimensiune n.
;   Toate elementele vor fi afisate pe aceeasi linie separate de un spatiu.
;   La finalul afisarii se va insera NEWLINE. Vezi sectiunea .data
;   functia `printf` poate modifica registrele EAX, ECX si EDX.

;void print_array(int *arr, int len)
print_array:
    push ebp
    mov ebp, esp

    xor ecx, ecx
    mov eax, dword[ebp + 12] ;len
    mov ebx, dword[ebp + 8]  ;v

print:
    push ebx
    push eax
    push ecx

    push dword[ebx]
    push int_fmt
    call printf
    add esp, 8

    pop ecx
    pop eax
    pop ebx
    inc ecx
    add ebx, 4
    cmp ecx, eax
    jne print

    push NEWLINE
    call printf
    add esp, 4

    mov esp,ebp
    pop ebp
    ret


;TODO b: Implementati functia `int sum_digits(n)` care intoarce suma cifrelor numarului
;   intreg fara semn `n`.
;   e.g:
;       -sum_digits(123456) = 1+2+3+4+5+6 = 21
;       -sum_digits(100) = 1+0+0 = 1
sum_digits:
    push ebp
    mov ebp, esp

    mov ebx, [ebp + 8]
    cmp ebx, 10
    jl sum_base_case

    ;a = eax && eax /= 10
    mov eax, ebx
    mov edx, 0
    mov ebx, 10
    div ebx

    ;sum_digits(a/10)
    push edx
    push eax
    call sum_digits
    add esp, 4
    pop edx

    ;a%10 + sum_digits(a/10)
    add eax, edx
    jmp sum_done

sum_base_case:
    mov eax, ebx

sum_done:
    leave
    ret

; TODO c: Implementati functia `void sum_digits_arr(int *arr, int len, int *out_arr)
; care actualizeaza fiecare element din vectorul `out_arr` cu suma cifrelor elementului
; corespunzator din vectorul `arr` de dimensiunea `len`.
; out_arr[i] = sum_digits(arr[i])
; ATENTIE la registrii pe care functia `sum_digits` ii modifica.
sum_digits_arr:
    push ebp
    mov ebp, esp
    
    push ebx
    push esi
    push edi

    mov esi, dword[ebp + 8] ;arr
    mov ebx, dword[ebp + 12] ;len
    mov edi, dword[ebp + 16] ;out_arr
    xor ecx, ecx
    xor edx, edx

for_sum_arr:
    push ecx
    mov edx, dword[esi + ecx * 4]
    ;push ecx

    push edx
    call sum_digits
    add esp, 4

    ;PRINTF32 `eax:%d\n\x0`, eax
    pop ecx
    mov dword[edi + ecx * 4], eax
    ;PRINTF32 `res[%d] = %d\n\x0`, ecx, dword[edi + ecx * 4]
    inc ecx
    cmp ecx, dword[ebp + 12]
    jl for_sum_arr

    pop edi
    pop esi
    pop ebx

    mov esp, ebp
    pop ebp
    ret

;TODO d: Implementati functia `int reverse(int a)` care intoarce rasturnatul
; unui numar intreg fara semn. Rasturnatul este numarul obtinut din citirea
; numarului initial de dreapta la stanga.
; e.g:
;       - reverse(123456) = 654321
;       - reverse(300000) = 3
;       - reverse(10002)  = 20001
reverse:
    push ebp
    mov ebp, esp
    ; ogl = ogl * 10 + n % 10
    xor ecx, ecx ; ogl = 0
    mov eax, dword[ebp + 8] ; a
    mov edi, 10

for_rev:
    xor edx, edx
    div edi
    xchg ecx, eax
    mov esi, edx
    mul edi
    add eax, esi
    xchg eax, ecx
    cmp eax, 0
    jnz for_rev
    
    mov eax, ecx
    mov esp, ebp
    pop ebp
    ret

main:
    push ebp
    mov ebp, esp

    ;TODO a: Afisati folosind functia `print_array` vectorul `arr` de dimensiune `len`.

    push len
    push arr
    call print_array
    add esp, 8

    

    ;TODO b: Apelati functia `sum_digits` pentru numerele intregi `123456` si `202020`. Afisati rezultatul
    ;folosind functia `printf`. Fiecare rezultat fiind afisat pe o linie noua.

    xor eax, eax
    push dword[nr1]
    call sum_digits
    add esp, 4

    push eax
    push int_fmt_newline
    call printf
    add esp, 12

    xor eax, eax
    

    push dword[nr2]
    call sum_digits
    add esp, 4

    push eax
    push int_fmt_newline
    call printf
    add esp, 8
    xor eax, eax
    
    
    ; TODO c: Apelati functia `sum_digits_arr` pentru a calcula suma cifrelor numerelor din vectorul `arr` de dimensiune `len`.
    ; Salvati rezultatul in vectorul `ans` alocat in sectiunea `.bss`
    ; Afisati apoi vectorul `ans` folosind functia `print_array` implementata la TODO a.
    ;(int *arr, int len, int *out_arr)
    push ans
    push len
    push arr
    call sum_digits_arr
    add esp, 12

    push len
    push ans
    call print_array
    add esp, 8

    xor eax, eax
    ; TODO d: Apelati functia `reverse` pentru a calcula rasturnatul numerelor intregi fara semn `123456` si `100`. Afisati
    ; apoi fiecare rezultat pe o linie noua.

    push 123456
    call reverse
    add esp, 4

    push eax
    push int_fmt_newline
    call printf
    add esp, 8

    xor eax, eax
    push 100
    call reverse
    add esp, 4

    push eax
    push int_fmt_newline
    call printf
    add esp, 8
    xor eax, eax
    leave
    ret
