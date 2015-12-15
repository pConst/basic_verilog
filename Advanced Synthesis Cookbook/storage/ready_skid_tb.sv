// Copyright 2009 Altera Corporation. All rights reserved.  
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

module ready_skid_tb ();

parameter WIDTH = 12;

reg clk,arst;

reg valid_i;
reg [WIDTH-1:0] dat_i, last_o;
wire ready_i;

wire valid_o;
wire [WIDTH-1:0] dat_o;
reg ready_o;

ready_skid #(.WIDTH(WIDTH)) dut
(
	.*
);

initial begin
	clk = 0;
	dat_i = 0;
	valid_i = 0;
	ready_o = 0;
	last_o = 0;
	arst = 0;
	#1 arst = 1'b1;
	@(negedge clk) arst = 1'b0;
end

always begin 
	#5 clk = ~clk;
end

always @(negedge clk) begin
	valid_i = $random | $random;
	if (valid_i & ready_i) dat_i = dat_i + 1'b1;
	ready_o = $random | $random;
end

reg fail = 0;
wire [WIDTH-1:0] next_last_o = last_o + 1'b1;

always @(posedge clk) begin
	if (valid_o) last_o <= dat_o;
	#1 if (last_o != dat_o && next_last_o != dat_o) begin
		$display ("Mismatch at time %d",$time);
		fail = 1;
	end
end

initial begin
	#1000000 if (!fail) $display ("PASS");
	$stop();
end

endmodule

