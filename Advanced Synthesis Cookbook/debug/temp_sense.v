// Copyright 2010 Altera Corporation. All rights reserved.  
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
// baeckler - 04-24-2009

module temp_sense (
	input clk,arst, // < 80 MHz
	output reg [7:0] degrees_c,
	output reg [7:0] degrees_f,
	output reg [11:0] degrees_f_bcd,
	output reg fresh_sample,failed_sample
);

parameter OFFSET_DEGREES = 8'd133;

/////////////////////////////////////
// slow down the clock by 2 for the TSD block
/////////////////////////////////////

reg half_clk;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		half_clk <= 1'b0;
	end
	else begin
		half_clk <= ~half_clk;
	end
end

/////////////////////////////////////
// temp sense block
/////////////////////////////////////

reg tsd_clr;
wire [7:0] tsd_out;
wire tsd_done;

stratixiv_tsdblock tsd
(
	.clk(half_clk),
	.ce(1'b1),
	.clr(tsd_clr),
	.tsdcalo(tsd_out),
	.tsdcaldone(tsd_done)
	
	// Temp sense is still kind of an "engineering only"
	// feature - the sim model appears to be a little out of sync.
	//
	// synthesis translate off
	,
	.offset(),
	.testin(),
	.fdbkctrlfromcore(),
	.compouttest(),
	.tsdcompout(),
	.offsetout()
	// synthesis translate on
);

/////////////////////////////////////
// sampling schedule
/////////////////////////////////////

reg [19:0] timer;
reg timer_max;
reg [7:0] raw_degrees_c;

always @(posedge clk or posedge arst) begin
	if (arst) begin
		timer <= 0;
		timer_max <= 1'b0;
		fresh_sample <= 1'b0;
		failed_sample <= 1'b0;
		raw_degrees_c <= 0;
	end
	else begin
		fresh_sample <= 1'b0;
		failed_sample <= 1'b0;
		timer_max <= (timer == 20'hffffe);
		tsd_clr <= (timer [19:4] == 16'h0000);
		if (timer_max) timer <= 0;
		else timer <= timer + 1'b1;
		if (timer_max) begin
			if (tsd_done) begin
				raw_degrees_c <= tsd_out;
				fresh_sample <= 1'b1;
			end				
			else failed_sample <= 1'b1;
		end		
		degrees_c <= raw_degrees_c - OFFSET_DEGREES;
	end	
end

wire [8:0] degc_x2 = {degrees_c,1'b0};
wire [8:0] degc_x14 = {2'b0,degrees_c[7:2]};

always @(posedge clk or posedge arst) begin
	if (arst) begin
		degrees_f <= 0;
	end
	else begin
		// rough C to F convert
		degrees_f <= degc_x2 - degc_x14 + 9'd32;
	end
end

localparam 
	ST_START = 2'h0,
	ST_HUND = 2'h1,
	ST_TENS = 2'h2,
	ST_ONES = 2'h3;

reg [1:0] bcd_state /* synthesis preserve */;

reg [7:0] working;
reg [3:0] working_hund,working_tens;

always @(posedge clk or posedge arst) begin
	if (arst) begin
		degrees_f_bcd <= 0;
		bcd_state <= ST_START;
	end
	else begin
		case (bcd_state) 
			ST_START : begin
				working <= degrees_f;
				working_hund <= 0;
				working_tens <= 0;
				bcd_state <= ST_HUND;
			end
			ST_HUND : begin
				if (working >= 8'd100) begin
					working <= working - 8'd100;
					working_hund <= working_hund + 1'b1;
				end	
				else bcd_state <= ST_TENS;
			end
			ST_TENS : begin
				if (working >= 8'd10) begin
					working <= working - 8'd10;
					working_tens <= working_tens + 1'b1;
				end	
				else bcd_state <= ST_ONES;
			end
			ST_ONES : begin
				degrees_f_bcd <= 
					{working_hund,
					working_tens,
					working[3:0]};
				bcd_state <= ST_START;
			end
		endcase				
	end	
end

endmodule
