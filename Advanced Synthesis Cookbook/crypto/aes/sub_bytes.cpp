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

// baeckler - 03-06-2006
// Loaded with a Rijndael sbox - double check the derivation
// and spit out verilog

#include <stdio.h>

unsigned char sbox [256] = {
	0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5,
	0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
	0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0,
	0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
	0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc,
	0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,
	0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a,
	0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,
	0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0,
	0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,
	0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b,
	0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,
	0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85,
	0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,
	0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5,
	0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,
	0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17,
	0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,
	0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88,
	0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,
	0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c,
	0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
	0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9,
	0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,
	0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6,
	0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,
	0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e,
	0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,
	0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94,
	0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
	0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68,
	0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16
};

int ror (int dist, int byte)
{
	int tmp = (byte << 8) | byte;
	tmp = (tmp >> dist); 
	return (tmp & 0xff);
}

// one step of GF polynomial mult : times two mod 11b
int xtime (int a)
{
	int out = 0;
	out = a << 1;
	if ((out & 0x100) != 0)
	{
		out = out ^ 0x11b;
	}
	return (out);
}

// GF multiply two bytes
int special_mult (int a, int b)
{
	int out = 0;
	int n = 0;

	int running = a;
	
	for (n=0; n<8; n++)
	{
		if ((b & 1) != 0) out ^= running;
		b >>= 1;
		running = xtime (running);
	}
	return (out);
}

