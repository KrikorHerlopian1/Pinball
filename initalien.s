	.arch	armv7
	.cpu	cortex-a53
	.fpu	neon-fp-armv8
	.global init_alien
	.text

/*
	void init_alien (sq_data *cp, int diff)
	{
	    if (diff == 1)
	    {
		cp->xsize = 200;
		cp->ysize = 200;
	    }
	    else if (diff == 2)
	    {
		cp->xsize = 150;
		cp->ysize = 150;
	    }
	    else
	    {
		cp->xsize = 100;
		cp->ysize = 100;
	    }
	    cp->speed = 2;
	    cp->x = screen.xres / 2;
	    cp->y = screen.yres - cp->ysize - 50;
	    cp->dirx = rand() % 5 - 2;
	    cp->diry = rand() % 5 - 2;
	}
*/

init_alien:
	push 	{LR}
	push 	{R5-R11}
	cmp	R1,#1			@if (diff == 1)
	beq	initballone
	cmp	R1,#2			@if (diff == 2)
	beq	initballtwo
	b	initballthree	

initballone:
	mov	R5, #200
	str	R5,[R0,#20]		@cp->xsize = 200;
	str	R5,[R0,#24]		@cp->ysize = 200;
	b	initballfinish
initballtwo:
	mov	R5, #150
	str	R5,[R0,#20]		@cp->xsize = 150;
	str	R5,[R0,#24]		@cp->ysize = 150;
	b	initballfinish
initballthree:
	mov	R5, #100
	str	R5,[R0,#20]		@cp->xsize = 100;
	str	R5,[R0,#24]		@cp->ysize = 100;
	b	initballfinish

initballfinish:
	mov	R5, #2
	ldr  	R10, =screen
	ldr  	R6, [R10, #0] 		@screen.xres
	ldr  	R7, [R10, #4] 		@screen.yres
	ldr  	R8, [R0, #24] 		@cp->ysize
	str	R5,[R0,#16]		@cp->speed = 2;
	mov	R6,R6, LSR #1		@screen.xres/2
	str	R6, [R0,#0]		@cp->x = screen.xres / 2;
	sub	R7,R7,R8		@screen.yres - cp->ysize
	sub	R7,R7,#50		@screen.yres - cp->ysize =50
	str	R7, [R0,#4]		@cp->y = screen.yres - cp->ysize - 50;
	mov	R5,R0
	mov	R7, R1
	mov	R8, R2
	mov	R9, R3
	bl	rand   			@rand() % 5 - 2; the rand part, result will return in R0.
	mov	R6, R0
	mov	R0,R5
	mov 	R1, R7
	mov	R2,R8
	mov 	R3, R9
	mov	R9, #5
	udiv	R7,R6,R9		@RAND()/5 EX. 21/5 = 4 
	mul	R7,R7,R9		@RAND()/5 *5 EX. 4 *5 = 20
	sub	R6,R6,R7		@Rand() - (samerand/5 *5) . We basically get rand() % 5. , EX. 21 - 20 = 1.
	sub	R6, R6, #2		@rand() % 5 - 2; the minus 2 part.
	str	R6,[R0,#8]		@cp->dirx = rand() % 5 - 2;
	
	mov	R5,R0
	mov	R7, R1
	mov	R8, R2
	mov	R9, R3
	bl	rand  
	mov	R6, R0
	mov	R0,R5
	mov 	R1, R7
	mov	R2,R8
	mov 	R3, R9
	mov	R9, #5
	udiv	R7,R6,R9		@RAND()/5 EX. 21/5 = 4 
	mul	R7,R7,R9		@RAND()/5 *5 EX. 4 *5 = 20
	sub	R6,R6,R7		@Rand() - (samerand/5 *5) . We basically get rand() % 5. , EX. 21 - 20 = 1.
	sub	R6, R6, #2		@rand() % 5 - 2; the minus 2 part.
	str	R6,[R0,#12]		@cp->diry = rand() % 5 - 2;
	pop 	{R5-R11}
	pop 	{PC}
