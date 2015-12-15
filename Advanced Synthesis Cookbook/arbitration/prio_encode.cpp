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

//baeckler - 11-14-2006

#include <stdio.h>

int log2 (int n)
{
	int bits = 0;
	while (n)
	{
		n >>= 1;
		bits++;
	}
	return (bits);
}

int main (void)
{
	unsigned int num_ins = 6;
	unsigned int num_outs = log2(num_ins);

	unsigned int num_cases = (1<<num_ins);
	unsigned int n = 0, k = 0;
	unsigned int out_val = 0;

	fprintf (stdout,"//baeckler - 11-14-2006\n");
	fprintf (stdout,"// priority encoder\n");
	fprintf (stdout,"//   no requests - output = 0\n");
	fprintf (stdout,"//   request bit 0 (highest priority) - output = 1\n");
	fprintf (stdout,"//   request bit %d (lowest priority) - output = %d\n",num_ins-1,num_ins);
	fprintf (stdout,"module prio_encode (reqs,out);\n");
	fprintf (stdout,"input [%d:0] reqs;\n",num_ins-1);
	fprintf (stdout,"output [%d:0] out;\n",num_outs-1);
	fprintf (stdout,"reg [%d:0] out;\n\n",num_outs-1);

	fprintf (stdout,"    always @(*) begin\n");
	fprintf (stdout,"      case(reqs)\n");
	
	fprintf (stdout,"        // 0 is special, no reqs\n");
	fprintf (stdout,"        %d'd%d: out = %d;\n\n",num_ins,0,0);		    
	
	for (n=1; n<num_cases; n++)
	{	
		out_val = 1;
		k = n;
		while (k && !(k&1))
		{
			k >>=1;
			out_val += 1;	
		}	
		fprintf (stdout,"        %d'd%d: out = %d;\n",num_ins,n,out_val);		    
	}
	fprintf (stdout,"      endcase\n");
	fprintf (stdout,"    end\n");
	fprintf (stdout,"endmodule\n");
	return (0);
}