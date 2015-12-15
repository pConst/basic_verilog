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

module chain_delay_adjust
(
	clk,rst,
	calibrate_a,
	calibrate_b,
	a_wins,
	b_wins,
	valid,
	adjusting,
	current_stats
);

parameter CALIBRATE_BITS = 4;

input clk,rst;
output [CALIBRATE_BITS-1:0] calibrate_a;
output [CALIBRATE_BITS-1:0] calibrate_b;
input a_wins,b_wins,valid;
output [15:0] current_stats;
output reg adjusting;

reg [2*CALIBRATE_BITS-1:0] current_setting;
reg [7:0] trials,a_tally,b_tally;
reg [15:0] current_stats;

assign {calibrate_a, calibrate_b} = current_setting;

reg [2:0] state /* synthesis preserve */;
parameter 
		ST_START = 3'h0,
		ST_COUNT = 3'h1,
		ST_CHECK = 3'h2,
		ST_CHECK_B = 3'h3,
		ST_ADJUST = 3'h4,
		ST_OPERATE = 3'h5;

always @(posedge clk) begin
	if (rst) begin
		state <= ST_START;
		a_tally <= 0;
		b_tally <= 0;
		trials <= 0;
		current_setting <= 0;
		current_stats <= 0;
		adjusting <= 1'b1;
	end
	else begin
		case (state)
			ST_START: begin
				state <= ST_COUNT;
			end
			ST_COUNT: begin
				if (valid & a_wins) a_tally <= a_tally + 1'b1;
				if (valid & b_wins) b_tally <= b_tally + 1'b1;
				if (valid) trials <= trials + 1'b1;
				if (&trials) state <= ST_CHECK;
			end
			ST_CHECK : begin
				current_stats <= {a_tally,b_tally};
				a_tally <= 0;
				b_tally <= 0;
				trials <= 0;
				state <= ST_CHECK_B;
			end
			ST_CHECK_B : begin
				if ((current_stats[15:8] != 8'hff &&
					current_stats[15:8] != 8'h00) ||
					(current_stats[7:0] != 8'hff &&
					current_stats[7:0] != 8'h00))
				begin
					state <= ST_OPERATE;
				end
				else begin
					state <= ST_ADJUST;
				end
			end
			ST_ADJUST : begin
				adjusting <= 1'b1;
				current_setting <= current_setting + 1'b1;
				state <= ST_COUNT;
			end
			ST_OPERATE : begin
				adjusting <= 1'b0;
				state <= ST_COUNT;
			end
		endcase
	end
end

endmodule