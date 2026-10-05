__tmp_reg__ = 0
__zero_reg__ = 1
__SREG__ = 63
__SP_H__ = 62
__SP_L__ = 61
	.file	"delay.ll"
	.text
	.globl	delay_ms                        ; -- Begin function delay_ms
	.p2align	1
	.type	delay_ms,@function
delay_ms:                               ; @delay_ms
; %bb.0:
	push	r28
	push	r29
	in	r28, 61
	in	r29, 62
	sbiw	r28, 4
	in	r0, 63
	cli
	out	62, r29
	out	63, r0
	out	61, r28
	std	Y+4, r25
	std	Y+3, r24
	std	Y+2, r23
	std	Y+1, r22
	ldi	r24, 0
	ldi	r25, 0
	rjmp	.LBB0_2
.LBB0_1:                                ; %break_2
                                        ;   in Loop: Header=BB0_2 Depth=1
	ldd	r18, Y+1
	ldd	r19, Y+2
	ldd	r20, Y+3
	ldd	r21, Y+4
	subi	r18, 1
	sbci	r19, 0
	sbci	r20, 0
	sbci	r21, 0
	std	Y+2, r19
	std	Y+1, r18
	std	Y+4, r21
	std	Y+3, r20
.LBB0_2:                                ; %again_1
                                        ; =>This Loop Header: Depth=1
                                        ;     Child Loop BB0_6 Depth 2
	ldd	r20, Y+1
	ldd	r21, Y+2
	ldd	r22, Y+3
	ldd	r23, Y+4
	ldi	r18, 1
	cp	r20, r1
	cpc	r21, r1
	cpc	r22, r24
	cpc	r23, r25
	breq	.LBB0_4
; %bb.3:                                ; %again_1
                                        ;   in Loop: Header=BB0_2 Depth=1
	mov	r18, r1
.LBB0_4:                                ; %again_1
                                        ;   in Loop: Header=BB0_2 Depth=1
	andi	r18, 1
	cpi	r18, 0
	breq	.LBB0_5
	rjmp	.LBB0_10
.LBB0_5:                                ; %body_1
                                        ;   in Loop: Header=BB0_2 Depth=1
	in	r26, 61
	in	r27, 62
	sbiw	r26, 4
	andi	r26, 252
	in	r0, 63
	cli
	out	62, r27
	out	63, r0
	out	61, r26
	mov	r30, r26
	mov	r31, r27
	std	Z+3, r25
	std	Z+2, r24
	std	Z+1, r25
	st	Z, r24
.LBB0_6:                                ; %again_2
                                        ;   Parent Loop BB0_2 Depth=1
                                        ; =>  This Inner Loop Header: Depth=2
	ldd	r20, Z+2
	ldd	r21, Z+3
	ld	r22, Z
	ldd	r23, Z+1
	ldi	r18, 1
	cpi	r22, 124
	cpc	r23, r18
	cpc	r20, r24
	cpc	r21, r25
	brsh	.LBB0_8
; %bb.7:                                ; %again_2
                                        ;   in Loop: Header=BB0_6 Depth=2
	mov	r18, r1
.LBB0_8:                                ; %again_2
                                        ;   in Loop: Header=BB0_6 Depth=2
	andi	r18, 1
	cpi	r18, 0
	breq	.LBB0_9
	rjmp	.LBB0_1
.LBB0_9:                                ; %body_2
                                        ;   in Loop: Header=BB0_6 Depth=2
	ld	r18, Z
	ldd	r19, Z+1
	ldd	r20, Z+2
	ldd	r21, Z+3
	subi	r18, 255
	sbci	r19, 255
	sbci	r20, 255
	sbci	r21, 255
	std	Z+1, r19
	st	Z, r18
	std	Z+3, r21
	std	Z+2, r20
	rjmp	.LBB0_6
.LBB0_10:                               ; %break_1
	adiw	r28, 4
	in	r0, 63
	cli
	out	62, r29
	out	63, r0
	out	61, r28
	pop	r29
	pop	r28
	ret
.Lfunc_end0:
	.size	delay_ms, .Lfunc_end0-delay_ms
                                        ; -- End function
	.section	".note.GNU-stack","",@progbits
