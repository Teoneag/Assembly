.global main

main:
    # prologue
    push %rbp
    mov %rsp, %rbp

    # code

    #epilogue
    mov %rbp, %rsp
    pop %rbp
end:
    mov $0, %rdi
    call exit