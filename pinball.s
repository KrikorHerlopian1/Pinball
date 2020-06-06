	.arch	armv7
	.cpu	cortex-a53
	.fpu	neon-fp-armv8
	.include "header.s"
	.global main
	.text

	.text				@ beginning of code lines


/*
	int main(int argc, char* argv[])
	{
	    int fdstdin;
	    int numc;
	    char inchars[3];
	    unsigned char *digit_images, *letter_images;
	    sq_data ball, paddle, alien;
	    int lives, score, dead;
	    int difficulty = 1;
	    unsigned int alien_color;

	    srand(time(NULL));

	    if (argc != 2)
		exit(1);
	    else
	    {
		difficulty = argv[1][0] - 48;
	    }

	    digit_images  = get_digit_images();
	    letter_images = get_letter_images();

	    setup_framebuffer();

	    init_ball(&ball, difficulty);
	    init_paddle(&paddle, difficulty);
	    init_alien(&alien, difficulty);

	    system("stty -icanon -echo min 0 time 0");
	    fdstdin = open("/dev/stdin", O_NONBLOCK);
	    inchars[0] = '.';

	    lives = 3;
	    score = 0;
	    alien_color = PURPLE;

	    do_intro(digit_images, letter_images, lives, score);

	    while (inchars[0] != 'q' && lives > 0)
	    {
		
		numc = read(fdstdin, inchars, 3);

		update_alien(&alien);
		update_paddle(&paddle, inchars, numc);
		dead = update_ball(&ball, &paddle, &alien, &score);
		memset(fbp, BLACK, screen.xres * screen.yres * screen.bits_per_pixel/8);
		draw_info(digit_images, letter_images, lives, score);
		draw_circle(&alien, alien_color);
		draw_circle(&ball, BLUE);
		draw_square(&paddle, GREEN);
		if (dead)
		{
		    lives--;
		    init_ball(&ball,difficulty);
		    init_paddle(&paddle,difficulty);
		}
		if (rand() % 10 == 0)
		    alien_color += rand();
		usleep(FRAME_DELAY);
	    }

	    do_ending(digit_images, letter_images, lives, score);

	    // cleanup
	    system("stty icanon echo min 0 time 0");
	    close(fdstdin);
	    munmap(fbp, screen.xres * screen.yres * screen.bits_per_pixel / 8);

	    return 0;
	}
*/

