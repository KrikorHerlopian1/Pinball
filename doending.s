	.arch	armv7
	.cpu	cortex-a53
	.fpu	neon-fp-armv8
	.include	"header.s"	
	.global do_ending
	.text

/*
	void do_ending (unsigned char *digit_images, unsigned char *letter_images, int lives, int score)
	{
	    int i;

	    for (i = 0; i < 100; i++)
	    {
		memset(fbp, BLACK, screen.xres * screen.yres * screen.bits_per_pixel/8);
		draw_info(digit_images, letter_images, lives, score);
		draw_string(screen.xres/2 - 4*IM_WIDTH-IM_WIDTH/2, screen.yres/2, letter_images, "GAME");
		draw_string(screen.xres/2 + IM_WIDTH/2, screen.yres/2, letter_images, "OVER");
		usleep(FRAME_DELAY);
	    }

	}
*/

do_ending:
	push 	{LR}
	push 	{R5-R11}
	mov	R5, #0			@int i = 0
	b	startLoopDoIntro1

startLoopDoIntro1:
	mov	R6, R0
	mov	R7, R1
	mov	R8, R2
	mov	R9, R3
	
	@memset(fbp, BLACK, screen.xres * screen.yres * screen.bits_per_pixel/8);
	ldr  	R0, =fbp		@ address of fb part record
	ldr	R0, [R0]
	mov	R1, #BLACK	
	ldr  	R10, =screen
	ldr  	R2, [R10, #0] 		@screen.xres
	ldr	R3, [R10, #4]		@screen.yres
	mul	R2 ,R2, R3		@screen.xres * screen.yres
	ldr	R3, [R10, #24]		@screen.bits_per_pixel
	mul	R2, R2, R3		@screen.xres * screen.yres * screen.bits_per_pixel
	mov	R2, R2, LSR #3		@screen.xres * screen.yres * screen.bits_per_pixel/8
	bl	memset
	
	mov	R0, R6
	mov	R1, R7
	mov	R2, R8
	mov	R3, R9

	@draw_info(digit_images, letter_images, lives, score);
	bl	draw_info

	@draw_string(screen.xres/2 - 4*IM_WIDTH-IM_WIDTH/2, screen.yres/2, letter_images, "GAME");
	mov	R6, R0
	mov	R7, R1
	mov	R8, R2
	mov	R9, R3
	ldr  	R10, =screen
	ldr  	R0, [R10, #0] 		@screen.xres
	mov	R0, R0, LSR #1		@screen.xres / 2
	ldr	R1, =IM_W
	ldr	R1, [R1]		@IM_WIDTH
	mov	R2, #4
	mul	R3, R1, R2		@4 * im_width
	sub	R0, R0, R3		@screen.xres / 2 - 4 * im_width
	mov	R1, R1, LSR #1		@im_width/2
	sub	R0, R0, R1		@screen.xres / 2 - 4 * im_width - im_width/2
	ldr	R1, [R10, #4]		@screen.yres
	mov	R1, R1, LSR #1		@screen.yres / 2
	mov	R2, R7			@letter_images
	ldr	R3, =gameStr		@GAME string.
	bl	draw_string

	@draw_string(screen.xres/2 + IM_WIDTH/2, screen.yres/2, letter_images, "OVER");
	ldr  	R10, =screen
	ldr  	R0, [R10, #0] 		@screen.xres
	mov	R0, R0, LSR #1		@screen.xres / 2
	ldr	R1, =IM_W
	ldr	R1, [R1]		@IM_WIDTH
	mov	R1, R1, LSR #1		@im_width/2
	add	R0, R0, R1		@screen.xres / 2 + im_width/2
	ldr	R1, [R10, #4]		@screen.yres
	mov	R1, R1, LSR #1		@screen.yres / 2
	mov	R2, R7			@letter_images
	ldr	R3, =overStr		@OVER string.
	bl	draw_string


	@usleep(FRAME_DELAY);
	ldr	R0, =fr_de
	ldr	R0, [R0]		@frame delay
	bl	usleep	
	
	mov	R0, R6
	mov	R1, R7
	mov	R2, R8
	mov	R3, R9
	
	
	add	R5, R5, #1		@i++
	cmp	R5, #100
	blt	startLoopDoIntro1
		
finito1:	
	pop 	{R5-R11}
	pop 	{PC}


