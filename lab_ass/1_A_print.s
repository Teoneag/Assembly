.text
output: .asciz "Teodor Neagoe, Andy Bardas, tNeagoe, aBardas, Compulsory Lab - Assignment 01- Powers\n"

.global main

main:
    # prologue
    push %rbp
    mov %rsp , %rbp
    
    # print
    mov $output, %rdi
    call printf
    
    # epilogue
    mov %rbp, %rsp
    pop %rbp
end:
    mov $0, %rdi
    call exit
