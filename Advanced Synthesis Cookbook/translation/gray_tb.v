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

module gray_tb ();

wire [9:0] gry, bin;
reg [9:0] cnt;
reg fail;

bin_to_gray bg (.bin(cnt),.gray(gry));
	defparam bg .WIDTH = 10;

gray_to_bin gb (.gray(gry),.bin(bin));
	defparam gb .WIDTH = 10;

initial begin
   cnt = 0;
   fail = 0;
   
end

always begin
   #1000 cnt = cnt + 1;
   #1000 if (cnt !== bin) begin
	$display ("Mismatch at time %d",$time);
	fail = 1;
   end
   if (cnt == 0) begin
	if (!fail) $display ("PASS");
	$stop();
   end
end

endmodule