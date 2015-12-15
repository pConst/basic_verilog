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

module one_hot_tb ();

wire [63:0] out;
reg [5:0] in;

one_hot o (.in(in),.out(out));

initial begin 
  in=0;
end

reg [63:0] ref;
always @(*) begin
	ref = 0;
	ref[in] = 1'b1;
end

reg fail = 0;
always begin
  #1000 in = in + 1;
  #10 if (ref !== out) begin
	$display ("Mismatch at time %d",$time);
	fail = 1; 
  end
  if (in == 63) begin
	if (!fail) $display ("PASS");
	$stop();
  end
end

endmodule