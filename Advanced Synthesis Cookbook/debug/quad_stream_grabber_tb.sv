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

module quad_stream_grabber_tb ();

parameter DAT_WIDTH = 72; // multiple of 8
parameter ADDR_BITS = 4; // depth of the sample memory

// streams to observe - independently clocked
wire [3:0] clk_str;
reg [3:0] arst_str;
reg [DAT_WIDTH*4-1:0] data_in;
reg [3:0] data_in_valid = 4'hf;

// system clk / ctrl
reg clk_sys, arst_sys;
reg start_harvest;

// combined output
wire [7:0] dout;
reg dout_ready = 1'b1;
reg dout_valid;
reg reporting;	
	
quad_stream_grabber dut
(
	.*
);

defparam dut .DAT_WIDTH = DAT_WIDTH; // multiple of 8
defparam dut .ADDR_BITS = ADDR_BITS;  // depth of the sample memory

//////////////////////////////////////////////////
// rough test data
//////////////////////////////////////////////////

genvar i;
initial data_in = 
	{72'h010101010101010101,
	 72'h111111111111111111,
	 72'h212121212121212121,
	 72'h313131313131313131};

for (i=0; i<4; i=i+1) begin : foo
	always @(posedge clk_str[i]) begin
		data_in[DAT_WIDTH*(i+1)-1:DAT_WIDTH*i] <=
			data_in[DAT_WIDTH*(i+1)-1:DAT_WIDTH*i] +
			72'h010101010101010101;
	end
end

initial begin
	start_harvest = 0;
	#1000
	@(negedge clk_sys);
	start_harvest = 1;
	@(posedge reporting);
	start_harvest = 0;
	@(negedge reporting);
	#1000
	@(negedge clk_sys);
	start_harvest = 1;
	@(posedge reporting);
	start_harvest = 0;	
	@(negedge reporting);
	#1000
	@(negedge clk_sys);
	start_harvest = 1;
	@(posedge reporting);
	start_harvest = 0;	
end
	
//////////////////////////////////////////////////
// clock driver
//////////////////////////////////////////////////

always begin
	#5 clk_sys = ~clk_sys;
end
assign #1 clk_str[0] = clk_sys;
assign #2 clk_str[1] = clk_sys;
assign #3 clk_str[2] = clk_sys;
assign #4 clk_str[3] = clk_sys;

initial begin
	clk_sys = 0;
	arst_sys = 0;
	#1 arst_sys = 1;
	arst_str <= 4'b1111;
	
	@(negedge clk_sys) arst_sys = 0;
	@(negedge clk_str[0]) arst_str[0] = 0;
	@(negedge clk_str[1]) arst_str[1] = 0;
	@(negedge clk_str[2]) arst_str[2] = 0;
	@(negedge clk_str[3]) arst_str[3] = 0;	
end	
	
	
endmodule