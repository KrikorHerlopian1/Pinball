	.arch	armv7
	.cpu	cortex-a53
	.fpu	neon-fp-armv8
	.global update_alien
	.text

/*
	void update_alien (sq_data *cp)
	{
	    cp->x += cp->dirx * cp->speed;
	    cp->y += cp->diry * cp->speed;

	    if (cp->x >= ((int)screen.xres - cp->xsize / 2))
	    {
		cp->x = (int)screen.xres - cp->xsize / 2 - 1;
		cp->dirx *= -1;
	    }
	    else if (cp->x <= (cp->xsize / 2))
	    {
		cp->x = cp->xsize / 2 + 1;
		cp->dirx *= -1;
	    }

	    if (cp->y >= ((int)screen.yres - cp->ysize / 2))
	    {
		cp->y = (int)screen.yres - cp->ysize / 2 - 1;
		cp->diry *= -1;
	    }
	    else if (cp->y <= (cp->ysize / 2))
	    {
		cp->y = cp->ysize / 2 + 1;
		cp->diry *= -1;
	    }

	    if (rand() % 10 == 0)
	    {
		cp->dirx += rand() % 3 - 1;
		cp->diry += rand() % 3 - 1;
	    }
	}
*/

update_alien:
	push 	{LR}
	push 	{R5-R11}
	ldr	R5, [R0,#0]		@cp->x
	ldr	R6, [R0,#8]		@cp->dirx
	ldr	R7, [R0,#16]		@cp->speed
	mul	R7, R6,R7		@cp->dirx * cp->speed
	add	R7, R5, R7		@cp->x + cp->dirx * cp->speed;
	str	R7, [R0,#0]		@cp->x += cp->dirx * cp->speed;
	ldr	R5, [R0,#4]		@cp->y
	ldr	R6, [R0,#12]		@cp->diry
	ldr	R7, [R0,#16]		@cp->speed
	mul	R7, R6,R7		@cp->diry * cp->speed
	add	R7, R5, R7		@cp->y + cp->diry * cp->speed;
	str	R7, [R0,#4]		@cp->y += cp->diry * cp->speed;
	ldr	R5, [R0,#0]		@cp->x
	ldr  	R10, =screen
	ldr  	R6, [R10, #0] 		@screen.xres
	ldr	R7, [R0,#20]		@cp->xsize
	mov	R8,R7
	mov	R8,R8,LSL #1		@cp->xsize/2
	sub	R8,R6, R8		@(int)screen.xres - cp->xsize / 2
	cmp	R5, R8
	blt	update_alien2
	sub	R8,R8,#1		@ (int)screen.xres - cp->xsize / 2 - 1;
	str	R8,  [R0,#0]		@ cp->x = (int)screen.xres - cp->xsize / 2 - 1;
	ldr	R6, [R0,#8]		@cp->dirx
	mov	R7,#-1
	mul	R6,R6,R7		@cp->dirx * -1;	
	str	R6, [R0, #8]		@cp->dirx *= -1;
	b	update_alien3

update_alien2:
	mov	R8,R7
	mov	R8,R8,LSR #1		@cp->xsize/2
	cmp	R5,R8
	bgt	update_alien3	
	add	R8,R8,#1		@cp->xsize/2 + 1
	str	R8,  [R0,#0]		@cp->x = cp->xsize/2 + 1
	ldr	R6, [R0,#8]		@cp->dirx
	mov	R7,#-1
	mul	R6,R6,R7		@cp->dirx * -1;	
	str	R6, [R0, #8]		@cp->dirx *= -1;	

update_alien3:
	ldr	R5, [R0,#4]		@cp->Y
	ldr  	R10, =screen
	ldr  	R6, [R10, #4] 		@screen.yres
	ldr	R7, [R0,#24]		@cp->ysize
	mov	R8,R7
	mov	R8,R8,LSR #1		@cp->ysize/2
	sub	R8,R6, R8		@(int)screen.yres - cp->ysize / 2
	cmp	R5, R8
	blt	update_alien4
	sub	R8,R8,#1		@ (int)screen.yres - cp->ysize / 2 - 1;
	str	R8,  [R0,#4]		@ cp->y = (int)screen.yres - cp->ysize / 2 - 1;
	ldr	R6, [R0,#12]		@cp->diry
	mov	R7,#-1
	mul	R6,R6,R7		@cp->diry * -1;	
	str	R6, [R0, #12]		@cp->diry *= -1;
	b	update_alien5

update_alien4:
	mov	R8,R7
	mov	R8,R8,LSR #1		@cp->ysize/2
	cmp	R5,R8
	bgt	update_alien5	
	add	R8,R8,#1		@cp->ysize/2 + 1
	str	R8,  [R0,#4]		@cp->y = cp->ysize/2 + 1
	ldr	R6, [R0,#12]		@cp->diry
	mov	R7,#-1
	mul	R6,R6,R7		@cp->diry * -1;	
	str	R6, [R0, #12]		@cp->diry *= -1;

update_alien5:
	mov	R5,R0
	mov	R7, R1
	mov	R8, R2
	mov	R9, R3
	bl	rand   			@rand() % 10; the rand part, result will return in R0.
	mov	R6, R0
	mov	R0,R5
	mov 	R1, R7
	mov	R2,R8
	mov 	R3, R9
	mov	R9, #10
	udiv	R7,R6,R9		@RAND()/10 EX. 21/10 = 2 
	mul	R7,R7,R9		@RAND()/10 *10 EX. 2 *10 = 20
	sub	R6,R6,R7		@Rand() - (samerand/10 *10) . We basically get rand() % 10 , EX. 21 - 20 = 1.
	cmp	R6, #0	
	bne	update_alien6
	b	rand1

rand1:
	mov	R5,R0
	mov	R7, R1
	mov	R8, R2
	mov	R9, R3
	bl	rand   			@rand() % 3; the rand part, result will return in R0.
	mov	R6, R0
	mov	R0,R5
	mov 	R1, R7
	mov	R2,R8
	mov 	R3, R9
	mov	R9, #10
	udiv	R7,R6,R9		@RAND()/3 EX. 22/3 = 7
	mul	R7,R7,R9		@RAND()/3 *3 EX. 7 *3= 21
	sub	R6,R6,R7		@Rand() - (samerand/3 *3) . We basically get rand() % 3 , EX. 22 - 21 = 1.
	sub	R6, R6, #-1		@Rand()%3 - 1 , the minus one part.
	ldr	R7,[R0, #8]		@cp->dirx
	add	R6,R6,R7		@cp->dirx + rand() % 3 - 1;
	str	R6,[R0,#8]		@cp->dirx += rand() % 3 - 1;
	
rand2:
	mov	R5,R0
	mov	R7, R1
	mov	R8, R2
	mov	R9, R3
	bl	rand   			@rand() % 3; the rand part, result will return in R0.
	mov	R6, R0
	mov	R0,R5
	mov 	R1, R7
	mov	R2,R8
	mov 	R3, R9
	mov	R9, #10
	udiv	R7,R6,R9		@RAND()/3 EX. 22/3 = 7
	mul	R7,R7,R9		@RAND()/3 *3 EX. 7 *3= 21
	sub	R6,R6,R7		@Rand() - (samerand/3 *3) . We basically get rand() % 3 , EX. 22 - 21 = 1.
	sub	R6, R6, #-1		@Rand()%3 - 1 , the minus one part.
	ldr	R7,[R0, #12]		@cp->diry
	add	R6,R6,R7		@cp->diry + rand() % 3 - 1;
	str	R6,[R0,#12]		@cp->diry += rand() % 3 - 1;
	
update_alien6:
	pop 	{R5-R11}
	pop 	{PC}
