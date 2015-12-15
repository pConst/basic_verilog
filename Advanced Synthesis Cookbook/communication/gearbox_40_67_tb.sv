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

module gearbox_40_67_tb ();

reg clk,arst;

localparam TEST_SAMPLES = 16;
reg [TEST_SAMPLES*67-1:0] test = {
	3'b010,64'h00000000_00000000,
	3'b110,64'hffffffff_ffffffff,
	3'b010,64'h02234567_89abcdef,
	3'b110,64'h03234567_89abcdef,
	3'b010,64'h04234567_89abcdef,
	3'b110,64'h05234567_8900cdef,
	3'b010,64'h06234567_8901cdef,
	3'b010,64'h07234567_8902cdef,
	3'b110,64'h08234567_8903cdef,
	3'b010,64'h09234567_8904cdef,
	3'b010,64'h0a234567_8905cdef,
	3'b110,64'h0b234567_8906cdef,
	3'b010,64'h0c234567_8907cdef,
	3'b110,64'h0d234567_89abcd99,
	3'b010,64'h0e234567_89abcdef,
	3'b110,64'h0f234567_89abcdef
};

reg [TEST_SAMPLES*67-1:0] expected;

//////////////////////////////////////////
// DUTs
//////////////////////////////////////////

wire din_ready;
wire [39:0] mid;

gearbox_67_40 dut_a (
	.clk,.arst,
	.din(test[66:0]),
	.din_ready,
	.dout (mid)
);

// recover the sender side data for observation
integer holding = 41;
reg [100:0] history;
reg [66:0] recovered;
always @(posedge clk) begin
	#1
	history = (history << 40) | mid;
	holding = holding + 40;
	if (holding >= 67) begin
		recovered = history >> (holding-67);
		holding = holding - 67;
	end
end

always @(posedge clk) begin
	if (din_ready) test <= 
		{test [(TEST_SAMPLES-1)*67-1:0],
		test[TEST_SAMPLES*67-1:(TEST_SAMPLES-1)*67]};
end

wire [66:0] dout;
wire dout_valid;

gearbox_40_67 dut_b (
	.clk,.arst,
	.slip_to_frame(1'b1),
	.din(mid),
	.dout,
	.dout_valid
);

//////////////////////////////////////////
// Follow the recovered data
//////////////////////////////////////////

initial expected = test;
wire match = (dout_valid & (dout == expected[66:0]));

integer match_count = 0;
integer trial_count = 0;

always @(posedge clk) begin
	#1 if (match) begin
		expected <= 
			{expected [(TEST_SAMPLES-1)*67-1:0],
			expected[TEST_SAMPLES*67-1:(TEST_SAMPLES-1)*67]};
		match_count <= match_count + 1;
	end
	if (dout_valid) trial_count <= trial_count + 1'b1;
end

initial begin
	#400 // allow some time to lock
	@(negedge clk) trial_count = 0;
	match_count = 0;
	#100000
	$display ("%d trials %d matches\n",trial_count,match_count);
	
	// Note : If there is a problem these will deviate
	// wildly.  Off by one is OK, but it doesn't seem
	// to happen in this test.
	
	if (trial_count == match_count) begin
		$display ("PASS");
	end
	$stop();	
end

//////////////////////////////////////////
// clock driver
//////////////////////////////////////////

always begin
	#5 clk = ~clk;
end

initial begin
	clk = 0; 
	arst = 0;
	#1 arst = 1;
	@(negedge clk) arst = 0;
end

endmodule