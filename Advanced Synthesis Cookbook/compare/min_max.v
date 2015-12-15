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

// baeckler - 04-12-2006

////////////////////////////////////////////
// fixed signed, for testing
////////////////////////////////////////////

module min_max_signed (clk,rst,a,b,min_ab,max_ab);

parameter WIDTH = 8;

input clk,rst;
input signed [WIDTH-1:0] a;
input signed [WIDTH-1:0] b;
output signed [WIDTH-1:0] min_ab;
output signed [WIDTH-1:0] max_ab;

reg signed [WIDTH-1:0] min_ab;
reg signed [WIDTH-1:0] max_ab;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		min_ab <= 0;
		max_ab <= 0;
	end
	else begin
		if (a<b) begin
			min_ab <= a;
			max_ab <= b;
		end else begin
			min_ab <= b;
			max_ab <= a;
		end		
	end
end

endmodule

////////////////////////////////////////////
// fixed unsigned, for testing
////////////////////////////////////////////

module min_max_unsigned (clk,rst,a,b,min_ab,max_ab);

parameter WIDTH = 8;

input clk,rst;
input [WIDTH-1:0] a;
input [WIDTH-1:0] b;
output [WIDTH-1:0] min_ab;
output [WIDTH-1:0] max_ab;

reg [WIDTH-1:0] min_ab;
reg [WIDTH-1:0] max_ab;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		min_ab <= 0;
		max_ab <= 0;
	end
	else begin
		if (a<b) begin
			min_ab <= a;
			max_ab <= b;
		end else begin
			min_ab <= b;
			max_ab <= a;
		end		
	end
end

endmodule

////////////////////////////////////////////
// Variable sign version
////////////////////////////////////////////

module min_max_8bit (clk,rst,is_signed,a_in,b_in,min_ab,max_ab);

parameter USE_SLOAD = 0;	// SLOAD vs 3 LUT for output reg
parameter REGISTER_AB = 0;	// optional input registers
localparam WIDTH = 8;  // the comparator is hard coded for 8

input clk,rst,is_signed;
input [WIDTH-1:0] a_in,b_in;
output [WIDTH-1:0] min_ab,max_ab;

reg [WIDTH-1:0] min_ab,max_ab;

//////////////////////////////////
// optional input registers for
// speed testing
//////////////////////////////////
reg [WIDTH-1:0] a,b;
generate
	if (REGISTER_AB) begin
		always @(posedge clk) begin
			a <= a_in;
			b <= b_in;
		end
	end
	else begin
		always @(a_in or b_in) begin
			a = a_in;
			b = b_in;
		end
	end
endgenerate

//////////////////////////////////
// Comparator building blocks
//////////////////////////////////
wire low_lt = a[2:0] < b[2:0] /* synthesis keep */;
wire mid_lt = a[5:3] < b[5:3] /* synthesis keep */;
wire mid_eq = a[5:3] == b[5:3] /* synthesis keep */;
wire hi_lt = (!(a[7] ^ b[7]) & (b[6] & !a[6])) |
		!(a[7] ^ is_signed) & (b[7] ^ is_signed)  /* synthesis keep */;
wire hi_eq = a[7:6] == b[7:6] /* synthesis keep */;

// merge it up into an A<B signal
wire a_lt_b = hi_lt | (hi_eq & (mid_lt | mid_eq & low_lt)) /* synthesis keep */;

//////////////////////////////////
// output register
//////////////////////////////////
genvar i;
generate
	if (USE_SLOAD) begin
		wire [WIDTH-1:0] min_internal,max_internal;
		for (i=0; i<WIDTH; i=i+1)
		begin : regs
			stratixii_lcell_ff r_min (
				.clk(clk),
				.ena(1'b1),
				.datain (b[i]),
				.sload (a_lt_b),
				.adatasdata (a[i]),
				.sclr (1'b0),
				.aload(1'b0),
				.aclr(rst),
				// synthesis translate_off
				.devpor(1'b1),
				.devclrn(1'b1),
				// synthesis translate on
				.regout (min_internal[i])	
			);
			stratixii_lcell_ff r_max (
				.clk(clk),
				.ena(1'b1),
				.datain (a[i]),
				.sload (a_lt_b),
				.adatasdata (b[i]),
				.sclr (1'b0),
				.aload(1'b0),
				.aclr(rst),
				// synthesis translate_off
				.devpor(1'b1),
				.devclrn(1'b1),
				// synthesis translate on
				.regout (max_internal[i])	
			);
		end		
		always @(min_internal) min_ab = min_internal;
		always @(max_internal) max_ab = max_internal;
	end
	else begin
		always @(posedge clk or posedge rst) begin
			if (rst) begin
				min_ab <= 0;
				max_ab <= 0;
			end
			else begin
				if (a_lt_b) begin
					min_ab <= a;
					max_ab <= b;
				end else begin
					min_ab <= b;
					max_ab <= a;
				end		
			end
		end
	end
endgenerate

endmodule

