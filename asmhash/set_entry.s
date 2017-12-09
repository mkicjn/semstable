.type	set_entry, @function
set_entry: # (table_t *table,char *str,void *entry)
	# Lazy hack:
	pushq	%rdi
	pushq	%rdx
	movq	%rsi, %rdi
	call	hash_key
	movq	%rax, %rsi
	popq	%rdx
	popq	%rdi

	movq	%rdx, %rcx # entry
	movq	%rsi, %rax # table->size
	xorq	%rdx, %rdx
	divq	(%rdi) # rdx=key%table->size
	movq	8(%rdi), %rdi # mem
	movq	(%rdi,%rdx,8), %rax # bucket_t *def=mem[rdx]
	cmpq	$0, %rax
	jz	.set_entry_x
	.set_entry_l:
	cmpq	$0, %rax # def==0
	jz	.set_entry_x
	cmpq	%rsi, (%rax) # def->key==key
	je	.set_entry_s
	movq	16(%rax), %rax # def=def->next
	jmp	.set_entry_l
	.set_entry_s:
	movq	%rcx, 8(%rax) # def->val=entry
	.set_entry_x:
	ret