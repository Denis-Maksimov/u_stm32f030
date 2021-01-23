.cpu cortex-m0      /* ограничиваем ассемблер списком существующих инструкций */
.syntax unified
.arch armv6-m
.thumb
.align 1

//Return double y minus double x
    .align 1					
    .thumb_func					
    .weak    __aeabi_drsub			
    .type    __aeabi_drsub, %function
__aeabi_drsub:
    eor	r1, r1, #0x80000000
    b	__adddf3
    .size   __aeabi_drsub, . - __aeabi_drsub


__aeabi_dsub:
    eor	r3, r3, #0x80000000

__adddf3:
    push	{r4, r5, lr}
 	lsl	r4, r1, #1
 	lsl	r5, r3, #1
 	teq	r4, r5
  	teqeq	r0, r2
  	orrsne	ip, r4, r0
 	orrsne	ip, r5, r2
 	mvnsne	ip, r4, asr #21
  	mvnsne	ip, r5, asr #21
  	beq	.L1
  	lsr	r4, r4, #21
  	rsbs	r5, r4, r5, lsr #21
  	rsblt	r5, r5, #0
  	ble	.L2
 	add	r4, r4, r5
  	eor	r2, r0, r2
  	eor	r3, r1, r3
  	eor	r0, r2, r0
  	eor	r1, r3, r1
  	eor	r2, r0, r2
  	eor	r3, r1, r3
 .L2:	
    cmp	r5, #54	; 0x36
  	pophi	{r4, r5, lr}
  	bxhi	lr
  	tst	r1, #0x80000000
  	lsl	r1, r1, #12
  	mov	ip, #0x100000
  	orr	r1, ip, r1, lsr #12
  	beq	.L3
  	rsbs	r0, r0, #0
  	rsc	r1, r1, #0
 .L3:	tst	r3, #0x80000000
  	lsl	r3, r3, #12
  	orr	r3, ip, r3, lsr #12
  	beq	.L4
  	rsbs	r2, r2, #0
 rsc	r3, r3, #0
 .L4:	teq	r4, r5
 beq	.L5 
 .L16:	sub	r4, r4, #1
 rsbs	lr, r5, #32
 blt	.L6 
 lsl	ip, r2, lr
 adds	r0, r0, r2, lsr r5
 adc	r1, r1, #0
 adds	r0, r0, r3, lsl lr
 adcs	r1, r1, r3, asr r5
 b	.L7
 .L6:	sub	r5, r5, #32
 add	lr, lr, #32
 cmp	r2, #1
 lsl	ip, r3, lr
 orrcs	ip, ip, #2
 adds	r0, r0, r3, asr r5
 adcs	r1, r1, r3, asr #31
 .L7:	and	r5, r1, #0x80000000
 bpl	.L8
 rsbs	ip, ip, #0
 rscs	r0, r0, #0
 rsc	r1, r1, #0
 .L8:	cmp	r1, #0x100000
 bcc	.L49
 cmp	r1, #2097152	; 0x200000
 bcc	.L9
 lsrs	r1, r1, #1
 rrxs	r0, r0
 rrx	ip, ip
 add	r4, r4, #1
 lsl	r2, r4, #21
 cmn	r2, #0x400000
 bcs	.L10
 .L9:	cmp	ip, #0x80000000
 lsrseq	ip, r0, #1
 adcs	r0, r0, #0
 adc	r1, r1, r4, lsl #20
 orr	r1, r1, r5
 pop	{r4, r5, lr}
 bx	lr
 .L49 lsls	ip, ip, #1
 adcs	r0, r0, r0
 adc	r1, r1, r1
 tst	r1, #0x100000
 sub	r4, r4, #1
 bne	.L9 <__adddf3+0x11c>
 .L19:	e3310000 	teq	r1, #0
 movne	r3, #20
 moveq	r3, #52	; 0x34
 moveq	r1, r0
 moveq	r0, #0
 mov	r2, r1
 cmp	r2, #0x10000
 lsrcs	r2, r2, #16
 subcs	r3, r3, #16
 cmp	r2, #0x100
 lsrcs	r2, r2, #8
 subcs	r3, r3, #8
 cmp	r2, #16
 lsrcs	r2, r2, #4
 subcs	r3, r3, #4
 cmp	r2, #4
 subcs	r3, r3, #2
 subcc	r3, r3, r2, lsr #1
 sub	r3, r3, r2, lsr #3
 subs	r2, r3, #32
 bge	.L11 <__adddf3+0x1c4>
 adds	r2, r2, #12
 ble	.L12 <__adddf3+0x1c0>
 add	ip, r2, #20
 rsb	r2, r2, #12
 lsl	r0, r1, ip
 lsr	r1, r1, r2
 b	.L13 
 .L12:	add	r2, r2, #20
 .L11:	rsble	ip, r2, #32
 lsl	r1, r1, r2
 orrle	r1, r1, r0, lsr ip
 lslle	r0, r0, r2
 .L13:	subs	r4, r4, r3
 addge	r1, r1, r4, lsl #20
 orrge	r1, r1, r5
 popge	{r4, r5, lr}
 bxge	lr
 mvn	r4, r4
 subs	r4, r4, #31
 bge	.L14
 adds	r4, r4, #12
 bgt	.L15
 add	r4, r4, #20
 rsb	r2, r4, #32
 lsr	r0, r0, r4
 orr	r0, r0, r1, lsl r2
 orr	r1, r5, r1, lsr r4
 pop	{r4, r5, lr}
 bx	lr
 .L15:	rsb	r4, r4, #12
 rsb	r2, r4, #32
 lsr	r0, r0, r2
 orr	r0, r0, r1, lsl r4
 mov	r1, r5
 pop	{r4, r5, lr}
 bx	lr
 .L14:	lsr	r0, r1, r4
 mov	r1, r5
 pop	{r4, r5, lr}
 bx	lr
 .L5:	teq	r4, #0
 eor	r3, r3, #0x100000
 eoreq	r1, r1, #0x100000
 addeq	r4, r4, #1
 subne	r5, r5, #1
 b	.L16 
 .L1:	mvns	ip, r4, asr #21
 mvnsne	ip, r5, asr #21
 beq	.L50 <__adddf3+0x2e0>
 teq	r4, r5
 teqeq	r0, r2
 beq	.L17 <__adddf3+0x288>
 orrs	ip, r4, r0
 moveq	r1, r3
 moveq	r0, r2
 pop	{r4, r5, lr}
 bx	lr
 .L17:	teq	r1, r3
 movne	r1, #0
 movne	r0, #0
 popne	{r4, r5, lr}
 bxne	lr
 lsrs	ip, r4, #21
 bne	.L18
 lsls	r0, r0, #1
 adcs	r1, r1, r1
 orrcs	r1, r1, #0x80000000
 pop	{r4, r5, lr}
 bx	lr
 .L18:  adds	r4, r4, #0x400000
 addcc	r1, r1, #0x100000
 popcc	{r4, r5, lr}
 bxcc	lr
 and	r5, r1, #0x80000000
 .L10:	orr	r1, r5, #0x7f000000
 orr	r1, r1, #0xf00000
 mov	r0, #0
 pop	{r4, r5, lr}
 bx	lr

