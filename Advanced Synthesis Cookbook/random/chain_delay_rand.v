// Copyright 2008 Altera Corporation. All rights reserved.  
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

// baeckler - 03-28-2008
module chain_delay_rand 
(
	clk,rst,
	out_bit,
	out_bit_valid,

	//debug info
	cal_a,cal_b,
	adjusting
);

input clk,rst;
output reg out_bit,out_bit_valid;

output [3:0] cal_a, cal_b;
output adjusting;

wire a_wins,b_wins,valid;
wire [3:0] cal_a, cal_b;
wire adjusting;

// Dual carry chain delay lines
chain_delay_race dr
(
	.clk(clk),
	.rst(rst),
	.calibrate_a(cal_a),
	.calibrate_b(cal_b),
	.a_wins(a_wins),
	.b_wins(b_wins),
	.valid(valid)		
);

// Control logic to adjust delays for unstable behavior
chain_delay_adjust dm (
	.clk(clk),
	.rst(rst),
	.calibrate_a(cal_a),
	.calibrate_b(cal_b),
	.a_wins(a_wins),
	.b_wins(b_wins),
	.valid(valid),	
	.adjusting(adjusting),	
	.current_stats()
);

// output filter - to fix up duty imbalance
reg last_a,last_b,last_valid;
always @(posedge clk) begin
	if (rst) begin
		last_a <= 1'b0;
		last_b <= 1'b0;
		last_valid <= 1'b0;
		out_bit <= 0;
		out_bit_valid <= 0;
	end
	else begin
		out_bit_valid <= 1'b0;
		if (valid & !adjusting) begin
			
			if (!last_valid) begin
				last_a <= a_wins;
				last_b <= b_wins;
				last_valid <= 1'b1;
			end 
			else begin
				if ({last_a,last_b} > {a_wins,b_wins}) begin
					out_bit_valid <= 1'b1;
					out_bit <= 1'b1;
				end else if ({last_a,last_b} < {a_wins,b_wins}) begin
					out_bit_valid <= 1'b1;
					out_bit <= 1'b0;
				end
				last_valid <= 1'b0;
			end
		end	
	end
end

endmodule