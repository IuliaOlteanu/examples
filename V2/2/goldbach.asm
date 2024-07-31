;%include "io.inc"

extern fgets
extern stdin
extern printf
extern atoi

section .data
    n            dd 7
    format_str   dd "Number: %d", 13, 10, 0
    prime_format dd "isPrime: %d", 13, 10, 0

section .text
global main

;TODO b: Implement stringToNumber
stringToNumber:
    push ebp
    mov ebp, esp

    mov ecx, dword[ebp + 8]
    movzx edx, byte[ecx]
    xor eax, eax
    test dl, dl 
    je end
for:
    lea eax, [eax + eax * 4]
    movsx edx, dl
    lea eax, [edx - 48 + eax * 2]
    movzx edx, byte[ecx + 1]
    add ecx, 1
    test dl, dl
    jne for

end:
    pop ebp
    ret

;TODO c.: Add missing code bits
isPrime:

loop:
    div ecx
    cmp edx, 0
    je not_prime
    inc ecx
    mov eax, [ebp+8]
    xor edx, edx
    cmp ecx, ebx
    jne loop
    
    jmp done
    
not_prime:
    jmp done
    
done:



main:
    push ebp
    mov ebp, esp

    ;TODO a.: allocate space on stack and call fgets
    sub esp, 4
    mov eax, ebp
    sub eax, 4

    push dword[stdin]
    push dword [n]
    push eax
    call fgets
    add esp, 12

    ;TODO b.: call stringToNumber and print it using printf
    mov eax, ebp
    sub eax, 4
    push eax
    call stringToNumber
    add esp, 8

    push eax
    push format_str
    call printf
    add esp, 8


    ;TODO c.: call isPrime and print result

    leave
    ret
