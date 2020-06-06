	.arch	armv7
	.cpu	cortex-a53
	.fpu	neon-fp-armv8
	.global update_ball
	.text
/*
	@extra credit i added lives to this function.
	int update_ball (sq_data *sp, sq_data *pp, sq_data *cp, int *score, int lives) 
	{
	    float d,ax,ay,va1,va2,vb1,vb2;

	    sp->x += sp->dirx * sp->speed;
	    sp->y += sp->diry * sp->speed;

	    if (sp->x >= ((int)screen.xres - sp->xsize / 2))
	    {
		sp->x = (int)screen.xres - sp->xsize / 2 - 1;
		sp->dirx *= -1;
	    }
	    else if (sp->x <= (sp->xsize / 2))
	    {
		sp->x = sp->xsize / 2 + 1;
		sp->dirx *= -1;
	    }

	    if (sp->y >= ((int)screen.yres - sp->ysize / 2))
	    {
		sp->y = (int)screen.yres - sp->ysize / 2 - 1;
		sp->diry *= -1;
	    }
	    else if (sp->y <= (sp->ysize / 2))
	    {
		sp->y = sp->ysize / 2 + 1;
		sp->diry *= -1;
	    }

	    if (paddle_ball_overlap(pp, sp))
	    {
		sp->y = pp->y - pp->ysize / 2 - sp->ysize / 2;
		sp->diry *= -1;
		*score += 1;
		@extra credit code added in assembly, if paddle ball over lap..I negate - 20 from paddle xsize. unless
		@paddle xsize is less than 50.
	    }

	    d = dist(sp->x,sp->y,cp->x,cp->y);

	    if (d <= (sp->xsize/2 + cp->xsize/2))
	    {
		sp->x -= sp->dirx * sp->speed;
		sp->y -= sp->diry * sp->speed;
		ax = (cp->x - sp->x)/d;
		ay = (cp->y - sp->y)/d;
		va1 = sp->dirx * ax + sp->diry * ay;
		vb1 = -sp->dirx * ay + sp->diry * ax;
		va2 = cp->dirx * ax + cp->diry * ay;
		vb2 = -cp->dirx * ay + cp->diry * ax;
		sp->dirx = (int)(va2 * ax - vb1 * ay);
		sp->diry = (int)(va2 * ay + vb1 * ax);
		cp->dirx = (int)(va1 * ax - vb2 * ay);
		cp->diry = (int)(va1 * ay + vb2 * ax);
		*score += 2;
	    }

	    if (sp->y > pp->y)
		return 1;
	    else
		return 0;
	}
*/

