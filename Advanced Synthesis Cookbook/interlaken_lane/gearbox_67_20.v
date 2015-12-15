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
// baeckler - 09-19-2008
// Convert a 67 bit stream to a 20 bit stream
// Note : requires a specific din_valid schedule to avoid overflow.
//
module gearbox_67_20 (
	input clk,arst,
	input [66:0] din,
	input din_valid,
	output [19:0] dout
);

// worst case : 19 bits surplus, and 67 arriving = 86 bits

reg [85:0] storage;
reg [4:0] wr_ptr /* synthesis preserve */;
reg [4:0] next_wr_ptr;
reg [85:0] aligned_din;

//////////////////////////////////////////////////////
// This is a debug only sanity check
//////////////////////////////////////////////////////
// synthesis translate off
reg [85:0] aligned_din_mask;
reg [85:0] storage_mask;

always @(*) begin
	case (wr_ptr) 
		5'd19 : aligned_din_mask = {67'h7ffffffffffffffff,19'b0};
		5'd18 : aligned_din_mask = {1'b0,67'h7ffffffffffffffff,18'b0};
		5'd17 : aligned_din_mask = {2'b0,67'h7ffffffffffffffff,17'b0};
		5'd16 : aligned_din_mask = {3'b0,67'h7ffffffffffffffff,16'b0};
		5'd15 : aligned_din_mask = {4'b0,67'h7ffffffffffffffff,15'b0};
		5'd14 : aligned_din_mask = {5'b0,67'h7ffffffffffffffff,14'b0};
		5'd13 : aligned_din_mask = {6'b0,67'h7ffffffffffffffff,13'b0};
		5'd12 : aligned_din_mask = {7'b0,67'h7ffffffffffffffff,12'b0};
		5'd11 : aligned_din_mask = {8'b0,67'h7ffffffffffffffff,11'b0};
		5'd10 : aligned_din_mask = {9'b0,67'h7ffffffffffffffff,10'b0};
		5'd9 : aligned_din_mask = {10'b0,67'h7ffffffffffffffff,9'b0};
		5'd8 : aligned_din_mask = {11'b0,67'h7ffffffffffffffff,8'b0};
		5'd7 : aligned_din_mask = {12'b0,67'h7ffffffffffffffff,7'b0};
		5'd6 : aligned_din_mask = {13'b0,67'h7ffffffffffffffff,6'b0};
		5'd5 : aligned_din_mask = {14'b0,67'h7ffffffffffffffff,5'b0};
		5'd4 : aligned_din_mask = {15'b0,67'h7ffffffffffffffff,4'b0};
		5'd3 : aligned_din_mask = {16'b0,67'h7ffffffffffffffff,3'b0};
		5'd2 : aligned_din_mask = {17'b0,67'h7ffffffffffffffff,2'b0};
		5'd1 : aligned_din_mask = {18'b0,67'h7ffffffffffffffff,1'b0};
		5'd0 : aligned_din_mask = {19'b0,67'h7ffffffffffffffff};
		default : aligned_din_mask = 0; // could be X for QOR
	endcase
end

