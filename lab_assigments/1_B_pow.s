.text
welcome: .asciz "Welcome to the power calculator\n"
input: .asciz "%ld"
enterBase: .asciz "Please enter the base (positive integer): "
enterExponent: .asciz "Please enter the exponent (positive integer): "
output: .asciz "The result of %ld to the power of %ld is %ld\n"

.global main

main:
    # prologue
    push %rbp
    mov %rsp , %rbp
    
    # print welcome
    mov $welcome, %rdi
    call printf
    
    # ask for the base
    mov $enterBase, %rdi
    call printf

    # get the base
    mov $input, %rdi
    sub $16, %rsp
    lea -8(%rbp), %rsi 
    call scanf

    # ask for the exponent
    mov $enterExponent, %rdi
    call printf

    # get the exponent
    mov $input, %rdi
    lea -16(%rbp), %rsi
    call scanf

    # move the base(-8(%rbp)) to %rdi & the exponent(-16(%rbp)) to %rcx
    mov -8(%rbp), %rdi
    mov -16(%rbp), %rsi

    # call pow
    call pow

    # print the result
    mov $output, %rdi
    mov -8(%rbp), %rsi
    mov -16(%rbp), %rdx
    mov %rax, %rcx
    call printf

    # clean the stack
    add $16, %rsp
    
    # epilogue
    mov %rbp, %rsp
    pop %rbp

end:
    mov $0, %rdi
    call exit

# The pow subrutine gets the base(%rdi) & the exponent (%rsi) and returns the base ^ exponent (%rax)
pow:
    # prologue
    push %rbp
    mov %rsp , %rbp

    # initialize %rax to 1
    mov $1, %rax

    # handle exponent 0
    cmp $0, %rsi
    je endPow

    # move %rsi in %rcx for the loop
    mov %rsi, %rcx

    # calculate %rdi to the power %rcx
powerLoop:
    mul %rdi
    loop powerLoop

endPow:
    # epilogue
    mov %rbp, %rsp
    pop %rbp

    ret