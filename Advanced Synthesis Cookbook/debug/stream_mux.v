// Copyright 2009 Altera Corporation. All rights reserved.  
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

module stream_mux #(
	parameter WIDTH = 8
)
(	
	input clk, arst,
	
	input [WIDTH-1:0] din_a,
	output din_ready_a,
	input din_valid_a,
	input reporting_a,

	input [WIDTH-1:0] din_b,
	output din_ready_b,
	input din_valid_b,
	input reporting_b,

	input start_harvest,
	output reporting,
	input dout_ready,
	output dout_valid,
	output [WIDTH-1:0] dout
);

reg chan_ena;
reg chan_sel;

////////////////////////////////////////////
// MUX A and B ports according to state
////////////////////////////////////////////

assign din_ready_a = chan_ena & !chan_sel & dout_ready;
assign din_ready_b = chan_ena & chan_sel & dout_ready;
assign dout_valid = (chan_sel ? din_valid_b : din_valid_a);
assign dout = (chan_sel ? din_b : din_a);

////////////////////////////////////////////
// to harvest
//   take report from A then B
//   wait for next harvest
////////////////////////////////////////////

reg [2:0] state /* synthesis preserve */;
localparam ST_IDLE = 0,
		ST_WAIT_A = 1,
		ST_WAIT_NOTA = 2,
		ST_WAIT_B = 3,
		ST_WAIT_NOTB = 4;

always @(posedge clk or posedge arst) begin
	if (arst) begin
		state <= ST_IDLE;
		chan_sel <= 0;
		chan_ena <= 0;
	end
	else begin
		case (state) 
			ST_IDLE : begin
					chan_sel <= 0;
					chan_ena <= 0;
					if (start_harvest) state <= ST_WAIT_A;					
				end
			ST_WAIT_A : begin
					chan_ena <= 1'b1;
					if (reporting_a) state <= ST_WAIT_NOTA;
				end
			ST_WAIT_NOTA : begin
					if (!reporting_a) state <= ST_WAIT_B;
				end
			ST_WAIT_B : begin
					chan_sel <= 1'b1;
					if (reporting_b) state <= ST_WAIT_NOTB;
				end
			ST_WAIT_NOTB : begin
					if (!reporting_b) state <= ST_IDLE;
				end
		endcase
	end			
end	

assign reporting = (state != ST_IDLE);

endmodule