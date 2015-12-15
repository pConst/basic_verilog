// Copyright 2007 Altera Corporation. All rights reserved.  
// Altera products are protected under numerous U.S. and foreign patents, 
// maskwork rights, copyrights and other intellectual property laws.  
//
// This reference design file, and your use thereof, is subject to and governed
// by the terms and conditions of the applicable Altera Reference Design 
// License Agreement (either as signed by you or found at www.altera.com).  By
// using this reference design file, you indicate your acceptance of such terms
// and conditions between you and Altera Corporation.  In the event that you do
// not agree with such terms and conditions, you may not use the reference 
// design file and please promptly destroy any copies you have made.
//
// This reference design file is being provided on an "as-is" basis and as an 
// accommodation and therefore all warranties, representations or guarantees of 
// any kind (whether express, implied or statutory) including, without 
// limitation, warranties of merchantability, non-infringement, or fitness for
// a particular purpose, are specifically disclaimed.  By making this reference
// design file available, Altera expressly does not recommend, suggest or 
// require that this reference design file be used in combination with any 
// other product not provided by Altera.
/////////////////////////////////////////////////////////////////////////////

#include <stdio.h>
#include <math.h>
#include <stdlib.h>

int main (void)
{
	
	float f = 0.0;
	void * ptr = &f;
	unsigned int i = 0;
	float tmp_x,tmp_y,sq,orig;
	int n = 0;
	int max = 100000;

	srand (123);

	for (n=0; n<max; n++)
	{
		// select random float val
		tmp_x = rand();
		tmp_y = rand();
		if (tmp_y == 0.0) tmp_y = 1;
		f = tmp_x / tmp_y;
		i = *((unsigned int *)ptr);
		fprintf (stdout,"32'h%08x,",i);
	
		// inverse square root
		orig = f;
		sq = 1/sqrt(orig);

		// Error less than 2 %
		tmp_x = sq * 0.98;		
		tmp_y = sq * 1.02;		
		
		f = tmp_x;
		i = *((unsigned int *)ptr);
		fprintf (stdout,"32'h%08x,",i);
	
		f = tmp_y;
		i = *((unsigned int *)ptr);
		fprintf (stdout,"32'h%08x, ",i);

		// Error less than 5 %
		tmp_x = sq * 0.95;		
		tmp_y = sq * 1.05;		
		
		f = tmp_x;
		i = *((unsigned int *)ptr);
		fprintf (stdout,"32'h%08x,",i);
	
		f = tmp_y;
		i = *((unsigned int *)ptr);
		fprintf (stdout,"32'h%08x, ",i);

		// Error less than 10 %
		tmp_x = sq * 0.90;		
		tmp_y = sq * 1.10;		
		
		f = tmp_x;
		i = *((unsigned int *)ptr);
		fprintf (stdout,"32'h%08x,",i);
	
		f = tmp_y;
		i = *((unsigned int *)ptr);
		fprintf (stdout,"32'h%08x",i);

		if (n != (max-1)) fprintf (stdout,",");

		fprintf (stdout,"// invsqrt(%0.4f) = %0.4f\n",orig,sq);
	
		
	}
	return (0);
}
