	.arch	armv7
	.cpu	cortex-a53
	.fpu	neon-fp-armv8
	.global dist
	.text

	.text			@ beginning of code lines

/*
	distance calculation.
	dist method takes 4 parameters.
	X0 ( R0), Y1(R1),  X1(R2), Y2(R2)
	float dist(int x1,int y1,int x2,int y2)
	{
   	 	return sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
	}
	and returns the sqrt of this formula (x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)) in S0
*/
dist:	
    	push {LR}
    	push {R5-R11} 
	cmp R0, R2  	// if R0 less than R2, do R2-R0. else do R0 - R2
	blt do1
	sub R5, R0,R2
	cmp R1,R3 	// if R1 less than R3, do R3-R1. else do R1 - R3
	blt do2
  	sub R6, R1,R3
	b   finalCalculation 
    	

do1:
	sub R5, R2,R0
	cmp R1,R3
	blt do2
  	sub R6, R1,R3
	b   finalCalculation 	 
    	

do2: 	
	sub R6, R3,R1	
	b   finalCalculation  
    	
finalCalculation:
	mul  R5, R5, R5		//so we did x1-x2, now we are doing (X1-X2)*(X1-X2)
	mul  R6,R6,R6		//so we did Y1-Y2, now we are doing (Y1-Y2)*(Y1-Y2)
	add  R0, R5, R6		// we add to R0
	mov	R5, R0
	vmov S0, R5		// We want to convert integer to floating point format, to calculate its square root.
	vcvt.f32.s32  S0, S0
	vsqrt.f32  S0,S0	//square root result will be in S0.
	vcvt.s32.f32  S6, S0		@ convert floating point to integer format (truncate)
	vmov    R0, S6			@ and move to general register.
	pop {R5-R11}
   	pop {PC}



