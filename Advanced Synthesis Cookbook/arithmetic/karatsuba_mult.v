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

// baeckler, liu - 06-14-2007

module karatsuba_mult (clk, a, b, o);

parameter IN_WIDTH = 64;			// must be even	
localparam OUT_WIDTH = 2*IN_WIDTH;
localparam WORD_WIDTH = IN_WIDTH / 2;

input [IN_WIDTH-1:0] a, b;
input clk;
output [OUT_WIDTH-1:0] o;

wire [WORD_WIDTH-1:0] a_h, a_l, b_h, b_l;
assign {a_h,a_l} = a;
assign {b_h,b_l} = b;

// tick 0 - Input registers
reg [WORD_WIDTH-1:0] a_hr,a_lr,b_hr,b_lr;
always @(posedge clk) begin
	a_hr <= a_h;
	a_lr <= a_l;
	b_hr <= b_h;
	b_lr <= b_l;
end

wire [WORD_WIDTH:0] a_hl, b_hl;
assign a_hl = a_hr + a_lr;
assign b_hl = b_hr + b_lr;

// ticks 0 1 2
wire [IN_WIDTH-1:0] pphh, ppll;
mult_3tick mx (.clk(clk),.a_in(a_h),.b_in(b_h),.o(pphh));
	defparam mx .IN_WIDTH = WORD_WIDTH;
mult_3tick my (.clk(clk),.a_in(a_l),.b_in(b_l),.o(ppll));
	defparam my .IN_WIDTH = WORD_WIDTH;

// ticks 1 2 3
wire [IN_WIDTH+1:0] pphl;
mult_3tick mz (.clk(clk),.a_in(a_hl),.b_in(b_hl),.o(pphl));
	defparam mz .IN_WIDTH = WORD_WIDTH+1;

// desired function is Out = 
//   {pphh,ppll} - pphh<<WORD_WIDTH - ppll<<WORD_WIDTH + pphl<<WORD_WIDTH

reg [WORD_WIDTH-2:0] o_h_quarter_reg3;
reg [WORD_WIDTH-1:0] o_l_quarter_reg3;
wire [IN_WIDTH:0] comp_a_oo, comp_a_ot; 
reg [IN_WIDTH:0] comp_a_oo_r, comp_a_ot_r;

// the low order 1's dispose of the first two's comp
// +1 - net effect is (+1 << WORD_WIDTH)
compress_32 comp_a (
	.a({pphh[WORD_WIDTH-1:0],ppll[IN_WIDTH-1:WORD_WIDTH]}),
	.b(~pphh),
	.c(~ppll),
	.oo(comp_a_oo[IN_WIDTH-1:0]),
	.ot(comp_a_ot[IN_WIDTH:1])
);
defparam comp_a .WIDTH = IN_WIDTH;

assign comp_a_oo[IN_WIDTH] = pphh[WORD_WIDTH];
assign comp_a_ot[0] = 1'b1;

// tick 3
always @(posedge clk) begin
	o_h_quarter_reg3 <= pphh[IN_WIDTH-1:WORD_WIDTH+1];
        o_l_quarter_reg3 <= ppll[WORD_WIDTH-1:0];	
	comp_a_oo_r <= comp_a_oo;
	comp_a_ot_r <= comp_a_ot;
end

wire [IN_WIDTH+1:0] comp_b_oo, comp_b_ot;

compress_32 comp_b (
	.a(comp_a_oo_r),
	.b(comp_a_ot_r),
	.c(pphl[IN_WIDTH:0]),
	.oo(comp_b_oo[IN_WIDTH:0]),
	.ot(comp_b_ot[IN_WIDTH+1:1])
);
defparam comp_b .WIDTH = IN_WIDTH+1;

assign comp_b_oo[IN_WIDTH+1] = ~pphl[IN_WIDTH+1];
assign comp_b_ot[0] = 1'b1;

// ticks 4 and 5
reg [WORD_WIDTH-2:0] o_h_quarter_reg4;
wire [WORD_WIDTH-2:0] o_h_quarter_reg4_plus /*synthesis keep*/;
reg [WORD_WIDTH-1:0] o_l_quarter_reg4;
reg [WORD_WIDTH-2:0] o_h_quarter_reg5;
reg [WORD_WIDTH-1:0] o_l_quarter_reg5;

wire o_h_sel;
wire tmp;

// this is a 2 cycle pipelined adder modified to expose the
// unregistered most significant bit.

pipeline_add_msb pa (
	.clk(clk),
	.rst(1'b0),
	.a(comp_b_oo),
	.b(comp_b_ot),
	.o({tmp, o[IN_WIDTH+WORD_WIDTH:WORD_WIDTH]}),
	.msb(o_h_sel)
);
defparam pa .LS_WIDTH = WORD_WIDTH+1;
defparam pa .MS_WIDTH = WORD_WIDTH+1;

assign o_h_quarter_reg4_plus = o_h_quarter_reg4 + 1;

always @(posedge clk) begin
	o_h_quarter_reg4 <= o_h_quarter_reg3;
	
	// carry select speed optimization
	o_h_quarter_reg5 <= o_h_sel? o_h_quarter_reg4_plus : o_h_quarter_reg4;
	
	o_l_quarter_reg4 <= o_l_quarter_reg3;
	o_l_quarter_reg5 <= o_l_quarter_reg4;
end

assign o[WORD_WIDTH-1:0] = o_l_quarter_reg5;
assign o[OUT_WIDTH-1:IN_WIDTH+WORD_WIDTH+1] = o_h_quarter_reg5;

endmodule