update_ball:
	push 		{LR}
	push 		{R5-R11}
	@sp->x = sp->speed * sp->dirx + SP->x;
	ldr     	R5, [R0, #16] 		@sp->speed;
	ldr		R6, [R0, #8]		@sp->dirx;
	mul		R5, R5, R6		@sp->speed * sp->dirx;
	ldr		R6, [R0, #0]		@sp->x
	add		R5, R6, R5		@sp->speed * sp->dirx + SP->x;
	str		R5, [R0, #0]		@sp->x = sp->speed * sp->dirx + SP->x;
	
	@sp->y = sp->speed * sp->dirx + SP->y
	ldr     	R5, [R0, #16] 		@sp->speed;
	ldr		R6, [R0, #12]		@sp->diry;
	mul		R5, R5, R6		@sp->speed * sp->diry;
	ldr		R6, [R0, #4]		@sp->y
	add		R5, R6, R5		@sp->speed * sp->diry + SP->y;
	str		R5, [R0, #4]		@sp->y = sp->speed * sp->dirx + SP->y

	/*
	    if (sp->x >= ((int)screen.xres - sp->xsize / 2))
	    {
		sp->x = (int)screen.xres - sp->xsize / 2 - 1;
		sp->dirx *= -1;
	    }
	    else if (sp->x <= (sp->xsize / 2))
	    {
		sp->x = sp->xsize / 2 + 1;
		sp->dirx *= -1;
	    }
	*/
	ldr		R5, [R0, #0]		@sp->x
	ldr  		R10, =screen	
	ldr  		R6, [R10, #0] 		@screen.xres
	ldr  		R7, [R0, #20] 		@sp->xsize
	mov		R8, R7, LSR #1		@sp->xsize / 2
	sub		R9, R6, R8		@screen.xres - sp->xsize / 2
	cmp		R5, R9			@sp-> x >= screen.xres - sp->xsize / 2
	bge		enterTheFirstIf
	cmp		R5, R8			@sp->x <= (sp->xsize/2)
	ble		enterTheSecondIf
	b		conontiune
		
enterTheFirstIf:
	sub		R9, R9, #1		@(int)screen.xres - sp->xsize / 2 - 1;
	str		R9, [R0,#0]		@sp->x = (int)screen.xres - sp->xsize / 2 - 1;
	b		multipleDirx

enterTheSecondIf:
	add		R8, R8, #1		@sp->xsize / 2 +1
	str		R8, [R0,#0]		@sp->x = sp->xsize / 2 +1
	b		multipleDirx

multipleDirx:
	mov		R8, #-1
	ldr		R9, [R0, #8]		@sp->dirx
	mul		R8, R9, R8		@sp->dirx * -1
	str		R8, [R0, #8]		@sp->dirx *= -1

/*
	    if (sp->y >= ((int)screen.yres - sp->ysize / 2))
	    {
		sp->y = (int)screen.yres - sp->ysize / 2 - 1;
		sp->diry *= -1;
	    }
	    else if (sp->y <= (sp->ysize / 2))
	    {
		sp->y = sp->ysize / 2 + 1;
		sp->diry *= -1;
	    }
*/
conontiune:
	ldr		R5, [R0, #4]		@sp->y
	ldr  		R10, =screen	
	ldr  		R6, [R10, #4] 		@screen.yres
	ldr  		R7, [R0, #24] 		@sp->ysize
	mov		R8, R7, LSR #1		@sp->ysize / 2
	sub		R9, R6, R8		@screen.yres - sp->ysize / 2
	cmp		R5, R9			@sp-> y >= screen.yres - sp->ysize / 2
	bge		enterTheFirstIfY
	cmp		R5, R8			@sp->y <= (sp->ysize/2)
	ble		enterTheSecondIfY
	b		conontiune1
	
enterTheFirstIfY:
	sub		R9, R9, #1		@(int)screen.yres - sp->ysize / 2 - 1;
	str		R9, [R0,#4]		@sp->y = (int)screen.yres - sp->ysize / 2 - 1;
	b		multipleDiry

enterTheSecondIfY:
	add		R8, R8, #1		@sp->ysize / 2 +1
	str		R8, [R0,#4]		@sp->y = sp->ysize / 2 +1
	b		multipleDiry

multipleDiry:
	mov		R8, #-1
	ldr		R9, [R0, #12]		@sp->diry
	mul		R8, R9, R8		@sp->diry * -1
	str		R8, [R0, #12]		@sp->diry *= -1

/*
	    if (paddle_ball_overlap(pp, sp))
	    {
		sp->y = pp->y - pp->ysize / 2 - sp->ysize / 2;
		sp->diry *= -1;
		*score += 1;
		@extra credit code added in assembly, if paddle ball over lap..I negate - 20 from paddle xsize. unless
		@paddle xsize is less than 50.
	    }
*/
conontiune1:
	mov		R5, R0			@SP
	mov		R10, R1			@pp
	mov		R7, R2			@cp
	mov		R8, R3			@SCORE

	@paddle_ball_overlap(pp, sp)
	mov		R0, R10
	mov		R1, R5
	bl		paddle_ball_overlap
	mov		R9, R0			@the result of calling paddle_ball_overlap(pp,sp).
	mov		R0, R5			@SP
	mov		R1, R10			@pp
	mov		R2, R7			@cp
	mov		R3, R8			@SCORE	
	cmp		R9, #1
	beq		enterPaddleBallOverlapIf	
	b		conontiune2

enterPaddleBallOverlapIf:
	ldr		R5, [R1, #24]		@PP->YSIZE
	mov		R5, R5, LSR #1		@pp->ysize/2
	ldr		R6, [R0, #24]		@sp->ysize
	mov		R6, R6, LSR #1		@sp->ysize/2
	ldr		R7, [R1, #4]		@PP->Y
	sub		R7, R7, R5		@PP->Y - PP->YSIZE/2
	sub		R7, R7, R6		@PP->Y - PP->YSIZE/2 - sp->ysize/2 
	str		R7, [R0, #4]		@SP-Y = PP->Y - PP->YSIZE/2 - sp->ysize/2


//  sp->diry *= -1;
multipleDiry1:
	mov		R8, #-1
	ldr		R9, [R0, #12]		@sp->diry
	mul		R8, R9, R8		@sp->diry * -1
	str		R8, [R0, #12]		@sp->diry *= -1

// *score +=1
addScore1:
	ldr		R5, [R3]
	add		R5, R5, #1		@*SCORE +=1
	str		R5, [R3]


makePaddleSmaller:
	@extra credit , make paddle smaller.
	ldr		R5, [R1, #20]		@PP->xsize
	cmp		R5, #50
	ble		conontiune2
	sub		R5, R5, #20
	str		R5, [R1, #20]

//d = dist(sp->x,sp->y,cp->x,cp->y);
conontiune2:
	mov		R5, R0			@SP
	mov		R6, R1			@pp
	mov		R7, R2			@cp
	mov		R8, R3			@SCORE
	ldr		R3, [R2,#4]		@CP->Y
	ldr		R1, [R0,#4]		@SP->Y
	ldr		R2, [R2,#0]		@CP->X
	ldr		R0, [R0, #0]		@SP->X
	bl		dist
	mov		R9, R0			@the result of calling  dist function. d.TRUNCATED.
	mov		R0, R5			@SP
	mov		R1, R6			@pp
	mov		R2, R7			@cp
	mov		R3, R8			@SCORE
	
	ldr		R5, [R0, #20]		@SP->XSIZE
	mov		R5, R5, LSR #1		@Sp->Xsize/2
	ldr		R6, [R2, #20]		@CP->XSIZE
	mov		R6, R6, LSR #1		@Cp->Xsize/2
	add		R6, R5, R6		@Sp->Xsize/2 + Cp->Xsize/2
	cmp		R9, R6			@if (d <= (sp->xsize/2 + cp->xsize/2))
	ble		enterTheLastIf
	b		contoninue3

/*
	
	sp->x -= sp->dirx * sp->speed;
        sp->y -= sp->diry * sp->speed;
        ax = (cp->x - sp->x)/d;
        ay = (cp->y - sp->y)/d;
        va1 = sp->dirx * ax + sp->diry * ay;
        vb1 = -sp->dirx * ay + sp->diry * ax;
        va2 = cp->dirx * ax + cp->diry * ay;
        vb2 = -cp->dirx * ay + cp->diry * ax;
        sp->dirx = (int)(va2 * ax - vb1 * ay);
        sp->diry = (int)(va2 * ay + vb1 * ax);
        cp->dirx = (int)(va1 * ax - vb2 * ay);
        cp->diry = (int)(va1 * ay + vb2 * ax);
	*SCORE +=2
*/
enterTheLastIf:
	ldr		R7,[R0, #16]		@sp->speed
	
	@sp->x -= sp->x - (sp->dirx * sp->speed)
	ldr		R5,[R0, #0]		@sp->x
	ldr		R6,[R0, #8]		@sp->dirx
	mul		R6,R6, R7		@sp->dirx * sp->speed
	sub		R6, R5, R6		@sp->x - (sp->dirx * sp->speed)
	str		R6, [R0, #0]		@sp->x = sp->x - (sp->dirx * sp->speed)
	
	@sp->y -= sp->diry * sp->speed;
	ldr		R5, [R0, #4]		@sp->y
	ldr		R6, [R0, #12]		@sp->diry
	mul		R6,R6, R7		@sp->diry * sp->speed
	sub		R6, R5, R6		@sp->y - (sp->diry * sp->speed)
	str		R6, [R0, #4]		@sp->y = sp->y - (sp->diry * sp->speed)
	
	@R9 is d. S0 is d ( not trunacted). S8 will be ax.
	ldr		R5,[R2,#0]		@cp->x
	ldr		R6,[R0,#0]		@sp->x
	sub		R6, R5, R6		@cp->x - sp->x
	vmov 		S7, R6			// We want to convert integer to floating point format
	vcvt.f32.s32  	S7, S7
	vdiv.f32	S8, S7,S0		@(cp->x - sp->x)/d
	
	@R9 is d. S0 is d ( not trunacted). S9 will be ay
	ldr		R5,[R2,#4]		@cp->y
	ldr		R6,[R0,#4]		@sp->y
	sub		R6, R5, R6		@cp->y - sp->y
	vmov 		S7, R6			// We want to convert integer to floating point format
	vcvt.f32.s32  	S7, S7
	vdiv.f32	S9, S7,S0		@(cp->y - sp->xy)/d
	
	@S9 ay, S8 ax. S11 will be val1.
	ldr		R5,[R0,#8]		@sp->dirx
	ldr		R6, [R0,#12]		@SP->DIRY
	vmov 		S7, R5			// We want to convert integer to floating point format
	vcvt.f32.s32  	S7, S7
	vmov 		S10, R6			// We want to convert integer to floating point format
	vcvt.f32.s32  	S10, S10
	vmul.f32	S10, S10,S9		//sp->diry * ay;
	vmul.f32	S7, S7, S8		//sp->dirx * ax
	vadd.f32	S11, S10, S7		// va1 = sp->dirx * ax + sp->diry * ay;

	@S9 ay, S8 ax. S11 will be val1. S10 will be vb1
	ldr		R5,[R0,#8]		@sp->dirx
	ldr		R6, [R0,#12]		@SP->DIRY
	vmov 		S7, R5			// We want to convert integer to floating point format
	vcvt.f32.s32  	S7, S7
	vmov 		S10, R6			// We want to convert integer to floating point format
	vcvt.f32.s32  	S10, S10
	vmul.f32	S10, S10,S8		//sp->diry * ax;
	vmul.f32	S7, S7, S9		//sp->dirx * ay	
	vsub.f32	S10, S10,S7		//vb1 = -sp->dirx * ay + sp->diry * ax;
	
	@S9 ay, S8 ax. S11 is val1.S10 is vb1. S12 WILL BE va2.
	ldr		R5,[R2,#8]		@cp->dirx
	ldr		R6, [R2,#12]		@cP->DIRY
	vmov 		S7, R5			// We want to convert integer to floating point format
	vcvt.f32.s32  	S7, S7
	vmov 		S12, R6			// We want to convert integer to floating point format
	vcvt.f32.s32  	S12, S12
	vmul.f32	S12, S12,S9		//cp->diry * ay;
	vmul.f32	S7, S7, S8		//cp->dirx * ax
	vadd.f32	S12, S12, S7		// va2 = cp->dirx * ax + cp->diry * ay;

	@S9 ay, S8 ax. S11 val1. S10  vb1. S12 va2. S13 vb2.
	ldr		R5,[R2,#8]		@cp->dirx
	ldr		R6, [R2,#12]		@cP->DIRY
	vmov 		S7, R5			// We want to convert integer to floating point format
	vcvt.f32.s32  	S7, S7
	vmov 		S13, R6			// We want to convert integer to floating point format
	vcvt.f32.s32  	S13, S13
	vmul.f32	S13, S13,S8		//cp->diry * ax;
	vmul.f32	S7, S7, S9		//cp->dirx * ay	
	vsub.f32	S13, S13,S7		//vb2 = -cp->dirx * ay + cp->diry * ax;
		
	@sp->dirx = (int)(va2 * ax - VB1 * AY)
	vmul.f32	S7, S12,S8		@va2 * ax
	vmul.f32	S6, S10,S9		@VB1 * AY
	vsub.f32	S7, S7, S6		@va2 * ax - VB1 * AY
	vcvt.s32.f32    S6, S7			@ convert floating point to integer format (truncate)
	vmov   		R8, S6			@ and move to general register.
	str		R8, [R0, #8]		@sp->dirx = (int)(va2 * ax - VB1 * AY)

	@sp->diry = (int)(va2 * ay + VB1 * AX)
	vmul.f32	S7, S12,S9		@va2 * ay
	vmul.f32	S6, S10,S8		@VB1 * Ax
	vadd.f32	S7, S7, S6		@va2 * ay + VB1 * ax
	vcvt.s32.f32    S6, S7			@ convert floating point to integer format (truncate)
	vmov   		R8, S6			@ and move to general register.
	str		R8, [R0, #12]		@sp->diry = (int)(va2 * ay + VB1 * AX)

	
	@cp->dirx = (int)(va1 * ax - VB2 * AY)
	vmul.f32	S7, S11,S8		@va1 * ax
	vmul.f32	S6, S13,S9		@VB2 * AY
	vsub.f32	S7, S7, S6		@va1 * ax - VB2 * AY
	vcvt.s32.f32    S6, S7			@ convert floating point to integer format (truncate)
	vmov   		R8, S6			@ and move to general register.
	str		R8, [R2, #8]		@cp->dirx = (int)(va1 * ax - VB2 * AY)

	@cp->diry = (int)(va1 * ay + VB2 * AX)
	vmul.f32	S7, S11,S9		@va1 * ay
	vmul.f32	S6, S13,S8		@VB2 * Ax
	vadd.f32	S7, S7, S6		@va1 * ay + VB2 * ax
	vcvt.s32.f32    S6, S7			@ convert floating point to integer format (truncate)
	vmov   		R8, S6			@ and move to general register.
	str		R8, [R2, #12]		@cp->diry = (int)(va1 * ay + VB2 * AX)
	
	ldr		R10, [R3]
	add		R10, R10, #2		@*SCORE +=2
	str		R10, [R3]
	
	@extra credit when alien hits the ball. And score is divisible by 5.
	mov		R9, #5
	udiv		R8, R10, R9		// DIVIDE score by 5. scored = 11, 11/5 = 2
	mul		R9, R9, R8		// multiple division score by 5. 5 * 2 = 10 
	sub		R9, R10, R9		// 11 - 10 = 1. we get remainder of score ( 11) % 5 
	cmp		R9,#0
	beq		addLives
	b 		contoninue3

addLives:
	add		R4, R4, #1
	
contoninue3:
	ldr		R5,[R0,#4]		@sp->y
	ldr		R6, [R1, #4]		@pp->y
	cmp		R5, R6
	ble		returnZaro
	mov		R0, #1
	b		finishUpdateBall

returnZaro:
	mov	R0, #0	

finishUpdateBall:
	pop 	{R5-R11}
	pop 	{PC}




