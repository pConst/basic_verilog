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

/*
LIU - 07-16-2007
tbl_gen is used to generate a table for 1/x estimation. 
  -The inputs are address bitwidth and data bitwidth.
  -Note that both address-in and data-out have a hidden leading 1
  -The estimation error is always positive (under-estimated)
  -The table may be automatically mapped to RAM. To force luts, add "synthesis keep" 
*/

///////////////////////////////////
#include <stdio.h>
#include <cstdlib>


void gen_tbl (int addr_width, int data_width)
/*	addr input has one hidden leading 1
 *	data output has one hidden leading 1
 */ 
{
	int i;
	int e0;

	fprintf(stdout,"module div_tbl(clk, in, out);\n");
	fprintf(stdout,"input clk;\n", (addr_width-1));
	fprintf(stdout,"input [%d:0] in;\n", (addr_width-1));
	fprintf(stdout,"output [%d:0] out;\n", (data_width-1));
	fprintf(stdout,"reg [%d:0] out;\n\n", (data_width-1));

	fprintf(stdout,"always @(posedge clk) begin\n");
	fprintf(stdout,"   case (in)\n");

	for (i = 0; i < (1<<addr_width); i++)
	{
		e0 = (1 << (addr_width + data_width + 1)) / ((1<<addr_width)+i+1);
		if ( (e0 & (1 << data_width )) == 0 ||
			(e0 >> (data_width+1)) != 0  )
		{
			return;
		}

		fprintf(stdout,"        %d'h%x : out <= %d'h%x;\n", 
				addr_width, i, data_width,e0 & ((1<<data_width)-1) );
	}
	
	fprintf (stdout,"    endcase\n");
	fprintf (stdout,"end\n");

	fprintf(stdout,"endmodule\n");
	
}

int main (int argc, char** argv)
{
	if ( argc == 3 )
	{
		int addr_w = atoi(argv[1]);
		int data_w = atoi(argv[2]);
		gen_tbl (addr_w,data_w);
	}
	else
	{
		fprintf(stdout, "Usage: tbl_gen [address width] [data_width]\n");
	}

	return (0);
}