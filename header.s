	.arch	armv7
	.cpu	cortex-a53
	.fpu	neon-fp-armv8	
	.equ    BLACK, 0x00000000
	.equ    PURPLE, 0x00FF00FF
	.equ    BLUE, 0x000000FF
	.equ    GREEN, 0x0000FF00
	.equ    RED, 0x00FF0000
	.equ    O_NONBLOCK, 0x00000800
	.data
	 IM_W:	.word	 28 	@IM_WIDTH
	 IM_H:	.word	 48	@IM_HEIGHT
	 fr_de:	 .word	 30000		@frame_delay
	divisorInit:	 .word	 1000000000
gameStr: 
	.asciz	"GAME"
overStr: 
	.asciz	"OVER"
getStr: 
	.asciz	"GET"
readyStr: 
	.asciz	"READY"
livesStr: 
	.asciz	"LIVES"
livesStrl: 
	.asciz	"lives"
pinballStr: 
	.asciz	"PINBALL"
wizardStr:
	.asciz	"WIZARD"
scoreStr:
	.asciz	"SCORE"
digits2: 
	.asciz	"digits.raw"
letters2: 
	.asciz	"letters.raw"
msgStr:
	.asciz "stty -icanon -echo min 0 time 0"
msg2Str:
	.asciz "/dev/stdin"
msg3Str:
	.asciz "stty icanon echo min 0 time 0"