@R6 Difficulty
@R5 digit_images
@R7 letter_images
@R8 fdstdin
main:	
	mov	R5, R0
	mov	R6, R1
	mov	R0, #0
	bl	time
	bl	srand

	cmp	R5, #2
	bne	exitApp
	
	mov 	R3, R6			

	add	R3, R3, #4	
	ldr	R3, [R3]	
	ldrb	R6, [R3,#0]		@ in case user types difficulty 99, we only take the first 9.In case he types 3, we take 3.
	sub	R6, R6, #48		@dificulty level in R6.
	
	bl	get_digit_images
	mov	R5, R0			@digit_images
	
	bl	get_letter_images
	mov	R7, R0			@letter_images
	
	bl	setup_framebuffer

	@init_ball(&ball, difficulty);	
	ldr  	R0, =ball		@ address of ball
	mov	R1, R6
	bl	init_ball	
	
	@init_paddle(&paddle, difficulty);	
	ldr  	R0, =paddle		@ address of paddle
	mov	R1, R6
	bl	init_paddle

	@init_alien(&alien, difficulty);
	ldr  	R0, =alien		@ address of alient
	mov	R1, R6
	bl	init_alien

	ldr	R0, =msgStr
	bl	system
	
	@open("/dev/stdin", O_NONBLOCK);
	ldr	R0, = msg2Str
	mov 	R1, #O_NONBLOCK		@O_NONBLOCK , 2048
	bl	open
	mov	R8, R0			@fdstdin

	@inchars[0] = '.';
	ldr	R1, =inchars
	mov	R2, #46			@. is 46 in ascii table.
	strb	R2, [R1, #0]

	@R5 digit_images
	@R6 Difficulty
	@R7 letter_images
	@R8 fdstdin
	@R9 lives
	@R11 alien_color
	mov	R9, #3			@LIVES
	mov	R11, #RED		@ALIEN_COLOR
	add	R11, R11, #255		@to get purple
	

	@do_intro(digit_images, letter_images, lives, score)
	mov	R0, R5
	mov	R1, R7
	mov	R2, R9
	ldr	R3, =score
	ldr	R3,[R3]
	bl	do_intro
	
	b	startTheWhileLoop

exitApp:
	mov	R0, #1
	bl	exit

startTheWhileLoop:
	ldr	R1, =inchars
	ldrb	R1,[R1, #0]
	cmp	R1, #113
	beq	endApp
	cmp	R9, #0	
	ble	endApp	
	
	@numc = read(fdstdin, inchars, 3);
	mov	R0,R8
	ldr	R1, =inchars
	mov	R2, #3
	bl	read
	mov	R2, R0
	
	@update_alien(&alien);
	ldr	R0,=alien
	bl	update_alien
	
	@update_paddle(&paddle, inchars, numc);
	ldr	R0,=paddle
	ldr	R1, =inchars
	bl	update_paddle

	@dead = update_ball(&ball, &paddle, &alien, &score, lives); extra credit i added lives
	ldr	R0, =ball
	ldr	R1, =paddle
	ldr	R2, =alien
	ldr	R3, =score	
	mov 	R4, R9			@Lives
	bl	update_ball
	mov	R9, R4			@UPDATED LIVES
	
	@R10 is variable dead now.
	mov	R10,R0

	@memset(fbp, BLACK,screen.xres * screen.yres * screen.bits_per_pixel / 8);
	ldr  	R0, =fbp		@ address of fb part record
	ldr	R0, [R0]
	ldr  	R3, =screen
	ldr  	R2, [R3, #0] 		@screen.xres
	ldr	R1, [R3, #4]		@screen.yres
	mul	R2 ,R2, R1		@screen.xres * screen.yres
	ldr	R1, [R3, #24]		@screen.bits_per_pixel
	mul	R1, R2, R1		@screen.xres * screen.yres * screen.bits_per_pixel
	mov	R2, R1, LSR #3		@screen.xres * screen.yres * screen.bits_per_pixel/8
	mov	R1, #BLACK
	bl	memset
	
	@draw_info(digit_images, letter_images, lives, score);
	mov	R0, R5
	mov	R1, R7
	mov	R2, R9
	ldr	R3, =score
	ldr	R3, [R3]
	bl 	draw_info
	
        @draw_circle(&alien, alien_color);
	ldr	R0, =alien
	mov	R1,R11
	bl	draw_circle

	
        @draw_circle(&ball, BLUE);
	ldr	R0, =ball
	mov	R1, #BLUE
	bl	draw_circle
        
	@draw_square(&paddle, GREEN);
	ldr	R0, =paddle
	mov	R1, #GREEN
	bl	draw_square
	
	cmp	R10, #1
	beq	isDead
	b	ranPd
isDead:
	sub	R9, R9, #1	@lives--
	
	@init_ball(&ball,difficulty);
	ldr	R0,=ball
	mov	R1, R6
	bl	init_ball
	
	@init_paddle(&paddle,difficulty);
	ldr	R0,=paddle
	mov	R1, R6
	bl	init_paddle

ranPd:
	bl	rand 
	mov	R1, #10
	udiv	R2, R0, R1
	mul	R2,R2,R1
	sub	R0,R0,R2
	cmp	R0, #0
	bne	usleePart
	bl	rand
	add	R11, R11, R0		@alien_color += rand()


usleePart:
	@usleep(FRAME_DELAY);
	ldr	R0, =fr_de
	ldr	R0, [R0]		@frame delay
	bl	usleep		
	b	startTheWhileLoop
endApp:
	@do_ending(digit_images, letter_images, lives, score);
	mov	R0,R5
	mov	R1,R7
	mov	R2,R9
	ldr	R3,=score
	ldr	R3,[R3]
	bl	do_ending	

	@system("stty icanon echo min 0 time 0");
	ldr	R0, =msg3Str
	bl	system

	@close(fdstdin);
	mov	R0,R8
	bl	close
	
	@munmap(fbp, screen.xres * screen.yres * screen.bits_per_pixel / 8);
	ldr  	R0, =fbp		@ address of fb part record
	ldr	R0, [R0]
	ldr  	R3, =screen
	ldr  	R2, [R3, #0] 		@screen.xres
	ldr	R1, [R3, #4]		@screen.yres
	mul	R2 ,R2, R1		@screen.xres * screen.yres
	ldr	R1, [R3, #24]		@screen.bits_per_pixel
	mul	R1, R2, R1		@screen.xres * screen.yres * screen.bits_per_pixel
	mov	R1, R1, LSR #3		@screen.xres * screen.yres * screen.bits_per_pixel/8
	bl	munmap

	mov	R0, #0		@return 0
	.data
	.align 4
ball:
	.word 0,0,0,0,0,0,0
	.align 4
paddle:
	.word 0,0,0,0,0,0,0
	.align 4
alien:
	.word 0,0,0,0,0,0,0
inchars:
	.byte 0, 0, 0	
score: .word 0
