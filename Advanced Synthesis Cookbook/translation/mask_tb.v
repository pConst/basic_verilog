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

module mask_tb ();

wire [15:0] mask,mask_b,mask_c;
reg [3:0] in;

mask_16 m16 (.in(in),.mask(mask));
mask_32 m32 (.in({1'b0,in}),.mask({mask_b,mask_c}));

initial begin 
  in=0;
end

// just a quick sanity check
reg fail = 0;
always begin
  #1000 in = in + 1;
  #10 if (mask !== mask_b || mask_c !== 0) begin
	  $display ("Mismatch at time %d",$time);
	  fail = 1'b1;
	end
  if (in == 15) begin
	if (!fail) $display ("PASS");
	$stop();
  end
end

endmodule