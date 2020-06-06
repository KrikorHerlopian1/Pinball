	.global draw_image
	.include	"header.s"
	
	.text			@ beginning of code lines

/*
	void draw_image (int x, int y, unsigned char *image)
	{
	    unsigned int *fbip;
	    int rowsize = screen.xres * screen.bits_per_pixel / 8;
	    int i, j;

	    for (i = 0; i < IM_HEIGHT; i++)
	      for (j = 0; j < IM_WIDTH; j++)
	      {
		 fbip = (unsigned int *)(fbp + (y+i)*rowsize + (x+j)*4);
		 if (image[i*IM_WIDTH+j] <= 200)
		   *fbip = RED;
	      }          
	}
*/


@ R9 i , R8 j . R7 Row size. 
draw_image: 		
	push 	{LR}
	push 	{R5-R11}
	ldr  	R10, =screen
	ldr  	R5, [R10, #0] 		@screen.xres
	ldr	R6, [R10,#24]		@screen.bits_per_pixel, i checked usr/include/linux/fb.h for fb_var_screeninfo
	mul	R7, R5, R6		@screen.xres * screen.bits_per_pixel
	mov	R7, R7, LSR #3		@@screen.xres * screen.bits_per_pixel/8
	mov	R8, #0
	mov 	R9, #0
	b	theFirstLoop

theFirstLoop:
	ldr	R6, =IM_H
	ldr	R6, [R6]		@IM_HEIGHT
	cmp	R9, R6
	bge	endDrawImage
	mov	R8, #0
	b	theSecondLoop

theSecondLoop:
	ldr	R6, =IM_W
	ldr	R6, [R6]		@IM_WIDTH
	cmp	R8,R6
	bge	theFirstLoopUpdate	
	add	R10, R9, R1		@y+i
	add	R11, R8, R0		@x+j
	mov	R5, #4
	mul	R11,R11,R5		@(x+j)*4
	mul	R10, R10, R7		@(y+i)*rowsize
	add	R5, R10, R11		@(x+j)*4 + (y+i)*rowsize
	ldr  	R10, =fbp		@ address of fb part record
	ldr	R10, [R10]
	add	R10, R10, R5		@fbp + (x+j)*4 + (y+i)*rowsize
        mul	R11, R9, R6		@i*im_width
	add	R11, R11, R8		@i*im_width+j
	ldrb	R11, [R2,R11]		@image[i*IM_WIDTH+j]
	cmp	R11, #200
	ble	upFbIpRed
	b	updateTheSecondLoob
	
upFbIpRed:
	mov	R11, #RED
	str     R11, [R10]
updateTheSecondLoob:
	add	R8, R8, #1
	b	theSecondLoop



theFirstLoopUpdate:
	add	R9, R9, #1
	b	theFirstLoop

endDrawImage:
	pop 	{R5-R11}
	pop 	{PC}


