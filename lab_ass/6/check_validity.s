.text
validS: .asciz "valid"
invalidS: .asciz "invalid"

.include "basic.s"

.global main

# *******************************************************************************************
# Subroutine: check_validity                                                                *
# Description: checks the validity of a string of parentheses as defined in Assignment 6.   *
# Parameters:                                                                               *
#   first: the string that should be check_validity                                         *
#   return: the result of the check, either "valid" or "invalid"                            *
# *******************************************************************************************
check_validity:
	# prologue
	pushq	%rbp 					# push the base pointer (and align the stack)
	movq	%rsp, %rbp				# copy stack pointer value to base pointer

	mov $0, %rcx					# index of the current character
	mov $0, %rax					# clear %rax

for_loop_beggining:					# for each character in the string
	movb (%rdi, %rcx, 1), %al		# load the current character
	cmp $0, %al
	je after_for_loop

	# if pharanteses is open
	# case '('
	cmp $'(', %al
	jne case1
	push $')'
	jmp for_loop_end

case1:								# case '['
	cmp $'[', %al
	jne case2
	push $']'
	jmp for_loop_end

case2:								# case '{'
	cmp $'{', %al
	jne case3
	push $'}'
	jmp for_loop_end

case3:								# case '<'
	cmp $'<', %al
	jne parantheses_close
	push $'>'
	jmp for_loop_end

# else parantheses is close
parantheses_close:
	pop %rdx
	cmp %dl, %al
	jne invalid

for_loop_end:
	inc %rcx
	jmp for_loop_beggining

after_for_loop:
	mov $validS, %rax
	cmp %rsp, %rbp				# check if stack is empty
	je end_check_validity

invalid:
	mov $invalidS, %rax

end_check_validity:
	# epilogue
	movq	%rbp, %rsp			# clear local variables from stack
	popq	%rbp				# restore base pointer location 
	ret

main:
	pushq	%rbp 				# push the base pointer (and align the stack)
	movq	%rsp, %rbp			# copy stack pointer value to base pointer

	movq	$MESSAGE, %rdi		# first parameter: address of the message
	call	check_validity		# call check_validity

	# print the result form %rax
	movq %rax, %rdi				# first parameter: address of the message
	call printf			

	popq	%rbp				# restore base pointer location 
	movq	$0, %rdi			# load program exit code
	call	exit				# exit the program

