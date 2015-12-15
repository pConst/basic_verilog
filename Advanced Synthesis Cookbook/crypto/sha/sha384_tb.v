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

// baeckler - 12-14-2006
// from appendix d2, SHA 384 example

module sha384_tb ();

reg clk,reset,new_msg,msg_complete;
wire msg_word_ack;

reg [63:0] msg_word;
wire [511:0] hash_out;
wire hash_ready;

sha512 dut 
(
	.clk(clk),
	.reset(reset),
	.new_msg(new_msg),
	.msg_complete(msg_complete),
	.msg_word(msg_word),
	.msg_word_ack(msg_word_ack),
	.msg_word_valid(1'b1),
	.hash_out(hash_out),
	.hash_ready(hash_ready)
);
defparam dut .HASH_SIZE = 384;

wire [895:0] test_str = {"abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmn",
					   "hijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrstu"};

wire [1151:0] padding = {1'b1,127'b0,  
					896'b0,64'h0,64'h380};

reg [2047:0] test_data;

integer n;

reg last_msg_word_ack;
always @(posedge clk) begin
	last_msg_word_ack <= msg_word_ack;
end

// sanity check that the message burn rate is correct
// should be 16 per message block
reg [7:0] reqs;
always @(posedge clk) begin
	if (reset) reqs <= 0;
	else if (msg_word_ack) reqs <= reqs + 1'b1;
end

initial begin
	#1
	clk = 1'b0;
	reset = 1'b1;
	new_msg = 1'b0;
	msg_complete = 1'b0;
	msg_word = 0;
	test_data = {test_str,padding};
	msg_word = test_data[2047:2047-63];	
		
	@(posedge clk);
	@(negedge clk);
	reset = 1'b0;
	new_msg = 1'b1;
	
	n = 0;
	while (n<=32) 
	begin
		if (n == 17) begin
			if (hash_out !== { 
				64'h8f2ebe9a81e6a2c5,
				64'h37eb9a6660feb519,
				64'h17b61a85e2ccf0a9,
				64'hc662113e9ebb4d64,
				64'hf6352ca156acaff7,
				64'h015a2173796c1a88,
				64'heaae96d1a673c741,
				64'h2a7f1d895fd58e0b }) 
			begin
				$display ("Hash of the 1st block is incorrect");
				$stop();
			end
			else begin
				$display ("Hash of 1st block matches expected value");
			end
		end

			
		@(negedge clk);
		new_msg = 1'b0;
		#1
		if (last_msg_word_ack) begin
			test_data = test_data << 64;
			n = n + 1;
		end
		#1 msg_word = test_data[2047:2047-63];	
	end
	msg_complete = 1'b1;

	if (hash_out !== { 
		64'hff334559a7135d3a,
		64'h1e9f1f7449ad1749,
		64'h66c3e9fa91746039,
		64'hfcc7c71a557e2db9,
		64'h2fa08086e3b0f712,
		64'h53111b173b3b05d2,
		64'h3d192fc782cd1b47,
		64'h09330c33f71147e8})
	begin
		$display ("Hash of the 2nd block is incorrect");
		$stop();
	end
	else begin
		$display ("Hash of 2nd block matches expected value");
	end

	@(negedge clk);
	@(negedge clk);
	$display ("PASS");
	$stop();	
end

always begin
	#100 clk = ~clk;
end
		
endmodule