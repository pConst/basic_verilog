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

module seconds_counter_tb ();

parameter WIDTH = 8;

reg rst = 0, clk = 0;
wire [WIDTH-1:0] val;
wire tick;

seconds_counter sc 
(
	.clk100(clk),
	.reset(rst),
	.count_val(val),
	.tick(tick)
);
	
	defparam sc .WIDTH = WIDTH;

integer check = 0;
reg fail = 0;

initial begin
	@(negedge clk) rst = 1'b1;
	@(negedge clk) rst = 1'b0;
	check = 0;
	@(posedge tick);
	@(negedge clk);
	@(negedge clk);
	$display ("check = %d",check);
	
	if (val != 1) begin
		$display ("Mismatch in seconds counter");
		fail = 1;
	end
	
	if (check !== 100_000_001) begin
		$display ("Mismatch with cycle count");
		fail = 1;
	end

	@(negedge clk);
	if (!fail) $display ("PASS");
	$stop();
end

always @(posedge clk) begin
	check <= check + 1'b1;
end

always begin
	#5 clk = ~clk;
end

endmodule