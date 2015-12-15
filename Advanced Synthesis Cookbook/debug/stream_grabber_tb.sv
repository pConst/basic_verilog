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

// baeckler -03-23-2009
module stream_grabber_tb ();

parameter DAT_WIDTH = 72; // multiple of 8
parameter ADDR_BITS = 4;  // depth of the sample memory

reg clk,arst;
reg [DAT_WIDTH-1:0] data_in = 0;
reg data_in_valid = 1'b0;

reg start_harvest;
wire reporting;

wire [7:0] byte_out;
wire byte_out_valid;
reg byte_out_ready = 1'b1;

//////////////////////////////////
// DUT
//////////////////////////////////

stream_grabber dut
(
	.*
);
defparam dut .DAT_WIDTH = DAT_WIDTH;
defparam dut .ADDR_BITS = ADDR_BITS;

//////////////////////////////////
// Rough data stream
//////////////////////////////////
always @(posedge clk) begin
	if (data_in_valid) data_in <= data_in + 1'b1;
	data_in_valid <= $random;		
end

//////////////////////////////////
// Clock driver
//////////////////////////////////

always begin
	#5 clk = ~clk;
end

initial begin
	clk = 0;
	arst = 0;
	#1 arst = 1'b1;
	@(negedge clk) arst = 1'b0;
	#200
	@(negedge clk) start_harvest = 1'b1;
	@(negedge clk) start_harvest = 1'b0;	
end

endmodule