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

// baeckler - 09-24-2008

module lane_tx_crc (
	input clk, arst,
	input [63:0] din,
	input previous_din_ack,
	input final_din_of_burst,
	input [1:0] status_bits, // to be embedded in the diagnostic word
	output reg [31:0] crc
);

reg [63:0] din_r;
reg din_r_fresh;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		din_r <= 0;
		din_r_fresh <= 1'b0;
	end
	else begin
		if (previous_din_ack) din_r <= din;		
	end
end

wire [63:0] diag = {6'b011001,24'h000000,status_bits,32'h00000000};

// CRC XOR networks
wire [31:0] evolved_din;
crc32c_dat64_only cc0 (.d(din_r),.crc_out(evolved_din));

// this one will minimize heavily
wire [31:0] evolved_diag;
crc32c_dat64_only cc1 (.d(diag),.crc_out(evolved_diag));

wire [31:0] evolved_prev;
crc32c_zer64 cc2 (.c(crc),.crc_out(evolved_prev));

reg [31:0] evolved_din_r, evolved_diag_r, evolved_prev_r;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		evolved_din_r <= 0;
		evolved_diag_r <= 0;
		evolved_prev_r <= 0;
	end
	else begin
		evolved_din_r <= evolved_din;
		evolved_diag_r <= evolved_diag;
		evolved_prev_r <= evolved_prev;
	end
end

// this is a short cut to get 2 evolutions away from DIN faster
wire [31:0] double_din;
crc32c_zer64_flat cc3 (.c(evolved_din_r ^ evolved_prev_r),.crc_out(double_din));

reg [31:0] double_din_r;
always @(posedge clk or posedge arst) begin
	if (arst) double_din_r <= 0;
	else double_din_r <= double_din;
end

reg [9:0] schedule;
wire [9:0] schedule_shl = {schedule[8:0],1'b0};
always @(posedge clk or posedge arst) begin
	if (arst) schedule <= 10'b1;
	else begin
		if (schedule[0] & previous_din_ack) schedule <= schedule_shl;
		if (schedule[1]) schedule <= schedule_shl; // din_r is valid
		if (schedule[2]) begin // evolved din_r is valid
			if (final_din_of_burst) schedule <= schedule_shl; 
			else schedule <= 10'b1;
		end
		if (schedule[3]) schedule <= schedule_shl; // double_din_r valid
		if (schedule[4]) schedule <= schedule_shl; // 
		if (schedule[5]) schedule <= schedule_shl; // 
		if (schedule[6]) schedule <= schedule_shl; // wait for CRC to send
		if (schedule[7]) schedule <= schedule_shl; // 
		if (schedule[8]) schedule <= schedule_shl; // start next crc
		if (schedule[9]) schedule <= 10'b01;  		
	end		
end

// CRC register
always @(posedge clk or posedge arst) begin
	if (arst) crc <= 0;
	else begin
		if (schedule[8]) crc <= 32'hf8dfefd0; 
			// This magic constant is the CRC of the 
			// sync word, scrambler state (blanked) and skip word
			// starting from all ones.
		else if (schedule[2]) crc <= (evolved_prev_r ^ evolved_din_r);
		else if (schedule[3]) crc <= (double_din_r ^ evolved_diag_r);
	end
end

endmodule 
