	.arch	armv7
	.cpu	cortex-a53
	.fpu	neon-fp-armv8
	.global draw_circle
	.text

/*
	void draw_circle (sq_data *cp, unsigned int color)
	{
	    unsigned int *fbip;
	    int rowsize = screen.xres * screen.bits_per_pixel / 8;
	    int row, col;

	    for (row = -cp->ysize/2; row <= cp->ysize/2; row++)
	       for (col = -cp->xsize/2; col <= cp->xsize/2; col++)
		   if (dist(row,col,0,0) < cp->xsize/2)
		   {
		      fbip = (unsigned int *)(fbp+(cp->y+row)*rowsize+(cp->x+col)*4);
		      *fbip = color;
		   }
	}
*/

@ R9 Col , R8 row . R7 Row size.
draw_circle:
	push 	{LR}
	push 	{R5-R11}
	ldr  	R10, =screen
	ldr  	R5, [R10, #0] 		@screen.xres
	ldr	R6, [R10,#24]		@screen.bits_per_pixel, i checked usr/include/linux/fb.h for fb_var_screeninfo
	mul	R7, R5, R6		@screen.xres * screen.bits_per_pixel
	mov	R7, R7, LSR #3		@@screen.xres * screen.bits_per_pixel/8
	ldr	R8, [R0,#24]		@cp->ysize
	mov	R8, R8, LSR #1		@cp->ysize/2
	mov	R9, #-1
	mul	R8, R8, R9		@(cp->ysize/2) *-1 = -cp->ysize/2 . Row .
	b	loop1

loop1:
	ldr	R5, [R0, #24]		@cp->ysize
	mov	R5, R5, LSR #1		@cp->ysize/2
	cmp	R8, R5			@ row <= -cp->ysize/2
	bgt	draw_circle_end	
	ldr	R9, [R0,#20]		@cp->xsize
	mov	R9, R9, LSR #1		@cp->xsize/2
	mov	R5, #-1
	mul	R9, R9, R5		@(cp->xsize/2) *-1 = -cp->xsize/2 . Col Idex.
	b	loop2	

loop2:
	ldr	R5, [R0, #20]		@cp->xsize
	mov	R5, R5, LSR #1		@cp->xsize/2
	cmp	R9, R5			@ col <= -cp->xsize/2
 	bgt	goToNextRow
	mov	R5, R0
	mov	R6, R1
	mov	R10, R2
	mov	R11, R3
	mov	R0, R8
	mov	R1, R9
	mov	R2,#0
	mov	R3, #0
	bl	dist			@dist ( row, col, 0 , 0)	
	mov	R1, R6
	mov	R2, R10
	mov	R10, R0	
	mov	R0, R5
	mov	R3, R11
	ldr	R5, [R0, #20]		@cp->xsize
	mov	R5, R5, LSR #1		@cp->xsize/2
	cmp	R10, R5
	blt	enterIf
	b	goToNextCol

@ R9 Col , R8 row . R7 Row size. . R10 (4)
enterIf:
	ldr	R5, [R0,#4]		@cp->y
	ldr	R6, [R0,#0]		@cp->x
	add	R6, R6, R9		@cp->x + col
	add	R5, R5, R8		@cp->y + row
	mov	R10, #4
	mul	R5, R5, R7		@(cp->y + row)*rowsize
	mul	R6, R6, R10		@(cp->x + col)*4
	add	R6, R5, R6		@(cp->y + row)*rowsize + (cp->x + col)*4

fbpPart:
	ldr  	R10, =fbp		@ address of fb part record
	ldr	R10, [R10]
	add	R10, R10, R6
        str     R1, [R10]

goToNextCol:
	add	R9, R9, #1
	b	loop2

goToNextRow:
	add	R8, R8 , #1		@row++
	b	loop1

draw_circle_end:
	pop 	{R5-R11}
	pop 	{PC}