.L50: mvns	ip, r4, asr #21
 movne	r1, r3
 movne	r0, r2
 mvnseq	ip, r5, asr #21
 movne	r3, r1
 movne	r2, r0
 orrs	r4, r0, r1, lsl #12
 orrseq	r5, r2, r3, lsl #12
 teqeq	r1, r3
 orrne	r1, r1, #0x80000
 pop	{r4, r5, lr}
 bx	lr

__aeabi_ui2d:
teq	r0, #0
moveq	r1, #0
bxeq	lr
 push	{r4, r5, lr}
 mov	r4, #1024	; 0x400
 add	r4, r4, #50	; 0x32
 mov	r5, #0
 mov	r1, #0
 b	.L19

__aeabi_i2d:
 teq	r0, #0
 moveq	r1, #0
 bxeq	lr
 push	{r4, r5, lr}
 mov	r4, #1024	; 0x400
 add	r4, r4, #50	; 0x32
 ands	r5, r0, #0x80000000
 rsbmi	r0, r0, #0
 mov	r1, #0
 b	.L19

__aeabi_f2d:
 lsls	r2, r0, #1
 asr	r1, r2, #3
 rrx	r1, r1
 lsl	r0, r2, #28
 andsne	r3, r2, #0xff000000
 teqne	r3, #0xff000000
 eorne	r1, r1, #0x38000000
 bxne	lr
 bics	r2, r2, #0xff000000
 bxeq	lr
 teq	r3, #0xff000000
 orreq	r1, r1, #0x80000
 bxeq	lr
 push	{r4, r5, lr}
 mov	r4, #896	; 0x380
 and	r5, r1, #0x80000000
 bic	r1, r1, #0x80000000
 b	.L19

