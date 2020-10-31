
noSimd:	file format Mach-O 64-bit x86-64

Disassembly of section __TEXT,__text:
__text:
; {
100000e30:	55 	pushq	%rbp
100000e31:	48 89 e5 	movq	%rsp, %rbp
100000e34:	48 83 ec 40 	subq	$64, %rsp
100000e38:	48 8b 05 d1 01 00 00 	movq	465(%rip), %rax
100000e3f:	48 8b 00 	movq	(%rax), %rax
100000e42:	48 89 45 f8 	movq	%rax, -8(%rbp)
100000e46:	c7 45 cc 00 00 00 00 	movl	$0, -52(%rbp)
; for(int i = 0; i < 8; ++i){
100000e4d:	c7 45 c8 00 00 00 00 	movl	$0, -56(%rbp)
100000e54:	83 7d c8 08 	cmpl	$8, -56(%rbp)
100000e58:	0f 8d 31 00 00 00 	jge	49 <_main+0x5f>
; a[i] = i;
100000e5e:	8b 45 c8 	movl	-56(%rbp), %eax
100000e61:	66 89 c1 	movw	%ax, %cx
100000e64:	48 63 55 c8 	movslq	-56(%rbp), %rdx
100000e68:	66 89 4c 55 e0 	movw	%cx, -32(%rbp,%rdx,2)
; b[i] = 8 - i;
100000e6d:	b8 08 00 00 00 	movl	$8, %eax
100000e72:	2b 45 c8 	subl	-56(%rbp), %eax
100000e75:	66 89 c1 	movw	%ax, %cx
100000e78:	48 63 55 c8 	movslq	-56(%rbp), %rdx
100000e7c:	66 89 4c 55 d0 	movw	%cx, -48(%rbp,%rdx,2)
; for(int i = 0; i < 8; ++i){
100000e81:	8b 45 c8 	movl	-56(%rbp), %eax
100000e84:	83 c0 01 	addl	$1, %eax
100000e87:	89 45 c8 	movl	%eax, -56(%rbp)
100000e8a:	e9 c5 ff ff ff 	jmp	-59 <_main+0x24>
; a[0] += b[0];
100000e8f:	0f bf 45 d0 	movswl	-48(%rbp), %eax
100000e93:	0f bf 4d e0 	movswl	-32(%rbp), %ecx
100000e97:	01 c1 	addl	%eax, %ecx
100000e99:	66 89 ca 	movw	%cx, %dx
100000e9c:	66 89 55 e0 	movw	%dx, -32(%rbp)
; a[1] += b[1];
100000ea0:	0f bf 45 d2 	movswl	-46(%rbp), %eax
100000ea4:	0f bf 4d e2 	movswl	-30(%rbp), %ecx
100000ea8:	01 c1 	addl	%eax, %ecx
100000eaa:	66 89 ca 	movw	%cx, %dx
100000ead:	66 89 55 e2 	movw	%dx, -30(%rbp)
; a[2] += b[2];
100000eb1:	0f bf 45 d4 	movswl	-44(%rbp), %eax
100000eb5:	0f bf 4d e4 	movswl	-28(%rbp), %ecx
100000eb9:	01 c1 	addl	%eax, %ecx
100000ebb:	66 89 ca 	movw	%cx, %dx
100000ebe:	66 89 55 e4 	movw	%dx, -28(%rbp)
; a[3] += b[3];
100000ec2:	0f bf 45 d6 	movswl	-42(%rbp), %eax
100000ec6:	0f bf 4d e6 	movswl	-26(%rbp), %ecx
100000eca:	01 c1 	addl	%eax, %ecx
100000ecc:	66 89 ca 	movw	%cx, %dx
100000ecf:	66 89 55 e6 	movw	%dx, -26(%rbp)
; a[4] += b[4];
100000ed3:	0f bf 45 d8 	movswl	-40(%rbp), %eax
100000ed7:	0f bf 4d e8 	movswl	-24(%rbp), %ecx
100000edb:	01 c1 	addl	%eax, %ecx
100000edd:	66 89 ca 	movw	%cx, %dx
100000ee0:	66 89 55 e8 	movw	%dx, -24(%rbp)
; a[5] += b[5];
100000ee4:	0f bf 45 da 	movswl	-38(%rbp), %eax
100000ee8:	0f bf 4d ea 	movswl	-22(%rbp), %ecx
100000eec:	01 c1 	addl	%eax, %ecx
100000eee:	66 89 ca 	movw	%cx, %dx
100000ef1:	66 89 55 ea 	movw	%dx, -22(%rbp)
; a[6] += b[6];
100000ef5:	0f bf 45 dc 	movswl	-36(%rbp), %eax
100000ef9:	0f bf 4d ec 	movswl	-20(%rbp), %ecx
100000efd:	01 c1 	addl	%eax, %ecx
100000eff:	66 89 ca 	movw	%cx, %dx
100000f02:	66 89 55 ec 	movw	%dx, -20(%rbp)
; a[7] += b[7];
100000f06:	0f bf 45 de 	movswl	-34(%rbp), %eax
100000f0a:	0f bf 4d ee 	movswl	-18(%rbp), %ecx
100000f0e:	01 c1 	addl	%eax, %ecx
100000f10:	66 89 ca 	movw	%cx, %dx
100000f13:	66 89 55 ee 	movw	%dx, -18(%rbp)
; for(int i = 0; i < 8; ++i)
100000f17:	c7 45 c4 00 00 00 00 	movl	$0, -60(%rbp)
100000f1e:	83 7d c4 08 	cmpl	$8, -60(%rbp)
100000f22:	0f 8d 2b 00 00 00 	jge	43 <_main+0x123>
; printf("a[%d]=%d\n", i, a[i]);
100000f28:	8b 75 c4 	movl	-60(%rbp), %esi
100000f2b:	48 63 45 c4 	movslq	-60(%rbp), %rax
100000f2f:	0f bf 54 45 e0 	movswl	-32(%rbp,%rax,2), %edx
100000f34:	48 8d 3d 71 00 00 00 	leaq	113(%rip), %rdi
100000f3b:	b0 00 	movb	$0, %al
100000f3d:	e8 3e 00 00 00 	callq	62 <noSimd.cpp+0x100000f80>
100000f42:	89 45 c0 	movl	%eax, -64(%rbp)
; for(int i = 0; i < 8; ++i)
100000f45:	8b 45 c4 	movl	-60(%rbp), %eax
100000f48:	83 c0 01 	addl	$1, %eax
100000f4b:	89 45 c4 	movl	%eax, -60(%rbp)
100000f4e:	e9 cb ff ff ff 	jmp	-53 <_main+0xee>
100000f53:	48 8b 05 b6 00 00 00 	movq	182(%rip), %rax
100000f5a:	48 8b 00 	movq	(%rax), %rax
100000f5d:	48 8b 4d f8 	movq	-8(%rbp), %rcx
100000f61:	48 39 c8 	cmpq	%rcx, %rax
100000f64:	0f 85 08 00 00 00 	jne	8 <_main+0x142>
100000f6a:	31 c0 	xorl	%eax, %eax
; return 0;
100000f6c:	48 83 c4 40 	addq	$64, %rsp
100000f70:	5d 	popq	%rbp
100000f71:	c3 	retq
100000f72:	e8 03 00 00 00 	callq	3 <noSimd.cpp+0x100000f7a>
100000f77:	0f 0b 	ud2

_main:
; {
100000e30:	55 	pushq	%rbp
100000e31:	48 89 e5 	movq	%rsp, %rbp
100000e34:	48 83 ec 40 	subq	$64, %rsp
100000e38:	48 8b 05 d1 01 00 00 	movq	465(%rip), %rax
100000e3f:	48 8b 00 	movq	(%rax), %rax
100000e42:	48 89 45 f8 	movq	%rax, -8(%rbp)
100000e46:	c7 45 cc 00 00 00 00 	movl	$0, -52(%rbp)
; for(int i = 0; i < 8; ++i){
100000e4d:	c7 45 c8 00 00 00 00 	movl	$0, -56(%rbp)
100000e54:	83 7d c8 08 	cmpl	$8, -56(%rbp)
100000e58:	0f 8d 31 00 00 00 	jge	49 <_main+0x5f>
; a[i] = i;
100000e5e:	8b 45 c8 	movl	-56(%rbp), %eax
100000e61:	66 89 c1 	movw	%ax, %cx
100000e64:	48 63 55 c8 	movslq	-56(%rbp), %rdx
100000e68:	66 89 4c 55 e0 	movw	%cx, -32(%rbp,%rdx,2)
; b[i] = 8 - i;
100000e6d:	b8 08 00 00 00 	movl	$8, %eax
100000e72:	2b 45 c8 	subl	-56(%rbp), %eax
100000e75:	66 89 c1 	movw	%ax, %cx
100000e78:	48 63 55 c8 	movslq	-56(%rbp), %rdx
100000e7c:	66 89 4c 55 d0 	movw	%cx, -48(%rbp,%rdx,2)
; for(int i = 0; i < 8; ++i){
100000e81:	8b 45 c8 	movl	-56(%rbp), %eax
100000e84:	83 c0 01 	addl	$1, %eax
100000e87:	89 45 c8 	movl	%eax, -56(%rbp)
100000e8a:	e9 c5 ff ff ff 	jmp	-59 <_main+0x24>
; a[0] += b[0];
100000e8f:	0f bf 45 d0 	movswl	-48(%rbp), %eax
100000e93:	0f bf 4d e0 	movswl	-32(%rbp), %ecx
100000e97:	01 c1 	addl	%eax, %ecx
100000e99:	66 89 ca 	movw	%cx, %dx
100000e9c:	66 89 55 e0 	movw	%dx, -32(%rbp)
; a[1] += b[1];
100000ea0:	0f bf 45 d2 	movswl	-46(%rbp), %eax
100000ea4:	0f bf 4d e2 	movswl	-30(%rbp), %ecx
100000ea8:	01 c1 	addl	%eax, %ecx
100000eaa:	66 89 ca 	movw	%cx, %dx
100000ead:	66 89 55 e2 	movw	%dx, -30(%rbp)
; a[2] += b[2];
100000eb1:	0f bf 45 d4 	movswl	-44(%rbp), %eax
100000eb5:	0f bf 4d e4 	movswl	-28(%rbp), %ecx
100000eb9:	01 c1 	addl	%eax, %ecx
100000ebb:	66 89 ca 	movw	%cx, %dx
100000ebe:	66 89 55 e4 	movw	%dx, -28(%rbp)
; a[3] += b[3];
100000ec2:	0f bf 45 d6 	movswl	-42(%rbp), %eax
100000ec6:	0f bf 4d e6 	movswl	-26(%rbp), %ecx
100000eca:	01 c1 	addl	%eax, %ecx
100000ecc:	66 89 ca 	movw	%cx, %dx
100000ecf:	66 89 55 e6 	movw	%dx, -26(%rbp)
; a[4] += b[4];
100000ed3:	0f bf 45 d8 	movswl	-40(%rbp), %eax
100000ed7:	0f bf 4d e8 	movswl	-24(%rbp), %ecx
100000edb:	01 c1 	addl	%eax, %ecx
100000edd:	66 89 ca 	movw	%cx, %dx
100000ee0:	66 89 55 e8 	movw	%dx, -24(%rbp)
; a[5] += b[5];
100000ee4:	0f bf 45 da 	movswl	-38(%rbp), %eax
100000ee8:	0f bf 4d ea 	movswl	-22(%rbp), %ecx
100000eec:	01 c1 	addl	%eax, %ecx
100000eee:	66 89 ca 	movw	%cx, %dx
100000ef1:	66 89 55 ea 	movw	%dx, -22(%rbp)
; a[6] += b[6];
100000ef5:	0f bf 45 dc 	movswl	-36(%rbp), %eax
100000ef9:	0f bf 4d ec 	movswl	-20(%rbp), %ecx
100000efd:	01 c1 	addl	%eax, %ecx
100000eff:	66 89 ca 	movw	%cx, %dx
100000f02:	66 89 55 ec 	movw	%dx, -20(%rbp)
; a[7] += b[7];
100000f06:	0f bf 45 de 	movswl	-34(%rbp), %eax
100000f0a:	0f bf 4d ee 	movswl	-18(%rbp), %ecx
100000f0e:	01 c1 	addl	%eax, %ecx
100000f10:	66 89 ca 	movw	%cx, %dx
100000f13:	66 89 55 ee 	movw	%dx, -18(%rbp)
; for(int i = 0; i < 8; ++i)
100000f17:	c7 45 c4 00 00 00 00 	movl	$0, -60(%rbp)
100000f1e:	83 7d c4 08 	cmpl	$8, -60(%rbp)
100000f22:	0f 8d 2b 00 00 00 	jge	43 <_main+0x123>
; printf("a[%d]=%d\n", i, a[i]);
100000f28:	8b 75 c4 	movl	-60(%rbp), %esi
100000f2b:	48 63 45 c4 	movslq	-60(%rbp), %rax
100000f2f:	0f bf 54 45 e0 	movswl	-32(%rbp,%rax,2), %edx
100000f34:	48 8d 3d 71 00 00 00 	leaq	113(%rip), %rdi
100000f3b:	b0 00 	movb	$0, %al
100000f3d:	e8 3e 00 00 00 	callq	62 <noSimd.cpp+0x100000f80>
100000f42:	89 45 c0 	movl	%eax, -64(%rbp)
; for(int i = 0; i < 8; ++i)
100000f45:	8b 45 c4 	movl	-60(%rbp), %eax
100000f48:	83 c0 01 	addl	$1, %eax
100000f4b:	89 45 c4 	movl	%eax, -60(%rbp)
100000f4e:	e9 cb ff ff ff 	jmp	-53 <_main+0xee>
100000f53:	48 8b 05 b6 00 00 00 	movq	182(%rip), %rax
100000f5a:	48 8b 00 	movq	(%rax), %rax
100000f5d:	48 8b 4d f8 	movq	-8(%rbp), %rcx
100000f61:	48 39 c8 	cmpq	%rcx, %rax
100000f64:	0f 85 08 00 00 00 	jne	8 <_main+0x142>
100000f6a:	31 c0 	xorl	%eax, %eax
; return 0;
100000f6c:	48 83 c4 40 	addq	$64, %rsp
100000f70:	5d 	popq	%rbp
100000f71:	c3 	retq
100000f72:	e8 03 00 00 00 	callq	3 <noSimd.cpp+0x100000f7a>
100000f77:	0f 0b 	ud2
Disassembly of section __TEXT,__stubs:
__stubs:
100000f7a:	ff 25 98 00 00 00 	jmpq	*152(%rip)
100000f80:	ff 25 9a 00 00 00 	jmpq	*154(%rip)
Disassembly of section __TEXT,__stub_helper:
__stub_helper:
100000f88:	4c 8d 1d 79 00 00 00 	leaq	121(%rip), %r11
100000f8f:	41 53 	pushq	%r11
100000f91:	ff 25 69 00 00 00 	jmpq	*105(%rip)
100000f97:	90 	nop
100000f98:	68 00 00 00 00 	pushq	$0
100000f9d:	e9 e6 ff ff ff 	jmp	-26 </var/folders/b1/wp29l_n155lflv0g59lgn9zr0000gn/T/noSimd-b49b55.o+0xa062ed32>
100000fa2:	68 18 00 00 00 	pushq	$24
100000fa7:	e9 dc ff ff ff 	jmp	-36 </var/folders/b1/wp29l_n155lflv0g59lgn9zr0000gn/T/noSimd-b49b55.o+0xa062ed32>
