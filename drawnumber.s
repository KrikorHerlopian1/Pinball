	.arch	armv7
	.cpu	cortex-a53	
	.fpu	neon-fp-armv8
	.include	"header.s"
	.global draw_number
	.text

/*
	void draw_number (int x, int y, unsigned char *images, int num)
	{
	   int divisor = 1000000000;
	   int quotient;
	   int start = 0;

	   if (num == 0)
	       draw_digit(x, y, images, num);
	   else
	       while (divisor != 0)
	       {
		   quotient = num / divisor;
	    
		   if ((quotient != 0) || (quotient == 0 && start != 0))
		   {
		       draw_digit(x+IM_WIDTH*start, y, images, quotient);
		       start++;
		   }
	     
		   num -= quotient * divisor;
		   divisor /= 10;
	       }
}
*/

draw_number:
	push 	{LR}
	push 	{R5-R11}
	cmp	R3, #0
	beq	tafinish
	mov	R5, #0			@R5 will be start
	ldr	R6, =divisorInit
	ldr	R6, [R6]

startWhile:
	udiv	R7, R3, R6		@R7 is quotient. quotient = num / divisor
	cmp	R7, #0			@(quotient != 0) 
	bne	enterIfQ
	cmp	R7,#0			@quotient == 0
	beq	checkAndPart
	b	dontEnterIfQ	

checkAndPart:
	cmp 	R5, #0			@start == 0
	bne	enterIfQ
	b	dontEnterIfQ

enterIfQ:
	mov	R8, R0
	mov	R9, R1
	mov	R10, R2
	mov	R11, R3	
	ldr	R0, =IM_W
	ldr	R0, [R0]		@IM_WIDTH
	mul	R0, R0, R5		@IM_WIDTH * START
	add	R0, R0, R8		@x + IM_WIDTH * START
	mov	R3, R7			@quotient
	bl	draw_digit
	mov	R0, R8
	mov	R1, R9
	mov	R2, R10
	mov	R3, R11
	add	R5, R5, #1		@START = START + 1
	

dontEnterIfQ:
	mul	R10, R6, R7		@quotient * divisor
	sub	R3, R3, R10		@num = num - quotient * divisor
	mov	R10, #10
	udiv	R6,R6, R10
	cmp	R6, #0
	bne	startWhile
	b	tafinish2

tafinish:
	bl	draw_digit

tafinish2:
	pop 	{R5-R11}
	pop 	{PC}