__aeabi_ul2d:
 orrs	r2, r0, r1
 bxeq	lr
 push	{r4, r5, lr}
 mov	r5, #0
 b	.L20

__aeabi_l2d:
 orrs	r2, r0, r1
 bxeq	lr
 push	{r4, r5, lr}
 ands	r5, r1, #0x80000000
 bpl	.L20
 rsbs	r0, r0, #0
 rsc	r1, r1, #0
 .L20:	mov	r4, #1024	; 0x400
 add	r4, r4, #50	; 0x32
 lsrs	ip, r1, #22
 beq	.L8
 mov	r2, #3
 lsrs	ip, ip, #3
 addne	r2, r2, #3
 lsrs	ip, ip, #3
 addne	r2, r2, #3
 add	r2, r2, ip, lsr #3
 rsb	r3, r2, #32
 lsl	ip, r0, r3
 lsr	r0, r0, r2
 orr	r0, r0, r1, lsl r3
 lsr	r1, r1, r2
 add	r4, r4, r2
 b	.L8 

__aeabi_dmul:
    push	{r4, r5, r6, lr}
    mov	ip, #255	; 0xff
    orr	ip, ip, #1792	; 0x700
    ands	r4, ip, r1, lsr #20
    andsne	r5, ip, r3, lsr #20
    teqne	r4, ip
    teqne	r5, ip
    bleq	.L21
    add	r4, r4, r5
    eor	r6, r1, r3
    bic	r1, r1, ip, lsl #21
    bic	r3, r3, ip, lsl #21
    orrs	r5, r0, r1, lsl #12
    orrsne	r5, r2, r3, lsl #12
    orr	r1, r1, #0x100000
  	orr	r3, r3, #0x100000
  	beq	.L22
  	umull	ip, lr, r0, r2
  	mov	r5, #0
  	umlal	lr, r5, r1, r2
  	and	r2, r6, #0x80000000
  	umlal	lr, r5, r0, r3
  	mov	r6, #0
  	umlal	r5, r6, r1, r3
  	teq	ip, #0
  	orrne	lr, lr, #1
  	sub	r4, r4, #255	; 0xff
  	cmp	r6, #512	; 0x200
  	sbc	r4, r4, #768	; 0x300
  	bcs	.L23 
  	lsls	lr, lr, #1
  	adcs	r5, r5, r5
  	adc	r6, r6, r6
