// Copyright 2011 Altera Corporation. All rights reserved.  
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

`timescale 1 ps / 1 ps

// baeckler - 09-16-2008
// 64 to 67 encoder 
//
// NOTE : This requires that din_fresh not occur more often than 1 per 3 ticks
// if that's not true, the din_r register needs a few pipe delays before
// dout

module enc_64_67 (
	input clk, arst,
	input [64:0] din, // bit 64=1 indicates control word
	input din_fresh,
	input pn_reverse,
	output reg [66:0] dout
);

// debug switches - not appropriate for normal 
// operation
parameter DISABLE_DISPARITY = 1'b0;
parameter DISABLE_REGISTERS = 1'b0;

reg [64:0] din_r;
generate 
	if (DISABLE_REGISTERS) begin
		// omit input registers for testing
		always @(*) din_r <= din;	
	end
	else begin
		// input registers
		always @(posedge clk or posedge arst) begin
			if (arst) din_r <= 0;
			else if (din_fresh) din_r <= din;
		end
	end
endgenerate

reg [2:0] din_fresh_history;
always @(posedge clk or posedge arst) begin
	if (arst) din_fresh_history <= 0;
	else din_fresh_history <= {din_fresh_history[1:0],din_fresh};
end

// sum of 64 input bits
//   0 -> -64 disparity 
//  32 -> 0
//  64 -> +64 disparity

// first and second layers - LUT based
wire [3:0] sum_a,sum_b,sum_c,sum_d,sum_e;
twelve_four_comp ca (.data(din_r[11:0]),.sum(sum_a));
twelve_four_comp cb (.data(din_r[23:12]),.sum(sum_b));
twelve_four_comp cc (.data(din_r[35:24]),.sum(sum_c));
twelve_four_comp cd (.data(din_r[47:36]),.sum(sum_d));
twelve_four_comp ce (.data(din_r[59:48]),.sum(sum_e));

// this block takes care of compressing 4 data bits,
// and mixing in a constant for disparity
reg [6:0] sum_f;
always @(*) begin
	case (din_r[63:60])
	  4'h0: sum_f=7'h5f;
	  4'h1: sum_f=7'h60;
	  4'h2: sum_f=7'h60;
	  4'h3: sum_f=7'h61;
	  4'h4: sum_f=7'h60;
	  4'h5: sum_f=7'h61;
	  4'h6: sum_f=7'h61;
	  4'h7: sum_f=7'h62;
	  4'h8: sum_f=7'h60;
	  4'h9: sum_f=7'h61;
	  4'ha: sum_f=7'h61;
	  4'hb: sum_f=7'h62;
	  4'hc: sum_f=7'h61;
	  4'hd: sum_f=7'h62;
	  4'he: sum_f=7'h62;
	  4'hf: sum_f=7'h63;
	  default: sum_f=0;
	endcase
end

// compressor output registers
reg [3:0] sum_a_r,sum_b_r,sum_c_r,sum_d_r,sum_e_r;
reg [6:0] sum_f_r;

generate 
	if (DISABLE_REGISTERS) begin
		always @(*) begin
			sum_a_r <= sum_a;
			sum_b_r <= sum_b;
			sum_c_r <= sum_c;
			sum_d_r <= sum_d;
			sum_e_r <= sum_e;
			sum_f_r <= sum_f;
		end
	end
	else begin
		always @(posedge clk or posedge arst) begin
			if (arst) begin
				sum_a_r <= 0;
				sum_b_r <= 0;
				sum_c_r <= 0;
				sum_d_r <= 0;
				sum_e_r <= 0;
				sum_f_r <= 0;
			end
			else begin
				sum_a_r <= sum_a;
				sum_b_r <= sum_b;
				sum_c_r <= sum_c;
				sum_d_r <= sum_d;
				sum_e_r <= sum_e;
				sum_f_r <= sum_f;
			end
		end
	end
endgenerate

// third layer binary adders
wire[4:0] sum_g = sum_a_r + sum_b_r; // this is 0..24
wire[4:0] sum_h = sum_c_r + sum_d_r; // this is 0..24
wire[6:0] sum_i = sum_e_r + sum_f_r; // this is 95..111 (which are all negative)

// fourth layer ternary add
wire [8:0] ones_sum;
ternary_add ta (.a({2'b0,sum_g}),.b({2'b0,sum_h}),.c(sum_i),.o(ones_sum));
	defparam ta .WIDTH=7;
	
// ones count register
reg [8:0] ones_sum_r;
generate 
	if (DISABLE_REGISTERS) begin
		always @(*) begin
			ones_sum_r <= ones_sum;
		end
	end
	else begin
		always @(posedge clk or posedge arst) begin
			if (arst) ones_sum_r <= 0;
			else ones_sum_r <= ones_sum;
		end
	end
endgenerate

// running disparity 
//    the input word disparity is (2*#ones)-64
//    there is an extra -1 associated with the [66] bit
//    the net -65 constant is embedded in sum_f, and the LSB 1 of signed_inword
reg [7:0] running_ones;
wire [7:0] signed_inword = {ones_sum_r[6:0],1'b1}; // -65 to 63

// check the signs to select invert or not
wire inword_gt_0 = !signed_inword[7];
wire running_positive = !running_ones[7];
wire inword_invert = ~DISABLE_DISPARITY & (~(inword_gt_0 ^ running_positive));

always @(posedge clk or posedge arst) begin
	if (arst) running_ones <= 0;
	else if (DISABLE_REGISTERS | din_fresh_history[2]) begin
		running_ones <= inword_invert ? (running_ones - signed_inword)
						: (running_ones + signed_inword);
	end
end

// mix together the output word bits
wire [66:0] dout_w;
assign dout_w = {inword_invert,
				din_r[64]^pn_reverse,din_r[64]^1'b1^pn_reverse,
				din_r[63:0]	^ {64{inword_invert}}};

// output registers
generate
	if (DISABLE_REGISTERS) begin
		always @(*) dout <= dout_w;
	end
	else begin
		always @(posedge clk or posedge arst) begin
			if (arst) dout <= 0;
			else if (din_fresh_history[2]) dout <= dout_w;
		end
	end
endgenerate

endmodule