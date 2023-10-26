// rdi: address of h0 (h1, h2... are right next)
// rsi: address of 1st word in the array of 80 32-bit words 
	// 1st 16 of this array are set to the 16 32-bit words the chunk contains = w[0] -> w[15]
// Modify: h0 -> h4

.global sha1_chunk
sha1_chunk:
	# prologue
	push %rbp 					# push the base pointer (and align the stack)
	mov	%rsp, %rbp				# copy stack pointer value to base pointer
	
	# save the registers %r12, %r13, %r14, %r15, %ebx on the stack
	push %r12
	push %r13
	push %r14
	push %r15
    push %rbx
    push %rbx

	# for i from 16 to 79
	movl $16, %ecx				# mov 16 in %ecx
for_loop_16_to_79:
	# 	w[i] = (w[i-3] xor w[i-8] xor w[i-14] xor w[i-16]) leftrotate 1
	# calculate in %r10dw[i] = (w[i-3] xor w[i-8] xor w[i-14] xor w[i-16]) leftrotate 1 
	movl %ecx, %r9d 					# mov i in %r9
	subl $3, %r9d 					# calculate i - 3 in %r9

	movl (%rsi, %r9, 4), %r10d 		# save w[i-3] in %r10

	movl %ecx, %r9d 					# mov i in %r9
	subl $8, %r9d 					# calculate i - 8 in %r9
	movl (%rsi, %r9, 4), %r11d 		# save w[i-8] in %r11

	xor %r11d, %r10d 					# %r10d= w[i-3] ^ w[i-8]

	movl %ecx, %r9d 					# mov i in %r9
	subl $14, %r9d 					# calculate i - 14 in %r9
	movl (%rsi, %r9, 4), %r11d 		# save w[i-14] in %r11

	xor %r11d, %r10d 					# %r10d= w[i-3] ^ w[i-8] ^ w[i-14]

	movl %ecx, %r9d 					# mov i in %r9
	subl $16, %r9d 					# calculate i - 16 in %r9
	movl (%rsi, %r9, 4), %r11d 		# save w[i-16] in %r11

	xor %r11d, %r10d 					# %r10d= w[i-3] ^ w[i-8] ^ w[i-14] ^ w[i-16]
	
	rol $1, %r10d 					# %r10d= (w[i-3] ^ w[i-8] ^ w[i-14] ^ w[i-16]) leftrotate 1
	
	movl %r10d, (%rsi, %rcx, 4) 		# mov %r10din w[i] (*(w + i))
	
	inc %ecx 						# increment i
	cmp $79, %ecx 					# compare i with 79
	jle for_loop_16_to_79 			# if i <= 79, jump to for_loop_16_to_79


	# Initialize hash value for this chunk:
	
	movl (%rdi), %r12d				# move h0 into %r12d a
	movl 4(%rdi), %r13d				# move h1 into %r13d b
	movl 8(%rdi), %r14d				# move h2 into %r14d c
	movl 12(%rdi), %r15d				# move h3 into %r15d d
	movl 16(%rdi), %ebx				# move h4 into %ebx e
									# f = %r9
									# k = %r10


	# Main loop:[3][56]
	# for i from 0 to 79
	mov $0, %ecx
for_loop_0_to_79:
	# if 0 ≤ i ≤ 19 then
	cmp $0, %ecx
	jl else1
	cmp $19, %ecx
	jg else1
	
	# f = (b and c) or ((not b) and d)
	movl %r13d, %r9d				# %r9 = %r13				
	andl %r14d, %r9d				# %r9 = %r13d and %r14
	movl %r13d, %r11d				# %r11d= %r13
	not %r11d					# %r11d= not %r13
	and %r15d, %r11d				# %r11d= not %r13d and %r15
	or %r11d, %r9d				# %r9 = %r13d and %r14d or ((not %r13) and %r15)

	movl $0x5A827999, %r10d		# k = 0x5A827999

	jmp else4
	
	# else if 20 ≤ i ≤ 39
