	.arch	armv7
	.cpu	cortex-a53
	.fpu	neon-fp-armv8
	.global paddle_ball_overlap
	.text

/*
	int paddle_ball_overlap (sq_data *pp, sq_data *sp)
	{
	    int paddletop, paddleleft, paddleright;
	    int squarebottom, squareleft, squareright;

	    paddletop = pp->y - pp->ysize / 2;
	    paddleleft = pp->x - pp->xsize / 2;
	    paddleright = pp->x + pp->xsize / 2;

	    squarebottom = sp->y + sp->ysize / 2;
	    squareleft = sp->x - sp->xsize / 2;
	    squareright = sp->x + sp->xsize / 2;

	    if ((squarebottom >= paddletop) && (squareleft <= paddleright) && 
		(squareright >= paddleleft))
		return 1;
	    else
		return 0;
	}
*/

@ R6  squareright
@ R7  squareleft
@ R8  paddletop
@ R9  paddeleft
@ R10 paddleright
@ R11 squarebottom
paddle_ball_overlap:
	push 	{LR}
	push 	{R5-R11}

	ldr	R5, [R0, #4]		@pp->y
	ldr	R6, [R0, #24]		@pp->ysize
	mov	R6, R6, LSR #1		@pp->ysize/2
	sub	R8, R5, R6		@pp->y - pp->ysize/2
	ldr	R5, [R0, #0]		@pp->x
	ldr	R6, [R0, #20]		@pp->xsize
	mov	R6, R6, LSR #1		@pp->xsize/2
	sub	R9, R5, R6		@pp->x - pp->xsize/2
	add	R10, R5, R6		@pp->x + pp->xsize/2
	ldr	R5, [R1, #4]		@sp->y
	ldr	R6, [R1, #24]		@sp->ysize
	mov	R6, R6, LSR #1		@sp->ysize/2
	add	R11, R5, R6		@sp->y + sp->ysize/2	
	ldr	R5, [R1, #0]		@sp->x
	ldr	R6, [R1, #20]		@sp->xsize
	mov	R6, R6, LSR #1		@sp->xsize/2
	sub	R7, R5, R6		@sp->x - sp->xsize/2
	add	R6, R5, R6		@sp->x + sp->xsize/2
	cmp	R11, R8			@squarebottom >= paddletop)
	blt	returnZero2
	cmp	R7, R10			@squareleft <= paddleright
	bgt	returnZero2
	cmp	R6, R9			@squareright >= paddleleft
	blt	returnZero2
	mov 	R0, #1
	b	end_paddle_ball_overlap

returnZero2:
	mov	R0, #0
end_paddle_ball_overlap:
	pop 	{R5-R11}
	pop 	{PC}