.L23: 
    orr	r1, r2, r6, lsl #11
  	orr	r1, r1, r5, lsr #21
  	lsl	r0, r5, #11
  	orr	r0, r0, lr, lsr #21
  	lsl	lr, lr, #11
  	subs	ip, r4, #253	; 0xfd
  	cmphi	ip, #1792	; 0x700
  	bhi	.L24 
  	cmp	lr, #0x80000000
  	lsrseq	lr, r0, #1
  	adcs	r0, r0, #0
  	adc	r1, r1, r4, lsl #20
  	pop	{r4, r5, r6, lr}
  	bx	lr

.L22:	and	r6, r6, #0x80000000
  	orr	r1, r6, r1
  	orr	r0, r0, r2
  	eor	r1, r1, r3
  	subs	r4, r4, ip, lsr #1
  	rsbsgt	r5, r4, ip
  	orrgt	r1, r1, r4, lsl #20
  	popgt	{r4, r5, r6, lr}
  	bxgt	lr
  	orr	r1, r1, #0x100000
  	mov	lr, #0
  	subs	r4, r4, #1
 .L24:	 bgt	.L25
  	cmn	r4, #54	; 0x36
  	movle	r0, #0
  	andle	r1, r1, #0x80000000
  	pople	{r4, r5, r6, lr}
  	bxle	lr
  	rsb	r4, r4, #0
  	subs	r4, r4, #32
  	bge	.L26 
  	adds	r4, r4, #12
  	bgt	.L27 
  	add	r4, r4, #20
  	rsb	r5, r4, #32
  	lsl	r3, r0, r5
  	lsr	r0, r0, r4
  	orr	r0, r0, r1, lsl r5
  	and	r2, r1, #0x80000000
  	bic	r1, r1, #0x80000000
  	adds	r0, r0, r3, lsr #31
  	adc	r1, r2, r1, lsr r4
  	orrs	lr, lr, r3, lsl #1
  	biceq	r0, r0, r3, lsr #31
  	pop	{r4, r5, r6, lr}
  	bx	lr
 .L27: 	rsb	r4, r4, #12
  	rsb	r5, r4, #32
  	lsl	r3, r0, r4
  	lsr	r0, r0, r5
  	orr	r0, r0, r1, lsl r4
  	and	r1, r1, #0x80000000
  	adds	r0, r0, r3, lsr #31
  	adc	r1, r1, #0
  	orrs	lr, lr, r3, lsl #1
  	biceq	r0, r0, r3, lsr #31
  	pop	{r4, r5, r6, lr}
  	bx	lr
 .L26:	rsb	r5, r4, #32
  	orr	lr, lr, r0, lsl r5
  	lsr	r3, r0, r4
  	orr	r3, r3, r1, lsl r5
  	lsr	r0, r1, r4
  	and	r1, r1, #0x80000000
  	bic	r0, r0, r1, lsr r4
  	add	r0, r0, r3, lsr #31
  	orrs	lr, lr, r3, lsl #1
  	biceq	r0, r0, r3, lsr #31
  	pop	{r4, r5, r6, lr}
  	bx	lr
 .L44:teq	r4, #0
  	bne	.L28
  	and	r6, r1, #0x80000000
 .L29:	lsls	r0, r0, #1
  	adc	r1, r1, r1
  	tst	r1, #0x100000
  	subeq	r4, r4, #1
  	beq	.L29 <__aeabi_dmul+0x1b8>
  	orr	r1, r1, r6
  	teq	r5, #0
  	bxne	lr
 .L28:	and	r6, r3, #0x80000000
 .L30:	lsls	r2, r2, #1
  	adc	r3, r3, r3
  	tst	r3, #0x100000
  	subeq	r5, r5, #1
  	beq	.L30
  	orr	r3, r3, r6
  	bx	lr
 .L21:	teq	r4, ip
  	and	r5, ip, r3, lsr #20
  	teqne	r5, ip
  	beq	.L31
  	orrs	r6, r0, r1, lsl #1
  	orrsne	r6, r2, r3, lsl #1
  	bne	.L44
 .L43:	 	eor	r1, r1, r3
  	and	r1, r1, #0x80000000
  	mov	r0, #0
  	pop	{r4, r5, r6, lr}
  	bx	lr
 .L31:	orrs	r6, r0, r1, lsl #1
  	moveq	r0, r2
  	moveq	r1, r3
  	orrsne	r6, r2, r3, lsl #1
  	beq	.L32  
  	teq	r4, ip
  	bne	.L33
  	orrs	r6, r0, r1, lsl #12
  	bne	.L32  
 .L33:	 	teq	r5, ip
  	bne	.L34 
  	orrs	r6, r2, r3, lsl #12
  	movne	r0, r2
  	movne	r1, r3
  	bne	.L32  
 .L34:	 	eor	r1, r1, r3
 .L25:	 	and	r1, r1, #0x80000000
  	orr	r1, r1, #0x7f000000
  	orr	r1, r1, #15728640	; 0xf00000
  	mov	r0, #0
  	pop	{r4, r5, r6, lr}
  	bx	lr
 .L32:	orr	r1, r1, #0x7f000000
  	orr	r1, r1, #16252928	; 0xf80000
  	pop	{r4, r5, r6, lr}
  	bx	lr

