.text
output: .asciz "%c"
outputColor: .asciz "\x1B[38;5;%ldm\x1B[48;5;%ldm"
outputEfects: .asciz "\x1B[%ldm"

.include "final.s" 

.global main

# ************************************************************
# Subroutine: decode                                         *
# Description: decodes message as defined in Assignment 3    *
#   - 1 byte - colour of the bg                              *
#   - 1 byte - colour of the fg (char)                       *
#   - 4 byte index  - next memory block to visit             *
#   - 1 byte amount - nr of times to print                   *
#   - 1 byte character - ASCI character                      *
# Parameters:                                                *
#   first: the address of the message to read                *
#   return: no return value                                  *
# ************************************************************
decode:
	# prologue
	push %rbp 					# push the base pointer (and align the stack)
	mov	%rsp, %rbp				# copy stack pointer value to base pointer

    # save the adress of the message on the stack - twice as we use -16 for rcx
    push %rdi
    push %rdi
	
    # save the registers %r12, %r13, %r14, %r15, %rbx on the stack
	push %r12
	push %r13
	push %r14
	push %r15
    push %rbx
    push %rbx

    mov $0, %rcx				# clear %rcx

startDecode:
	mov -8(%rbp), %rdi			# get the address of the message
    mov	(%rdi, %rcx, 8), %r12	# save the quadWord in %r12
	
	# save the char: 8th byte in %r13
	mov $0, %r13
	movb %r12b, %r13b

	# save the nr: 7th byte in %r14
	shr $8, %r12
	mov $0, %r14
	movb %r12b, %r14b

	# save the bytes 3 to 6 (EAX) in %rcx
	shr $8, %r12				# shift the 8 bits to the right
	mov $0, %rcx 				# clear %rcx
	mov %r12d, %ecx				# copy the 3rd to 6th byte to %ecx
	mov %rcx, -16(%rbp)         # save the value of %rcx on the stack

    # save the 2nd byte in %r15
    shr $32, %r12
    mov $0, %r15
    movb %r12b, %r15b

    # save the 1st byte in %rbx
    shr $8, %r12
    mov $0, %rbx
    movb %r12b, %bl

    # print the char saved in %r13 %r14 times with the bg r15 and the fg rbx
printLoop:
    # if (%r15 == %rbx) print effect
    cmp %r15, %rbx
    je printEffectLoop

    # else print the outputColor to set the bg and the fg
    mov $0, %rax
    mov $outputColor, %rdi
    mov %r15, %rsi
    mov %rbx, %rdx
    call printf
    jmp endPrintEffectLoop

printEffectLoop: # print effect
    mov $outputEfects, %rdi
    
    cmp $0, %r15
    je reset
    cmp $37, %r15
    je stopBlinking
    cmp $42, %r15
    je bold
    cmp $66, %r15
    je faint
    cmp $105, %r15
    je conceal
    cmp $153, %r15
    je reveal
    cmp $182, %r15
    je blink
reset: # 0 - 0 reset
    mov $0, %rsi
    jmp printEffect
stopBlinking: # 37 - 25 stopBlinking
    mov $25, %rsi
    jmp printEffect
bold: # 42 - 1 bold
    mov $1, %rsi
    jmp printEffect
faint: # 66 - 2 faint
    mov $2, %rsi
    jmp printEffect
conceal: # 105 - 8 conceal
    mov $8, %rsi
    jmp printEffect
reveal: # 153 - 28 reveal
    mov $28, %rsi
    jmp printEffect
blink: # 182 - 5 blink
    mov $5, %rsi
    jmp printEffect

printEffect:
    mov $0, %rax
    mov $outputEfects, %rdi
    call printf

endPrintEffectLoop: # print the char saved in %r13 %r14 times
	mov $0, %rax
	mov $output, %rdi
	mov %r13, %rsi
	call printf
	dec %r14
	cmp $0, %r14
	jg printLoop

    # restore the value of %rcx
    mov -16(%rbp), %rcx

	# if the address (%rcx) is not 0, call decode
	cmp $0, %rcx
	jne startDecode

	# restore the registers %r12, %r13, %r14, %r15
    pop %rbx
    pop %rbx
    pop %r15
	pop %r14
	pop %r13
	pop %r12
    pop %rdi
    pop %rdi

	# epilogue
	mov	%rbp, %rsp				# clear local variables from stack
	pop	%rbp					# restore base pointer location 
	ret

main:
	# prologue
	push %rbp 					# push the base pointer (and align the stack)
	mov	%rsp, %rbp				# copy stack pointer value to base pointer

	# call decode
	mov	$MESSAGE, %rdi			# 1st parameter: address of the message
	mov $0, %rcx 				# 2nd parameter: displacement of the message 
	call decode

	# epilogue	
	mov	%rbp, %rsp				# clear local variables from stack
	pop	%rbp					# restore base pointer location 
	mov	$0, %rdi				
	call exit					
