.text
helloS: .asciz "Suiiiiii %ld \n"

.global main

main:
    # epilog
    push %rbp
    mov %rsp , %rbp

    # print
    mov $helloS, %rdi
    mov $-9223372036854775808, %rsi
    mov $0, %rax
    call printf

    # prolog
    mov %rbp, %rsp
    pop %rbp
end:
    mov $0, %rdi
    call exit
