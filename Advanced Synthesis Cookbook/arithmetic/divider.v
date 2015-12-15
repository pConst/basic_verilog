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

// baeckler - 04-13-2006
// unsigned iterative divider, 1 and 2 bit per clock
// tick versions

////////////////////////////////////////////////////
// 1 bit per tick version
////////////////////////////////////////////////////

module divider (clk,rst,load,n,d,q,r,ready);

`include "log2.inc"

parameter WIDTH_N = 32;
parameter WIDTH_D = 32;
localparam LOG2_WIDTH_N = log2(WIDTH_N);
localparam MIN_ND = (WIDTH_N <WIDTH_D ? WIDTH_N : WIDTH_D);

input clk,rst;

input load;					// load the numer and denominator
input [WIDTH_N-1:0] n;		// numerator
input [WIDTH_D-1:0] d;		// denominator
output [WIDTH_N-1:0] q;		// quotient
output [WIDTH_D-1:0] r;		// remainder
output ready;				// Q and R are valid now.

reg [WIDTH_N + MIN_ND : 0] working;
reg [WIDTH_D-1 : 0] denom;

wire [WIDTH_N-1:0] lower_working = working [WIDTH_N-1:0];
wire [MIN_ND:0] upper_working = working [WIDTH_N + MIN_ND : WIDTH_N];

wire [WIDTH_D:0] sub_result = upper_working - denom;
wire sub_result_neg = sub_result[WIDTH_D];

reg [LOG2_WIDTH_N:0] cntr;
wire cntr_zero = ~|cntr;
assign ready = cntr_zero;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		working <= 0;
		denom <= 0;
		cntr <= 0;
	end
	else begin
		if (load) begin
			working <= {{WIDTH_D{1'b0}},n,1'b0};
			cntr <= WIDTH_N;
			denom <= d;
		end
		else begin
			if (!cntr_zero) begin
				cntr <= cntr - 1;
				working <= sub_result_neg ? {working[WIDTH_N+MIN_ND-1:0],1'b0} :
						{sub_result[WIDTH_D-1:0],lower_working,1'b1};
			end
		end
	end
end

assign q = lower_working;
assign r = upper_working >> 1;

endmodule

////////////////////////////////////////////////////
// 2 bits per tick (radix 4) version
////////////////////////////////////////////////////

module divider_rad4 (clk,rst,load,n,d,q,r,ready);

`include "log2.inc"

parameter WIDTH_N = 32;	// assumed to be EVEN
parameter WIDTH_D = 32;
localparam LOG2_WIDTH_N = log2(WIDTH_N);
localparam MIN_ND = (WIDTH_N <WIDTH_D ? WIDTH_N : WIDTH_D);

input clk,rst;

input load;					// load the numer and denominator
input [WIDTH_N-1:0] n;		// numerator
input [WIDTH_D-1:0] d;		// denominator
output [WIDTH_N-1:0] q;		// quotient
output [WIDTH_D-1:0] r;		// remainder
output ready;				// Q and R are valid now.

reg [WIDTH_N + MIN_ND + 1 : 0] working;
reg [WIDTH_D-1 : 0] denom;
reg [WIDTH_D+1 : 0] triple_denom;

wire [WIDTH_N-1:0] lower_working = working [WIDTH_N-1:0];
wire [MIN_ND + 1:0] upper_working = working [WIDTH_N + MIN_ND + 1: WIDTH_N];

wire [WIDTH_D + 2:0] minus_zero = upper_working;
wire [WIDTH_D + 2:0] minus_one = upper_working - denom;
wire [WIDTH_D + 2:0] minus_two = upper_working - (denom << 1);
wire [WIDTH_D + 2:0] minus_three = upper_working - triple_denom;

wire [1:0] quot_bits = {!minus_two[WIDTH_D+2],
			!minus_one[WIDTH_D+2] & 
				!(minus_three[WIDTH_D+2] ^ minus_two[WIDTH_D+2])};
			
wire [WIDTH_D + 2:0] appro_minus = 
			quot_bits[1] ? (quot_bits[0] ? minus_three : minus_two) :
						(quot_bits[0] ? minus_one : minus_zero);

reg [LOG2_WIDTH_N:0] cntr;
wire cntr_zero = ~|cntr;
assign ready = cntr_zero;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		working <= 0;
		denom <= 0;
		triple_denom <= 0;
		cntr <= 0;
	end
	else begin
		if (load) begin
			working <= {{MIN_ND{1'b0}},n,2'b0};
			cntr <= (WIDTH_N >> 1);
			denom <= d;
			triple_denom <= (d + (d << 1));
		end
		else begin
			if (!cntr_zero) begin
				cntr <= cntr - 1;
				working <= {appro_minus[WIDTH_D-1:0],lower_working,quot_bits};
			end
		end
	end
end

assign q = lower_working;
assign r = upper_working >> 2;

endmodule


