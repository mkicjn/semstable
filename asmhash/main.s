.include "chomp.s"
.include "hash_key.s"
.include "new_table.s"
.include "free_table.s"
.include "new_bucket.s"
.include "free_bucket.s"
.include "get_entry.s"
.include "set_entry.s"
.include "add_bucket.s"
.include "add_entry.s"

form:
	.string	"%s -> %lu\n"
teststr:
	.string "test"
test2str:
	.string "test2"

.globl	main
.type	main, @function
main:
	pushq	%rbp
	movq	%rsp, %rbp
	# Make a new table, send to rbx
	movq	$1, %rdi
	call	new_table
	movq	%rax, %rbx
	# Add an entry as teststr -> teststr
	movq	%rbx, %rdi
	leaq	teststr(%rip), %rsi
	movq	%rsi, %rdx
	call	add_entry
	# Retrieve the entry for teststr and print
	movq	%rbx, %rdi
	leaq	teststr(%rip), %rsi
	call	get_entry
	movq	%rax, %rdi
	call	puts@plt
	# Set the entry for teststr to test2str
	movq	%rbx, %rdi
	leaq	teststr(%rip), %rsi
	leaq	test2str(%rip), %rdx
	call	set_entry
	# Retrieve the entry for teststr and print (copy)
	movq	%rbx, %rdi
	leaq	teststr(%rip), %rsi
	call	get_entry
	movq	%rax, %rdi
	call	puts@plt
	# Not freeing memory; free functions expect malloc'd vals
	# Must free manually here; doesn't serve testing purposes

/*	# Old key test
	# Allocate 100 bytes for string
	movq	$100, %rdi
	call	malloc@plt
	movq	%rax, %rbx # Save address in non-volatile register
	# Read string
	xorq	%rdi, %rdi
	movq	%rbx, %rsi
	movq	$99, %rdx
	call	read@plt
	# Remove trailing newline, get key
	movq	%rbx, %rdi
	call	chomp
	movq	%rbx, %rdi
	call	hash_key
	# Print string and resulting key
	leaq	form(%rip), %rdi
	movq	%rbx, %rsi
	movq	%rax, %rdx
	call	printf@plt
*/

	# Done
	popq	%rbp
	xorq	%rax, %rax
	ret
