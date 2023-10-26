.text
cout: .asciz "Yaes: %ld \n"

.global main

main:
    # epilog
    push %rbp
    mov %rsp , %rbp

    # divide 69 by 10
    mov $69, %rax
    mov $10, %rbx
    cqto
    idiv %rbx
    mov %rdx, %rsi
    mov $cout, %rdi
    mov $0, %rax
    call printf
    
    # Rax - result
    # Rdx - remainder

    # prolog
    mov %rbp, %rsp
    pop %rbp
end:
    mov $0, %rdi
    call exit
