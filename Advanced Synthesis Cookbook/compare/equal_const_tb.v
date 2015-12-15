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

module equal_const_tb ();

parameter WIDTH = 10;
parameter CONST_VAL = 10'b1010111010;

reg [WIDTH-1:0] dat;
reg fail;

wire aa,bb;

equal_const a (.dat(dat),.out(aa));
	defparam a .WIDTH = WIDTH;
	defparam a .METHOD = 0;
	defparam a .CONST_VAL = CONST_VAL;

equal_const b (.dat(dat),.out(bb));
	defparam b .WIDTH = WIDTH;
	defparam b .METHOD = 1;
	defparam b .CONST_VAL = CONST_VAL;

initial begin
	dat = 0;
	fail = 0;

	#100000 if (!fail) $display ("PASS");
	$stop();
end


always begin
  #50 dat = {$random,$random};
	
  #50 if  (aa !== bb) begin
  		$display ("Mismatch at time %d",$time);
		fail = 1;
	end
end

endmodule