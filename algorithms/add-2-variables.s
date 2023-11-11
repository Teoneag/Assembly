.text
suma: .asciz "%ld is the sum of %ld and %ld.\n"
.equ a, 69
.equ b, 420

.global main

main:
    # epilog
    push %rbp
    mov %rsp , %rbp

    # print
    mov $suma, %rdi
    mov $a, %rsi
    add $b, %rsi
    mov $a, %rdx
    mov $b, %rcx
    call printf

    # prolog
    mov %rbp, %rsp
    pop %rbp
end:
    mov $0, %rdi
    call exit