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

// baeckler - 7-21-2006

#include <stdio.h>

int bit_count (int c)
{
	int cnt = 0;
	int n = 0;

	for (n=0;n<6; n++)
	{
		if ((c & 1) != 0) cnt++;
		c >>= 1;
	}
	return (cnt);
}

int main (void)
{
	
	int code = 0;
	int diff[4];
	int best_diff = 0;

	fprintf (stdout,"//////////////////////////////////////////////\n");
	fprintf (stdout,"// 2 to 6 bit ECC encoder\n");
	fprintf (stdout,"//////////////////////////////////////////////\n");
	fprintf (stdout,"module ecc_encode_2bit (d,c);\n");
	fprintf (stdout,"input [1:0] d;\n");
	fprintf (stdout,"output [5:0] c;\n");
	fprintf (stdout,"wire [5:0] c;\n\n");

	fprintf (stdout,"  assign c = {d[1],d[1],d[0],d[0],^d,^d};\n");
	fprintf (stdout,"endmodule\n\n");
	
	fprintf (stdout,"//////////////////////////////////////////////\n");
	fprintf (stdout,"// the error flag indicates\n");
	fprintf (stdout,"//   [2] 2 or more bit error\n");
	fprintf (stdout,"//   [1] 1 bit error (corrected)\n");
	fprintf (stdout,"//   [0] no error\n");
	fprintf (stdout,"//////////////////////////////////////////////\n");
	
	fprintf (stdout,"module ecc_decode_2bit (c,d,err_flag);\n");
	fprintf (stdout,"input [5:0] c;\n");
	fprintf (stdout,"output [1:0] d;\n");
	fprintf (stdout,"output [2:0] err_flag;\n");
	fprintf (stdout,"reg [1:0] d;\n");
	fprintf (stdout,"reg [2:0] err_flag;\n");

	fprintf (stdout,"  always @(c) begin\n");
	fprintf (stdout,"    case (c)\n");
	fprintf (stdout,"                      // bit distance to codes 0 .. 3\n");
	for (code = 0; code<64; code++)
	{
		fprintf (stdout,"      6'h%02x : ",code);

		// look at the bit distance from input to the codes
		diff[0] = bit_count(code ^ 0x00);
		diff[1] = bit_count(code ^ 0x0f);
		diff[2] = bit_count(code ^ 0x33);
		diff[3] = bit_count(code ^ 0x3c);
		best_diff = 0;
		if (diff[1] < diff[best_diff]) best_diff = 1;
		if (diff[2] < diff[best_diff]) best_diff = 2;
		if (diff[3] < diff[best_diff]) best_diff = 3;

		// select data
		fprintf (stdout, "{d,err_flag} = {2'b%d%d, 3'b%d%d%d};",
				(best_diff>>1) & 1, best_diff & 1,
				diff[best_diff] >= 2 ? 1 : 0,
				diff[best_diff] == 1 ? 1 : 0,
				diff[best_diff] == 0 ? 1 : 0);

		fprintf (stdout," // %d %d %d %d\n",diff[0],diff[1],diff[2],diff[3]);	
		
	}
	fprintf (stdout,"    endcase\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"endmodule\n");
	
	
	return (0);
	
}