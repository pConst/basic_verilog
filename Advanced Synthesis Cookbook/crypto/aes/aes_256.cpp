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

// baeckler - 03-07-2006
//  fill in rounds and constants for a pipelined
// Rijndael w/ 256 bit key (AES256)
//
#include <stdio.h>

int rconst[] = {0x1,0x2,0x4,0x8,0x10,0x20,0x40};

int main(void)
{
	int round;
	int n = 0;

	fprintf (stdout,"// baeckler - 12-15-2006\n\n");
	fprintf (stdout,"// pipelined Rijndael / AES256 encrypt and decrypt units\n\n");
	
	fprintf (stdout,"////////////////////////////////////\n");
	fprintf (stdout,"// Encrypt using 256 bit key\n");
	fprintf (stdout,"////////////////////////////////////\n");

	fprintf (stdout,"module aes_256 (clk,clr,dat_in,dat_out,key,inv_key);\n");
	fprintf (stdout,"input clk,clr;\n");
	fprintf (stdout,"input [127:0] dat_in;\n");
	fprintf (stdout,"input [255:0] key;\n");
	fprintf (stdout,"output [127:0] dat_out;\n");
	fprintf (stdout,"output [255:0] inv_key;\n\n");

	fprintf (stdout,"parameter LATENCY = 14; // currently allowed 0,14\n");
	fprintf (stdout,"localparam ROUND_LATENCY = (LATENCY == 14 ? 1 : 0);\n");

	fprintf (stdout,"wire [127:0] start1,start2,start3,start4,start5;\n");
	fprintf (stdout,"wire [127:0] start6,start7,start8,start9,start10;\n");
	fprintf (stdout,"wire [127:0] start11,start12,start13,start14;\n");
	fprintf (stdout,"wire [255:0] key1,key2,key3,key4,key5;\n");
	fprintf (stdout,"wire [255:0] key6,key7,key8,key9,key10;\n");
	fprintf (stdout,"wire [255:0] key11,key12,key13,key14;\n\n");
	
	fprintf (stdout,"assign start1 = dat_in ^ key[255:128];\n");
	fprintf (stdout,"assign key1 = key;\n\n");
	
	for (round=1; round<=14; round++)
	{
		fprintf (stdout,"    aes_round_256 r%d (\n",round);
		fprintf (stdout,"        .clk(clk),.clr(clr),\n");
		fprintf (stdout,"        .dat_in(start%d),.key_in(key%d),\n",round,round);
		if (round == 14)
		{
			fprintf (stdout,"        .dat_out(dat_out),.key_out(inv_key),\n");
			fprintf (stdout,"        .skip_mix_col(1'b1),\n");
		}
		else
		{
			fprintf (stdout,"        .dat_out(start%d),.key_out(key%d),\n",
					round+1,round+1);
			fprintf (stdout,"        .skip_mix_col(1'b0),\n");
		}	
		fprintf (stdout,"        .rconst(8'h%02x)",rconst[(round-1) / 2]);
		fprintf (stdout,");\n");
		fprintf (stdout,"        defparam r%d .LATENCY = ROUND_LATENCY;\n",round);
		fprintf (stdout,"        defparam r%d .KEY_EVOLVE_TYPE = %d;\n",round,
				(round + 1) % 2);
	}	

	fprintf (stdout,"endmodule\n\n");

	//////////////////

	fprintf (stdout,"////////////////////////////////////\n");
	fprintf (stdout,"// Inverse (Decrypt) using 256 bit key\n");
	fprintf (stdout,"////////////////////////////////////\n");

	fprintf (stdout,"module inv_aes_256 (clk,clr,dat_in,dat_out,inv_key);\n");
	fprintf (stdout,"input clk,clr;\n");
	fprintf (stdout,"input [127:0] dat_in;\n");
	fprintf (stdout,"input [255:0] inv_key;\n");
	fprintf (stdout,"output [127:0] dat_out;\n\n");
	
	fprintf (stdout,"parameter LATENCY = 14; // currently allowed 0,14\n");
	fprintf (stdout,"localparam ROUND_LATENCY = (LATENCY == 14 ? 1 : 0);\n");

	fprintf (stdout,"wire [127:0] start1,start2,start3,start4,start5;\n");
	fprintf (stdout,"wire [127:0] start6,start7,start8,start9,start10;\n");
	fprintf (stdout,"wire [127:0] start11,start12,start13,start14;\n");
	fprintf (stdout,"wire [127:0] unkeyd_out;\n");
	fprintf (stdout,"wire [255:0] last_key;\n");
	fprintf (stdout,"wire [255:0] key1,key2,key3,key4,key5;\n");
	fprintf (stdout,"wire [255:0] key6,key7,key8,key9,key10;\n");
	fprintf (stdout,"wire [255:0] key11,key12,key13,key14;\n\n");
	
	fprintf (stdout,"assign start1 = dat_in;\n");
	fprintf (stdout,"assign key1 = inv_key;\n\n");
	
	for (round=1; round<=14; round++)
	{
		fprintf (stdout,"    inv_aes_round_256 r%d (\n",round);
		fprintf (stdout,"        .clk(clk),.clr(clr),\n");
		fprintf (stdout,"        .dat_in(start%d),.key_in(key%d),\n",round,round);
		if (round == 1)
		{
			fprintf (stdout,"        .dat_out(start%d),.key_out(key%d),\n",
					round+1,round+1);
			fprintf (stdout,"        .skip_mix_col(1'b1),\n");
		}
		else if (round == 14)
		{
			fprintf (stdout,"        .dat_out(unkeyd_out),.key_out(last_key),\n",
					round+1,round+1);
			fprintf (stdout,"        .skip_mix_col(1'b0),\n");
		}	
		else
		{
			fprintf (stdout,"        .dat_out(start%d),.key_out(key%d),\n",
					round+1,round+1);
			fprintf (stdout,"        .skip_mix_col(1'b0),\n");
		}
		fprintf (stdout,"        .rconst(8'h%02x)",rconst[(14-round) / 2]);
		fprintf (stdout,");\n");
		fprintf (stdout,"        defparam r%d .LATENCY = ROUND_LATENCY;\n",round);
		fprintf (stdout,"        defparam r%d .KEY_EVOLVE_TYPE = %d;\n",round,
				(round) % 2);
	}	

	fprintf (stdout,"assign dat_out = last_key[255:128] ^ unkeyd_out;\n\n");
	
	fprintf (stdout,"endmodule\n");
	return (0);
}