.text
welcome: .asciz "Welcome to the factorial calculator\n"
input: .asciz "%ld"
enterNr: .asciz "Please enter the number (positive integer): "
output: .asciz "The result is %ld\n"

.global main

main:
    # prologue
    push %rbp
    mov %rsp , %rbp
    
    # print welcome
    mov $welcome, %rdi
    call printf
    
    # ask for the nr
    mov $enterNr, %rdi
    call printf

    # get the nr
    mov $input, %rdi
    mov %rsp, %rsi
    // sub $16, %rsp
    // lea -8(%rbp), %rsi
    call scanf

    # move the nr in %rdi for factorial
    mov %rsi, %rdi
    call factorial

    # print the result
    mov $output, %rdi
    // mov -8(%rbp), %rsi
    mov %rax, %rsi
    call printf

    # clean the stack
    add $16, %rsp
    
    # epilogue
    mov %rbp, %rsp
    pop %rbp

end:
    mov $0, %rdi
    call exit

# The factorial subrutine taxes n (%rdi) and returns n! recursevly (%rax)
factorial:
    # prologue
    push %rbp
    mov %rsp , %rbp

    # if (n == 0) return 1
    mov $1, %rax
    cmpq $0, %rdi
    je returnFactorial

    # else return n * factorial(n-1)
    push %rdi # save %rdi on the stack
    dec %rdi
    call factorial

    pop %rdi    
    mulq %rdi # multiply n * factorial(n-1), result in %rax

returnFactorial:
    # epilogue
    mov %rbp, %rsp
    pop %rbp

    ret
