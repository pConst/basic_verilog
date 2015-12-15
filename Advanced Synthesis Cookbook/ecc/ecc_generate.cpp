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

// baeckler - 07-06-2006
//    reved to be more parameterized 08-25-2006
//
// Build verilog factored XORs for error correction encode
// matrix.  Not very fancy because there isn't any good reuse
// to be had on the depth 2 6-LUT solution.  Needs a bit of
// hand balancing to reflect smaller luts being cheaper.
//
// And then the decoder and appropriate helper modules.  Variable
// latency controlled by parameters.

#include <stdio.h>

// 64 -> 72 (8)
// 32 -> 39	(7)
// 16 -> 22	(6)
// 8 -> 13	(5)

int const DATA_BITS = 8;
int const SYN_BITS = 5;
int const TOTAL_BITS = DATA_BITS + SYN_BITS;


unsigned char matrix[64][72+1] = 
{
"11100000000000000000000000000000000000000000000000000000000000000000000",
"10011000000000000000000000000000000000000000000000000000000000000000000",
"01010100000000000000000000000000000000000000000000000000000000000000000",
"11010010000000000000000000000000000000000000000000000000000000000000000",
"10000001100000000000000000000000000000000000000000000000000000000000000",
"01000001010000000000000000000000000000000000000000000000000000000000000",
"11000001001000000000000000000000000000000000000000000000000000000000000",
"00010001000100000000000000000000000000000000000000000000000000000000000",
"10010001000010000000000000000000000000000000000000000000000000000000000",
"01010001000001000000000000000000000000000000000000000000000000000000000",
"11010001000000100000000000000000000000000000000000000000000000000000000",
"10000000000000011000000000000000000000000000000000000000000000000000000",
"01000000000000010100000000000000000000000000000000000000000000000000000",
"11000000000000010010000000000000000000000000000000000000000000000000000",
"00010000000000010001000000000000000000000000000000000000000000000000000",
"10010000000000010000100000000000000000000000000000000000000000000000000",
"01010000000000010000010000000000000000000000000000000000000000000000000",
"11010000000000010000001000000000000000000000000000000000000000000000000",
"00000001000000010000000100000000000000000000000000000000000000000000000",
"10000001000000010000000010000000000000000000000000000000000000000000000",
"01000001000000010000000001000000000000000000000000000000000000000000000",
"11000001000000010000000000100000000000000000000000000000000000000000000",
"00010001000000010000000000010000000000000000000000000000000000000000000",
"10010001000000010000000000001000000000000000000000000000000000000000000",
"01010001000000010000000000000100000000000000000000000000000000000000000",
"11010001000000010000000000000010000000000000000000000000000000000000000",
"10000000000000000000000000000001100000000000000000000000000000000000000",
"01000000000000000000000000000001010000000000000000000000000000000000000",
"11000000000000000000000000000001001000000000000000000000000000000000000",
"00010000000000000000000000000001000100000000000000000000000000000000000",
"10010000000000000000000000000001000010000000000000000000000000000000000",
"01010000000000000000000000000001000001000000000000000000000000000000000",
"11010000000000000000000000000001000000100000000000000000000000000000000",
"00000001000000000000000000000001000000010000000000000000000000000000000",
"10000001000000000000000000000001000000001000000000000000000000000000000",
"01000001000000000000000000000001000000000100000000000000000000000000000",
"11000001000000000000000000000001000000000010000000000000000000000000000",
"00010001000000000000000000000001000000000001000000000000000000000000000",
"10010001000000000000000000000001000000000000100000000000000000000000000",
"01010001000000000000000000000001000000000000010000000000000000000000000",
"11010001000000000000000000000001000000000000001000000000000000000000000",
"00000000000000010000000000000001000000000000000100000000000000000000000",
"10000000000000010000000000000001000000000000000010000000000000000000000",
"01000000000000010000000000000001000000000000000001000000000000000000000",
"11000000000000010000000000000001000000000000000000100000000000000000000",
"00010000000000010000000000000001000000000000000000010000000000000000000",
"10010000000000010000000000000001000000000000000000001000000000000000000",
"01010000000000010000000000000001000000000000000000000100000000000000000",
"11010000000000010000000000000001000000000000000000000010000000000000000",
"00000001000000010000000000000001000000000000000000000001000000000000000",
"10000001000000010000000000000001000000000000000000000000100000000000000",
"01000001000000010000000000000001000000000000000000000000010000000000000",
"11000001000000010000000000000001000000000000000000000000001000000000000",
"00010001000000010000000000000001000000000000000000000000000100000000000",
"10010001000000010000000000000001000000000000000000000000000010000000000",
"01010001000000010000000000000001000000000000000000000000000001000000000",
"11010001000000010000000000000001000000000000000000000000000000100000000",
"10000000000000000000000000000000000000000000000000000000000000011000000",
"01000000000000000000000000000000000000000000000000000000000000010100000",
"11000000000000000000000000000000000000000000000000000000000000010010000",
"00010000000000000000000000000000000000000000000000000000000000010001000",
"10010000000000000000000000000000000000000000000000000000000000010000100",
"01010000000000000000000000000000000000000000000000000000000000010000010",
"11010000000000000000000000000000000000000000000000000000000000010000001"
};