__aeabi_ddiv:
  	push	{r4, r5, r6, lr}
  	mov	ip, #255	; 0xff
  	orr	ip, ip, #1792	; 0x700
  	ands	r4, ip, r1, lsr #20
  	andsne	r5, ip, r3, lsr #20
  	teqne	r4, ip
  	teqne	r5, ip
  	bleq	.L35 
  	sub	r4, r4, r5
  	eor	lr, r1, r3
  	orrs	r5, r2, r3, lsl #12
  	lsl	r1, r1, #12
  	beq	.L36 
  	lsl	r3, r3, #12
  	mov	r5, #268435456	; 0x10000000
  	orr	r3, r5, r3, lsr #4
  	orr	r3, r3, r2, lsr #24
  	lsl	r2, r2, #8
  	orr	r5, r5, r1, lsr #4
  	orr	r5, r5, r0, lsr #24
  	lsl	r6, r0, #8
  	and	r1, lr, #0x80000000
  	cmp	r5, r3
  	cmpeq	r6, r2
  	adc	r4, r4, #253	; 0xfd
  	add	r4, r4, #768	; 0x300
  	bcs	.L37 
  	lsrs	r3, r3, #1
  	rrx	r2, r2
 .L37:	 	subs	r6, r6, r2
  	sbc	r5, r5, r3
  	lsrs	r3, r3, #1
  	rrx	r2, r2
  	mov	r0, #0x100000
  	mov	ip, #524288	; 0x80000
 .L39:	 	subs	lr, r6, r2
  	sbcs	lr, r5, r3
  	subcs	r6, r6, r2
  	movcs	r5, lr
  	orrcs	r0, r0, ip
  	lsrs	r3, r3, #1
  	rrx	r2, r2
  	subs	lr, r6, r2
  	sbcs	lr, r5, r3
  	subcs	r6, r6, r2
  	movcs	r5, lr
  	orrcs	r0, r0, ip, lsr #1
  	lsrs	r3, r3, #1
  	rrx	r2, r2
  	subs	lr, r6, r2
  	sbcs	lr, r5, r3
  	subcs	r6, r6, r2
  	movcs	r5, lr
  	orrcs	r0, r0, ip, lsr #2
  	lsrs	r3, r3, #1
  	rrx	r2, r2
  	subs	lr, r6, r2
  	sbcs	lr, r5, r3
  	subcs	r6, r6, r2
  	movcs	r5, lr
  	orrcs	r0, r0, ip, lsr #3
  	orrs	lr, r5, r6
  	beq	.L38 
  	lsl	r5, r5, #4
  	orr	r5, r5, r6, lsr #28
  	lsl	r6, r6, #4
  	lsl	r3, r3, #3
  	orr	r3, r3, r2, lsr #29
  	lsl	r2, r2, #3
  	lsrs	ip, ip, #4
  	bne	.L39 
  	tst	r1, #0x100000
  	bne	.L40 
  	orr	r1, r1, r0
  	mov	r0, #0
  	mov	ip, #0x80000000
  	b	.L39 
 .L38:	tst	r1, #0x100000
  	orreq	r1, r1, r0
  	moveq	r0, #0
 .L40:	subs	ip, r4, #253	; 0xfd
  	cmphi	ip, #1792	; 0x700
  	bhi	.L24 
  	subs	ip, r5, r3
  	subseq	ip, r6, r2
  	lsrseq	ip, r0, #1
  	adcs	r0, r0, #0
  	adc	r1, r1, r4, lsl #20
  	pop	{r4, r5, r6, lr}
  	bx	lr
 .L36:	 	and	lr, lr, #0x80000000
  	orr	r1, lr, r1, lsr #12
  	adds	r4, r4, ip, lsr #1
  	rsbsgt	r5, r4, ip
  	orrgt	r1, r1, r4, lsl #20
  	popgt	{r4, r5, r6, lr}
  	bxgt	lr
  	orr	r1, r1, #0x100000
  	mov	lr, #0
  	subs	r4, r4, #1
  	b	.L24 
  	orr	lr, r5, r6
  	b	.L24 
 .L35:	 	and	r5, ip, r3, lsr #20
  	teq	r4, ip
  	teqeq	r5, ip
  	beq	.L32  
  	teq	r4, ip
  	bne	.L41 
  	orrs	r4, r0, r1, lsl #12
  	bne	.L32  
  	teq	r5, ip
  	bne	.L34 
  	mov	r0, r2
  	mov	r1, r3
  	b	.L32  
 .L41:	 	teq	r5, ip
  	bne	.L42 
  	orrs	r5, r2, r3, lsl #12
  	beq	.L43 
  	mov	r0, r2
  	mov	r1, r3
  	b	.L32  
 .L42:	orrs	r6, r0, r1, lsl #1
  	orrsne	r6, r2, r3, lsl #1
  	bne	.L44
  	orrs	r4, r0, r1, lsl #1
  	bne	.L34 
  	orrs	r5, r2, r3, lsl #1
  	bne	.L43 
  	b	.L32  

