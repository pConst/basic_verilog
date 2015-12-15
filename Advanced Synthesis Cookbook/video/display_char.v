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

// baeckler - 03-13-2009
// little state machine to scanout a binary
// font character to raster writes
 
module display_char #(
	parameter RASTER_ADDR_WIDTH = 18,
	parameter RASTER_LINE_WIDTH = 640,
	parameter RASTER_DATA_WIDTH = 16,
	parameter FONT_DATA_WIDTH = 24,
	parameter FONT_HEIGHT = 27,
	parameter FONT_ADDR_WIDTH = 11	
)(

	input clk,arst,
	
	input [9:0] raster_x,
	input [9:0] raster_y,
	input [7:0] char_select,
	input [RASTER_DATA_WIDTH-1:0] wdata,
	output busy,
	input start_write,
	
	output reg [RASTER_ADDR_WIDTH-1:0] raster_addr,
	output reg [RASTER_DATA_WIDTH-1:0] raster_data,
	output reg raster_we	
);

`include "log2.inc"
localparam PIXEL_CNT_WIDTH = log2(FONT_DATA_WIDTH);
localparam LINE_CNT_WIDTH = log2(FONT_HEIGHT);

function [FONT_DATA_WIDTH-1:0] reverse_font;
    input [FONT_DATA_WIDTH-1:0] din;
    integer n;
    for (n=0; n<FONT_DATA_WIDTH; n=n+1) begin : foo
        reverse_font[n] = din[FONT_DATA_WIDTH-1-n];
    end
endfunction

/////////////////////////////////////////
// Convert user input to raw addr
/////////////////////////////////////////

reg [RASTER_ADDR_WIDTH-1:0] raster_start;
reg [FONT_ADDR_WIDTH-1:0] char_start;
reg start_write_d; 

always @(posedge clk or posedge arst) begin
	if (arst) begin
		char_start <= 0;
		raster_start <= 0;	
		start_write_d <= 0;
	end
	else begin
		char_start <= char_select * FONT_HEIGHT;
		raster_start <= raster_x + raster_y * RASTER_LINE_WIDTH;
		start_write_d <= start_write;
	end
end

/////////////////////////////////////////
// Font ROM
/////////////////////////////////////////

reg [FONT_ADDR_WIDTH-1:0] font_addr;
wire [FONT_DATA_WIDTH-1:0] font_data;

font_rom fr (
    .clk(clk),
    .addr(font_addr),
    .out(font_data)
);

/////////////////////////////////////////
// Index into the font data
/////////////////////////////////////////

reg load_start_address;
reg [PIXEL_CNT_WIDTH-1:0] pixel_idx;
reg [LINE_CNT_WIDTH-1:0] char_line;
reg addr_valid, addr_valid_d, addr_valid_dd, char_complete;

// these are offset slightly to cancel the 
// font ROM latency
wire pixel_idx_max = (pixel_idx == (FONT_DATA_WIDTH-1));
wire pixel_idx_short = (pixel_idx == (FONT_DATA_WIDTH-3));

always @(posedge clk or posedge arst) begin
	if (arst) begin
		font_addr <= 0;
		pixel_idx <= 0;
		char_line <= 0;
		addr_valid <= 1'b0;
		addr_valid_d <= 1'b0;
		addr_valid_dd <= 1'b0;
		char_complete <= 1'b1;
	end	
	else begin
		if (load_start_address) begin
			font_addr <= char_start;
			pixel_idx <= FONT_DATA_WIDTH-4'd2;			
			char_line <= 0;
			addr_valid <= 1'b1;
			addr_valid_d <= 1'b0;
			addr_valid_dd <= 1'b0;
			char_complete <= 1'b0;
		end
		else begin
			addr_valid_d <= addr_valid;
			addr_valid_dd <= addr_valid_d;
		
			if (pixel_idx_max) pixel_idx <= 0;
			else pixel_idx <= pixel_idx + 1'b1;			
			
			if (pixel_idx_short) begin
				font_addr <= font_addr + 1'b1;			
				char_line <= char_line + 1'b1;
				if (char_line == (FONT_HEIGHT-1)) begin
					addr_valid <= 1'b0;
					char_complete <= 1'b1;
				end
			end
		end
	end
end

/////////////////////////////////////////
// combine to font bit stream
/////////////////////////////////////////
reg font_bit, font_bit_valid, font_eol;
wire [FONT_DATA_WIDTH-1:0] rev_font_data = reverse_font (font_data);
always @(posedge clk or posedge arst) begin
	if (arst) begin
		font_bit <= 1'b0;
		font_bit_valid <= 1'b0;
		font_eol <= 1'b0;
	end
	else begin
		font_bit <= rev_font_data [pixel_idx];
		font_bit_valid <= addr_valid_dd;
		font_eol <= pixel_idx_max;
	end
end

/////////////////////////////////////////
// Translate font bitstream to raster
/////////////////////////////////////////

always @(posedge clk or posedge arst) begin
	if (arst) begin
		raster_addr <= 0;
		raster_data <= 0;
		raster_we <= 0;
	end
	else begin
		if (load_start_address) begin
			raster_addr <= raster_start;
		end
		else begin
			if (font_bit_valid) begin
				if (font_eol) begin
					raster_addr <= raster_addr +
						RASTER_LINE_WIDTH -
						FONT_DATA_WIDTH + 1;
				end
				else begin
					raster_addr <= raster_addr + 1'b1;
				end
				raster_data <= font_bit ? wdata : 0;
				raster_we <= font_bit;
			end
		end
	end
end

/////////////////////////////////////////
// Control state machine
/////////////////////////////////////////

localparam ST_WAIT = 1'b0, ST_WRITE = 1'b1;
reg state,next_state;

always @(*) begin
	
	next_state = state;
	load_start_address = 1'b0;
	
	case (state)
		ST_WAIT : begin
			load_start_address = 1'b1;
			if (start_write_d) next_state = ST_WRITE;
		end
		ST_WRITE : begin
			if (char_complete) next_state = ST_WAIT;			
		end
	endcase		
end

assign busy = (state != ST_WAIT);

always @(posedge clk or posedge arst) begin
	if (arst) state <= ST_WAIT;
	else state <= next_state;
end

endmodule