void dump_ecc_coder (FILE * f)
{
	int x=0,y=0;
	int num_terms = 0;
	int lutsize = 6;
	int n=0,i=0,num_helpers=0,num_ins_this_helper=0;

	fprintf (f,"// baeckler - 08-25-2006 \n\n");

	fprintf (f,"//////////////////////////////////////////\n");
	fprintf (f,"// %d bit to %d bit ECC encoder\n",DATA_BITS,TOTAL_BITS);
	fprintf (f,"//////////////////////////////////////////\n\n");
	fprintf (f,"module ecc_encode_%dbit (d,c);\n\n",DATA_BITS);
	fprintf (f,"input [%d:0] d;\n",DATA_BITS-1);
	fprintf (f,"output [%d:0] c;\n",TOTAL_BITS-1);
	fprintf (f,"wire [%d:0] c;\n\n",TOTAL_BITS-1);

	// the MSB of the code is the parity of the other code outs.
	// re-express it in terms of the data inputs in the MSB postion
	// of the matrix.
	for (y=0; y<DATA_BITS; y++)
	{
		matrix[y][TOTAL_BITS-1] = '0';
		matrix[y][TOTAL_BITS] = 0;
	}
	for (x=0; x<(TOTAL_BITS-1); x++)
	{
		for (y=0; y<DATA_BITS; y++)
		{
			if (matrix[y][x] == '1') matrix[y][TOTAL_BITS-1] ^= 1;
		}
	}
	
	// the first TOTAL_BITS-1 bits are in the matrix, last is parity
	for (x=0; x<TOTAL_BITS; x++)
	{
		// count the number of 1's
		num_terms = 0;
		for (y=0; y<DATA_BITS; y++)
		{
			if (matrix[y][x] == '1')
			{
				num_terms++;
			}
		}	
		
		if (num_terms < lutsize)
		{
			// this is fine - just dump it
			num_terms = 0;
			fprintf (f,"  assign c[%d] = ",x);
			for (y=0; y<DATA_BITS; y++)
			{
				if (matrix[y][x] == '1')
				{
					if (num_terms != 0) fprintf (f," ^ ");
					fprintf (f,"d[%d]",y);
					num_terms++;
				}
			} 
			fprintf (f,";\n");
		}
		else
		{
			// create helpers
			num_helpers = num_terms / lutsize;
			if (num_helpers * lutsize < num_terms) num_helpers++;
			fprintf (f,"  wire [%d:0] help_c%d;\n",num_helpers-1,x);
			y = 0;
			for (n=0; n<num_helpers; n++)
			{
				num_ins_this_helper = lutsize;
				if (num_terms < num_ins_this_helper)
				{
					num_ins_this_helper = num_terms;
				}
				
				if (num_ins_this_helper == 1)
				{
					fprintf (f,"  assign help_c%d[%d] = ",x,n);
					while (matrix[y][x] != '1') y++;
					fprintf (f,"d[%d];\n",y);
					y++;
					num_terms--;
				}
				else
				{
					// build the next helper XOR gate
					fprintf (f,"  xor6 help_c%d_%d (help_c%d[%d],",x,n,x,n);
					for (i = 0; i<num_ins_this_helper; i++)
					{
						while (matrix[y][x] != '1') y++;
						if (i != 0) fprintf (f,",");
						fprintf (f,"d[%d]",y);
						y++;
						num_terms--;
					}	
					while (i<lutsize)
					{
						fprintf (f,",1'b0");						
						i++;
					}
					fprintf (f,");\n");
				}
			}

			// xor up the helpers for the result
			fprintf (f,"  assign c[%d] = ^help_c%d;\n\n",x,x);			
		}
	}
	fprintf (f,"endmodule\n\n");
	
	// put together the hamming distance matrix, which 
	// is a slightly odd counter
	unsigned int matrix_h [TOTAL_BITS];
	for (x=0;x<(TOTAL_BITS-1);x++)
	{
		matrix_h[x] = (1<<(SYN_BITS-1)) | (x+1);
	}
	matrix_h[TOTAL_BITS-1] = (1<<(SYN_BITS-1));
	
	// spit out a syndrome generator
	fprintf (f,"//////////////////////////////////////////\n");
	fprintf (f,"// compute a syndrome from the code word\n");
	fprintf (f,"//////////////////////////////////////////\n\n");
	fprintf (f,"module ecc_syndrome_%dbit (clk,rst,c,s);\n\n",DATA_BITS);

	fprintf (f,"// optional register on the outputs\n");
	fprintf (f,"// of bits 0..6 and back one level in bit 7\n");
	fprintf (f,"parameter REGISTER = 0;\n\n");
	
	fprintf (f,"input clk,rst;\n");
	fprintf (f,"input [%d:0] c;\n",TOTAL_BITS-1);
	fprintf (f,"output [%d:0] s;\n",SYN_BITS-1);
	fprintf (f,"reg [%d:0] s;\n\n",SYN_BITS-1);

	for (y=0;y<SYN_BITS;y++)
	{
		num_terms = 0;
		for (x=0;x<TOTAL_BITS;x++)
		{
			if ((matrix_h[x] & (1<<y)) != 0)
			{
				num_terms++;
			}
		}
		fprintf (f,"  // %d terms\n",num_terms);

		// create helpers
		num_helpers = num_terms / lutsize;
		if (num_helpers * lutsize < num_terms) num_helpers++;
		fprintf (f,"  wire [%d:0] help_s%d;\n",num_helpers-1,y);
		x = 0;
		for (n=0; n<num_helpers; n++)
		{
			num_ins_this_helper = lutsize;
			if (num_terms < num_ins_this_helper)
			{
				num_ins_this_helper = num_terms;
			}
			
			if (num_ins_this_helper == 1)
			{
				fprintf (f,"  assign help_s%d[%d] = ",y,n);
				while ((matrix_h[x] & (1<<y)) == 0) x++;
				fprintf (f,"c[%d];\n",x);
				x++;
				num_terms--;
			}
			else
			{
				// build the next helper XOR gate
				fprintf (f,"  xor6 help_s%d_%d (help_s%d[%d],",y,n,y,n);
				for (i = 0; i<num_ins_this_helper; i++)
				{
					while ((matrix_h[x] & (1<<y)) == 0) x++;
					if (i != 0) fprintf (f,",");
					fprintf (f,"c[%d]",x);
					x++;
					num_terms--;
				}	
				while (i<lutsize)
				{
					fprintf (f,",1'b0");						
					i++;
				}
				fprintf (f,");\n");
			}
		}

		// xor up the helpers for the result
		// and optional register for the lower bits
		if ((y != (SYN_BITS-1)) || DATA_BITS != 64)
		{
			fprintf (f,"  generate\n");
			fprintf (f,"    if (REGISTER) begin\n");
			fprintf (f,"      always @(posedge clk or posedge rst) begin\n");
			fprintf (f,"        if (rst) s[%d] <= 0;\n",y);
			fprintf (f,"        else s[%d] <= ^help_s%d;\n",y,y);
			fprintf (f,"      end\n");
			fprintf (f,"    end else begin\n");
			fprintf (f,"      always @(help_s%d) begin\n",y);
			fprintf (f,"        s[%d] = ^help_s%d;\n",y,y);
			fprintf (f,"      end\n");
			fprintf (f,"    end\n");
			fprintf (f,"  endgenerate\n\n");
		}

		// the last parity bit for 64 data is special due to high input count
		// register it a bit higher
		else
		{
			fprintf (f,"\n");
			fprintf (f,"  // the parity bit has too much fanin\n");
			fprintf (f,"  // register it a bit higher for balance\n");
			fprintf (f,"  reg [%d:0] help_s%d_r;\n",num_helpers-1,y);
		
			fprintf (f,"  generate\n");
			fprintf (f,"    if (REGISTER) begin\n");
			fprintf (f,"      always @(posedge clk or posedge rst) begin\n");
			fprintf (f,"        if (rst) help_s%d_r <= 0;\n",y);
			fprintf (f,"        else help_s%d_r <= help_s%d;\n",y,y);
			fprintf (f,"      end\n");
			fprintf (f,"    end else begin\n");
			fprintf (f,"      always @(help_s%d) begin\n",y);
			fprintf (f,"        help_s%d_r = help_s%d;\n",y,y);
			fprintf (f,"      end\n");
			fprintf (f,"    end\n");
			fprintf (f,"  endgenerate\n\n");
	
			fprintf (f,"  // group the parity helper XORs\n");

			fprintf (f,"  wire par_0, par_1;\n");
			fprintf (f,"  xor6 par_0x (par_0");
			for (n=0; n<6; n++)
			{
				fprintf (f,",help_s%d_r[%d]",y,n);
			}
			fprintf (f,");\n");
			fprintf (f,"  xor6 par_1x (par_1");
			for (n=6; n<12; n++)
			{
				fprintf (f,",help_s%d_r[%d]",y,n);
			}
			fprintf (f,");\n\n");
			
			fprintf (f,"  always @(par_0 or par_1) begin\n",y);
			fprintf (f,"    s[%d] = par_0 ^ par_1;\n",y);
			fprintf (f,"  end\n\n");
		}
	}

	fprintf (f,"endmodule\n\n");

	// figure out which syndromes correspond to which data bits to
	// flip to make a correction.
	int final = 0;
	int bit_syndrome[DATA_BITS];
	n=0;
	for (x=1; x<(SYN_BITS-1); x++)
	{
		if (x == (SYN_BITS-2)) final = TOTAL_BITS-1;
		else final = (1<<(x+1)) -1;
	
		for (y=(1<<x)+1; y<=final; y++)
		{
			bit_syndrome[n] = y;
			n++;
		}
	}

	// spit out a correction generator
	fprintf (f,"//////////////////////////////////////////\n");
	fprintf (f,"// From the syndrome compute the correction\n");
	fprintf (f,"// needed to fix the data, or set fatal = 1\n");
	fprintf (f,"// and no correction if there are too many.\n");
	fprintf (f,"//////////////////////////////////////////\n");
	fprintf (f,"module ecc_correction_%dbit (s,e,fatal);\n\n",DATA_BITS);
	fprintf (f,"input [%d:0] s;\n",SYN_BITS-1);
	fprintf (f,"output [%d:0] e;\n",DATA_BITS-1);
	fprintf (f,"output fatal;\n");
	fprintf (f,"wire [%d:0] e;\n\n",DATA_BITS-1);

	if (DATA_BITS == 64)
	{
		////////////////////////////////////////////////////////
		// 64 bit data needs a little help factoring the decoder
		////////////////////////////////////////////////////////
		fprintf (f,"  // decode the lower part of syndrome\n");
		fprintf (f,"  reg [%d:0] d;\n",DATA_BITS-1);
		fprintf (f,"  wire [%d:0] dw /* synthesis keep */;\n",DATA_BITS-1);
		fprintf (f,"  always @(s) begin\n");
		fprintf (f,"    d = %d'b0;\n",DATA_BITS);
		fprintf (f,"    d[s[%d:0]] = 1'b1;\n",SYN_BITS-3);
		fprintf (f,"  end\n");
		fprintf (f,"  assign dw = d;\n\n");

		fprintf (f,"  // Identify uncorrectable errors\n");
		fprintf (f,"  // and unroll the s[6] ODC condition to help\n");
		fprintf (f,"  // synthesis get minimum depth\n");
		fprintf (f,"  wire or_syn50 = |(s[5:0]) /* synthesis keep */;\n");
		fprintf (f,"  wire fatal = (s[6] & !s[7]) | (or_syn50 & !s[7]);\n");
		fprintf (f,"  wire fatal_s6_cold = (or_syn50 & !s[7]);\n");
		fprintf (f,"  wire fatal_s6_hot = !s[7];\n");
	
		fprintf (f,"  assign e = {\n    ");

		for (n=63;n>=0;n--)
		{
			fprintf (f,"dw[%d] & %ss[6] & !fatal_s6_%s",
				bit_syndrome[n] & 0x3f,
				((bit_syndrome[n] & 0x40) != 0 ? "" : "!"),
				((bit_syndrome[n] & 0x40) != 0 ? "hot" : "cold"));
			if (n!=0) fprintf (f,",");
			if ((n%4) == 0) fprintf (f,"\n    ");
		}
		fprintf (f,"};\n\n");
	}
	else 
	{
		////////////////////////////////////////////////////////
		// non - 64 bit decoder
		////////////////////////////////////////////////////////
		fprintf (f,"  // decode the syndrome\n");
		fprintf (f,"  reg [%d:0] d;\n",4*DATA_BITS-1);
		fprintf (f,"  wire [%d:0] dw /* synthesis keep */;\n",4*DATA_BITS-1);
		fprintf (f,"  always @(s) begin\n");
		fprintf (f,"    d = %d'b0;\n",4*DATA_BITS);
		fprintf (f,"    d[{!s[%d],s[%d:0]}] = 1'b1;\n",SYN_BITS-1,SYN_BITS-2);
		fprintf (f,"  end\n");
		fprintf (f,"  assign dw = d;\n\n");

		fprintf (f,"  // Identify uncorrectable errors\n");
		fprintf (f,"  wire fatal = (|s[%d:0]) & !s[%d] /* synthesis keep */;\n",
				SYN_BITS-2,SYN_BITS-1);
		
		fprintf (f,"  assign e = {\n    ");

		for (n=DATA_BITS-1;n>=0;n--)
		{
			fprintf (f,"dw[%d]",
				bit_syndrome[n] & ((1<<SYN_BITS)-1));
			if (n!=0) fprintf (f,",");
			if ((n%4) == 0) fprintf (f,"\n    ");
		}
		fprintf (f,"};\n\n");
	}

	
	fprintf (f,"\nendmodule\n\n");
	
	fprintf (f,"//////////////////////////////////////////\n");
	fprintf (f,"// select the (uncorrected) data bits out\n");
	fprintf (f,"// of the code word.\n");
	fprintf (f,"//////////////////////////////////////////\n\n");
	fprintf (f,"module ecc_raw_data_%dbit (clk,rst,c,d);\n",DATA_BITS);
	fprintf (f,"parameter REGISTER = 0;\n");
	fprintf (f,"input clk,rst;\n");
	fprintf (f,"input [%d:0] c;\n",TOTAL_BITS-1);
	fprintf (f,"output [%d:0] d;\n",DATA_BITS-1);
	fprintf (f,"reg [%d:0] d;\n\n",DATA_BITS-1);
	fprintf (f,"wire [%d:0] d_int;\n\n",DATA_BITS-1);
		
	fprintf (f,"  // pull out the pure data bits\n");
	fprintf (f,"  assign d_int = {\n    ");
	for (n=DATA_BITS-1;n>=0;n--)
	{
		fprintf (f,"c[%d]",bit_syndrome[n]-1);
		if (n!=0) fprintf (f,",");
		if ((n%8) == 0) fprintf (f,"\n    ");
	}
	fprintf (f,"};\n\n");

	fprintf (f,"  // conditional output register\n");
	fprintf (f,"  generate\n");
	fprintf (f,"  if (REGISTER) begin\n");
	fprintf (f,"    always @(posedge clk or posedge rst) begin\n");
	fprintf (f,"      if (rst) d <= 0;\n");
	fprintf (f,"      else d <= d_int;\n");
	fprintf (f,"    end\n");
	fprintf (f,"  end else begin\n");
	fprintf (f,"    always @(d_int) begin\n");
	fprintf (f,"      d <= d_int;\n");
	fprintf (f,"    end\n");
	fprintf (f,"  end\n");
	fprintf (f,"  endgenerate\n\n");

	fprintf (f,"endmodule\n\n");
	
	fprintf (f,"//////////////////////////////////////////\n");
	fprintf (f,"// %d bit to %d bit ECC decoder\n",TOTAL_BITS,DATA_BITS);
	fprintf (f,"//////////////////////////////////////////\n\n");
	fprintf (f,"module ecc_decode_%dbit (clk,rst,c,d,no_err,err_corrected,err_fatal);\n\n",DATA_BITS);
	
	fprintf (f,"// optional pipeline registers at the halfway\n");
	fprintf (f,"// point and on the outputs\n");
	fprintf (f,"parameter MIDDLE_REG = 0;\n");
	fprintf (f,"parameter OUTPUT_REG = 0;\n\n");

	fprintf (f,"input clk,rst;\n");
	fprintf (f,"input [%d:0] c;\n",TOTAL_BITS-1);
	fprintf (f,"output [%d:0] d;\n",DATA_BITS-1);
	fprintf (f,"output no_err, err_corrected, err_fatal;\n\n");
	
	fprintf (f,"reg [%d:0] d;\n",DATA_BITS-1);
	fprintf (f,"reg no_err, err_corrected, err_fatal;\n\n");
		
	fprintf (f,"  // Pull the raw (uncorrected) data from the codeword\n");
	fprintf (f,"  wire [%d:0] raw_bits;\n",DATA_BITS-1);
	fprintf (f,"  ecc_raw_data_%dbit raw (.clk(clk),.rst(rst),.c(c),.d(raw_bits));\n\n",DATA_BITS);
	fprintf (f,"    defparam raw .REGISTER = MIDDLE_REG;\n");

	fprintf (f,"  // Build syndrome, which will be 0 for correct\n");
	fprintf (f,"  // correct codewords, otherwise a pointer to the\n");
	fprintf (f,"  // error.\n");
	fprintf (f,"  wire [%d:0] syndrome;\n",SYN_BITS-1);
	fprintf (f,"  ecc_syndrome_%dbit syn (.clk(clk),.rst(rst),.c(c),.s(syndrome));\n",DATA_BITS);
	fprintf (f,"    defparam syn .REGISTER = MIDDLE_REG;\n\n");

	fprintf (f,"  // Use the the syndrome to find a correction, or 0 for no correction\n");
	fprintf (f,"  wire [%d:0] err_flip;\n",DATA_BITS-1);
	fprintf (f,"  wire fatal;\n");
	fprintf (f,"  ecc_correction_%dbit cor (.s(syndrome),.e(err_flip),.fatal(fatal));\n\n",DATA_BITS);

	fprintf (f,"  // Classify error types and correct data as appropriate\n");
	fprintf (f,"  // If there is a multibit error take care not to make \n");
	fprintf (f,"  // the data worse.\n");
	fprintf (f,"  generate\n");
	fprintf (f,"    if (OUTPUT_REG) begin\n");
	fprintf (f,"      always @(posedge clk or posedge rst) begin\n");
	fprintf (f,"        if (rst) begin\n");
	fprintf (f,"          no_err <= 1'b0;\n");
	fprintf (f,"          err_corrected <= 1'b0;\n");
	fprintf (f,"          err_fatal <= 1'b0;\n");
	fprintf (f,"          d <= 1'b0;\n");
	fprintf (f,"        end else begin\n");
	fprintf (f,"          no_err <= ~| syndrome;\n");
	fprintf (f,"          err_corrected <= syndrome[%d];\n",SYN_BITS-1);
	fprintf (f,"          err_fatal <= fatal;\n\n");
	fprintf (f,"          d <= err_flip ^ raw_bits;\n");
	fprintf (f,"        end\n");
	fprintf (f,"      end\n");
	fprintf (f,"    end else begin\n");
	fprintf (f,"      always @(*) begin\n");
	fprintf (f,"          no_err = ~| syndrome;\n");
	fprintf (f,"          err_corrected = syndrome[%d];\n",SYN_BITS-1);
	fprintf (f,"          err_fatal = fatal;\n\n");
	fprintf (f,"          d = err_flip ^ raw_bits;\n");
	fprintf (f,"      end\n");
	fprintf (f,"    end\n");
	fprintf (f,"  endgenerate\n\n");

	fprintf (f,"endmodule\n\n");
}

