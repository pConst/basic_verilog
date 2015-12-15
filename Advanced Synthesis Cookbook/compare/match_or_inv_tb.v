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

// baeckler - 02-23-2006

module match_or_inv_tb ();

parameter WIDTH = 8;

reg [WIDTH-1:0] ra;
reg [WIDTH-1:0] rb;
wire m;
reg fail = 0;

reg gold;

match_or_inv moi (
	.bus_a(ra),
	.bus_b(rb),
	.match_or_inv (m)
);
defparam moi .WIDTH = WIDTH;

always @(ra or rb) begin
  gold = (ra == rb) || (ra == ~rb);
end

initial begin
  ra = 0;
  rb = 0;
  fail = 0;

#100000
  if (!fail) $display ("PASS");

  $stop();
end

always begin
  #10 ra = $random;
  rb = $random;
  #10 if (m != gold) begin
	$display ("Mismatch at time %d",$time);
	fail = 1;
  end
end

endmodule