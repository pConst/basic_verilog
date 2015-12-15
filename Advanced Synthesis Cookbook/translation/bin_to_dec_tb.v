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


module bin_to_dec_tb ();

reg [31:0] ins;
reg [31:0] ins_copy;

reg [39:0] expected;
wire [39:0] out;

reg fail = 0;
integer n;

bin_to_dec bd (.ins(ins),.out(out));

always begin
	#10 ins = $random;
	#1 ins_copy = ins; 
	expected = 0;
	for (n=0; n<10; n=n+1)
	begin : chk
		#1 expected = {expected[3:0],expected[39:4]} | (ins_copy % 10);
		ins_copy = ins_copy / 10;
	end
	expected = {expected[3:0],expected[39:4]};
	#1 if (out !== expected) fail = 1;
end

initial begin
	#200000 if (!fail) $display ("PASS");
	$stop();
end

endmodule 