////////////////////////////////////////////////////////////

void dump_ecc_ram (FILE * f)
{
    fprintf (f,"// baeckler - 07-10-2006\n");
    fprintf (f,"// %d-%d ECC internal RAM\n",DATA_BITS,TOTAL_BITS);
    fprintf (f,"//\n");
    fprintf (f,"module soft_ecc_ram_%dbit (\n",DATA_BITS);
    fprintf (f,"	rst,\n");
    fprintf (f,"	address_a,\n");
    fprintf (f,"	address_b,\n");
    fprintf (f,"	clock_a,\n");
    fprintf (f,"	clock_b,\n");
    fprintf (f,"	data_a,\n");
    fprintf (f,"	data_b,\n");
    fprintf (f,"	wren_a,\n");
    fprintf (f,"	wren_b,\n");
    fprintf (f,"	q_a,\n");
    fprintf (f,"	q_b,\n");
    fprintf (f,"	err_a,\n");
    fprintf (f,"	err_b\n");
    fprintf (f,");\n");
    fprintf (f,"\n");
    fprintf (f,"`include \"log2.inc\"\n");
    fprintf (f,"\n");
    fprintf (f,"// Number of %d bit data words (stored as %d bit words internally)\n",DATA_BITS,TOTAL_BITS);
    fprintf (f,"parameter NUM_WORDS = 512;\n");
    fprintf (f,"localparam ADDR_WIDTH = log2(NUM_WORDS-1);\n");
    fprintf (f,"\n");
    fprintf (f,"// For testing error detection / correction\n");
    fprintf (f,"// a 1 bit indicates inversion of the corresponding code bit\n");
    fprintf (f,"// on the encoded RAM output.\n");
    fprintf (f,"parameter PORT_A_ERROR_INJECT = %d'b0;\n",TOTAL_BITS);
    fprintf (f,"parameter PORT_B_ERROR_INJECT = %d'b0;\n",TOTAL_BITS);
    fprintf (f,"\n");
    fprintf (f,"	input   rst;\n");
    fprintf (f,"	input	[ADDR_WIDTH-1:0]  address_a;\n");
    fprintf (f,"	input	[ADDR_WIDTH-1:0]  address_b;\n");
    fprintf (f,"	input   clock_a;\n");
    fprintf (f,"	input   clock_b;\n");
    fprintf (f,"	input	[%d:0]  data_a;\n",DATA_BITS-1);
    fprintf (f,"	input	[%d:0]  data_b;\n",DATA_BITS-1);
    fprintf (f,"	input   wren_a;\n");
    fprintf (f,"	input   wren_b;\n");
    fprintf (f,"	output	[%d:0]  q_a;\n",DATA_BITS-1);
    fprintf (f,"	output	[%d:0]  q_b;\n",DATA_BITS-1);
    fprintf (f,"	output  [2:0] err_a;\n");
    fprintf (f,"	output  [2:0] err_b;\n");
    fprintf (f,"\n");
    fprintf (f,"\n");
    fprintf (f,"///////////////////////\n");
    fprintf (f,"// port A encoder\n");
    fprintf (f,"///////////////////////\n");
    fprintf (f,"reg [%d:0] data_a_reg;\n",DATA_BITS-1);
    fprintf (f,"always @(posedge clock_a or posedge rst) begin\n");
    fprintf (f,"	if (rst) data_a_reg <= %d'b0;\n",DATA_BITS);
    fprintf (f,"	else data_a_reg <= data_a;\n");
    fprintf (f,"end\n");
    fprintf (f,"wire [%d:0] data_a_code;\n",TOTAL_BITS-1);
    fprintf (f,"ecc_encode_%dbit enc_a (.d(data_a_reg),.c(data_a_code));\n",DATA_BITS);
    fprintf (f,"\n");
    fprintf (f,"///////////////////////\n");
    fprintf (f,"// port B encoder\n");
    fprintf (f,"///////////////////////\n");
    fprintf (f,"reg [%d:0] data_b_reg;\n",DATA_BITS-1);
    fprintf (f,"always @(posedge clock_b or posedge rst) begin\n");
    fprintf (f,"	if (rst) data_b_reg <= %d'b0;\n",DATA_BITS);
    fprintf (f,"	else data_b_reg <= data_b;\n");
    fprintf (f,"end\n");
    fprintf (f,"wire [%d:0] data_b_code;\n",TOTAL_BITS-1);
    fprintf (f,"ecc_encode_%dbit enc_b (.d(data_b_reg),.c(data_b_code));\n",DATA_BITS);
    fprintf (f,"\n");
    fprintf (f,"///////////////////////\n");
    fprintf (f,"// RAM block (%d bit words)\n",TOTAL_BITS);
    fprintf (f,"///////////////////////\n");
    fprintf (f,"wire [%d:0] q_a_code;\n",TOTAL_BITS-1);
    fprintf (f,"wire [%d:0] q_b_code;\n",TOTAL_BITS-1);
    fprintf (f,"ram_block ram (\n");
    fprintf (f,"	.aclr_a(rst),\n");
    fprintf (f,"	.aclr_b(rst),\n");
    fprintf (f,"	.address_a(address_a),\n");
    fprintf (f,"	.address_b(address_b),\n");
    fprintf (f,"	.clock_a(clock_a),\n");
    fprintf (f,"	.clock_b(clock_b),\n");
    fprintf (f,"	.data_a(data_a_code),\n");
    fprintf (f,"	.data_b(data_b_code),\n");
    fprintf (f,"	.wren_a(wren_a),\n");
    fprintf (f,"	.wren_b(wren_b),\n");
    fprintf (f,"	.q_a(q_a_code),\n");
    fprintf (f,"	.q_b(q_b_code)\n");
    fprintf (f,");\n");
    fprintf (f,"defparam ram .NUM_WORDS = NUM_WORDS;\n");
    fprintf (f,"defparam ram .DAT_WIDTH = %d;\n",TOTAL_BITS);
    fprintf (f,"\n");
    fprintf (f,"///////////////////////\n");
    fprintf (f,"// port A decoder\n");
    fprintf (f,"///////////////////////\n");
    fprintf (f,"ecc_decode_%dbit dec_a (\n",DATA_BITS);
    fprintf (f,"	.clk(clock_a),\n");
    fprintf (f,"	.rst(rst),\n");
    fprintf (f,"	.c(q_a_code ^ PORT_A_ERROR_INJECT),\n");
    fprintf (f,"	.d(q_a),\n");
    fprintf (f,"	.no_err(err_a[0]),\n");
    fprintf (f,"	.err_corrected(err_a[1]),\n");
    fprintf (f,"	.err_fatal(err_a[2]));\n");
    fprintf (f,"\n");
    fprintf (f,"defparam dec_a .OUTPUT_REG = 1;\n");
    fprintf (f,"defparam dec_a .MIDDLE_REG = 1;\n");
    fprintf (f,"\n");
    fprintf (f,"///////////////////////\n");
    fprintf (f,"// port B decoder\n");
    fprintf (f,"///////////////////////\n");
    fprintf (f,"ecc_decode_%dbit dec_b (\n",DATA_BITS);
    fprintf (f,"	.clk(clock_b),\n");
    fprintf (f,"	.rst(rst),\n");
    fprintf (f,"	.c(q_b_code ^ PORT_B_ERROR_INJECT),\n");
    fprintf (f,"	.d(q_b),\n");
    fprintf (f,"	.no_err(err_b[0]),\n");
    fprintf (f,"	.err_corrected(err_b[1]),\n");
    fprintf (f,"	.err_fatal(err_b[2]));\n");
    fprintf (f,"\n");
    fprintf (f,"defparam dec_b .OUTPUT_REG = 1;\n");
    fprintf (f,"defparam dec_b .MIDDLE_REG = 1;\n");
    fprintf (f,"\n");
    fprintf (f,"endmodule\n");
}

int main (void)
{
	char buffer [255];
	FILE * f = NULL;

	////////////////
	// build the encode and decode functions
	sprintf (buffer,"ecc_matrix_%dbit.v",DATA_BITS);
	f = fopen (buffer,"wt");
	if (!f)
	{
		fprintf (stdout,"ERROR : Unable to write file %s\n",buffer);
		return (1);
	}
	dump_ecc_coder (f);
	fclose (f);

	////////////////
	// build a soft RAM with 2 enc/dec ports
	sprintf (buffer,"soft_ecc_ram_%dbit.v",DATA_BITS);
	f = fopen (buffer,"wt");
	if (!f)
	{
		fprintf (stdout,"ERROR : Unable to write file %s\n",buffer);
		return (1);
	}
	dump_ecc_ram (f);
	fclose (f);
	return (0);
}
	
