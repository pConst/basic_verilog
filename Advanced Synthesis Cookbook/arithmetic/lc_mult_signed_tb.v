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

// baeckler - 01-03-2006

module lc_mult_signed_tb ();

parameter WIDTH_A = 16;
parameter WIDTH_B = 13;
parameter WIDTH_O = WIDTH_A + WIDTH_B;
parameter LATENCY_L = 6;  
parameter LATENCY_LM = 10;  

reg clk;

//////////////////////////////////
// unit under test - no pipeline
//////////////////////////////////
reg [WIDTH_A-1:0] a;
reg [WIDTH_B-1:0] b;
wire [WIDTH_O-1:0] o;
lc_mult_signed m (.clk(clk),.a(a),.b(b),.o(o));
	defparam m .WIDTH_A = WIDTH_A;
	defparam m .WIDTH_B = WIDTH_B;
	defparam m .WIDTH_O = WIDTH_O;
	defparam m .REGISTER_LAYERS = 0;
	defparam m .REGISTER_MIDPOINTS = 0;

//////////////////////////////////
// unit under test - layer pipelined
//////////////////////////////////
wire [WIDTH_O-1:0] op;
lc_mult_signed mp (.clk(clk),.a(a),.b(b),.o(op));
	defparam mp .WIDTH_A = WIDTH_A;
	defparam mp .WIDTH_B = WIDTH_B;
	defparam mp .WIDTH_O = WIDTH_O;
	defparam mp .REGISTER_LAYERS = 1;
	defparam mp .REGISTER_MIDPOINTS = 0;

//////////////////////////////////
// unit under test - layer and middle pipelined
//////////////////////////////////
wire [WIDTH_O-1:0] opp;
lc_mult_signed mpp (.clk(clk),.a(a),.b(b),.o(opp));
	defparam mpp .WIDTH_A = WIDTH_A;
	defparam mpp .WIDTH_B = WIDTH_B;
	defparam mpp .WIDTH_O = WIDTH_O;
	defparam mpp .REGISTER_LAYERS = 1;
	defparam mpp .REGISTER_MIDPOINTS = 1;

/////////////////////
// reference unit
/////////////////////
wire signed [WIDTH_A-1:0] as;
wire signed [WIDTH_B-1:0] bs;
wire signed [WIDTH_O-1:0] os;
assign as = a;
assign bs = b;
assign os = as * bs;

////////////////////////////////
// history for reference unit
////////////////////////////////
reg [WIDTH_O*LATENCY_LM-1:0] pipe_history;
reg [LATENCY_LM-1:0] pipe_flushed;
wire [WIDTH_O-1:0] osp,ospp;
initial begin
	pipe_history = 0;
	pipe_flushed = 0;
end
always @(posedge clk) begin
	pipe_history <= (pipe_history << WIDTH_O) | os;
	pipe_flushed <= (pipe_flushed << 1) | 1'b1;
end
assign osp = pipe_history[WIDTH_O*LATENCY_L-1:WIDTH_O*LATENCY_L-WIDTH_O];
assign ospp = pipe_history[WIDTH_O*LATENCY_LM-1:WIDTH_O*LATENCY_LM-WIDTH_O];

/////////////////////
// stim
/////////////////////
reg fail;
initial begin 
	a = 0;
	b = 0;
	clk = 0;
	fail = 0;
	#1000000
	if (!fail) $display ("PASS");
	$stop();
end

always @(negedge clk) begin
	a = $random;
	b = $random;
end

always begin 
	#100 clk = ~clk;
end

always @(posedge clk) begin
	#10 if (os !== o) begin
		$display ("Mismatch in unregistered unit at time %d",$time);
		fail = 1;
	end
	if (&pipe_flushed && (osp !== op)) begin
		$display ("Mismatch in layer pipelined unit at time %d",$time);
		fail = 1;
	end
	if (&pipe_flushed && (ospp !== opp)) begin
		$display ("Mismatch in layer and midpoint pipelined unit at time %d",$time);
		fail = 1;
	end
end

endmodule
