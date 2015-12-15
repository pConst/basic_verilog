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

module fifo_tb ();

parameter DAT_WIDTH = 8;
parameter ADDR_WIDTH = 4;

reg aclr;

wire [DAT_WIDTH-1:0] rd_dat;
reg rd_clk, rd_req;
wire rd_empty;
wire [ADDR_WIDTH:0] rd_used;

wire [DAT_WIDTH-1:0] wr_dat;
reg wr_clk,wr_req;
wire wr_full;
wire [ADDR_WIDTH:0] wr_used;

fifo f (
	aclr,

	rd_dat,
	rd_clk,
	rd_req,
	rd_empty,
	rd_used,

	wr_dat,
	wr_clk,
	wr_req,
	wr_full,
	wr_used
);

defparam f .SIMULATION = 1'b1;
defparam f .ADDR_WIDTH = ADDR_WIDTH;
defparam f .DAT_WIDTH = DAT_WIDTH; 

reg fail;

initial begin
	fail = 0;
	rd_clk = 0;
	wr_clk = 0;
	rd_req = 0;
	wr_req = 0;
	aclr = 1'b0;
	#5 
	aclr = 1'b1;
	#5
	rd_clk = 1;
	wr_clk = 1;
	#5
	rd_clk = 0;
	wr_clk = 0;
	#5
	rd_clk = 1;
	wr_clk = 1;
	#5
	rd_clk = 0;
	wr_clk = 0;
	#5
	rd_clk = 1;
	wr_clk = 1;
	#5
	aclr = 1'b0;
	rd_clk = 0;
	wr_clk = 0;
	#5
	rd_clk = 1;
	wr_clk = 1;

	#5
	rd_clk = 0;
	wr_clk = 0;
	#5
	rd_clk = 1;
	wr_clk = 1;

	#100000000 if (!fail) $display ("PASS");
	$stop();
end

// change the clock frequency

integer RD_PER = 50;
integer WR_PER = 50;
reg [2:0] tmp = 2'b00;
always begin
	#60000
		tmp = $random;
		RD_PER = tmp * 25 + 25;
	#60000
		WR_PER = tmp * 25 + 25;
end

always begin
	#(RD_PER) rd_clk = ~rd_clk;
end

always begin
	#(WR_PER) wr_clk = ~wr_clk;
end

//
// R/W randomly, stop to check used words
//
reg rd_req_ena = 1'b1;
reg wr_req_ena = 1'b1;
always @(negedge wr_clk) wr_req <= $random & rd_req_ena;
always @(negedge rd_clk) rd_req <= $random & wr_req_ena;

always begin 
	// disable IO
	#100000 @(negedge rd_clk) rd_req_ena = 1'b0;
	@(negedge wr_clk) wr_req_ena = 1'b0;
	
	// wait for it to stabilize
	@(posedge rd_clk);
	@(posedge wr_clk);

	@(posedge rd_clk);
	@(posedge wr_clk);

	@(posedge rd_clk);
	@(posedge wr_clk);

	@(posedge rd_clk);
	@(posedge wr_clk);

	@(posedge rd_clk);
	@(posedge wr_clk);

	// verify and re-enable
	if (wr_used != rd_used) begin
		$display ("Used words disagreement at time %d",$time);
		fail = 1'b1;
	end

	@(negedge rd_clk) rd_req_ena = 1'b1;
	@(negedge wr_clk) wr_req_ena = 1'b1;
	
end

//
// Test pattern write and verify
//	
wire [DAT_WIDTH-1:0] exp_dat;
reg [DAT_WIDTH-1:0] exp_stall;
test_pattern tst (.aclr(aclr),.clk(wr_clk),.ena(wr_req & !wr_full),.val(wr_dat));
	defparam tst .WIDTH = DAT_WIDTH;

test_pattern exp (.aclr(aclr),.clk(rd_clk),.ena(rd_req & !rd_empty),.val(exp_dat));
	defparam exp .WIDTH = DAT_WIDTH;

always @(posedge rd_clk) begin
	if (rd_req & !rd_empty) exp_stall <= exp_dat;
end

always @(posedge rd_clk) begin
	if (rd_req & !rd_empty) begin
		@(posedge rd_clk) #2
		if (exp_stall !== rd_dat) begin
			$display ("Data stream is not as expected time %d",$time);
			fail = 1'b1;
		end
	end
end

endmodule
