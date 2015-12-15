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

module eight_to_one_tb ();

reg [7:0] dat;
reg [2:0] sel;
reg fail = 0;

wire out_a,out_b,out_c;

eight_to_one a (.dat(dat),.sel(sel),.out(out_a));
	defparam a .SEVEN_SEVEN_STYLE = 1;

eight_to_one b (.dat(dat),.sel(sel),.out(out_b));
	defparam b .FIVE_FIVE_STYLE = 1;

eight_to_one c (.dat(dat),.sel(sel),.out(out_c));

initial begin
	dat = 0;
	sel = 0;
	fail = 0;
	#1000000 
	if (!fail) $display ("PASS");
	$stop();
end

always begin
	#1000 dat = $random;
	sel = $random;
	#1000
	if (out_a != out_b || out_a != out_c) begin
		fail = 1;
		$display ("Mismatch at time %d",$time);
	end
end

endmodule