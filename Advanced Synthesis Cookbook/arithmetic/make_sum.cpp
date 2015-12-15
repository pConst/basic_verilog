// Copyright 2008 Altera Corporation. All rights reserved.  
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

int const num_ins = 3; // per word to add
int const num_outs = num_ins + 1;

int main (void)
{
	unsigned int n = 0, k = 0, sum = 0;
	unsigned int mask = (1 << num_ins) - 1;

	fprintf (stdout,"    case (data)\n");
	for (n=0; n<(1<<(num_ins*2)); n++)
	{
		sum = (n >> num_ins) & mask;
		sum += (n & mask);
		
		fprintf (stdout,"      %d'd%d: sum=%d'd%d;\n",2*num_ins,n,num_outs,sum);
	}
	fprintf (stdout,"      default: sum=0;\n");
    fprintf (stdout,"    endcase\n");

	return (0);
}