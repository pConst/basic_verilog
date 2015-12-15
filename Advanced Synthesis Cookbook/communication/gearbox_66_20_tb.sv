// Copyright 2010 Altera Corporation. All rights reserved.  
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

`timescale 1 ps / 1 ps
module gearbox_66_20_tb ();

reg clk = 0 ;
reg [65:0] din = 0;
wire din_ack;
wire [19:0] dout_20;

gearbox_66_20 dut_a (
	.clk,
	.sclr(1'b0),
	.din,	// lsbit sent first
	.din_ack,
	.dout(dout_20) 
);

reg [39:0] history;
always @(posedge clk) begin
	history <= (history >> 20) | (dout_20 << 20);
end
wire [19:0] shifted_dout_20 = history >> 3;

wire [65:0] recovered;
wire recovered_valid;

gearbox_20_66 dut_b (
	.clk,
	.slip_to_frame (1'b1), // look for ethernet framing, [1:0] opposite
	.din(shifted_dout_20), // lsbit used first
	.dout(recovered),
	.dout_valid(recovered_valid)
);

reg [63:0] payload;
initial payload = {$random,$random};

always @(posedge clk) begin
	if (din_ack) begin
		din <= {payload,2'b10};
		payload <= {payload[62:0],payload[63]};
	end
end

reg [65:0] last_recover = 0;
reg recover_err = 1'b1;
always @(posedge clk) begin
	if (recovered_valid) begin
		last_recover <= recovered;
		recover_err <= (recovered[65:2] !== {last_recover[64:2],last_recover[65]}) ?
		 1'b1 : 1'b0;		 
	end
end

always begin
	#5 clk = ~clk;
end

reg grace = 1'b1;
initial begin
	grace = 1'b1;
	#10000 grace = 1'b0;
end

reg fail = 1'b0;
always @(posedge clk) begin
	if (!grace & recover_err) fail <= 1'b1;
end

initial begin
	#100000 if (!fail) $display ("PASS");
	$stop();
end

endmodule