.text
output: .asciz "%c"

.include "final.s"

.global main

# ************************************************************
# Subroutine: decode                                         *
# Description: decodes message as defined in Assignment 3    *
#   - 2 byte unknown - useless                               *
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

	# save the registers %r12, %r13, %r14, %r15
	push %r12
	push %r13
	push %r14
	push %r15

	# save the address of the message in %r15
	mov %rdi, %r15

startDecode:
	mov	(%r15, %rcx, 8), %r12	# save the quadWord in %r12
	
	# save the char: 8th byte in %r13
	mov $0, %r13
	movb %r12b, %r13b

	# save the nr: 7th byte in %r14
	shr $8, %r12
	mov $0, %r14
	movb %r12b, %r14b

	# print the char saved in %r13 %r14 times
printLoop:
	mov $0, %rax
	mov $output, %rdi
	mov %r13, %rsi
	call printf
	dec %r14
	cmp $0, %r14
	jg printLoop

	# save the bytes 3 to 6 (EAX) in %rcx
	shr $8, %r12				# shift the 8 bits to the right
	mov $0, %rcx 				# clear %rcx
	mov %r12d, %ecx				# copy the 3rd to 6th byte to %ecx
	
	# if the address (%rcx) is not 0, call decode
	cmp $0, %rcx
	jne startDecode

	# restore the registers %r12, %r13, %r14, %r15
	pop %r15
	pop %r14
	pop %r13
	pop %r12

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
