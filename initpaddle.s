	.global init_paddle
	.text			@ beginning of code lines
/*
	void init_paddle (sq_data *pp, int diff)
	{
	    if (diff == 1)
	    {
		pp->xsize = 200;
		pp->ysize = 20;
		pp->speed = 20;
	    }
	    else if (diff == 2)
	    {
		pp->xsize = 150;
		pp->ysize = 15;
		pp->speed = 25;
	    }
	    else
	    {
		pp->xsize = 100;
		pp->ysize = 10;
		pp->speed = 30;
	    }
	    pp->x = screen.xres / 2;
	    pp->y = screen.yres - pp->ysize - 50;
	}
*/


init_paddle:
	push {LR}
	push {R5-R11}
	cmp R1, #1			@ if (diff == 1)
	beq E1
	cmp R1, #2
	beq E2
	mov     R5, #30
        mov     R6, #100
	mov	R7, #10
	str     R5, [R0, #16] 		@pp->speed = 30;
	str     R6, [R0, #20]		@pp->xsize = 100;
        str     R7, [R0, #24]		@pp->ysize = 10;
	b	finalStep
	

E1:
	mov     R5, #20
        mov     R6, #200
        str     R5, [R0, #16] 		@pp->speed = 20;
	str     R6, [R0, #20]		@pp->xsize = 200;
	str     R5, [R0, #24]		@pp->ysize = 20;
	b	finalStep
		
E2:
	mov     R5, #25
        mov     R6, #150
	mov	R7, #15
	str     R5, [R0, #16]		@pp->speed = 25;
	str     R6, [R0, #20]		@pp->xsize = 150;
        str     R7, [R0, #24]		@pp->ysize = 15;
	b	finalStep

finalStep:
	ldr  R10, =screen	
	ldr  R6, [R10, #0] 	@screen.xres
	ldr  R7, [R10, #4] 	@screen.yres
	mov  R6,R6,LSR #1  	@screen.xres/2
	ldr  R8, [R0, #24] 	@pp->ysize
	sub  R7, R7, R8    	@screen.yres - pp->ysize
	sub  R7, R7, #50   	@screen.yres - pp->ysize - 50
	str  R7, [R0, #4]	@pp->y = screen.yres - pp->ysize - 50
	str  R6, [R0, #0]	@pp->x = screen.xres/2
	pop {R5-R11}
	pop {PC}
