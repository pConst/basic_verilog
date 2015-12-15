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

module system_timer (
	input clk,rst,

	output reg [9:0] usecond_cntr,
	output reg [9:0] msecond_cntr,
	output reg [5:0] second_cntr,
	output reg [5:0] minute_cntr,
	output reg [4:0] hour_cntr,
	output reg [9:0] day_cntr,
		
	output reg usecond_pulse,
	output reg msecond_pulse,
	output reg second_pulse
);

parameter CLOCK_MHZ = 200;

reg [7:0] tick_cntr;
reg tick_cntr_max;

// review tick counter design if leaving this range
// initial assert (CLOCK_MHZ > 64 && CLOCK_MHZ < 250);

always @(posedge clk) begin
	if (rst) begin
		tick_cntr <= 0;
		tick_cntr_max <= 0;
	end
	else begin
		if (tick_cntr_max) tick_cntr <= 1'b0;
		else tick_cntr <= tick_cntr + 1'b1;
		tick_cntr_max <= (tick_cntr == (CLOCK_MHZ - 2'd2));
	end
end

/////////////////////////////////
// Count off 1000 us to form 1 ms
/////////////////////////////////
reg usecond_cntr_max;

always @(posedge clk) begin
	if (rst) begin
		usecond_cntr <= 0;
		usecond_cntr_max <= 0;
	end
	else if (tick_cntr_max) begin
		if (usecond_cntr_max) usecond_cntr <= 1'b0;
		else usecond_cntr <= usecond_cntr + 1'b1;
		usecond_cntr_max <= (usecond_cntr == 10'd998);
	end
end

/////////////////////////////////
// Count off 1000 ms to form 1 s
/////////////////////////////////
reg msecond_cntr_max;

always @(posedge clk) begin
	if (rst) begin
		msecond_cntr <= 0;
		msecond_cntr_max <= 0;
	end
	else if (usecond_cntr_max & tick_cntr_max) begin
		if (msecond_cntr_max) msecond_cntr <= 1'b0;
		else msecond_cntr <= msecond_cntr + 1'b1;
		msecond_cntr_max <= (msecond_cntr == 10'd998);
	end
end

/////////////////////////////////
// Count off 60s to form 1 m
/////////////////////////////////
reg second_cntr_max;

always @(posedge clk) begin
	if (rst) begin
		second_cntr <= 0;
		second_cntr_max <= 0;
	end
	else if (msecond_cntr_max & usecond_cntr_max & tick_cntr_max) begin
		if (second_cntr_max) second_cntr <= 1'b0;
		else second_cntr <= second_cntr + 1'b1;
		second_cntr_max <= (second_cntr == 6'd58);
	end
end

/////////////////////////////////
// Count off 60m to form 1hr
/////////////////////////////////
reg minute_cntr_max;

always @(posedge clk) begin
	if (rst) begin
		minute_cntr <= 0;
		minute_cntr_max <= 0;
	end
	else if (second_cntr_max & msecond_cntr_max & 
			usecond_cntr_max & tick_cntr_max) begin
		if (minute_cntr_max) minute_cntr <= 1'b0;
		else minute_cntr <= minute_cntr + 1'b1;
		minute_cntr_max <= (minute_cntr == 6'd58);
	end
end

/////////////////////////////////
// Count off 24h to form 1day
/////////////////////////////////
reg hour_cntr_max;

always @(posedge clk) begin
	if (rst) begin
		hour_cntr <= 0;
		hour_cntr_max <= 0;
	end
	else if (minute_cntr_max & second_cntr_max & msecond_cntr_max &
			 usecond_cntr_max & tick_cntr_max) begin
		if (hour_cntr_max) hour_cntr <= 1'b0;
		else hour_cntr <= hour_cntr + 1'b1;
		hour_cntr_max <= (hour_cntr == 5'd22);
	end
end

/////////////////////////////////
// Count off 1024 days then wrap
/////////////////////////////////
always @(posedge clk) begin
	if (rst) begin
		day_cntr <= 0;
	end
	else if (hour_cntr_max & minute_cntr_max & second_cntr_max & msecond_cntr_max &
			 usecond_cntr_max & tick_cntr_max) begin
		day_cntr <= day_cntr + 1'b1;
	end
end

/////////////////////////////////////
// Filtered output pulses 
/////////////////////////////////////
always @(posedge clk) begin
	if (rst) begin
		usecond_pulse <= 1'b0;
		msecond_pulse <= 1'b0;
		second_pulse <= 1'b0;
	end
	else begin
		usecond_pulse <= tick_cntr_max;
		msecond_pulse <= tick_cntr_max & usecond_cntr_max;
		second_pulse <= tick_cntr_max & msecond_cntr_max & usecond_cntr_max;
	end
end			

endmodule
