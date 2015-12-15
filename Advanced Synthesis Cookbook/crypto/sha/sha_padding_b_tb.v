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

// test the padding of the standard demo with one byte removed

module sha_padding_b_tb ();

reg clk,reset;
reg [63:0] word_in,word_expect,reg_word_out;
reg [6:0] word_in_bits;
reg next_word;

wire [63:0] word_out;
wire msg_complete;

sha_padding sp (
	.clk(clk),
	.reset(reset),
	.word_in(word_in),
	.word_in_bits(word_in_bits),
	.word_out(word_out),
	.msg_complete(msg_complete),
	.next_word(next_word)
);

reg [887:0] test_str = {"abcdefghbcdefghicdefghijdefghijkefghijklfghijklmghijklmn",
					   "hijklmnoijklmnopjklmnopqklmnopqrlmnopqrsmnopqrstnopqrst"};

reg [135:0] test_str_padding = {1'b1,7'b0,  
					64'h0,64'h378};

reg [1023:0] expect_str;

integer n;

reg fail;

always @(posedge clk) begin
	reg_word_out <= word_out;
end

initial begin
	clk = 1'b0;
	reset = 1'b1;
	fail = 1'b0;
	expect_str = {test_str,test_str_padding};

	@(posedge clk);
	@(negedge clk) reset = 1'b0;

	next_word = 1'b1;
	for (n=0; n<14; n=n+1)
	begin
		word_in = test_str [887:824];
		word_expect = expect_str [1023:960];
		word_in_bits = (n == 13 ? 7'd56 :7'd64);
		#1
		test_str = test_str << 64;
		expect_str = expect_str << 64;
		@(posedge clk);
		#1
		if (word_expect !== reg_word_out) begin
			$display ("Mismatch at time %d",$time);
			fail = 1'b1;
		end
		@(negedge clk);
	end
	word_in_bits = 7'd0;

	for (n=0; n<2; n=n+1)
	begin
		word_expect = expect_str [1023:960];
		expect_str = expect_str << 64;
		
		@(posedge clk);
		#1
		
		if (word_expect !== reg_word_out) begin
			$display ("Mismatch at time %d",$time);
			fail = 1'b1;
		end
		@(negedge clk);
	end

	if (!msg_complete) begin
		$display ("Mismatch on message complete");
		fail = 1'b1;
	end
	if (!fail) $display ("PASS");
	$stop();
end

		
always begin 
	#100 clk = ~clk;
end

endmodule
