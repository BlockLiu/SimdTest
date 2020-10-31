
simd:	file format Mach-O 64-bit x86-64

Disassembly of section __TEXT,__text:
__text:
; {
100000e50:	55 	pushq	%rbp
100000e51:	48 89 e5 	movq	%rsp, %rbp
100000e54:	48 81 ec a0 00 00 00 	subq	$160, %rsp
100000e5b:	48 8b 05 ae 01 00 00 	movq	430(%rip), %rax
100000e62:	48 8b 00 	movq	(%rax), %rax
100000e65:	48 89 45 f8 	movq	%rax, -8(%rbp)
100000e69:	c7 45 8c 00 00 00 00 	movl	$0, -116(%rbp)
; for(int i = 0; i < 8; ++i){
100000e70:	c7 45 88 00 00 00 00 	movl	$0, -120(%rbp)
100000e77:	83 7d 88 08 	cmpl	$8, -120(%rbp)
100000e7b:	0f 8d 31 00 00 00 	jge	49 <_main+0x62>
; a[i] = i;
100000e81:	8b 45 88 	movl	-120(%rbp), %eax
100000e84:	66 89 c1 	movw	%ax, %cx
100000e87:	48 63 55 88 	movslq	-120(%rbp), %rdx
100000e8b:	66 89 4c 55 e0 	movw	%cx, -32(%rbp,%rdx,2)
; b[i] = 8 - i;
100000e90:	b8 08 00 00 00 	movl	$8, %eax
100000e95:	2b 45 88 	subl	-120(%rbp), %eax
100000e98:	66 89 c1 	movw	%ax, %cx
100000e9b:	48 63 55 88 	movslq	-120(%rbp), %rdx
100000e9f:	66 89 4c 55 d0 	movw	%cx, -48(%rbp,%rdx,2)
; for(int i = 0; i < 8; ++i){
100000ea4:	8b 45 88 	movl	-120(%rbp), %eax
100000ea7:	83 c0 01 	addl	$1, %eax
100000eaa:	89 45 88 	movl	%eax, -120(%rbp)
100000ead:	e9 c5 ff ff ff 	jmp	-59 <_main+0x27>
100000eb2:	48 8d 45 e0 	leaq	-32(%rbp), %rax
; __m128i m = _mm_add_epi16(*(__m128i*)b, *(__m128i*)a);
100000eb6:	66 0f 6f 45 d0 	movdqa	-48(%rbp), %xmm0
100000ebb:	66 0f 6f 4d e0 	movdqa	-32(%rbp), %xmm1
100000ec0:	66 0f 7f 45 a0 	movdqa	%xmm0, -96(%rbp)
100000ec5:	66 0f 7f 4d 90 	movdqa	%xmm1, -112(%rbp)
100000eca:	66 0f 6f 45 a0 	movdqa	-96(%rbp), %xmm0
100000ecf:	66 0f 6f 4d 90 	movdqa	-112(%rbp), %xmm1
100000ed4:	66 0f fd c1 	paddw	%xmm1, %xmm0
100000ed8:	66 0f 7f 85 70 ff ff ff 	movdqa	%xmm0, -144(%rbp)
; _mm_store_si128((__m128i*)a, m);
100000ee0:	66 0f 6f 85 70 ff ff ff 	movdqa	-144(%rbp), %xmm0
100000ee8:	48 89 45 c8 	movq	%rax, -56(%rbp)
100000eec:	66 0f 7f 45 b0 	movdqa	%xmm0, -80(%rbp)
100000ef1:	66 0f 6f 45 b0 	movdqa	-80(%rbp), %xmm0
100000ef6:	48 8b 45 c8 	movq	-56(%rbp), %rax
100000efa:	66 0f 7f 00 	movdqa	%xmm0, (%rax)
; for(int i = 0; i < 8; ++i)
100000efe:	c7 85 6c ff ff ff 00 00 00 00 	movl	$0, -148(%rbp)
100000f08:	83 bd 6c ff ff ff 08 	cmpl	$8, -148(%rbp)
100000f0f:	0f 8d 3a 00 00 00 	jge	58 <_main+0xff>
; printf("a[%d]=%d\n", i, a[i]);
100000f15:	8b b5 6c ff ff ff 	movl	-148(%rbp), %esi
100000f1b:	48 63 85 6c ff ff ff 	movslq	-148(%rbp), %rax
100000f22:	0f bf 54 45 e0 	movswl	-32(%rbp,%rax,2), %edx
100000f27:	48 8d 3d 7a 00 00 00 	leaq	122(%rip), %rdi
100000f2e:	b0 00 	movb	$0, %al
100000f30:	e8 49 00 00 00 	callq	73 <simd.cpp+0x100000f7e>
100000f35:	89 85 68 ff ff ff 	movl	%eax, -152(%rbp)
; for(int i = 0; i < 8; ++i)
100000f3b:	8b 85 6c ff ff ff 	movl	-148(%rbp), %eax
100000f41:	83 c0 01 	addl	$1, %eax
100000f44:	89 85 6c ff ff ff 	movl	%eax, -148(%rbp)
100000f4a:	e9 b9 ff ff ff 	jmp	-71 <_main+0xb8>
100000f4f:	48 8b 05 ba 00 00 00 	movq	186(%rip), %rax
100000f56:	48 8b 00 	movq	(%rax), %rax
100000f59:	48 8b 4d f8 	movq	-8(%rbp), %rcx
100000f5d:	48 39 c8 	cmpq	%rcx, %rax
100000f60:	0f 85 0b 00 00 00 	jne	11 <_main+0x121>
100000f66:	31 c0 	xorl	%eax, %eax
; return 0;
100000f68:	48 81 c4 a0 00 00 00 	addq	$160, %rsp
100000f6f:	5d 	popq	%rbp
100000f70:	c3 	retq
100000f71:	e8 02 00 00 00 	callq	2 <simd.cpp+0x100000f78>
100000f76:	0f 0b 	ud2

_main:
; {
100000e50:	55 	pushq	%rbp
100000e51:	48 89 e5 	movq	%rsp, %rbp
100000e54:	48 81 ec a0 00 00 00 	subq	$160, %rsp
100000e5b:	48 8b 05 ae 01 00 00 	movq	430(%rip), %rax
100000e62:	48 8b 00 	movq	(%rax), %rax
100000e65:	48 89 45 f8 	movq	%rax, -8(%rbp)
100000e69:	c7 45 8c 00 00 00 00 	movl	$0, -116(%rbp)
; for(int i = 0; i < 8; ++i){
100000e70:	c7 45 88 00 00 00 00 	movl	$0, -120(%rbp)
100000e77:	83 7d 88 08 	cmpl	$8, -120(%rbp)
100000e7b:	0f 8d 31 00 00 00 	jge	49 <_main+0x62>
; a[i] = i;
100000e81:	8b 45 88 	movl	-120(%rbp), %eax
100000e84:	66 89 c1 	movw	%ax, %cx
100000e87:	48 63 55 88 	movslq	-120(%rbp), %rdx
100000e8b:	66 89 4c 55 e0 	movw	%cx, -32(%rbp,%rdx,2)
; b[i] = 8 - i;
100000e90:	b8 08 00 00 00 	movl	$8, %eax
100000e95:	2b 45 88 	subl	-120(%rbp), %eax
100000e98:	66 89 c1 	movw	%ax, %cx
100000e9b:	48 63 55 88 	movslq	-120(%rbp), %rdx
100000e9f:	66 89 4c 55 d0 	movw	%cx, -48(%rbp,%rdx,2)
; for(int i = 0; i < 8; ++i){
100000ea4:	8b 45 88 	movl	-120(%rbp), %eax
100000ea7:	83 c0 01 	addl	$1, %eax
100000eaa:	89 45 88 	movl	%eax, -120(%rbp)
100000ead:	e9 c5 ff ff ff 	jmp	-59 <_main+0x27>
100000eb2:	48 8d 45 e0 	leaq	-32(%rbp), %rax
; __m128i m = _mm_add_epi16(*(__m128i*)b, *(__m128i*)a);
100000eb6:	66 0f 6f 45 d0 	movdqa	-48(%rbp), %xmm0
100000ebb:	66 0f 6f 4d e0 	movdqa	-32(%rbp), %xmm1
100000ec0:	66 0f 7f 45 a0 	movdqa	%xmm0, -96(%rbp)
100000ec5:	66 0f 7f 4d 90 	movdqa	%xmm1, -112(%rbp)
100000eca:	66 0f 6f 45 a0 	movdqa	-96(%rbp), %xmm0
100000ecf:	66 0f 6f 4d 90 	movdqa	-112(%rbp), %xmm1
100000ed4:	66 0f fd c1 	paddw	%xmm1, %xmm0
100000ed8:	66 0f 7f 85 70 ff ff ff 	movdqa	%xmm0, -144(%rbp)
; _mm_store_si128((__m128i*)a, m);
100000ee0:	66 0f 6f 85 70 ff ff ff 	movdqa	-144(%rbp), %xmm0
100000ee8:	48 89 45 c8 	movq	%rax, -56(%rbp)
100000eec:	66 0f 7f 45 b0 	movdqa	%xmm0, -80(%rbp)
100000ef1:	66 0f 6f 45 b0 	movdqa	-80(%rbp), %xmm0
100000ef6:	48 8b 45 c8 	movq	-56(%rbp), %rax
100000efa:	66 0f 7f 00 	movdqa	%xmm0, (%rax)
; for(int i = 0; i < 8; ++i)
100000efe:	c7 85 6c ff ff ff 00 00 00 00 	movl	$0, -148(%rbp)
100000f08:	83 bd 6c ff ff ff 08 	cmpl	$8, -148(%rbp)
100000f0f:	0f 8d 3a 00 00 00 	jge	58 <_main+0xff>
; printf("a[%d]=%d\n", i, a[i]);
100000f15:	8b b5 6c ff ff ff 	movl	-148(%rbp), %esi
100000f1b:	48 63 85 6c ff ff ff 	movslq	-148(%rbp), %rax
100000f22:	0f bf 54 45 e0 	movswl	-32(%rbp,%rax,2), %edx
100000f27:	48 8d 3d 7a 00 00 00 	leaq	122(%rip), %rdi
100000f2e:	b0 00 	movb	$0, %al
100000f30:	e8 49 00 00 00 	callq	73 <simd.cpp+0x100000f7e>
100000f35:	89 85 68 ff ff ff 	movl	%eax, -152(%rbp)
; for(int i = 0; i < 8; ++i)
100000f3b:	8b 85 6c ff ff ff 	movl	-148(%rbp), %eax
100000f41:	83 c0 01 	addl	$1, %eax
100000f44:	89 85 6c ff ff ff 	movl	%eax, -148(%rbp)
100000f4a:	e9 b9 ff ff ff 	jmp	-71 <_main+0xb8>
100000f4f:	48 8b 05 ba 00 00 00 	movq	186(%rip), %rax
100000f56:	48 8b 00 	movq	(%rax), %rax
100000f59:	48 8b 4d f8 	movq	-8(%rbp), %rcx
100000f5d:	48 39 c8 	cmpq	%rcx, %rax
100000f60:	0f 85 0b 00 00 00 	jne	11 <_main+0x121>
100000f66:	31 c0 	xorl	%eax, %eax
; return 0;
100000f68:	48 81 c4 a0 00 00 00 	addq	$160, %rsp
100000f6f:	5d 	popq	%rbp
100000f70:	c3 	retq
100000f71:	e8 02 00 00 00 	callq	2 <simd.cpp+0x100000f78>
100000f76:	0f 0b 	ud2
Disassembly of section __TEXT,__stubs:
__stubs:
100000f78:	ff 25 9a 00 00 00 	jmpq	*154(%rip)
100000f7e:	ff 25 9c 00 00 00 	jmpq	*156(%rip)
Disassembly of section __TEXT,__stub_helper:
__stub_helper:
100000f84:	4c 8d 1d 7d 00 00 00 	leaq	125(%rip), %r11
100000f8b:	41 53 	pushq	%r11
100000f8d:	ff 25 6d 00 00 00 	jmpq	*109(%rip)
100000f93:	90 	nop
100000f94:	68 00 00 00 00 	pushq	$0
100000f99:	e9 e6 ff ff ff 	jmp	-26 </var/folders/b1/wp29l_n155lflv0g59lgn9zr0000gn/T/simd-591a57.o+0xa0633e38>
100000f9e:	68 18 00 00 00 	pushq	$24
100000fa3:	e9 dc ff ff ff 	jmp	-36 </var/folders/b1/wp29l_n155lflv0g59lgn9zr0000gn/T/simd-591a57.o+0xa0633e38>
