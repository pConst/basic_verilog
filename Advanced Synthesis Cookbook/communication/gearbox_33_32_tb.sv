// Copyright 2011 Altera Corporation. All rights reserved.  
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

module gearbox_33_32_tb ();

reg clk,arst;
reg [32:0] din = 0;
wire din_ready;
wire [31:0] dout;

gearbox_33_32 dut (
	.*	
);

integer n;
wire [32:0] recovered;
wire recovered_valid;
reg din_slip;
initial begin
	din_slip = 1'b1;
	for (n=0; n<34; n=n+1) begin
		@(negedge clk);
	end	
	din_slip = 1'b0;
	
end

gearbox_32_33 dut_b (
	.clk,.arst,
	.din(dout),  // bit 0 is sent first
	.din_valid(1'b1),
	.din_slip(din_slip),		// drop bit 0 of the current din
	.dout(recovered), // bit 0 is sent first
	.dout_valid(recovered_valid)
);

always @(posedge clk) begin
	if (din_ready) din <= din + 1'b1;
end

////////////////////////////////////
// clock driver

always begin
	#5 clk = ~clk;
end

initial begin
	clk = 0;
	arst = 0;
	#1 arst = 1'b1;
	@(negedge clk) arst = 1'b0;
end

endmodule