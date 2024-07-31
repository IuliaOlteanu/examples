extern printf
extern scanf
extern malloc
extern free

%include "printf32.asm"

section .rodata
  read_fmt: db "%d", 0
  print_int_crlf: db "%d", 0xa, 0xd, 0
  print_int_space: db "%d ", 0
  arr_fmt: db "v[%d] = ", 0
  freq_fmt: db "Odd Freq: %d", 0xa, 0xd, 0
  crlf: db 0xa, 0xd, 0

section .data
  test_vector dd 10, 30, 31, 33, 75
  test_odd dd 13
  test_even dd 24

section .bss
  p_arr resd 1


section .text
global main

; TODO a: Implementati functia void print_vector(int *v, int len) care afiseaza
;         valorile dintr-un vector de intregi "v" de lungime "len" separate prin
;         spatiu pe o line separata.
;         Apoi apelati functia in programul principal pentru vectorul de test
;         "test_vector" definit in sectiunea ".data".
;         ATENTIE: Functia printf modifica o parte din registrele de uz general.

;void print_vector(int *v, int len)
print_vector:
  push ebp
  mov ebp, esp

  xor ecx, ecx
  mov eax, dword[ebp + 12] ;len
  mov ebx, dword[ebp + 8]  ;v

print:
  push ebx
  push eax
  push ecx

  ; %d 
  ; v[%d] =
  push dword[ebx]
  push print_int_space
  call printf
  add esp, 8

  pop ecx
  pop eax
  pop ebx
  inc ecx
  add ebx, 4
  cmp ecx, eax
  jne print

  push crlf
  call printf
  add esp, 4

  mov esp,ebp
  pop ebp
  ret
; TODO b: Implementati functia int* read_vector(int len) care citeste
;         de la inputul standard un numar de "len" valori intregi pe care le
;         depune intr-un vector alocat dinamic cu aceeasi dimensiune.
;         Functia returneaza adresa catre vectorul populat catre apelant.
;
;         Apelati functia in programul principal pentru a creea un vector
;         de 10 intregi citit de la inputul standard si afisati vectorul introdus.
;         ATENTIE: Functia scanf modifica o parte din registrele de uz general.
read_vector:
  push ebp
  mov ebp, esp 

  ; eax * 4
  mov eax, dword[ebp + 8]
  shl eax, 2

  push eax
  call malloc
  add esp, 4

  xor ecx, ecx
  sub esp, 4
for:
  pusha

  mov edx, ebp
  sub edx, 4

  push edx
  push read_fmt
  call scanf
  add esp, 8

  popa
  mov ebx, dword[ebp - 4]
  mov dword[eax + ecx * 4], ebx
  ;PRINTF32 `%d\n\x0`, ebx
  inc ecx
  cmp ecx, dword[ebp + 8]
  jl for

  
  mov esp, ebp
  pop ebp
  ret


; TODO c: Implementati functia int is_even(int x) care returneaza 1 sau 0 daca
;         argumentul "x" este par sau respectiv, impar.
;
;         Apelati functia in programul principal pentru cele doua variabile de
;         de test "test_odd"/"test_even" definite in sectiunea de .data si afisati
;         rezultatul obtinut pentru fiecare dintre acestea pe cate o line separata.

;int is_even(int x)
is_even:
  
  enter 0, 0
  mov eax, dword[ebp + 8]
  and eax, 1
  xor eax, 1


  leave
  ret

; TODO d: Implementati functia int max_even(int *v, int len) care determina
;         valoarea maxima para dintr-un vectorde valori intregi fara semn
;         si returneaza acesta valoare apelantului.
;
;         Apelati functia in programul principal pentru vectorul citit de la intrarea
;         standard, afisati rezultatul obtinut si de-alocati vectorul de intregi
;         alocat dinamic.

max_even:
  push ebp
  mov ebp, esp

  push esi
  mov esi, dword[ebp + 12]

  push ebx
  mov ebx, dword[ebp + 8] 

  cmp esi, 1
  mov eax, dword[ebx] ; max = v[0]
  jle end_max_even
  mov edx, 1

for_max_even:
  mov ecx, dword[ebx + edx * 4]
  test cl, 1
  jne check
  cmp eax, ecx
  jge check
  mov eax, ecx

check:
  inc edx
  cmp edx, esi
  jne for_max_even

end_max_even:
  pop ebx
  pop esi
  mov esp, ebp
  pop ebp
  ret

main:
    push ebp
    mov ebp, esp

    ;TODO a: Apelati functia print_vector pentru vectorul de test "test_vector"
    ;        definit in sectiunea de date.
    push 5
    push test_vector
    call print_vector
    add esp, 8

    xor eax, eax

    ; TODO b: Apelati functia read_vector pentru a creea un vector de 10 intregi
    ;         citit de la inputul standard. Apoi afisati valorile acestui vector
    ;         utilizand functia print_vector.
    ;         Hint: puteti salva adresa vectorului returnat de functie
    ;               intr-o variabila globala.
    push 10
    call read_vector
    add esp, 4

    mov dword[p_arr], eax

    push 10
    push dword[p_arr]
    call print_vector
    add esp, 8
  
    
    ; TODO c: Apelati functia int is_even(int x) pentru variabilele "test_odd"/
    ;         "test_even" si afisati rezultatele obtiunte pentru fiecare pe
    ;         cate o line separata.
    push dword[test_odd]
    call is_even
    add esp, 4

    push eax
    push print_int_crlf
    call printf
    add esp, 8

    xor eax, eax

    push dword[test_even]
    call is_even
    add esp, 4

    push eax
    push print_int_crlf
    call printf
    add esp, 8

    ; TODO d: Apelati functia max_even pentru vectorul citit de la intrarea
    ;         standard, apoi afisati rezultatul obtinut si de-alocati vectorul
    ;         de intregi.
    push 10
    push dword[p_arr]
    call max_even
    add esp, 8

    push eax
    push print_int_crlf
    call printf
    add esp, 8

    push dword[p_arr]
    call free
    add esp, 4

    ; Return 0.
    xor eax, eax
    leave
    ret
