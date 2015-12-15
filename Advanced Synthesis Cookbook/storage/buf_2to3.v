// Copyright 2007 Altera Corporation. All rights reserved.  
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

//baeckler - 11-14-2006

//////////////////////////////////////////
// reformat 16 bit stream to 24 bit stream
//////////////////////////////////////////
module buf_2to3 ( 
	clk,rst,

	din,
	din_valid,
	din_ack,

	dout,
	dout_valid,
	dout_ack
);

input clk,rst;

input [15:0] din;
input din_valid;
output din_ack;

output [23:0] dout;
output dout_valid;
input dout_ack;

reg [47:0] storage;
reg [2:0] held;

wire din_ack = !rst & din_valid & (held < 5);
wire dout_valid = !rst & (held > 2);
assign dout = storage[23:0];

always @(posedge clk) begin
	if (rst) begin
		storage <= 0;
		held <= 0;
	end
	else begin
		if (din_ack && dout_ack) begin
			// accepting new data and dumping old	
			// not doing the held = 5 'make space' option
			// because it extends the critical path 
			// and makes things (more) confusing
			if (held == 3'b11) begin
				storage[15:0] <= din;
				held <= 3'b010;
			end
			else begin // held == 4
				storage[31:0] <= {din,storage[31:24]};
				held <= 3'b11;
			end		 	
		end
		else if (din_ack) begin
			// accepting new data only
			if (held == 3'b0) begin
				storage[15:0] <= din;
				held <= 3'b010;
			end
			else if (held == 3'b1) begin
				storage[23:8] <= din;
				held <= 3'b11;
			end
			else if (held == 3'b10) begin
				storage[31:16] <= din;
				held <= 3'b100;
			end			
			else if (held == 3'b11) begin 
				storage[39:24] <= din;
				held <= 3'b101;
			end	
			else begin // held = 4
				storage[47:32] <= din;
				held <= 3'b110;
			end
		end
		else if (dout_ack) begin
			// dumping old data only
			storage <= {24'b0,storage[47:24]};
			held <= held - 2'b11;
		end
	end		
end
endmodule


