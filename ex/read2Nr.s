.text
input: .asciz "%ld %ld"
output: .asciz "%ld"

.global main

main:
    # prologue
    push %rbp
    mov %rsp , %rbp

    # read 2 nr
    subq $16, %rsp          # make room for 1st, 2nd nr
    lea -8(%rbp), %rsi      # address of 1st nr
    lea -16(%rbp), %rdx     # address of 2nd nr
    mov $input, %rdi        # format string
    mov $0, %rax            # clear rax
    call scanf              # read 1st nr
    mov -8(%rbp), %r12      # save 1st nr in %r12
    mov -16(%rbp), %r13     # save 2nd nr in %r13

    # print 
    mov $output, %rdi       # format string
    mov %r12, %rsi          # 1st nr
    mov $0, %rax            # clear rax
    call printf             # print 1st nr

    # epilogue
    mov %rbp, %rsp
    pop %rbp
end:
    mov $0, %rdi
    call exit