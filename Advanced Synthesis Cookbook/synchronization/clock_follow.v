// Copyright 2008 Altera Corporation. All rights reserved.  
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

// This is an interesting circut that effectively moves a clock
// off of the global clock network onto local routing.  It
// will cause some skew and duty distortion.  In the strict
// sense you can use this circuit to avoid gated clock warnings.
// However, it is unclear that the underlying timing situation is
// any better than the simple "out = clk" version.

module clock_follow (
	input clk_in,
	output clk_out
);

reg rp = 1'b0;
reg rn = 1'b0;

always @(posedge clk_in) begin
	rp <= ~rp;
end

always @(negedge clk_in) begin
	rn <= ~rp;
end

assign clk_out = ~rp ^ rn;

endmodule