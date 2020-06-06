	.arch	armv7
	.cpu	cortex-a53
	.fpu	neon-fp-armv8
	.global init_ball
	.text

	.text			@ beginning of code lines

/*
	void init_ball (sq_data *sp, int diff)
	{
	    sp->x = screen.xres / 2;
	    if (diff == 1)
	    {
		sp->xsize = 17;
		sp->ysize = 17;
		sp->speed = 4;
		sp->y = 50;
	    }
	    else if (diff == 2)
	    {
		sp->xsize = 13;
		sp->ysize = 13;
		sp->speed = 6;
		sp->y = screen.yres / 4;
	    }
	    else
	    {
		sp->xsize = 9;
		sp->ysize = 9;
		sp->speed = 8;
		sp->y = screen.yres / 3;
	    }
	    
	    sp->dirx = rand() % 5 - 2;
	    sp->diry = 1;
	}
*/

init_ball:
	push 	{LR}
	push 	{R5-R11}
	ldr  	R10, =screen	
	ldr  	R6, [R10, #0] 	@screen.xres
	mov	R6,R6, LSR #1	@screen.xres/2
	str  	R6, [R0, #0] 	@sp->x = screen.xres / 2;
	cmp	R1, #1		@if (diff == 1)
	beq	diffOne
	cmp	R1, #2		@if (diff == 2)
	beq	diffTwo
	b	diffThree

diffOne:
	mov	R5, #17
	mov	R6, #4
	mov	R7, #50
	str	R5,[R0,#20]	@sp->xsize = 17;
	str	R5,[R0,#24]	@sp->ysize = 17;
	str	R6,[R0,#16]	@sp->speed = 4;
	str	R7,[R0,#4]	@sp->y = 50;
	b	doneDiff

diffTwo:
	mov	R5, #13
	mov	R6, #6
	str	R5,[R0,#20]	@sp->xsize = 13;
	str	R5,[R0,#24]	@sp->ysize = 13;
	str	R6,[R0,#16]	@sp->speed = 6;
	ldr  	R6, [R10, #4] 	@screen.yres
	mov	R6,R6,LSR #2	@screen.yres/4
	str	R6,[R0,#4]	@sp->y = screen.yres / 4;
	b	doneDiff

diffThree:
	mov	R5, #9
	mov	R6, #8
	str	R5,[R0,#20]	@sp->xsize = 9;
	str	R5,[R0,#24]	@sp->ysize = 9;
	str	R6,[R0,#16]	@sp->speed = 8;
	ldr  	R6, [R10, #4] 	@screen.yres
	mov	R9, #3
	udiv	R6,R6,R9
	str	R6,[R0,#4]	@sp->y = screen.yres / 3;
	b	doneDiff

doneDiff:
	mov	R5,R0
	mov	R7, R1
	mov	R8, R2
	mov	R9, R3
	bl	rand   		@rand() % 5 - 2; the rand part, result will return in R0.
	mov	R6, R0
	mov	R0,R5
	mov 	R1, R7
	mov	R2,R8
	mov 	R3, R9
	mov	R9, #5
	udiv	R7,R6,R9	@RAND()/5 EX. 21/5 = 4 
	mul	R7,R7,R9	@RAND()/5 *5 EX. 4 *5 = 20
	sub	R6,R6,R7	@Rand() - (samerand/5 *5) . We basically get rand() % 5. , EX. 21 - 20 = 1.
	sub	R6, R6, #2	@rand() % 5 - 2; the minus 2 part.
	str	R6,[R0,#8]	@sp->dirx = rand() % 5 - 2;
	mov	R6,#1
	str	R6,[R0,#12]	@sp->diry = 1;
	pop 	{R5-R11}
	pop 	{PC}
