	.arch	armv7
	.cpu	cortex-a53
	.fpu	neon-fp-armv8
	 .include	"header.s"
	.global draw_letter
	.text

	.text			@ beginning of code lines

/*
	void draw_letter (int x, int y, unsigned char *images, char letter)
	{
	    unsigned char *im;

	    im = images + (letter-65) * IM_WIDTH * IM_HEIGHT;

	    draw_image(x,y,im);
	}
*/

draw_letter:
	push 	{LR}
    	push 	{R5-R11} 
	ldr	R6, =IM_H
	ldr	R6, [R6]		@IM_HEIGHT
	ldr	R7, =IM_W
	ldr	R7, [R7]		@IM_WIDTH
	mul	R5, R6,R7		@IM_WIDTH * IM_HEIGHT
	sub	R3, R3, #65		@letter - 65
	mul	R5, R5, R3		@IM_WIDTH * IM_HEIGHT * (letter - 65)
	add	R2, R5, R2		@IM_WIDTH * IM_HEIGHT * digit + images
	bl	draw_image
	pop 	{R5-R11}
   	pop 	{PC}	
