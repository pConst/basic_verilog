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

// baeckler - 09-19-2008

// Note : This testbench is for observation only.
// See testbench gearbox_67_20_tb

module gearbox_20_67_tb ();

reg clk,arst;
reg [19:0] din;
wire [66:0] dout;
wire dout_valid;

gearbox_20_67 dut (
	.*
);

initial begin
	clk = 0;
	#1 arst = 1'b1;
	@(negedge clk) arst = 1'b0;
end

always begin
	#5 clk = ~clk;
end

reg [4*67-1:0] data_stream = {
	3'b010, 64'h1234567812345670,
	3'b010, 64'habcdef12abcdef11,
	3'b010, 64'h1234567812345679,
	3'b010, 64'habcdef12abcdef13
};
	
integer n = 4*67-1;
integer k;

always @(negedge clk) begin
	#2 if (!arst) begin
		din = 0;
		for (k=19;k>=0;k=k-1) begin
			din[k] = data_stream[n];
			if (n > 0) n = n - 1;
		end
	end
end

endmodule