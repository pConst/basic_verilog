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

// baeckler - 02-23-2006

module pipe_equal_tb ();

reg [63:0] ra;
reg [63:0] rb;
reg clk,rst,fail;

initial begin
  ra = 0;
  rb = 0;
  fail = 0;
  clk = 0;
  rst = 0;
  #10 rst = 1;
  #10 rst = 0;

  #100000
  if (!fail) $display ("PASS");
  $stop();
end

wire eq;
reg [2:0] lag;

always @(posedge clk) begin
  lag <= (lag << 1) | (ra == rb);
end

pipe_equal p (.rst(rst),.clk(clk),.a(ra),.b(rb),.eq(eq));

always begin
  #100 clk = ~clk;
end

// make the inputs equal a lot of the time
always @(negedge clk) begin
  if ($random & 1'b1) begin
    ra = {$random,$random};
	rb = {$random,$random};  
  end
  else begin
	rb = ra;  
  end
end

// check it
always @(posedge clk) begin
  #10 if (lag[2] == 1'b1 || lag[2] == 1'b0) begin
	if (lag[2] != eq) begin
		$display ("Mismatch at time %d",$time);
		fail = 1;
	end
  end
end

endmodule
