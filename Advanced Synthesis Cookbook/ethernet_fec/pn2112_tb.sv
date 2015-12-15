// Copyright 2011 Altera Corporation. All rights reserved.  
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

// baeckler - 12-15-2008
// Simultate the pn2112 sequence to build a little table

module pn2112_tb ();

`include "reverse_32.inc"

reg [0:2111] seq;
reg clk = 0;

reg [57:0] lfreg = 58'h2aaaaaaaaaaaaaa;
wire out;

assign out = (lfreg[57] ^ lfreg[38]);
always @(posedge clk) begin
	lfreg <= {lfreg[56:0],out};
	seq <= (seq << 1) | out;
end

always begin
	#5 clk = ~clk;
end

integer n = 0;
initial begin
	#21120 
	for (n=0; n<66; n=n+1)
	begin
		$display ("7'd%d : seq = 32'h%x;",n[6:0],reverse_32(seq[32*n+:32]));
	end
	#5 $stop();
end

endmodule
	