.text
welcome: .asciz "\nWelcome to our program!\n"
prompt: .asciz "Please enter a positive number:\n"
input: .asciz "%ld"
output: .asciz "The result is: %ld. \n\n"

.global main

main:
    # prologue
    push %rbp
    mov %rsp, %rbp

    mov $welcome, %rdi
    call printf
    call inout

    # epilogue
    mov %rbp, %rsp
    pop %rbp

end:
    mov $0, %rdi
    call exit

inout:
    # prologue
    push %rbp
    mov %rsp, %rbp

    # print prompt
    mov $prompt, %rdi
    call printf

    # read input
    mov %r12, %rsi
    mov $input, %rdi
    call scanf

    # check if it's even
    mov %rsi, %rax
    mov $2, %rcx
    mov $0, %rdx
    div %rcx

    cmp $0, %rdx
    jne odd

even:
    inc %rsi

odd:
    # print output
    mov $output, %rdi
    call printf

    #epilogue
    mov %rbp, %rsp
    pop %rbp

    ret