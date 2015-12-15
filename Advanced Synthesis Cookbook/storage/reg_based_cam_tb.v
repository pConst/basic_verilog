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

// baeckler - 08-24-2007

module reg_based_cam_tb ();

parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 4;
parameter WORDS = (1<<ADDR_WIDTH);

reg clk,rst;
reg [ADDR_WIDTH-1:0] waddr;
reg [DATA_WIDTH-1:0] wdata,wcare;
reg wena;

reg [DATA_WIDTH-1:0] lookup_data;

wire [WORDS-1:0] match_lines;

reg_based_cam dut (
	.clk(clk),
	.rst(rst),
	.waddr(waddr),
	.wdata(wdata),
	.wcare(wcare),
	.wena(wena),
	.lookup_data(lookup_data),
	.match_lines(match_lines)
);

defparam dut .DATA_WIDTH = DATA_WIDTH;
defparam dut .ADDR_WIDTH = ADDR_WIDTH;

reg fail;

initial begin
  rst = 1'b1;
  clk = 0;
  wcare = 0;
  wdata = 0;
  wena = 0;
  lookup_data = 0;
  fail = 0;

  @(posedge clk);
  @(negedge clk);
  rst = 1'b0;

  // load some initial masks
  @(negedge clk);
  wdata = 32'h12340000;
  wcare = 32'hffff0000;
  waddr = 4'h0;
  wena = 1'b1;

  @(negedge clk);
  wdata = 32'h12345000;
  wcare = 32'hfffff000;
  waddr = 4'h1;
  wena = 1'b1;

  @(negedge clk);
  wdata = 32'habcd0000;
  wcare = 32'hffff0000;
  waddr = 4'h2;
  wena = 1'b1;

  @(negedge clk);
  wdata = 32'hef000000;
  wcare = 32'hfff00000;
  waddr = 4'h9;
  wena = 1'b1;

  @(negedge clk);
  wena = 1'b1;


  // sample reads
  @(negedge clk);
  lookup_data = 32'h12345abc;
  @(negedge clk);
		if (match_lines !== 16'h3) fail = 1'b1;
  lookup_data = 32'h12344abc;
  @(negedge clk);
		if (match_lines !== 16'h1) fail = 1'b1;
  lookup_data = 32'h55555555;
  @(negedge clk);
		if (match_lines !== 16'h0) fail = 1'b1;
  lookup_data = 32'habc12341;
  @(negedge clk);
  		if (match_lines !== 16'h0) fail = 1'b1;
  lookup_data = 32'habcd2341;
  @(negedge clk);
  		if (match_lines !== 16'h4) fail = 1'b1;
  lookup_data = 32'hef100000;
  @(negedge clk);
  		if (match_lines !== 16'h0) fail = 1'b1;
  lookup_data = 32'hef000000;
  @(negedge clk);
  		if (match_lines !== 16'h200) fail = 1'b1;
  lookup_data = 32'hef012000;
	@(negedge clk);
  		if (match_lines !== 16'h200) fail = 1'b1;
  
  @(negedge clk);
  if (fail) $display ("Mismatch - CAM lookup results not correct");
  else $display ("PASS");
  $stop();

end

always begin 
    #100 clk = ~clk;
end

endmodule