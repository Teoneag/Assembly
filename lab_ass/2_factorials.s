.text
welcome: .asciz "Welcome to the factorial calculator\n"
input: .asciz "%ld"
enterNr: .asciz "Please enter the number (positive integer): "
output: .asciz "The result of %ld! is %ld\n"

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
    mov $0, %rax
    mov $input, %rdi
    sub $16, %rsp
    lea -8(%rbp), %rsi
    call scanf

    # move the nr in %rdi for factorial
    mov -8(%rbp), %rdi
    call factorial

    # print the result
    mov $output, %rdi
    mov -8(%rbp), %rsi
    mov %rax, %rdx
    call printf

    add $16, %rsp # clean the stack
    
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
    push %rdi # save the nr for after the call
    push %rdi # 2 pushes so the stack is aligned
    dec %rdi
    call factorial

    # multiply n * factorial(n-1), result in %rax
    pop %rdi    
    pop %rdi # second pop so that the stack is aligned
    mulq %rdi

returnFactorial:
    # epilogue
    mov %rbp, %rsp
    pop %rbp

    ret