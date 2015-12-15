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


module bitscan_tb ();
parameter WIDTH = 16;
reg [WIDTH-1:0] req;
wire [WIDTH-1:0] sel;

bitscan b (.req(req),.sel(sel));
  defparam b .WIDTH = WIDTH;

initial begin
  req = 16'h8000;
end

integer n;
reg [WIDTH-1:0] result;
reg fail = 0;

always begin 
  #100 req = $random & $random & $random;
  #10 
  result = 0;
  for (n=0; n<WIDTH; n=n+1)
  begin
	if (req[n] == 1'b1) begin
		result[n] = 1'b1;
		n = WIDTH;
	end
  end
  #10 if (sel !== result) begin
	$display ("Mismatch at time %d",$time);
	fail = 1'b1;
	$stop();
  end
end

initial begin
	#1000000 if (!fail) $display ("PASS");
	$stop();
end

endmodule
