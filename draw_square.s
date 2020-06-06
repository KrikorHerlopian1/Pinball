	.arch	armv7
	.cpu	cortex-a53
	.fpu	neon-fp-armv8
	.global draw_square
	.text

/*
	
void draw_square (sq_data *sp, unsigned int color)
{
    unsigned int *fbip;
    int rowsize = screen.xres * screen.bits_per_pixel / 8;
    int row, col;

    for (row = -sp->ysize/2; row <= sp->ysize/2; row++)
       for (col = -sp->xsize/2; col <= sp->xsize/2; col++)
       {
          fbip = (unsigned int *)(fbp + (sp->y+row)*rowsize + (sp->x+col)*4);
          *fbip = color;
       }
}

*/

@ R9 Col , R8 row . R7 Row size.
draw_square:
	push 	{LR}
	push 	{R5-R11}
	ldr  	R10, =screen
	ldr  	R5, [R10, #0] 		@screen.xres
	ldr	R6, [R10,#24]		@screen.bits_per_pixel, i checked usr/include/linux/fb.h for fb_var_screeninfo
	mul	R7, R5, R6		@screen.xres * screen.bits_per_pixel
	mov	R7, R7, LSR #3		@@screen.xres * screen.bits_per_pixel/8
	ldr	R8, [R0,#24]		@sp->ysize
	mov	R8, R8, LSR #1		@sp->ysize/2
	mov	R9, #-1
	mul	R8, R8, R9		@(sp->ysize/2) *-1 = -sp->ysize/2 . Row .
	b	firstLoop

firstLoop:
	ldr	R5, [R0, #24]		@sp->ysize
	mov	R5, R5, LSR #1		@sp->ysize/2
	cmp	R8, R5			@ row <= -sp->ysize/2
	bgt	draw_square_end	
	ldr	R9, [R0,#20]		@sp->xsize
	mov	R9, R9, LSR #1		@sp->xsize/2
	mov	R5, #-1
	mul	R9, R9, R5		@(sp->xsize/2) *-1 = -sp->xsize/2 . Col Idex.
	b	secondLoop	

secondLoop:
	ldr	R5, [R0, #20]		@sp->xsize
	mov	R5, R5, LSR #1		@sp->xsize2
	cmp	R9, R5			@ col <= -sp->xsize/2
 	bgt	goToTheNextRow
	mov	R5, R0
	mov	R6, R1
	mov	R10, R2
	mov	R11, R3
	ldr	R5, [R0, #20]		@sp->xsize
	mov	R5, R5, LSR #1		@sp->xsize/2
	cmp	R10, R5
	b	modify

@ R9 Col , R8 row . R7 Row size. . R10 (4)
modify:
	ldr	R5, [R0,#4]		@sp->y
	ldr	R6, [R0,#0]		@sp->x
	add	R6, R6, R9		@sp->x + col
	add	R5, R5, R8		@sp->y + row
	mov	R10, #4
	mul	R5, R5, R7		@(sp->y + row)*rowsize
	mul	R6, R6, R10		@(sp->x + col)*4
	add	R6, R5, R6		@(sp->y + row)*rowsize + (sp->x + col)*4

fbpPart1:
	ldr  	R10, =fbp		@ address of fb part record
	ldr	R10, [R10]
	add	R10, R10, R6
        str     R1, [R10]

goToTheNextCol:
	add	R9, R9, #1
	b	secondLoop

goToTheNextRow:
	add	R8, R8 , #1		@row++
	b	firstLoop

draw_square_end:
	pop 	{R5-R11}
	pop 	{PC}
