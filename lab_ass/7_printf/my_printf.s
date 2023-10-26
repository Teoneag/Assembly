.data
outputString: .skip 100000

.text
hello: .asciz "%u appel %d lala %s %% %t %d %d %d"
exampleString: .asciz "Hello, World"

.global main

main:
    # prologue
    push %rbp
    mov %rsp, %rbp

    mov $hello, %rdi                # move the address of the string to %rdi 
    mov $42,%rsi
    mov $-1, %rdx
    mov $exampleString, %rcx
    mov $-2, %r8
    mov $-3, %r9
    push $-4
    push $-5
    # push the parameters on the stack, in reverse order
    call my_printf

    #epilogue
    mov %rbp, %rsp
    pop %rbp
end:
    # syscall exit
    mov $0, %rdi
    mov $60, %rax
    syscall


my_printf:
    # prologue
    push %rbp
    mov %rsp, %rbp

    # the 1st parameters are in %rdi, %rsi, %rdx, %rcx, %r8, %r9
    push %r9
    push %r8
    push %rcx
    push %rdx
    push %rsi

    mov $0, %rcx                    # index of the inputString
    mov $0, %r8                     # index of the outputString
    mov $-7, %r9                    # index of the parameter
    # from rbp: ret, rbp, 1 -> 5 parameters => -7

    loop:                           # loop through all the c in the inputString
        movb (%rdi, %rcx, 1), %al   # save the char in %al

        # if this is the end of the string, jump to end_loopn
        cmp $0, %al                 # check if it is the end of the string
        je end_loop                 
        
        # check if c is normal
        cmp $37, %al                # check if it is %
        jne is_normal

        # if c is %
        # check the next character
        inc %rcx
        movb (%rdi, %rcx, 1), %al   # save the next char in %al

        jmp check_d

    end_loop:
        # print using the syscall
        mov $1, %rax
        mov $outputString, %rsi
        mov $1, %rdi
        mov %r8, %rdx
        syscall

        push $69                        # to align the stack

        #epilogue
        mov %rbp, %rsp
        pop %rbp
        ret


check_u:
    cmp $117, %al
    jne check_s

    # if next c is u
    mov 16(%rbp, %r9, 8), %rax     # mov current parameter in %rax
    inc %r9
    cmp $-2, %r9
    jne not_equal2
    mov $0, %r9

    not_equal2:
    
    # take the number digit by digit, push it untill 0
    print_positive_nr_from_rax:
    mov $0, %r11                     # index of the number

    # loop to take the digits
    loop_untill_rax_zero:
    inc %r11                         # increse the index
    mov $10, %r10
    xor %rdx, %rdx                  # clear rdx (xor is more efficient than mov)
    idiv %r10                       # get rax % 10 into rdx
    push %rdx                       # push the digit
    cmp $0, %rax                    # check if %rax is 0
    jne loop_untill_rax_zero        # if %rax > 0, loop again

    # loop to pop the digits
    loop_pop:
    pop %rax                        # pop the digit
    add $48, %rax                   # convert to ascii
    movb %al, outputString(%r8)     # save the digit in the outputString
    inc %r8                         # increase the index
    dec %r11                         # decrease the index
    cmp $0, %r11                     # check if %r11 is 0
    jg loop_pop                     # if %r11 > 0, loop again

    inc %rcx
    jmp loop


check_d:
    # check if next character is d
    cmp $100, %al
    jne check_u                # check u, s, %
    # if next c is d
    mov 16(%rbp, %r9, 8), %rax # address of the current parameter
    inc %r9
    cmp $-2, %r9
    jne not_equal1
    mov $0, %r9
    not_equal1:
    
    cmp $0, %rax
    jge print_positive_nr_from_rax

    # add - to the outputString
    movb $45, outputString(%r8)
    inc %r8

    # convert %rax to positive
    mov $0, %r11
    sub %rax, %r11
    mov %r11, %rax
    jmp print_positive_nr_from_rax

    inc %rcx
    jmp loop

    end_check_procent:
    dec %rcx
    movb (%rdi, %rcx, 1), %al

    is_normal:
    movb %al, outputString(%r8)
    inc %r8

    inc %rcx
    jmp loop


check_s:
    cmp $115, %al
    jne check_procent
    
    # if next c is s
    mov $0, %rsi                    # index of the pietString
    mov 16(%rbp, %r9, 8), %r11      # address of the current parameter
    inc %r9
    cmp $-2, %r9
    jne not_equal3
    mov $0, %r9
    not_equal3:
    // mov 8(%rbp), %rax       
    inc %rcx
    
    # take the pietString char by char, push it untill /0
    loop_string:
    movb (%r11, %rsi, 1), %al
    cmp $0, %al
    je loop
    inc %rsi
    movb %al, outputString(%r8)
    inc %r8
    jmp loop_string

    jmp loop

check_procent:
    cmp $37, %al
    jne end_check_procent
    
    # if next c is %
    movb %al, outputString(%r8)
    inc %r8
    inc %rcx
    jmp loop

