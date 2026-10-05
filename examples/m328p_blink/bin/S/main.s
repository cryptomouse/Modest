__tmp_reg__ = 0
__zero_reg__ = 1
__SREG__ = 63
__SP_H__ = 62
__SP_L__ = 61
	.file	"main.ll"
	.text
	.globl	main                            ; -- Begin function main
	.p2align	1
	.type	main,@function
main:                                   ; @main
; %bb.0:
	push	r10
	push	r11
	push	r12
	push	r13
	push	r15
	push	r16
	push	r17
	ldi	r24, -1
	mov	r15, r24
	sts	1, r24
	ldi	r24, 232
	ldi	r25, 3
	mov	r10, r24
	mov	r11, r25
	ldi	r16, 0
	ldi	r17, 0
.LBB0_1:                                ; %again_1
                                        ; =>This Inner Loop Header: Depth=1
	mov	r24, r15
	sts	2, r24
	mov	r12, r10
	mov	r13, r11
	mov	r22, r12
	mov	r23, r13
	mov	r24, r16
	mov	r25, r17
	rcall	delay_ms
	sts	2, r1
	mov	r22, r12
	mov	r23, r13
	mov	r24, r16
	mov	r25, r17
	rcall	delay_ms
	rjmp	.LBB0_1
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
                                        ; -- End function
	.section	".note.GNU-stack","",@progbits
