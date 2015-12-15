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

// baeckler - 12-18-2006

module ram_delay_reg_tb ();

parameter DEPTH = 5;
parameter WIDTH = 64;

reg clock,enable, fail;
reg [WIDTH-1:0] data_in;
wire [WIDTH-1:0] data_out;

/////////////////////
// test unit
/////////////////////
ram_delay_reg dut (
	.clock (clock),
	.enable (enable),
	.data_in (data_in),
	.data_out (data_out)
);
defparam dut .DEPTH = DEPTH;
defparam dut .WIDTH = WIDTH;

/////////////////////
// reference unit
/////////////////////
reg [DEPTH*WIDTH-1:0] comp_reg;
always @(posedge clock) begin
	if (enable) comp_reg <= (comp_reg << WIDTH) | data_in;
end

/////////////////////
// stimulus
/////////////////////
initial begin
	clock = 1'b0;
	data_in = 0;
	enable = 1'b1;
	fail = 0;
	#1000000
	if (!fail) $display ("PASS");
	$stop();
end

always begin 
	#100 clock = ~clock;
end

always @(negedge clock) begin
	data_in = {$random,$random};
	enable = $random;
end

always @(posedge clock) begin
	#10 if (comp_reg[DEPTH*WIDTH-1:DEPTH*WIDTH-WIDTH] != data_out) begin
		$display ("Disagreement at time %d",$time);
		fail = 1;
	end
end

endmodule