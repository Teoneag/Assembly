.text
input: .asciz "%ld"
printS: .asciz "Let me show u this: %ld\n"

.global main

main:
    # prologue
    push %rbp
    mov %rsp , %rbp

    # read 1st nr
    mov %rsp, %rsi
    mov $input, %rdi
    call scanf

    # print 1st nr
    mov $printS, %rdi
    call printf

    # read 2nd nr
    mov %rsp, %rsi
    mov $input, %rdi
    call scanf

    # print 2 2nd nr
    mov $printS, %rdi
    call printf

    # epilogue
    mov %rbp, %rsp
    pop %rbp
end:
    mov $0, %rdi
    call exit