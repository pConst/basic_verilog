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

// baeckler - 1-22-2009

module twenty_to_five_tb ();

parameter WORD_LEN = 16;

reg clk,arst;

reg [5*WORD_LEN-1:0] din = 0;
reg din_valid;
wire din_ready;

wire [20*WORD_LEN-1:0] middle;
wire middle_valid,middle_ready;

wire [5*WORD_LEN-1:0] dout;
wire dout_valid;
reg dout_ready;
	
five_to_twenty #(
	.WORD_LEN(WORD_LEN)
)
dut_5_20
(
	.clk,.arst,
	
	.din, 
	.din_valid,
	.din_ready,
	
	.dout(middle),
	.dout_ready(middle_ready),
	.dout_valid(middle_valid)		
);

twenty_to_five #(
	.WORD_LEN(WORD_LEN)
)
dut_20_5
(
	.clk,.arst,
	
	.din(middle),
	.din_valid(middle_valid),
	.din_ready(middle_ready),
	
	.dout,
	.dout_ready,
	.dout_valid
);

// readback + verify
reg fail = 0;
integer k;
reg [5*WORD_LEN-1:0] check;
reg [WORD_LEN-1:0] exp = 1;
always @(posedge clk) begin
	if (dout_valid & dout_ready) begin
		check = dout;
		for (k=0; k<5; k=k+1) begin
			if (check[WORD_LEN-1:0] != 0) begin
				if (exp != check[WORD_LEN-1:0]) begin
					$display ("Mismatch at time %d",$time);
					fail = 1;
				end
				exp = exp + 1;
			end
			check = check >> WORD_LEN;
		end
	end
end

reg last_din_valid, last_din_ready;
always @(posedge clk) begin
	last_din_valid <= din_valid;
	last_din_ready <= din_ready;
end

// test stimulus
integer n;
reg [WORD_LEN-1:0] tmp = 0;
always @(negedge clk) begin
	din_valid = $random;
	dout_ready = $random;
	if (last_din_valid & last_din_ready) begin
		for (n=0; n<5; n=n+1) begin
			tmp = tmp + 1;
			din = (din >> WORD_LEN) | (tmp << 4*WORD_LEN);	
		end
	end
end

initial begin
	clk = 0; 
	arst = 0;
	#1 arst = 1;
	@(negedge clk) arst = 0;
end

always begin
	#5 clk = ~clk;
end

endmodule