else1: 							
	cmp $20, %ecx
	jl else2
	cmp $39, %ecx
	jg else2
	
	# f = b xor c xor d
	movl %r13d, %r9d				# %r9 = %r13
	xor %r14d, %r9d				# %r9 = %r13d xor %r14
	xor %r15d, %r9d				# %r9 = %r13d xor %r14d xor %r15
	
	movl $0x6ED9EBA1, %r10d		# k = %r10d= 0x6ED9EBA1
	
	jmp else4

	# else if 40 ≤ i ≤ 59
else2:							
	cmp $40, %ecx
	jl else3
	cmp $59, %ecx
	jg else3
	
	# f = (b and c) or (b and d) or (c and d)
	movl %r13d, %r9d				# %r9 = %r13
	and %r14d, %r9d				# %r9 = %r13d and %r14
	movl %r13d, %r11d				# %r11d = %r13
	and %r15d, %r11d				# %r11d = %r13d and %r15
	or %r11d, %r9d				# %r9 = %r13d and %r14d or %r13d and %r15
	movl %r14d, %r11d				# %r11d = %r14
	and %r15d, %r11d				# %r11d = %r14d and %r15
	or %r11d, %r9d				# %r9 = (%r13d and %r14) or (%r13d and %r15) or (%r14d and %r15) 

	movl $0x8F1BBCDC, %r10d		# k = %r10d= 0x8F1BBCDC
	
	jmp else4

	# else if 60 ≤ i ≤ 79
else3: 							
	cmp $60, %ecx
	jl else4
	cmp $79, %ecx
	jg else4
	
	# f = b xor c xor d
	movl %r13d, %r9d				# %r9 = %r13
	xor %r14d, %r9d				# %r9 = %r13d xor %r14
	xor %r15d, %r9d				# %r9 = %r13d xor %r14d xor %r15
	
	movl $0xCA62C1D6, %r10d		# k = %r10d= 0xCA62C1D6

else4:
	# temp = %rax = (a leftrotate 5) + f + e + k + w[i]
	movl %r12d, %eax				# %rax = %r12
	rol $5, %eax				# %rax = %r12d leftrotate 5
	addl %r9d, %eax				# %rax = %r12d leftrotate 5 + %r9
	addl %ebx, %eax				# %rax = %r12d leftrotate 5 + %r9 + %ebx	
	addl %r10d, %eax
	
	movl (%rsi, %rcx, 4), %r8d	# %r8 = w[i]
	addl %r8d, %eax				# %rax = %r12d leftrotate 5 + %r9 + %ebx + w[i]

	movl %r15d, %ebx 				# e = d
	movl %r14d, %r15d				# d = c
	
	# c = b leftrotate 30
	movl %r13d, %r8d				# %r8 = %r13
	rol $30, %r8d				# %r8 = %r13d leftrotate 30
	movl %r8d, %r14d				# c = %r13d leftrotate 30
	 
	movl %r12d, %r13d				# b = a
	movl %eax, %r12d				# a = temp
	
	# i++
	inc %ecx
	cmp $79, %ecx
	jle for_loop_0_to_79

	# addl this chunk's hash to result so far:
	addl %r12d, (%rdi)			# h0 = h0 + a
	addl %r13d, 4(%rdi)			# h1 = h1 + b 
	addl %r14d, 8(%rdi)			# h2 = h2 + c
    addl %r15d, 12(%rdi)			# h3 = h3 + d
	addl %ebx, 16(%rdi)			# h4 = h4 + e

	# restore the registers %r12, %r13, %r14, %r15
    pop %rbx
    pop %rbx
    pop %r15
	pop %r14
	pop %r13
	pop %r12
	
	# epilogue
	mov	%rbp, %rsp				# clear local variables from stack
	pop	%rbp					# restore base pointer location
	ret