__aeabi_d2f:
  	lsl	r2, r1, #1
  	subs	r3, r2, #0x70000000
  	subscs	ip, r3, #0x200000
  	rsbscs	ip, ip, #0x1fc00000
  	bls	.L45 
.L47: 	and	ip, r1, #0x80000000
  	lsl	r2, r0, #3
  	orr	r0, ip, r0, lsr #29
  	cmp	r2, #0x80000000
  	adc	r0, r0, r3, lsl #2
  	biceq	r0, r0, #1
  	bx	lr
.L45: 	tst	r1, #0x40000000
  	bne	.L46 
  	adds	r2, r3, #0x2e00000
  	andlt	r0, r1, #0x80000000
  	bxlt	lr
  	orr	r1, r1, #0x100000
  	lsr	r2, r2, #21
  	rsb	r2, r2, #24
  	rsb	ip, r2, #32
  	lsls	r3, r0, ip
  	lsr	r0, r0, r2
  	orrne	r0, r0, #1
  	lsl	r3, r1, #11
  	lsr	r3, r3, #11
  	orr	r0, r0, r3, lsl ip
  	lsr	r3, r3, r2
  	lsl	r3, r3, #1
  	b	.L47 
 .L46:	mvns	r3, r2, asr #21
  	bne	.L48 
  	orrs	r3, r0, r1, lsl #12
  	movne	r0, #0x7f000000
  	orrne	r0, r0, #12582912	; 0xc00000
  	bxne	lr
 .L48: and	r0, r1, #0x80000000
  	orr	r0, r0, #0x7f000000
  	orr	r0, r0, #0x800000
  	bx	lr
