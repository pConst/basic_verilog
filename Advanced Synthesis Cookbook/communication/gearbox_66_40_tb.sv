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

module gearbox_66_40_tb ();

reg clk = 1'b0;
reg [65:0] din = 0;     // lsbit first
reg sclr = 1'b0;
wire din_ack;
wire [39:0] dout;
wire din_pre_ack;
wire din_pre2_ack;

gearbox_66_40 dut_a (.*);

reg [79:0] history = 0;
always @(posedge clk) begin
	history <= {dout,history[79:40]};
end

wire [39:0] word_locked,slipping;

genvar i;
generate 
	for (i=0; i<40; i=i+1) begin
		
		wire [65:0] recover;
		wire recover_valid;
		
		gearbox_40_66 dut_b (
			.clk,
			.slip_to_frame(1'b1),
			.din (history[i+39:i]),
			.dout (recover),
			.dout_valid (recover_valid),
			.slipping(slipping[i]),
			.word_locked (word_locked[i])
		);						
	end
endgenerate

reg send_rand = 1'b1;
reg [31:0] cntr = 0;

always @(posedge clk) begin
	if (din_ack) din <= send_rand ? {$random,$random,din[13],din[13]^1'b1} :
				{30'h0,cntr,2'b00,2'b01};
end

wire all_locked = &word_locked;

reg fail = 1'b0;
initial begin
	#100 @(posedge all_locked);
	@(negedge all_locked);
	$display ("Unexpected loss of lock");
	fail = 1'b1;
end

initial begin
	@(posedge all_locked);
	$display ("locked at time %d",$time);
	send_rand = 1'b0;	
	#100000 if (!fail) $display ("PASS");
	$stop();
end

always begin
	#5 clk <= ~clk;
end

endmodule
