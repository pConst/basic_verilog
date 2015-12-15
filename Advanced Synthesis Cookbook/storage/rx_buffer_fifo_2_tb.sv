// Copyright 2011 Altera Corporation. All rights reserved.  
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

module rx_buffer_fifo_2_tb ();

parameter WIDTH = 16;

reg clk = 0,arst = 0;
reg [WIDTH-1:0] din;
wire [WIDTH-1:0] dout;
reg din_valid;
wire dout_valid;
reg dout_wait;
wire overflow;
reg [WIDTH-1:0] junk = 0;

rx_buffer_fifo_2 dut 
(
	.clk,
	.arst,
	.din(din_valid ? din : junk),
	.din_valid,		// pulse marking fresh input data 
	.dout_wait,		// wait means I don't want to see dout_valid yet
	.dout,
	.dout_valid,		// pulse marking fresh output data
	.overflow		// overflow with loss of data
);
defparam dut .WIDTH = WIDTH;

always begin
	#5 clk = ~clk;
end

initial begin
	#1 arst = 1'b1;
	@(negedge clk) arst = 0;
end

reg [1:0] rbits = 0;
reg fail = 0;
reg [WIDTH-1:0] expected_dout;

always @(posedge clk or posedge arst) begin
	if (arst) begin
		din <= 0;
		expected_dout <= 1;
		din_valid <= 0;
		dout_wait <= 0;
	end
	else begin
		rbits <= $random;
		junk <= $random;
		
		// provide data on the input side
		if (rbits[0]) begin
			din_valid <= 1'b1;
			din <= din + 1'b1;
		end
		else begin
			din_valid <= 1'b0;			
		end
		dout_wait <= rbits[1];
		
		// grab data on the output side
		if (!overflow & !dout_wait & dout_valid) begin
			if (dout !== expected_dout) begin
				$display ("Mismatch at time %d",$time);
				fail = 1;
			end
			expected_dout <= expected_dout + 1'b1;
		end
	end	
end

// this is obviously only OK for simulation
always @(posedge clk) begin
	#2 if (overflow) begin
		arst = 1'b1;
		@(negedge clk) arst = 1'b0;
	end	
end

endmodule