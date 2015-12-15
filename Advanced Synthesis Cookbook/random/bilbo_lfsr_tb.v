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

module bilbo_lfsr_tb ();

parameter WIDTH = 16;

reg clk,rst,sin,fail;
wire sout;
wire [WIDTH-1:0] out;
reg [WIDTH-1:0] in;
reg [1:0] mode;

bilbo_lfsr b (.pin(in),.pout(out),.shift_in(sin),.shift_out(sout),
	.mode(mode),.clk(clk),.rst(rst));
defparam b.WIDTH = WIDTH;

initial begin
	fail = 0;
	clk = 0;
	rst = 0;
	sin = 0;
	in = 0;
	mode = 0;
		
	#10 rst = 1;
	#10 rst = 0;
end

always begin 
	#1000 clk = ~clk;
end

reg [WIDTH-1:0] last_out;

always @(negedge clk) begin
	in = $random;
	sin = $random;
	mode = $random;
	last_out = out;
end

// test the shifting and pass through modes
always @(posedge clk) begin
	#10 if (mode == 0) begin
		if (out != in) begin
			$display ("Mode 0 failure");
			fail = 1;
		end
	end
	else if (mode == 1) begin
		if (out != ((last_out << 1) | sin)) begin
			$display ("Mode 1 failure");
			fail = 1;
		end
	end

	// other modes verified in system
end

initial begin
	#1000000
	if (!fail) $display ("PASS (not fully covered)");
	$stop();
end

endmodule

