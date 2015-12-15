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

//baeckler - 11-14-2006

///////////////////////////////////////////////////////
// test 3 to 2 to 3 buffers
///////////////////////////////////////////////////////
module buffer_tb();

reg clk,rst;

reg [23:0] din;
reg din_valid;
wire din_ack;

wire [15:0] dout32;
wire dout_valid32;
wire dout_ack32;

wire [23:0] dout;
wire dout_valid;
reg dout_ack;

// convert 3 byte stream to 2 byte
buf_3to2 bfx ( 
	.clk(clk),.rst(rst),

	.din(din),
	.din_valid(din_valid),
	.din_ack(din_ack),

	.dout(dout32),
	.dout_valid(dout_valid32),
	.dout_ack(dout_ack32)
);

// convert 2 byte stream back to 3 byte
buf_2to3 bfy ( 
	.clk(clk),.rst(rst),

	.din(dout32),
	.din_valid(dout_valid32),
	.din_ack(dout_ack32),

	.dout(dout),
	.dout_valid(dout_valid),
	.dout_ack(dout_ack)
);

reg fail = 0;

initial begin
	clk = 0 ;
	rst = 0;

	din_valid = 1'b1;
	din = 0;
	dout_ack = 0;

	#10 rst = 1'b1;
	#1 clk = 1'b1;
	#1 clk = 1'b0;
	#10 rst = 1'b0;

	#1000000 if (!fail) $display ("PASS");
	$stop();
end

reg [47:0] history = 0;

always @(posedge clk) begin
	if (din_ack) history <= (history << 24) | din;
	if (dout_valid) begin
		if (dout !== history[47:24]) begin
			$display ("Mismatch at time %d",$time);
			fail <= 1;
		end
	end
end

always @(negedge clk) begin
	
	// update input data on acknowledge
	if (din_ack) din <= $random;
	
	// accept output data whenever available
	dout_ack <= dout_valid;

end

always begin
	#100 clk = ~clk;
end

endmodule
