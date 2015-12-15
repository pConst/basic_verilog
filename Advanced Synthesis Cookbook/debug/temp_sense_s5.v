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

`timescale 1 ps / 1 ps
// baeckler - 06-09-2011

module temp_sense_s5 (
	input clk, // ~50-100 MHz
	output reg [7:0] degrees_c,
	output reg [7:0] degrees_f	
);

//////////////////////////////////////////////

wire [7:0] tsd_out;
wire tsd_done;
reg tsd_clr = 1'b0;
reg tsd_clr_inv = 1'b0 /* synthesis preserve */;
wire tsd_clk;
reg tsd_ce = 1'b0 /* synthesis preserve */;
reg [7:0] raw_c = 8'd133;

// little clock divider
reg [11:0] tsd_cntr = 0 /* synthesis preserve */
	/* synthesis ALTERA_ATTRIBUTE = "-name SDC_STATEMENT \"create_clock -name {temp_sense_clock} -period 40.0 [get_keepers {*temp_sense*tsd_cntr\[11\]}]\" " */;
assign tsd_clk = tsd_cntr[11];
always @(posedge clk) tsd_cntr <= tsd_cntr + 1'b1;

reg [7:0] tsd_sched = 0 /* synthesis preserve */;
always @(posedge tsd_clk) begin
	tsd_sched <= tsd_sched + 1'b1;		
	tsd_clr <= (tsd_sched == 8'h01) ^ tsd_clr_inv;
	if (&tsd_sched) begin
		if (tsd_done && (~&tsd_out)) begin
			raw_c <= tsd_out ^ {1'b0,tsd_out[7:1]}; // grey code for crossing
		end
		else begin
			// sampling error - call it very cold
			raw_c <= 8'd133;
			
			// muck with the control polarity - it is programmable
			// and not super clear in the docs
			{tsd_ce,tsd_clr_inv} <= {tsd_ce,tsd_clr_inv} + 1'b1;
		end
	end
end

// WYS connection to sense diode ADC
stratixv_tsdblock tsd
(
	.clk(tsd_clk),
	.ce(tsd_ce),
	.clr(tsd_clr),
	.tsdcalo(tsd_out),
	.tsdcaldone(tsd_done)	
);

// this is ridiculous overkill, but better safe than unstable
reg [7:0] raw_c_meta = 8'h0 /* synthesis preserve */
		/* synthesis ALTERA_ATTRIBUTE = "-name SDC_STATEMENT \"set_false_path -to [get_keepers {*temp_sense*raw_c_meta\[*\]}]\" " */;
reg [7:0] raw_c_sync = 8'h0 /* synthesis preserve */;
always @(posedge clk) begin
	raw_c_meta <= raw_c;
	raw_c_sync <= raw_c_meta;
end

// convert back to decimal
reg [7:0] raw_c_dec = 0;
genvar i;
generate
for (i=0; i<8; i=i+1) begin : gry
	always @(posedge clk) begin
		raw_c_dec[i] <= ^raw_c_sync[7:i];	
	end
end
endgenerate

// convert valid samples to better format
initial degrees_c = 0;
initial degrees_f = 0;
always @(posedge clk) begin
	degrees_c <= raw_c_dec - 8'd133; // offset
	
	// F = C * 1.8 + 32
	// rounding off the fraction a little bit
	degrees_f <= {degrees_c, 1'b0}  - {2'b0,degrees_c [7:2]} + 
			{4'b0,degrees_c [7:4]} + 8'd32;
end

endmodule
