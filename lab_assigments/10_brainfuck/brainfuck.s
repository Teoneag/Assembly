.global brainfuck

.data
vector: .skip 100000

.section .text
// format_str: .asciz "We should be executing the following code:\n%s"
input: .asciz "%c"
output: .asciz "%c"

# Your brainfuck subroutine will receive one argument:
# a zero terminated string containing the code to execute.
brainfuck:
	# prologue
	pushq	%rbp 					# push the base pointer (and align the stack)
	movq	%rsp, %rbp				# copy stack pointer value to base pointer

	# save the registers %r12, %r13, %r14, %r15 on the stack
	push %r12
	push %r13
	push %r14
	push %r15

	mov %rdi, %r12					# save the string in %r12
	
	// movq %rdi, %rsi
	// movq $format_str, %rdi
	// call printf
	// movq $0, %rax

	mov $0, %r13					# index of string
	mov $0, %r14					# index of vector
	mov $0, %r15					# nr of open parantheses

loop:
	cmpb $43, (%r12, %r13, 1)		# <
	je plus

	cmpb $45, (%r12, %r13, 1)		# >
	je minus

	cmpb $62, (%r12, %r13, 1)		# +
	je pointer_right

	cmpb $60, (%r12, %r13, 1)		# -
	je pointer_left

	cmpb $46, (%r12, %r13, 1)		# .
	je print

	cmpb $44, (%r12, %r13, 1)		# ,
	je scan

	cmpb $91, (%r12, %r13, 1)		# [
	je open_paranthesis

	cmpb $93, (%r12, %r13, 1)		# ]
	je closed_paranthesis

	back:
	inc %r13
	cmpb $0, (%r12, %r13, 1)
	jne loop

	jmp final

plus:
	incb vector(%r14)
	jmp back

minus:
	decb vector(%r14)
	jmp back

pointer_right:
	inc %r14
	jmp back

pointer_left:
	dec %r14
	jmp back


# if s[is] = '['
open_paranthesis:
	cmpb $0, vector(%r14)
	# if vector[ic] != 0
	jne back

	# if vector[ic] == 0
	inc %r15						# add the initial '['
	find_close_paranthesis:			# go to the the coresponding ']'
		inc %r13

		cmpb $91, (%r12, %r13, 1)	# for each '[' increment %r15
		jne end_case_1
		inc %r15
		jmp find_close_paranthesis

		end_case_1:					# for each ']' decrement %r15
		cmpb $93, (%r12, %r13, 1)
		jne find_close_paranthesis
		dec %r15

		cmp $0, %r15				#  %r15 == 0, we found the coresponding ']'
		jne find_close_paranthesis

	jmp back						# jump back

closed_paranthesis:
# if s[is] == ']'
	# if vector[ic] == 0
	cmpb $0, vector(%r14)
	je back
	
	# if vector[ic] != 0
	dec %r15						# decrement %r15
	find_open_paranthesis:			# go to the coresponding '['
	dec %r13

	cmpb $93, (%r12, %r13, 1)		# for each ']' decrement %r15
	jne end_case_2
	dec %r15
	jmp find_open_paranthesis

	end_case_2:					# for each '[' increment %r15
	cmpb $91, (%r12, %r13, 1)
	jne find_open_paranthesis
	inc %r15

	cmp $0, %r15				#  %r15 == 0, we found the coresponding '['
	jne find_open_paranthesis
	
	dec %r13					# decrement %r13 to point to the '['
	jmp back

print:
	mov $output, %rdi
	mov vector(%r14), %rsi
	# output the char x
	// mov $'c', %rsi
	call printf
	jmp back

scan:
	mov $input, %rdi
	lea vector(%r14), %rsi
	call scanf
	jmp back

final:
	# restore the registers %r12, %r13, %r14, %r15
	pop %r15
	pop %r14
	pop %r13
	pop %r12

	# epilogue
	movq	%rbp, %rsp			# clear local variables from stack
	popq	%rbp				# restore base pointer location 
	ret