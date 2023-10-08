.text
helloS: .asciz "Suiiiiii %ld \n"

.global main

main:
    # epilog
    push %rbp
    mov %rsp , %rbp

    # print
    mov $helloS, %rdi
    mov $69, %rsi
    call printf

    # prolog
    mov %rbp, %rsp
    pop %rbp
end:
    mov $0, %rdi
    call exit
