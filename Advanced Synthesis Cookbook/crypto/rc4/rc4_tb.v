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

// baeckler - 04-17-2006
// RC4 testbench 
//   tests the generator using a fixed key (matching the CPP file)
//   and the synchronous reset capability
//
module rc4_tb ();

reg clk,rst,load_key,ena;
wire [7:0] dat;
wire dat_valid;

rc4 rs (.clk(clk),.ena(ena),.rst(rst),.dat(dat),.dat_valid(dat_valid),
			.key("gregg"),.load_key(load_key));
	defparam rs .KEY_BYTES = 5;
integer i;

reg fail = 0;

initial begin
	clk = 1'b0;
	rst = 1'b0;
	ena = 1'b1;
	load_key = 0;
	#10 rst = 1;
	#10 rst = 0;
	
	$display ("Keying...");
	@(posedge dat_valid);
	#10 
	$display ("First byte generated : %x expected ee",dat);
	if (dat != 8'hee) fail = 1'b1;
		
	for (i=2; i<101; i=i+1)
	begin
		@(posedge dat_valid);
	end
	#10
	$display ("100th byte generated : %x expected ab",dat);
	if (dat != 8'hab) fail = 1'b1;
	
	for (i=101; i<1001; i=i+1)
	begin
		@(posedge dat_valid);
	end
	#10
	$display ("1000th byte generated : %x expected 90",dat);
	if (dat != 8'h90) fail = 1'b1;
	
	for (i=1001; i<10001; i=i+1)
	begin
		@(posedge dat_valid);
	end
	#10
	$display ("10000th byte generated : %x expected 28",dat);
	if (dat != 8'h28) fail = 1'b1;
	
	/////////////////////////////////
	// test the synchronous reset
	/////////////////////////////////
	@(negedge clk);
	#10
	load_key = 1;
	ena = 1;
	@(posedge clk);
	@(negedge clk);
	load_key = 0;
	
	$display ("Started ReKeying at time %d...",$time);
	@(posedge dat_valid);
	#10 
	$display ("First byte generated : %x expected ee",dat);
	if (dat != 8'hee) fail = 1'b1;
	
	for (i=2; i<101; i=i+1)
	begin
		@(posedge dat_valid);
	end
	#10
	$display ("100th byte generated : %x expected ab",dat);
	if (dat != 8'hab) fail = 1'b1;
	
	for (i=101; i<1001; i=i+1)
	begin
		@(posedge dat_valid);
	end
	#10
	$display ("1000th byte generated : %x expected 90",dat);
	if (dat != 8'h90) fail = 1'b1;
	

	for (i=1001; i<10001; i=i+1)
	begin
		@(posedge dat_valid);
	end
	#10
	$display ("10000th byte generated : %x expected 28",dat);

	if (!fail) $display ("PASS");
	$stop();
end

// fiddle the enable randomly
always @(negedge clk) begin
	ena = $random;
end

always begin
	#100 clk = ~clk;
end

endmodule
