extern rand
extern time
extern srand
extern scanf
extern printf
extern puts


section .data
    uint_format    db "%zu", 0
    uint_format_newline    db "%zu", 10, 0
    msg    db "Insert number: ", 0
    is_smaller_string db "Numarul introdus este mai mic", 0
    is_larger_string db "Numarul introdus este mai mare", 0
    n dw 100
    corect db "Corect", 10, 0



section .bss
    num resd 1


section .text


; TODO c: Create read_cmp() function.
read_cmp:
    push ebp
    mov ebp, esp
    
    ;citire
    sub esp, 4
    
    push msg
    call printf
    add esp, 4

    mov eax, ebp
    sub eax, 4
    push eax
    push uint_format
    call scanf
    add esp, 8
    ;citire final

    mov ebx, dword[ebp - 4]
    cmp ebx, [num]
    je exit_corect
    
    cmp ebx, [num]
    jg exit_greater

    push is_smaller_string
    call printf
    add esp, 4
    mov eax, 0
    jmp exit_read_cmp

exit_greater:
    push is_larger_string
    call printf
    add esp, 4
    mov eax, 0
    jmp exit_read_cmp


exit_corect:
    push corect
    call printf
    add esp, 4
    mov eax, 1

exit_read_cmp:
    add esp, 4
    
    leave
    ret



global main
main:
    push ebp
    mov ebp, esp


    ; TODO a: Call srand(time(0)) and then rand() and store return value modulo 100 in num.
    push 0
    call time
    add esp, 4

    push eax
    call srand
    add esp, 4

    call rand
    xor edx, edx
    mov ebx, 10
    div ebx
    mov dword[num], edx


    ; Debug only: Print value of num to check it was properly initialized.
    push dword [num]
    push uint_format_newline
    call printf
    add esp, 8

    ; Comment this out when doing TODO b. Uncomment it when doing TODO c and d.
    jmp make_call
    
    ; TODO b: Read numbers from keyboard in an infinite loop.
    sub esp, 4
my_scan:
    push msg
    call printf
    add esp, 4

    mov eax, ebp
    sub eax, 4
    push eax
    push uint_format
    call scanf
    add esp, 8

    push dword[ebp + 4]
    push uint_format_newline
    call printf
    add esp, 8
    jmp my_scan



make_call:
    
    ; TODO d:

read:
    call read_cmp
    cmp eax, 1
    jne read

    ; Return 0.
    xor eax, eax
    leave
    ret
