	.arch	armv7
	.cpu	cortex-a53
	.fpu	neon-fp-armv8
	.include	"header.s"
	.global draw_info
	.text

/*
	void draw_info (unsigned char *digit_images, unsigned char *letter_images, int lives, int score)
	{
	    draw_string(screen.xres/2 - 7*IM_WIDTH, 5, letter_images, "PINBALL");
	    draw_string(screen.xres/2 + IM_WIDTH, 5, letter_images, "WIZARD");
	    draw_string(25, screen.yres-2-IM_HEIGHT, letter_images, "SCORE");
	    draw_number(25+6*IM_WIDTH, screen.yres-2-IM_HEIGHT, digit_images, score);
	    draw_string(screen.xres-25-7*IM_WIDTH, screen.yres-2-IM_HEIGHT, letter_images, "LIVES");
	    draw_number(screen.xres-25-IM_WIDTH, screen.yres-2-IM_HEIGHT, digit_images, lives);
	}
*/
draw_info:
	push 	{LR}
	push 	{R5-R11}
	mov	R5, R0
	mov	R6, R1			@LETTER_IMAGES
	mov	R7, R2			
	mov	R8, R3

	ldr     R9, =screen		@ address of frame buffer record
	ldr	R10, =IM_W
	ldr	R10, [R10]		@IM_WIDTH

	
	mov	R0, #7		
	mul	R0, R0, R10		@IM_WIDTH * 7
	
	@draw_string(screen.xres/2 - 7*IM_WIDTH, 5, letter_images, "PINBALL");
	ldr  	R11, [R9, #0]		@ X resolution, screen.xres
	mov	R11, R11, LSR #1	@screen.xres /2
	sub	R0, R11, R0		@screen.xres /2 - IM_WIDTH * 7
	mov	R1, #5
	mov	R2, R6
	ldr	R3, =pinballStr
	bl	draw_string
	
	@ draw_string(screen.xres/2 + IM_WIDTH, 5, letter_images, "WIZARD");
	add	R0, R11, R10		@screen.xres/2 + IM_WIDTH
	mov	R1, #5
	mov	R2, R6
	ldr	R3, =wizardStr
	bl	draw_string
	
	@ draw_string(25, screen.yres-2-IM_HEIGHT, letter_images, "SCORE");
	mov	R0, #25
	ldr  	R11, [R9, #4]		@screen.yres
	sub	R11, R11, #2		@screen.yres - 2
	ldr	R10, =IM_H
	ldr	R10, [R10]		@IM_Height
	sub	R1, R11, R10		@screen.yres-2-IM_HEIGHT
	mov	R2, R6
	ldr	R3, =scoreStr
	bl	draw_string

	@draw_number(25+6*IM_WIDTH, screen.yres-2-IM_HEIGHT, digit_images, score);
	ldr  	R11, [R9, #4]		@screen.yres
	sub	R11, R11, #2		@screen.yres - 2	
	ldr	R10, =IM_H
	ldr	R10, [R10]		@IM_Height
	sub	R1, R11, R10		@screen.yres-2-IM_HEIGHT
	mov	R2, R5
	mov	R3, R8
	ldr	R10, =IM_W
	ldr	R10, [R10]		@IM_Width
	mov	R11, #6
	mul	R10, R10, R11
	add	R0, R10, #25
	bl	draw_number
	
	@draw_string(screen.xres-25-7*IM_WIDTH, screen.yres-2-IM_HEIGHT, letter_images, "LIVES");
	ldr  	R11, [R9, #4]		@screen.yres
	sub	R11, R11, #2		@screen.yres - 2	
	ldr	R10, =IM_H
	ldr	R10, [R10]		@IM_Height
	sub	R1, R11, R10		@screen.yres-2-IM_HEIGHT
	mov	R2, R6	
	ldr	R3, =livesStr
	ldr  	R11, [R9, #0]		@ X resolution, screen.xres
	sub	R11, R11, #25		@screen.xres - 25
	ldr	R10, =IM_W
	ldr	R10, [R10]		@IM_WIDTH
	mov	R0, #7		
	mul	R0, R0, R10		@IM_WIDTH * 7
	sub	R0, R11, R0		@screen.xres - 25 - IM_WIDTH * 7
	bl	draw_string
	

	@draw_number(screen.xres-25-IM_WIDTH, screen.yres-2-IM_HEIGHT, digit_images, lives);
	ldr  	R11, [R9, #4]		@screen.yres
	sub	R11, R11, #2		@screen.yres - 2	
	ldr	R10, =IM_H
	ldr	R10, [R10]		@IM_Height
	sub	R1, R11, R10		@screen.yres-2-IM_HEIGHT
	mov	R2, R5	
	mov	R3, R7
	ldr  	R11, [R9, #0]		@ X resolution, screen.xres
	sub	R11, R11, #25		@screen.xres - 25
	ldr	R10, =IM_W
	ldr	R10, [R10]		@IM_WIDTH
	mov	R0, #1	
	mul	R0, R0, R10		@IM_WIDTH * 1
	sub	R0, R11, R0		@screen.xres - 25 - IM_WIDTH * 7
	bl	draw_number


	mov	R0, R5
	mov	R1, R6			@LETTER_IMAGES
	mov	R2, R7			
	mov	R3, R8
	pop 	{R5-R11}
	pop 	{PC}


