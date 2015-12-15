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

module ycbcr_to_rgb (
	y,cb,cr,
	red,green,blue,
	clk
);

input clk;

input [7:0] y,cb,cr;
output reg [7:0] red,green,blue;

// offset the inputs
reg signed [8:0] adj_y,adj_cb,adj_cr;
always @(posedge clk) begin
	adj_y <= y - 8'd16;
	adj_cr <= cr - 8'd128;
	adj_cb <= cb - 8'd128;
end

// scaling constants from standard formulas
// nominal Y is 16 to 235
// nominal C's are 16-240 with 128 at zero
//
wire signed [8:0] const0 = 9'd149; // 1.164 * 128
wire signed [8:0] const1 = 9'd204; // 1.596 * 128
wire signed [8:0] const2 = - 9'd104; // 0.813 * 128 
wire signed [8:0] const3 = - 9'd50;	// 0.392 * 128

//wire signed [8:0] const4 = (10)'d258;	// 2.017 * 128 
// const 4 should be 258, which doesn't fit the 9x9 size.
// do some shifted additions to fake it.

// multipliers - 9x9 is a natural building block
reg signed [17:0] product_a, product_b, product_c, 
	product_d, product_e;
always @(posedge clk) begin
	product_a <= const0 * adj_y;
	product_b <= const1 * adj_cr;
	product_c <= const2 * adj_cr;
	product_d <= const3 * adj_cb;
	product_e <= {adj_cb[8],adj_cb[8:0],8'b0} +
				{{9{adj_cb[8]}},adj_cb[7:0],1'b0};
end

// summation - 17 selected by simulation
reg signed [17:0] sum_red, sum_green, sum_blue;
always @(posedge clk) begin
	sum_red <= product_a + product_b;
	sum_green <= product_a + product_c + product_d;
	sum_blue <= product_a + product_e;
end

// saturation
always @(posedge clk) begin
	red <= sum_red[17] ? 8'h0 : 
			(sum_red[15] | sum_red[16]) ? 8'hff :
			sum_red [14:7];
	green <= sum_green[17] ? 8'h0 : 
			(sum_green[15] | sum_green[16]) ? 8'hff :
			sum_green [14:7];
	blue <= sum_blue[17] ? 8'h0 : 
			(sum_blue[15] | sum_blue[16]) ? 8'hff :
			sum_blue [14:7];
end

endmodule
