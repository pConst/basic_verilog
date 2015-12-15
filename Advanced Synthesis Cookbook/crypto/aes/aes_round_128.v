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

// baeckler - 03-08-2006

/////////////////////////////////////////////////////////
// one round of ENcipher and key evolve - 128 bit key
/////////////////////////////////////////////////////////

module aes_round_128 (
	clk,clr,dat_in,dat_out,rconst,skip_mix_col,key_in,key_out
);

input clk,clr;
input [127:0] dat_in,key_in;
input [7:0] rconst; // lower 24 bits are 0
input skip_mix_col; // for the final round
output [127:0] dat_out,key_out;

parameter LATENCY = 0; // currently allowable values are 0,1

reg [127:0] dat_out,key_out;

// internal temp vars
wire [127:0] dat_out_i,key_out_i,sub,shft,mix;
reg [127:0] shft_r;

// evolve key
evolve_key_128 ek (.key_in(key_in),
				.rconst(rconst),.key_out(key_out_i));
	
// first two LUT levels of work
sub_bytes sb (.in(dat_in),.out(sub));
shift_rows sr (.in(sub),.out(shft));

// mid layer registers would go here, the keying
// is awkward
always @(shft) shft_r = shft;

// second 2 LUT levels of work
mix_columns mx (.in(shft_r),.out(mix));
assign dat_out_i = (skip_mix_col ? shft : mix) ^ key_out_i;

// conditional output register
generate
if (LATENCY!=0) begin
	always @(posedge clk or posedge clr) begin
		if (clr) dat_out <= 128'b0;
		else dat_out <= dat_out_i;
	end
	always @(posedge clk or posedge clr) begin
		if (clr) key_out <= 128'b0;
		else key_out <= key_out_i;
	end
end
else begin
	always @(dat_out_i) dat_out = dat_out_i;
	always @(key_out_i) key_out = key_out_i;
end
endgenerate
endmodule

/////////////////////////////////////////////////////////
// one round of DEcipher and key evolve - 128 bit key
/////////////////////////////////////////////////////////

module inv_aes_round_128 (
	clk,clr,dat_in,dat_out,rconst,skip_mix_col,key_in,key_out
);

input clk,clr;
input [127:0] dat_in,key_in;
input [7:0] rconst; // lower 24 bits are 0
input skip_mix_col; // for the final round
output [127:0] dat_out,key_out;

parameter LATENCY = 0; // currently allowable values are 0,1

reg [127:0] dat_out,key_out;

// internal temp vars
wire [127:0] keyd_dat,dat_out_i,key_out_i,mixed,middle,shft;

// inverse evolve key (for the next round)
inv_evolve_key_128 ek (.key_in(key_in),
				.rconst(rconst),.key_out(key_out_i));

// key the input data
assign keyd_dat = dat_in ^ key_in;

// optional skip of the mix columns step
inv_mix_columns mx (.in(keyd_dat),.out(mixed));
assign middle = (skip_mix_col ? keyd_dat : mixed);

// second 2 levels of work
inv_shift_rows sr (.in(middle),.out(shft));
inv_sub_bytes sb (.in(shft),.out(dat_out_i));

// conditional output register
generate
if (LATENCY!=0) begin
	always @(posedge clk or posedge clr) begin
		if (clr) dat_out <= 128'b0;
		else dat_out <= dat_out_i;
	end
	always @(posedge clk or posedge clr) begin
		if (clr) key_out <= 128'b0;
		else key_out <= key_out_i;
	end
end
else begin
	always @(dat_out_i) dat_out = dat_out_i;
	always @(key_out_i) key_out = key_out_i;
end
endgenerate
endmodule
