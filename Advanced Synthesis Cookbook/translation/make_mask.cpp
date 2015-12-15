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

int const num_ins = 4;
int const num_outs = 1 << num_ins;

int main (void)
{
	unsigned int n = 0, k = 0;
	int style = 0;

	bool from_msb = false;
	bool diag_ones = false;

	fprintf (stdout,"module mask_%d (in,mask);\n",num_outs);
	fprintf (stdout,"input [%d:0] in;\n",num_ins-1);
	fprintf (stdout,"output [%d:0] mask;\n",num_outs-1);
	fprintf (stdout,"reg [%d:0] mask;\n\n",num_outs-1);
	fprintf (stdout,"parameter FROM_MSB = 1'b1;\n");
	fprintf (stdout,"parameter DIAG_ONES = 1'b1;\n\n");
	
	fprintf (stdout,"generate\n");
	for (style = 0; style < 4; style++)
	{
		from_msb = (style & 1) != 0 ? true : false;
		diag_ones = (style & 2) != 0 ? true : false;

		fprintf (stdout,"  %sif (%cFROM_MSB && %cDIAG_ONES) begin\n",
			(style == 0 ? "" : "else "),
			(from_msb ? ' ' : '!'),
			(diag_ones ? ' ' : '!'));

		fprintf (stdout,"    always @(in) begin\n");
		fprintf (stdout,"    case (in)\n");
		for (n=0; n<num_outs; n++)
		{
			fprintf (stdout,"      %d'd%d: mask=%d'b",num_ins,n,num_outs);
			for (k=0; k<num_outs; k++)
			{
				if (from_msb)
				{
					if (diag_ones)
					{
						fprintf (stdout,"%c",(k<=n ? '1' : '0'));
					}
					else
					{
						fprintf (stdout,"%c",(k<n ? '1' : '0'));
					}
				}
				else
				{
					if (diag_ones)
					{
						fprintf (stdout,"%c",((num_outs-1-k)<=n ? '1' : '0'));	
					}
					else
					{
						fprintf (stdout,"%c",((num_outs-1-k)<n ? '1' : '0'));	
					}
				}
			}		
			fprintf (stdout,";\n");
		}
		fprintf (stdout,"      default: mask=0;\n");
		fprintf (stdout,"    endcase\n");
		fprintf (stdout,"    end\n");
		fprintf (stdout,"  end\n");
		
	}
	fprintf (stdout,"endgenerate\n");
	fprintf (stdout,"endmodule\n");
	
	return (0);
}