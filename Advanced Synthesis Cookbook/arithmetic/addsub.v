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

module addsub (sub,a,b,o);

parameter WIDTH = 16;
parameter METHOD = 1;

input sub;
input [WIDTH-1:0] a,b;
output [WIDTH:0] o;

generate
  if (METHOD == 0) begin
    // generic style
    assign o = sub ? (a - b) : (a + b);
  end
  else if (METHOD == 1) begin
    // Hardware implementation with XORs in front of a
	// carry chain.
	wire [WIDTH+1:0] tmp;
	assign tmp = {1'b0,a,sub} + {sub,{WIDTH{sub}} ^ b,sub};
	assign o = tmp[WIDTH+1:1];
  end
endgenerate

endmodule

/////////////////////////////////////

module addsub_tb ();
parameter WIDTH = 16;

reg [WIDTH-1:0] a,b;
reg sub,fail;
wire [WIDTH:0] ox,oy;

initial begin
  a = 0;
  b = 0;
  fail = 0;
  #100000 if (!fail) $display ("PASS");
  $stop();
end

addsub x (.a(a),.b(b),.sub(sub),.o(ox));
  defparam x .WIDTH = WIDTH;
  defparam x .METHOD = 0;

addsub y (.a(a),.b(b),.sub(sub),.o(oy));
  defparam y .WIDTH = WIDTH;
  defparam y .METHOD = 1;

always begin
  #50 a = $random;
  b = $random;
  sub = $random;
  #50 
  if (ox !== oy) begin
    $display ("Mismatch at time %d",$time);
    fail = 1;
  end
end
endmodule
