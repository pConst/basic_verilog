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

module cam_ram_block_tb ();

reg clk = 1'b0, rst = 1'b1, start_write = 1'b0;
reg [4:0] waddr;
reg [6:0] wdata,wcare;
reg [6:0] lookup_data;

wire ready;
wire [31:0] match_lines;

cam_ram_block dut 
(
	.clk(clk),
	.rst(rst),
	.waddr(waddr),
	.wdata(wdata),
	.wcare(wcare),
	.start_write(start_write),
	.ready(ready),
	.lookup_data(lookup_data),
	.match_lines(match_lines)
);

reg fail;
initial begin 
	lookup_data = 7'h3;
	waddr = 5'h1a;
	wdata = 7'h3;
	wcare = 7'b1111111;
	fail = 0;

	@(posedge clk);
	@(negedge clk);
	rst = 1'b0;
	
	@(posedge ready);
	@(negedge clk);
	start_write = 1'b1;
	@(negedge clk);
	start_write = 1'b0;

	@(posedge ready);
	@(negedge clk);

	waddr = 5'h0;
	wdata = 7'h38;
	wcare = 7'b1111000;
	start_write = 1'b1;
	@(negedge clk);
	start_write = 1'b0;

	@(posedge ready);
	@(negedge clk);

	waddr = 5'h9;
	wdata = 7'h12;
	wcare = 7'b1111110;
	start_write = 1'b1;
	@(negedge clk);
	start_write = 1'b0;

	@(posedge ready);
	@(negedge clk);

	waddr = 5'ha;
	wdata = 7'h13;
	wcare = 7'b1111111;
	start_write = 1'b1;
	@(negedge clk);
	start_write = 1'b0;

	@(posedge ready);
	@(negedge clk);

	waddr = 5'hb;
	wdata = 7'h60;
	wcare = 7'b1110000;
	start_write = 1'b1;
	@(negedge clk);
	start_write = 1'b0;

	@(posedge ready);
	@(negedge clk);

	waddr = 5'hc;
	wdata = 7'h7f;
	wcare = 7'b1111111;
	start_write = 1'b1;
	@(negedge clk);
	start_write = 1'b0;

	@(posedge ready);
	@(negedge clk);

	lookup_data = 7'h12;
	@(negedge clk);
	lookup_data = 7'h13;
	@(negedge clk);
		if (match_lines !== (1<<9)) fail = 1'b1;
	lookup_data = 7'h42;
	@(negedge clk);
		if (match_lines !== ((1<<9) | (1<<10))) fail = 1'b1;
	lookup_data = 7'h39;
	@(negedge clk);
		if (match_lines !== 0) fail = 1'b1;
	lookup_data = 7'h38;
	@(negedge clk);
		if (match_lines !== (1<<0)) fail = 1'b1;
	lookup_data = 7'h39;
	@(negedge clk);
		if (match_lines !== (1<<0)) fail = 1'b1;
	lookup_data = 7'h64;
	@(negedge clk);
		if (match_lines !== (1<<0)) fail = 1'b1;
	lookup_data = 7'h03;
	@(negedge clk);
		if (match_lines !== (1<<11)) fail = 1'b1;
	lookup_data = 7'h04;
	@(negedge clk);
		if (match_lines !== (1<<8'h1a)) fail = 1'b1;
	lookup_data = 7'h7f;
	@(negedge clk);
		if (match_lines !== 0) fail = 1'b1;
	@(negedge clk);
		if (match_lines !== (1<<12)) fail = 1'b1;
	@(negedge clk);
	@(negedge clk);

	if (fail) $display ("Mismatch - CAM lookup results not correct");
	else $display ("PASS");
	$stop();
	
end

always begin
	#100 clk = ~clk;
end

endmodule 