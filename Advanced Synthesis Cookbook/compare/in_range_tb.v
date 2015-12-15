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

module in_range_tb ();

parameter LOWER_BOUND = 85;
parameter UPPER_BOUND = 120;
parameter WIDTH = 7;

reg [WIDTH-1:0] value;
wire inra, inrb, inrc ;

in_range a (.dat(value),.inr(inra));
  defparam a .WIDTH = WIDTH;
  defparam a .LOWER_BOUND = LOWER_BOUND;
  defparam a .UPPER_BOUND = UPPER_BOUND;
  defparam a .METHOD = 0;

in_range b (.dat(value),.inr(inrb));
  defparam b .WIDTH = WIDTH;
  defparam b .LOWER_BOUND = LOWER_BOUND;
  defparam b .UPPER_BOUND = UPPER_BOUND;
  defparam b .METHOD = 1;

in_range c (.dat(value),.inr(inrc));
  defparam c .WIDTH = WIDTH;
  defparam c .LOWER_BOUND = LOWER_BOUND;
  defparam c .UPPER_BOUND = UPPER_BOUND;
  defparam c .METHOD = 2;

wire too_low = value < LOWER_BOUND;
wire too_high = value >= UPPER_BOUND;

reg fail = 0;

initial begin
  value = 0;
  #100000 if (!fail) $display ("PASS");
  $stop();
end

always begin
  #50 value = $random;
  #50 if (inra !== inrb || inra !== inrc) begin
	$display ("Mismatch at time %d - val %d",$time,value);
	fail = 1;
  end
end

endmodule