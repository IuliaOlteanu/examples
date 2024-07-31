%include "utils/printf32.asm"

section .data
    ; TODO a: Define arr1, arr2 and res arrays.
    arr1 dd 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    arr2 dd 1, 2, 3, 4, 5, 6, 7, 8, 9, 10


section .bss
    res resd 10

section .text
global main
extern printf

main:
    push ebp
    mov ebp, esp


    ; TODO b: Compute res[0] and res[n-1].
    ; res[0] = arr1[0] + arr2[9]
    mov eax, dword[arr1] ; arr1[0]
    add eax, dword[arr2 + 36] ; arr1[0] + arr2[9]
    mov dword[res], eax
    PRINTF32 `Res[0] = %d\n\x0`, [res]

    ;res[9] = arr1[9] + arr2[0]
    xor eax, eax
    mov eax, dword[arr1 + 36]
    add eax, dword[arr2]
    mov dword[res + 36], eax
    PRINTF32 `Res[9] = %d\n\x0`, [res + 36]



    ; List first and last item in each array.
    PRINTF32 `%d\n\x0`, [arr1]
    PRINTF32 `%d\n\x0`, [arr2]
    PRINTF32 `%d\n\x0`, [res]

    PRINTF32 `%d\n\x0`, [arr1+36]
    PRINTF32 `%d\n\x0`, [arr2+36]
    PRINTF32 `%d\n\x0`, [res+36]
    


    ; TODO d: Compute cross sums in res[i].
    ; res[i] = arr1[i] + arr2[n-i]
    xor ecx, ecx
calcul:
    mov eax, dword[arr1 + ecx * 4] ; arr1[i]
    mov ebx, 9
    sub ebx, ecx
    add eax, dword[arr2 + ebx * 4]; arr2[9 - i]
    mov dword[res + ecx * 4], eax
    inc ecx
    cmp ecx, 10
    jl calcul



    ; TODO c: List arrays.
    xor ecx, ecx
for:
    ; PRINTF32 `Arr1[%d] = \x0`, ecx
    ; PRINTF32 `%d\n\x0`, dword[arr1 + ecx * 4]
    ; PRINTF32 `Arr2[%d] = \x0`, ecx
    ; PRINTF32 `%d\n\x0`, dword[arr2 + ecx * 4]
    PRINTF32 `Res[%d] = \x0`, ecx
    PRINTF32 `%d\n\x0`, dword[res + ecx * 4]
    inc ecx
    cmp ecx, 10
    jl for




    ; Return 0.    
    xor eax, eax
    leave
    ret