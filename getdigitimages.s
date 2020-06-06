	.arch	armv7
	.cpu	cortex-a53
	.fpu	neon-fp-armv8
	.include	"header.s"
	.global get_digit_images
	.text
/*
	unsigned char *get_digit_images ()
	{
	    unsigned char *images;
	    int fdimage;

	    fdimage = open("digits.raw", O_RDONLY);
	    images = malloc(10 * IM_WIDTH * IM_HEIGHT);
	    read(fdimage, images, 10 * IM_WIDTH * IM_HEIGHT);
	    close(fdimage);

	    return images;
	}
*/

get_digit_images:
	push 	{LR}
	push 	{R5-R11}
	mov	R8 , R1
	mov	R5, R2
	ldr	R0, =digits2
	mov	R1, #0			@O_RDONLY
	bl	open			@ open("digits.raw", O_RDONLY);
	mov	R10, R0			@fdimage
	ldr	R6, =IM_H
	ldr	R6, [R6]		@IM_HEIGHT
	ldr	R7, =IM_W
	ldr	R7, [R7]		@IM_WIDTH
	mov	R9, #10
	mul	R9, R9, R6		@im_height * 10
	mul	R9, R9, R7		@im_height * 10 * im_width
	mov	R0, R9
	bl	malloc
	mov	R11, R0			@IMAGES
	mov	R1, R0			@images
	mov	R0, R10			@FDIMAGE
	mov	R2, R9
	bl	read
	mov	R0 , R10
	bl	close
	mov	R0, R11
	mov	R1, R8
	mov	R2, R5
	pop 	{R5-R11}
	pop 	{PC}

