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

module shift_tb ();

parameter WIDTH = 32;
parameter DW = 5;

reg [WIDTH-1:0] din;
reg [DW-1:0] dist;
reg fail;

wire [WIDTH-1:0] dout_r,dout_s,dout_b,dout_c;

rotate_internal r (.din(din),.dout(dout_r),.distance(dist));
	defparam r .WIDTH = WIDTH;
	defparam r .DIST_WIDTH=DW;
	defparam r .GENERIC = 1;

rotate_internal s (.din(din),.dout(dout_s),.distance(dist));
	defparam s .WIDTH = WIDTH;
	defparam s .DIST_WIDTH=DW;
	defparam s .GENERIC = 0;

barrel_shift b (.din(din),.dout(dout_b),.distance(dist));
	defparam b .RIGHT = 1;
	defparam b .WIDTH = WIDTH;
	defparam b .DIST_WIDTH=DW;
	
barrel_shift c (.din(dout_b),.dout(dout_c),.distance(dist));
	defparam c .RIGHT = 0;
	defparam c .WIDTH = WIDTH;
	defparam c .DIST_WIDTH=DW;

initial begin
	dist = 0;
	din = 0;
	fail = 0;
	#100000 if (!fail) $display ("PASS");
	$stop();
end

always begin 
	#1000 din = $random;
	dist = $random;
	#1000 if (dout_r != dout_s || dout_b != dout_s || dout_c != din) begin
		$display ("Mismatch at time %d",$time);
		fail = 1;
	end
end
endmodule