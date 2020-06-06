	.arch	armv7
	.cpu	cortex-a53
	.fpu	neon-fp-armv8
	.global draw_string
	.include	"header.s"

	.text			@ beginning of code lines

/*
	void draw_string (int x, int y, unsigned char *images, char *message)
	{
	    int i;

	    for (i = 0; i < strlen(message); i++)
		draw_letter(x + i*IM_WIDTH, y, images, message[i]);
	}
*/
draw_string:
	push 	{LR}
    	push 	{R5-R11} 
	mov	R9, #0		@i 
	b	startForLoobi

startForLoobi:
	mov	R5, R0		@x
	mov	R6,R1		@y
	mov	R7, R2		@Images
	mov 	R8, R3		@message
	mov	R0, R3		@put message in r3, and call strlen to get its length.
	bl	strlen
	cmp	R9, R0		@i < strlen(message) . R0 is strlen(message).
	blt	goONWith
	b 	endIt

goONWith:
	ldr	R0, =IM_W
	ldr	R0, [R0]		@IM_WIDTH
	mul	R0, R0, R9		@IM_WIDTH *i
	add	R0, R0, R5		@x + im_width * i
	mov	R1, R6			@Y
	mov	R2, R7			@IMAGES
	ldrb	R3, [R8,R9]		@message[i]
	bl	draw_letter
	mov	R0, R5			@x
	mov	R1,R6			@y
	mov	R2, R7			@images
	mov 	R3, R8			@message
	add	R9, R9, #1		@UPDATE i , i++.
	b	startForLoobi

endIt:
	pop 	{R5-R11}
   	pop 	{PC}	
	
