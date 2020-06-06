	.global update_paddle
	.text			@ beginning of code linesvoid 

/*
	update_paddle (sq_data *pp, char *inchars, int numc)
	{
	    if (numc == 3)
	    {
		if (inchars[2] == 'D')
		    pp->x = pp->x - pp->speed;
		else if (inchars[2] == 'C')
		    pp->x += pp->speed;

		if (pp->x >= ((int)screen.xres - pp->xsize / 2))
		    pp->x = (int)screen.xres - pp->xsize / 2 - 1;
		else if (pp->x <= (pp->xsize / 2))
		    pp->x = pp->xsize / 2 + 1;
	    }
	}
*/


update_paddle:
	push 	{LR}
	push 	{R5-R11}
	cmp	R2, #3		@numc == 3
	beq	goOn
	b	update_paddle_last

goOn:
 	ldrb	R5, [R1,#2]	@inchars[2]
	ldr  	R8, [R0, #0] 	@pp->x
	ldr  	R9, [R0, #16]	@pp->pp->speed
	ldr  	R6, [R0, #4] 	@pp->y
	cmp	R5, #68		@inchars[2] = 'D'
	beq	update1
	cmp	R5,#67		@inchars[2] = 'C'
	beq	update2
	
	@extra credit for key up, and key down.
	cmp	R5, #65		@inchars[2] = 'A'	
	beq	update3
	cmp	R5, #66		@inchars[2] = 'B'	
	beq	update4
	
	b	nextUpdatePhase

update1:
	sub	R10, R8,R9	@  pp->x -= pp->speed;
	str	R10,[R0,#0]
	b	nextUpdatePhase

update2:
	add	R10, R8,R9	@ pp->x += pp->speed;
	str	R10,[R0,#0]
	b	nextUpdatePhase

@extra credit update3, update 4. User can move paddle up and down, maximum a paddle can go up is screen.yes/2.
@maximum a paddle can go down is screen.yres	 - 50 - pp->ysize. 
update3:
	ldr  	R11, =screen	
	ldr  	R8, [R11, #4] 		@screen.yres
	mov	R8,R8, lsr #1		@screen.yres/2	
	cmp	R6, R8			@in case pp->y  less then or equal to screen.yres/2 , paddle cannot move more up.
	ble	nextUpdatePhase	
	sub	R10, R6,R9		@  pp->y -= pp->speed;
	str	R10,[R0,#4]
	b	nextUpdatePhase

update4:	
	ldr  	R11, =screen	
	ldr  	R8, [R11, #4] 		
	sub	R8, R8, #50		@screen.yres	 - 50
	ldr	R11,[R0,#24]		@pp->ysize
	sub	R8, R8, R11		@screen.yres	 - 50 - pp->ysize

	@ in case pp->y greater than or equal to than screen.yres - 50 - pp->ysize, paddle cannot move more down.
	cmp	R6, R8			
	bge	nextUpdatePhase	  	
	add	R10, R6,R9		@ pp->y += pp->speed;
	str	R10,[R0,#4]
	b	nextUpdatePhase

nextUpdatePhase:
	ldr  	R8, [R0, #0] 	@pp->x
	ldr  	R9, [R0, #20] 	@pp->xsize
	ldr  	R10, =screen	
	ldr  	R6, [R10, #0] 	@screen.xres
	mov  	R5,R9,LSR #1  	@pp->xsize/2
	sub	R5, R6,R5	@(int)screen.xres - pp->xsize/2
	cmp	R8, R5
	blt	nextUpdatePhase2
	sub	R5, R5,#1	@ pp->x = (int)screen.xres - pp->xsize/2 - 1
	str	R5, [R0,#0]
	b	update_paddle_last

nextUpdatePhase2:
	mov  	R5,R9,LSR #1  	@pp->xsize/2
	cmp	R8, R5		@if (pp->x <= (pp->xsize / 2))
	bgt	update_paddle_last	
	add	R5, R5, #1	@pp->x = pp->xsize / 2 + 1
	str	R5, [R0,#0]



update_paddle_last:
	pop 	{R5-R11}
	pop 	{PC}

