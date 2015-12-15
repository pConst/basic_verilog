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

// baeckler - 09-25-2008

module lane_rx_crc (
	input clk,arst,
	input [63:0] din,
	input din_fresh,
	input diag_word,
	output reg crc_error
);

// input registers
reg [63:0] din_r;
reg last_din_fresh,last2_din_fresh;
reg last_diag_word;
reg [31:0] expect_crc;

always @(posedge clk or posedge arst) begin
	if (arst) begin
		din_r <= 0;
		last_din_fresh <= 0;
		last2_din_fresh <= 0;
		last_diag_word <= 0;
		expect_crc <= 0;
	end
	else begin
		if (din_fresh) begin
			if (last_diag_word) begin
				din_r <= din & 64'hffffffff00000000;
				expect_crc <= din[31:0];
			end
			else din_r <= din;
		end
		last_din_fresh <= din_fresh;
		last2_din_fresh <= last_din_fresh;
		last_diag_word <= diag_word;		
	end
end

reg [3:0] check_schedule;
always @(posedge clk or posedge arst) begin
	if (arst) check_schedule <= 0;
	else check_schedule <= {check_schedule[2:0],last_diag_word & din_fresh};
end

reg [31:0] crc;

// CRC XOR networks
wire [31:0] din_r_evolved, crc_evolved;
crc32c_dat64_only cc0 (.d(din_r),.crc_out(din_r_evolved));
crc32c_zer64 cc1 (.c(crc),.crc_out(crc_evolved));

// Register the XOR outs
reg [31:0] din_r_evolved_r, crc_evolved_r;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		din_r_evolved_r <= 0;
		crc_evolved_r <= 0;
	end
	else begin
		din_r_evolved_r <= din_r_evolved;
		crc_evolved_r <= crc_evolved;
	end
end

// CRC register
always @(posedge clk or posedge arst) begin
	if (arst) crc <= 0;
	else begin
		if (check_schedule[2]) crc <= 32'hffffffff;
		else if (last2_din_fresh) crc <= din_r_evolved_r ^ crc_evolved_r;
	end
end

// Computed CRC should be the expected chunk from diag word negated
reg crc_match;
always @(posedge clk or posedge arst) begin
	if (arst) crc_match <= 0;
	else crc_match <= &(crc ^ expect_crc);
end


always @(posedge clk or posedge arst) begin
	if (arst) crc_error <= 0;
	else crc_error <= (!crc_match & check_schedule[3]);
end

endmodule