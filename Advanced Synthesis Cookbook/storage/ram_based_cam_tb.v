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

module ram_based_cam_tb ();


parameter DATA_BLOCKS = 5;  // number of blocks of 7 bits
parameter ADDR_WIDTH = 5; 

localparam DATA_PER_BLOCK = 7;   // Note : affects write latency
localparam DATA_WIDTH = DATA_BLOCKS * DATA_PER_BLOCK;
localparam WORDS = (1 << ADDR_WIDTH);

reg clk,rst,start_write;
reg [ADDR_WIDTH-1:0] waddr;
reg [DATA_WIDTH-1:0] wdata,wcare;
reg [DATA_WIDTH-1:0] lookup_data;
wire [WORDS-1:0] match_lines;
wire ready;

ram_based_cam dut (
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
	defparam dut .DATA_BLOCKS = DATA_BLOCKS;
	defparam dut .ADDR_WIDTH = ADDR_WIDTH;

reg fail;

initial begin
	clk = 0;
	rst = 0;
	wdata = 0;
	wcare = 0;
	lookup_data = 0;
	start_write = 0;
	waddr = 0;
	fail = 0;
		
	///////////////////////////////////////////
	// reset and wait for initialization to 0
	rst = 1;
	@(posedge clk);
	@(negedge clk);
	rst = 0;
	@(posedge ready);

	///////////////////////////////////////////
	// make a little routing table
	//
	// e3.d2.12.** to addr 0
	// 13.d2.**.** to addr 5
	// 01.05.0a.ff to addr 7
	// 13.d2.01.** to addr 31
	//
	@(negedge clk);
	waddr = 0;
	wdata = 35'h0e3d21200;
	wcare = 35'hfffffff00;
	start_write = 1'b1;
	@(negedge clk);
	start_write = 1'b0;
	@(posedge ready);
	
	@(negedge clk);
	waddr = 5;
	wdata = 35'h013d20000;
	wcare = 35'hfffff0000;
	start_write = 1'b1;
	@(negedge clk);
	start_write = 1'b0;
	@(posedge ready);
	
	@(negedge clk);
	waddr = 7;
	wdata = 35'h001050aff;
	wcare = 35'hfffffffff;
	start_write = 1'b1;
	@(negedge clk);
	start_write = 1'b0;
	@(posedge ready);
		
	@(negedge clk);
	waddr = 31;
	wdata = 35'h013d20100;
	wcare = 35'hfffffff00;
	start_write = 1'b1;
	@(negedge clk);
	start_write = 1'b0;
	@(posedge ready);
	
	///////////////////////////////////////////
	// burst of packets to lookup
	//	 this isn't elegant, but need a sanity check.	
	@(negedge clk);
	lookup_data = 35'h001050aff; // @ 7
	@(negedge clk);
	lookup_data = 35'h013d21234; // @ 5
	@(negedge clk);
		if (match_lines !== (1<<7)) fail = 1;
	lookup_data = 35'h013d20134; // @ 5 and 31
	@(negedge clk);
		if (match_lines !== (1<<5)) fail = 1;
	lookup_data = 35'h0f3d21212; // @ nowhere
	@(negedge clk);
	lookup_data = 35'h0e3d21212; // @ 0
		if (match_lines !== ((1<<5) | (1<<31))) fail = 1;
	@(negedge clk);
		if (match_lines !== 0) fail = 1;
	@(negedge clk);
		if (match_lines !== 1) fail = 1;
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