always @(posedge clk or posedge arst) begin
	if (arst) begin
		storage_mask <= 0;
	end
	else begin
		if (din_valid) begin
			storage_mask <= (storage_mask << 7'd20) | aligned_din_mask;			
			if (|((storage_mask << 7'd20) & aligned_din_mask))
				$display ("Warning - TX gearbox lost one or more bits");
		end
		else 
			storage_mask <= (storage_mask << 7'd20);
	end
end

wire [19:0] dout_mask;
assign dout_mask = storage_mask [85:85-19];

reg [4:0] flushing;
always @(posedge clk or posedge arst) begin
	if (arst) flushing <= 5'b11111;
	else if (|flushing) flushing <= flushing - 1'b1;
end 

always @(posedge clk) begin
	#1 if (din_valid & ~(din[65] ^ din[64]) & (~|flushing)) begin
		// the data in to the gearbox should have 10 or 01 framing bits
		// possibly ignoring some pipe flush at reset time
		$display ("Warning - TX gearbox din is not properly framed");
	end
	if (~&dout_mask & (~|flushing)) begin
		// sim only check for gearbox sending out "missing" bits
		// possibly ignoring some pipe flush
		$display ("Warning - some TX gearbox dout bits are invalid");
	end
end
		
// synthesis translate on
//////////////////////////////////////////////////////
// End of sanity check
//////////////////////////////////////////////////////

assign dout = storage [85:85-19];

// semi barrel shifter to align incomming data words
always @(*) begin
	case (wr_ptr) 
		5'd19 : aligned_din = {din,19'b0};
		5'd18 : aligned_din = {1'b0,din,18'b0};
		5'd17 : aligned_din = {2'b0,din,17'b0};
		5'd16 : aligned_din = {3'b0,din,16'b0};
		5'd15 : aligned_din = {4'b0,din,15'b0};
		5'd14 : aligned_din = {5'b0,din,14'b0};
		5'd13 : aligned_din = {6'b0,din,13'b0};
		5'd12 : aligned_din = {7'b0,din,12'b0};
		5'd11 : aligned_din = {8'b0,din,11'b0};
		5'd10 : aligned_din = {9'b0,din,10'b0};
		5'd9 : aligned_din = {10'b0,din,9'b0};
		5'd8 : aligned_din = {11'b0,din,8'b0};
		5'd7 : aligned_din = {12'b0,din,7'b0};
		5'd6 : aligned_din = {13'b0,din,6'b0};
		5'd5 : aligned_din = {14'b0,din,5'b0};
		5'd4 : aligned_din = {15'b0,din,4'b0};
		5'd3 : aligned_din = {16'b0,din,3'b0};
		5'd2 : aligned_din = {17'b0,din,2'b0};
		5'd1 : aligned_din = {18'b0,din,1'b0};
		5'd0 : aligned_din = {19'b0,din};
		default : aligned_din = 0; // could be X for QOR
	endcase
end

// figure out where the next word will need to be loaded
always @(*) begin
	case (wr_ptr) 
		5'd19 : next_wr_ptr = 5'd12; 	// residue 0 + 67 new = 7 leftover
		5'd18 : next_wr_ptr = 5'd11; 	// residue 1 + 67 new = 8 leftover
		5'd17 : next_wr_ptr = 5'd10; 	// residue 2 + 67 new = 9 leftover
		5'd16 : next_wr_ptr = 5'd9; 	// residue 3 + 67 new = 10 leftover
		5'd15 : next_wr_ptr = 5'd8; 	// residue 4 + 67 new = 11 leftover
		5'd14 : next_wr_ptr = 5'd7; 	// residue 5 + 67 new = 12 leftover
		5'd13 : next_wr_ptr = 5'd6; 	// residue 6 + 67 new = 13 leftover
		5'd12 : next_wr_ptr = 5'd5; 	// residue 7 + 67 new = 14 leftover
		5'd11 : next_wr_ptr = 5'd4; 	// residue 8 + 67 new = 15 leftover
		5'd10 : next_wr_ptr = 5'd3; 	// residue 9 + 67 new = 16 leftover
		5'd9 : next_wr_ptr = 5'd2;	 	// residue 10 + 67 new = 17 leftover
		5'd8 : next_wr_ptr = 5'd1;		// residue 11 + 67 new = 18 leftover
		5'd7 : next_wr_ptr = 5'd0;		// residue 12 + 67 new = 19 leftover
		5'd6 : next_wr_ptr = 5'd19; 	// residue 13 + 67 new = 0 leftover
		5'd5 : next_wr_ptr = 5'd18; 	// residue 14 + 67 new = 1 leftover
		5'd4 : next_wr_ptr = 5'd17; 	// residue 15 + 67 new = 2 leftover
		5'd3 : next_wr_ptr = 5'd16; 	// residue 16 + 67 new = 3 leftover
		5'd2 : next_wr_ptr = 5'd15; 	// residue 17 + 67 new = 4 leftover
		5'd1 : next_wr_ptr = 5'd14; 	// residue 18 + 67 new = 5 leftover
		5'd0 : next_wr_ptr = 5'd13; 	// residue 19 + 67 new = 6 leftover		
		default : next_wr_ptr = 5'd0;
	endcase
end

always @(posedge clk or posedge arst) begin
	if (arst) begin
		wr_ptr <= 7'd19;
		storage <= 0;
	end
	else begin
		if (din_valid) begin
			storage <= (storage << 7'd20) | aligned_din;
			wr_ptr <= next_wr_ptr;
		end
		else begin
			storage <= (storage << 7'd20);			
		end
	end
end

endmodule