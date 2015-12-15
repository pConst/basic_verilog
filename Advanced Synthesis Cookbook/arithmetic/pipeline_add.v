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

// baeckler - 09-01-2006
// 
// Adder with one level of pipeline (embedded in the carry chain).
// This is the most efficient way to speed up arithmetic when 
// latency is available.
//
// For some additional speed in return for more area you can duplicate
// the more significant chain and do carry-select.  Shorten the less 
// significant half to balance the delay.
//

module pipeline_add (clk,rst,a,b,o);

parameter LS_WIDTH = 10;
parameter MS_WIDTH = 10;
parameter WIDTH = LS_WIDTH + MS_WIDTH;

input [WIDTH-1:0] a,b;
input clk,rst;
output [WIDTH-1:0] o;
reg [WIDTH-1:0] o;

	// Build the less significant adder with an extra bit on the top to get
	// the carry chain onto the normal routing.  
	reg [LS_WIDTH-1+1:0] ls_adder;
	wire cross_carry = ls_adder[LS_WIDTH];
	always @(posedge clk or posedge rst) begin
		if (rst) ls_adder <= 1'b0;
		else ls_adder <= {1'b0,a[LS_WIDTH-1:0]} + {1'b0,b[LS_WIDTH-1:0]};
	end

	// the more significant data needs to wait a tick for the carry
	// signal to be ready
	reg [MS_WIDTH-1:0] ms_data_a,ms_data_b;
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			ms_data_a <= 0;
			ms_data_b <= 0;
		end
		else begin
			ms_data_a <= a[WIDTH-1:WIDTH-MS_WIDTH];
			ms_data_b <= b[WIDTH-1:WIDTH-MS_WIDTH];
		end
	end

	// Build the more significant adder with an extra low bit to incorporate
	// the carry from the split lower chain.
	wire [MS_WIDTH-1+1:0] ms_adder;
	assign ms_adder = {ms_data_a,cross_carry} + 
			{ms_data_b,cross_carry};

	// collect the sum back together and register, drop the two internal bits
	always @(posedge clk or posedge rst) begin
		if (rst) o <= 0;
		else o <= {ms_adder[MS_WIDTH:1],ls_adder[LS_WIDTH-1:0]};
	end

endmodule

