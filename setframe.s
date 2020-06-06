	.global setup_framebuffer
	.global screen
	.global fbp
@	.extern fbp

	.equ  O_RDWR, 0x00000002
	.equ  PROT_READ, 1
	.equ  PROT_WRITE, 2
	.equ  PROT_FLAGS, (PROT_READ | PROT_WRITE)
	.equ  MAP_SHARED, 1
	.equ  FBIOGET_VSCREENINFO, 0x4600
	.equ  FBIOPUT_VSCREENINFO, 0x4601
	.equ  FBIOGET_FSCREENINFO, 0x4602
	
	.text			@ beginning of code lines


setup_framebuffer: 		@ definition of main function

	push {LR}
	push {R5-R11}

        ldr  R0, =memfile
        mov  R1, #O_RDWR
        bl   open
	mov  R5, R0		@ file descriptor of /dev/fb0

	ldr  R1, =fbgetflag
	ldr  R1, [R1]
	ldr  R2, =screen
	bl   ioctl

	ldr  R10, =screen	@ address of frame buffer record
	ldr  R6, [R10, #0]	@ X resolution
	ldr  R7, [R10, #4]	@ Y resolution
	ldr  R9, [R10, #24]	@ Bits per pixel

	sub  SP, SP, #8
	str  R5, [SP]
	mov  R0, #0
	str  R0, [SP, #4]
	mov  R0, #0
	mul  R1, R6, R7
	mov  R11, #4
	mul  R1, R1, R11
	mov  R2, #PROT_FLAGS
	mov  R3, #MAP_SHARED
	bl   mmap
	add  SP, SP, #8

	ldr  R10, =fbp
	str  R0, [R10]

	mov  R0, R5
	bl   close

	pop {R5-R11}
	pop {PC}

	.data
	.align 4
screen:
	.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	.align 4
fbp:    
	.word 0
	.align 4
flags:
	.word O_RDWR
	.align 4
fbgetflag:
	.word FBIOGET_VSCREENINFO
	.align 4
fbputflag:
	.word FBIOPUT_VSCREENINFO
	.align 4
memfile:
	.asciz "/dev/fb0"

