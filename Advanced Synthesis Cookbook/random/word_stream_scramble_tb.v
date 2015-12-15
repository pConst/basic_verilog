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

module word_stream_scramble_tb ();

reg clk,rst,ena;
reg [7:0] din;
wire [7:0] sc_dout, dout;
wire sc_dout_valid, dout_valid;

word_stream_scramble ws (
	.clk(clk),
	.ena(rst | ena),
	.rst(rst),
	.din(din),
	.dout(sc_dout),
	.dout_valid(sc_dout_valid)
);
defparam ws .WORD_LEN = 8;

word_stream_scramble uws (
	.clk(clk),
	.ena(rst | sc_dout_valid),
	.rst(rst),
	.din(sc_dout),
	.dout(dout),
	.dout_valid(dout_valid)
);
defparam uws .WORD_LEN = 8;
defparam uws .SCRAMBLE = 1'b0;

reg fail;

initial begin
	clk = 0;
	rst = 0;
	din = 0;
	ena = 1;
	fail = 0;
	#10 
	rst = 1'b1;
	@(posedge clk);
	@(negedge clk);
	rst = 1'b0;
	
	#1000000 if (!fail) $display ("PASS");
	$stop();
end

reg [7:0] expect_out;
always @(posedge clk) begin
	if (rst) begin
		din <= 0;
		expect_out <= 0;
	end
	else begin
		din <= din + 1'b1;
		if (dout_valid) expect_out <= expect_out + 1'b1;
	end
end

always @(posedge clk) begin
	#5 if (expect_out !== dout) begin
		$display ("Mismatch at time %d",$time);
		fail = 1;
	end
end

always begin
	#100 clk <= ~clk;
end

endmodule