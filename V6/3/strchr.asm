extern strlen
extern printf


section .rodata
    test_str db "hell, it's about time", 0
    format db "length = %d", 10, 0

section .text
global main

;int my_strlen(char *str)
my_strlen:
    push ebp
    mov ebp, esp

    mov eax, dword[ebp + 8]
    mov al, byte[eax]
    test al, al
    jne for
    xor eax, eax
    jmp end

for:
    mov eax, dword[ebp + 8]
    inc eax

    push eax
    call my_strlen
    add esp, 4

    inc eax
end:
    mov esp, ebp
    pop ebp
    ret

main:
    push ebp
    mov ebp, esp



    push test_str
    call strlen
    add esp, 4


    push eax
    push format
    call printf
    add esp, 8

    xor eax, eax
    ; TODO a: Implement strlen-like functionality using a RECURSIVE implementation.

    push test_str
    call my_strlen
    add esp, 4

    push eax
    push format
    call printf
    add esp, 8

    ; Return 0.
    xor eax, eax
    leave
    ret
