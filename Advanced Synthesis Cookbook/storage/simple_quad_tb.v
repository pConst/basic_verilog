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

// baeckler - 04-24-2007

module simple_quad_tb ();

parameter ADDR_WIDTH = 5;
parameter NUM_WORDS = 1 << ADDR_WIDTH;
parameter DATA_WIDTH = 32;

reg clk;
reg [ADDR_WIDTH-1:0] wraddr_a,wraddr_b,rdaddr_a,rdaddr_b;
reg [DATA_WIDTH-1:0] wrdat_a,wrdat_b;
reg we_a,we_b;
wire [DATA_WIDTH-1:0] rddat_a,rddat_b;

reg fail = 1'b0;

////////////////
// DUT
////////////////
simple_quad sq (
	.clk(clk),
	.wraddr_a(wraddr_a),
	.wraddr_b(wraddr_b),
	.wrdat_a(wrdat_a),
	.wrdat_b(wrdat_b),
	.we_a(we_a),
	.we_b(we_b), 
	.rdaddr_a(rdaddr_a),
	.rdaddr_b(rdaddr_b),
	.rddat_a(rddat_a),
	.rddat_b(rddat_b)
);
defparam sq .ADDR_WIDTH = ADDR_WIDTH;
defparam sq .DATA_WIDTH = DATA_WIDTH;

////////////////////
// Functional Model
////////////////////
reg [DATA_WIDTH-1:0] store [0:NUM_WORDS-1];
reg [NUM_WORDS-1:0] valid;
reg valid_rda, valid_rdb;

reg [ADDR_WIDTH-1:0] waar,wabr,raar,rabr;
reg [DATA_WIDTH-1:0] wdar,wdbr,rda,rdb;
reg wear,webr;

initial valid = 0;

always @(posedge clk) begin
	
	waar <= wraddr_a;
	wabr <= wraddr_b;
	wdar <= wrdat_a;
	wdbr <= wrdat_b;
	wear <= we_a;
	webr <= we_b;
	
	if (wear) begin
		store[waar] <= wdar;
		valid[waar] <= 1'b1;
	end
	if (webr) begin
		store[wabr] <= wdbr;
		valid[wabr] <= 1'b1;
	end

	raar <= rdaddr_a;
	rabr <= rdaddr_b;
	rda <= store[raar];
	rdb <= store[rabr];
	valid_rda <= valid[raar];
	valid_rdb <= valid[rabr];					 	
end

always @(posedge clk) begin
	#10 if (valid_rda && (rda !== rddat_a)) begin
		$display ("Mismatch on port A");
		fail = 1'b1;
	end
	if (valid_rdb && (rdb !== rddat_b)) begin
		$display ("Mismatch on port B");
		fail = 1'b1;
	end
end

////////////////////
// Test driver
////////////////////

initial begin
	clk = 0;
	rdaddr_a = 5'h0;
	rdaddr_b = 5'h0;
	#100000000 if (!fail) $display ("PASS");
	$stop();
end

reg [23:0] tmp_a,tmp_b;

always @(negedge clk) begin
	rdaddr_a = $random;
	rdaddr_b = $random;
	wraddr_a = $random;
	wraddr_b = $random;
	tmp_a = $random;
	tmp_b = $random;
	wrdat_a = {2'b0,wraddr_a,tmp_a};
	wrdat_b = {2'b0,wraddr_b,tmp_b};
	we_a = 1'b1;
	we_b = 1'b1;
end

always begin
	#100 clk = ~clk;
end

endmodule