// build the sbox tables
int main (void)
{
	int in, out;
	int affine [256];
	int rev_affine [256];
	int rev_sbox [256];
	
	int i,n;
	unsigned int nyb;

	// reverse the sbox
	for (in=0; in<256; in ++)
	{
		rev_sbox[sbox[in]] = in;
	}

	// build the affine and reverse affine functions as
	// tables
	for (in=0; in<256; in ++)
	{
		out = in ^ 0x63 ^ ror(4,in) ^ ror(5,in) ^ ror(6,in) ^ ror(7,in);
		affine[in] = out;
		rev_affine[out] = in;
	}
	
	// reverse the affine and sanity check the mult inverse
	// is correct.
	for (in=0; in<256; in ++)
	{
		out = rev_affine[sbox[in]];
		if (special_mult (in,out) != 1)
		{
			// inverse of 0 is defined to be 0
			if (in != 0) 
			{
				fprintf (stdout,"Error - sbox table cross check failed\n");
				fprintf (stdout," in = %02x out = %02x\n",in,out);
				return (1);
			}
		}		
	}

	fprintf (stdout,"// baeckler - 03-09-2006\n\n");
	fprintf (stdout,"//////////////////////////////////////////////\n");
	fprintf (stdout,"// eight input (256 word) ROM helper fn\n");
	fprintf (stdout,"//////////////////////////////////////////////\n");

	fprintf (stdout,"module eight_input_rom (in,out);\n");
	fprintf (stdout,"input [7:0] in;\n");
	fprintf (stdout,"output out;\n");
	fprintf (stdout,"wire out /* synthesis keep */;\n\n");

	fprintf (stdout,"parameter [255:0] mask = 256'b0;\n\n");

	fprintf (stdout,"wire [3:0] t /* synthesis keep */;\n");
	fprintf (stdout,"wire [63:0] m0 = mask[63:0];\n");
	fprintf (stdout,"wire [63:0] m1 = mask[127:64];\n");
	fprintf (stdout,"wire [63:0] m2 = mask[191:128];\n");
	fprintf (stdout,"wire [63:0] m3 = mask[255:192];\n\n");

	fprintf (stdout,"assign t[0] = m0[in[5:0]];\n");
	fprintf (stdout,"assign t[1] = m1[in[5:0]];\n");
	fprintf (stdout,"assign t[2] = m2[in[5:0]];\n");
	fprintf (stdout,"assign t[3] = m3[in[5:0]];\n");
	fprintf (stdout,"assign out = t[in[7:6]];\n\n");
	fprintf (stdout,"endmodule\n\n");

	// dump verilog sbox
	fprintf (stdout,"//////////////////////////////////////////////\n");
	fprintf (stdout,"// Single Rijndael SBOX\n");
	fprintf (stdout,"//////////////////////////////////////////////\n");

	fprintf (stdout,"module sbox (in,out);\n");
	fprintf (stdout,"input [7:0] in;\n");
	fprintf (stdout,"output [7:0] out;\n");
	fprintf (stdout,"wire [7:0] out;\n\n");
	
	fprintf (stdout,"parameter METHOD = 1;\n\n");

	fprintf (stdout,"generate\n");
	fprintf (stdout,"  if (METHOD == 0) begin\n");
	fprintf (stdout,"    reg [7:0] o;\n");
	fprintf (stdout,"    always @(in) begin\n");
	fprintf (stdout,"      case (in)\n    ");
	for (in=0; in<256; in++)
	{
		fprintf (stdout,"    8'h%02x: o = 8'h%02x;",in,sbox[in]);
		if ((in % 4) == 3) fprintf (stdout,"\n    ");
	}
	fprintf (stdout,"        default: o = 8'h0;\n");
	fprintf (stdout,"      endcase\n");
	fprintf (stdout,"    end\n");
	fprintf (stdout,"    assign out = o;\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"  else if (METHOD == 1) begin\n");
	for (i=0;i<8;i++)
	{
		fprintf (stdout,"      eight_input_rom r%d (.in(in),.out(out[%d]));\n",i,i);
		fprintf (stdout,"        defparam r%d .mask = 256'h",i);
		for (n=255;n>=0;n-=4)
		{
			nyb = (sbox[n] & (1 << i)) >> i;
			nyb = (nyb << 1) | ((sbox[n-1] & (1 << i)) >> i);
			nyb = (nyb << 1) | ((sbox[n-2] & (1 << i)) >> i);
			nyb = (nyb << 1) | ((sbox[n-3] & (1 << i)) >> i);
			fprintf (stdout,"%x",nyb);
		}
		fprintf (stdout,";\n");
	}
	fprintf (stdout,"  end\n");
	fprintf (stdout,"endgenerate\n");
	fprintf (stdout,"endmodule\n\n");
	
	// dump verilog inverse sbox
	fprintf (stdout,"//////////////////////////////////////////////\n");
	fprintf (stdout,"// Single Rijndael Inverse SBOX\n");
	fprintf (stdout,"//////////////////////////////////////////////\n");

	fprintf (stdout,"module inv_sbox (in,out);\n");
	fprintf (stdout,"input [7:0] in;\n");
	fprintf (stdout,"output [7:0] out;\n");
	fprintf (stdout,"wire [7:0] out;\n\n");
	
	fprintf (stdout,"parameter METHOD = 1;\n\n");

	fprintf (stdout,"generate\n");
	fprintf (stdout,"  if (METHOD == 0) begin\n");
	fprintf (stdout,"    reg [7:0] o;\n");
	fprintf (stdout,"    always @(in) begin\n");
	fprintf (stdout,"      case (in)\n    ");
	for (in=0; in<256; in++)
	{
		fprintf (stdout,"    8'h%02x: o = 8'h%02x;",in,rev_sbox[in]);
		if ((in % 4) == 3) fprintf (stdout,"\n    ");
	}
	fprintf (stdout,"        default: o = 8'h0;\n");
	fprintf (stdout,"      endcase\n");
	fprintf (stdout,"    end\n");
	fprintf (stdout,"    assign out = o;\n");
	fprintf (stdout,"  end\n");
	fprintf (stdout,"  else if (METHOD == 1) begin\n");
	for (i=0;i<8;i++)
	{
		fprintf (stdout,"      eight_input_rom r%d (.in(in),.out(out[%d]));\n",i,i);
		fprintf (stdout,"        defparam r%d .mask = 256'h",i);
		for (n=255;n>=0;n-=4)
		{
			nyb = (rev_sbox[n] & (1 << i)) >> i;
			nyb = (nyb << 1) | ((rev_sbox[n-1] & (1 << i)) >> i);
			nyb = (nyb << 1) | ((rev_sbox[n-2] & (1 << i)) >> i);
			nyb = (nyb << 1) | ((rev_sbox[n-3] & (1 << i)) >> i);
			fprintf (stdout,"%x",nyb);
		}
		fprintf (stdout,";\n");
	}
	fprintf (stdout,"  end\n");
	fprintf (stdout,"endgenerate\n");
	fprintf (stdout,"endmodule\n\n");
	
	fprintf (stdout,"////////////////////////////////////////////////////\n");
	fprintf (stdout,"// sub_bytes implemented as 4 by 4 array of SBOXes\n");
	fprintf (stdout,"////////////////////////////////////////////////////\n");
	
	fprintf (stdout,"module sub_bytes (in,out);\n");
	fprintf (stdout,"input [16*8-1 : 0] in;\n");
	fprintf (stdout,"output [16*8-1 : 0] out;\n");
	fprintf (stdout,"wire [16*8-1 : 0] out;\n\n");
	
	fprintf (stdout,"genvar i;\n");
	fprintf (stdout,"generate\n");
	fprintf (stdout,"    for (i=0; i<16; i=i+1)\n");
	fprintf (stdout,"    begin : sb\n");
	fprintf (stdout,"        sbox s (.in(in[8*i+7:8*i]), .out(out[8*i+7:8*i]));\n");
	fprintf (stdout,"    end\n");
	fprintf (stdout,"endgenerate\n");
	fprintf (stdout,"endmodule\n\n");

	fprintf (stdout,"////////////////////////////////////////////////////\n");
	fprintf (stdout,"// inv_sub_bytes implemented as 4x4 inv_SBOXes\n");
	fprintf (stdout,"////////////////////////////////////////////////////\n");
	
	fprintf (stdout,"module inv_sub_bytes (in,out);\n");
	fprintf (stdout,"input [16*8-1 : 0] in;\n");
	fprintf (stdout,"output [16*8-1 : 0] out;\n");
	fprintf (stdout,"wire [16*8-1 : 0] out;\n\n");
	
	fprintf (stdout,"genvar i;\n");
	fprintf (stdout,"generate\n");
	fprintf (stdout,"    for (i=0; i<16; i=i+1)\n");
	fprintf (stdout,"    begin : sb\n");
	fprintf (stdout,"        inv_sbox s (.in(in[8*i+7:8*i]), .out(out[8*i+7:8*i]));\n");
	fprintf (stdout,"    end\n");
	fprintf (stdout,"endgenerate\n");
	fprintf (stdout,"endmodule\n\n");

	return (0);
}