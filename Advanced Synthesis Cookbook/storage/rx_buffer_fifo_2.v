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

// baeckler - 10-20-2008
// 2 word FIFO
module rx_buffer_fifo_2 #(
	parameter WIDTH = 20*20
)
(
	input clk, arst,
	input [WIDTH-1:0] din,
	input din_valid,		// pulse marking fresh input data 
	input dout_wait,		// wait means I don't want to see dout_valid yet
	output reg [WIDTH-1:0] dout,
	output dout_valid,		// pulse marking fresh output data
	output reg overflow		// overflow with loss of data
);

reg [WIDTH-1:0] store_a, store_b;
reg [1:0] wr_ptr, rd_ptr /* synthesis preserve */;

//////////////////////////////////////////
// when DIN is valid always accept it
//   into storage
//////////////////////////////////////////
always @(posedge clk or posedge arst) begin
	if (arst) begin
		wr_ptr <= 2'b0;
		store_a <= 0;
		store_b <= 0;
	end
	else begin
		if (din_valid) begin
			case (wr_ptr)
				2'b00 : wr_ptr <= 2'b01;
				2'b01 : wr_ptr <= 2'b10;
				2'b10 : wr_ptr <= 2'b11;
				2'b11 : wr_ptr <= 2'b00;				
			endcase					
			
			case (wr_ptr[0])
				1'b0 : store_a <= din;
				1'b1 : store_b <= din;				
			endcase							
		end
	end
end
			
//////////////////////////////////////////
// Read ptr and data out...
//////////////////////////////////////////
reg dout_content_valid;
assign dout_valid = dout_content_valid & !dout_wait;

reg read_now;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		dout <= 0;
		rd_ptr <= 2'b00;
		dout_content_valid <= 1'b0;
	end
	else begin
		dout_content_valid <= dout_content_valid & dout_wait;
		if (read_now) begin
			dout_content_valid <= 1'b1;
			case (rd_ptr[0])
				1'b0 : dout <= store_a;
				1'b1 : dout <= store_b;				
			endcase
		
			case (rd_ptr)
				2'b00 : rd_ptr <= 2'b01;
				2'b01 : rd_ptr <= 2'b10;
				2'b10 : rd_ptr <= 2'b11;
				2'b11 : rd_ptr <= 2'b00;				
			endcase									
		end
	end
end	
		
//////////////////////////////////////////
// Decide when to read
//////////////////////////////////////////
assign full = (wr_ptr[1] ^ rd_ptr[1]) && (wr_ptr[0] == rd_ptr[0]);
wire empty = (wr_ptr[1] ~^ rd_ptr[1]) && (wr_ptr[0] == rd_ptr[0]);

always @(*) begin
	read_now = 1'b0;
	
	// read if caller wants a read and data is available
	// don't read on consecutive cycles.
	if (!empty & (!dout_content_valid | !dout_wait)) read_now = 1'b1;
	
	// read when you are overflowing to stay semi consistent
	if (din_valid & full) read_now = 1'b1;
end

//////////////////////////////////////////
// error detect
//////////////////////////////////////////

always @(posedge clk or posedge arst) begin
	if (arst) begin
		overflow <= 1'b0;
	end
	else begin
		overflow <= 1'b0;
		
		// oops.  New data and no place to keep it
		if (din_valid & full & dout_content_valid & dout_wait) overflow <= 1'b1;			
	end
end

endmodule