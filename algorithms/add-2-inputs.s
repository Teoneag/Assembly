.text
input: .asciz "%ld"
print1S: .asciz "This is the 1st nr: %ld\n"
print2S: .asciz "This is the 2nd nr: %ld\n"
printSumS: .asciz "This is the sum: %ld\n"

.global main

main:
    # epilog
    push %rbp
    mov %rsp , %rbp

    # read 1st nr
    mov $input, %rdi
    call scanf

    # save 1st nr
    mov %rsi, %rbx

    # print 1st nr
    mov $print1S, %rdi
    call printf

    # read 2nd nr
    mov $input, %rdi
    call scanf

    # add 2nd nr to 1st nr 
    add %rsi, %rbx

    # print 2nd nr
    mov $print2S, %rdi
    call printf

    #print the sum
    mov %rbx, %rsi
    mov $printSumS, %rdi
    call printf

    # prolog
    mov %rbp, %rsp
    pop %rbp
end:
    mov $0, %rdi
    call exit