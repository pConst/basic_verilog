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

// baeckler - 02-15-2006
// recursive sorting network implementation of rotate right
// for Stratix II

module rotate_internal (din,dout,distance);

`include "log2.inc"

parameter WIDTH = 16;
parameter DIST_WIDTH = log2(WIDTH-1);
parameter GENERIC = 0;

localparam MAX_D = 1 << DIST_WIDTH; // The shifting range described by
									// the distance. 

// this subdesign does not allow shifting beyond the data width
// e.g. rotating an 8 bit value 100 steps.  
initial begin 
	#10
	if (MAX_D > WIDTH) begin
		$display ("Error - Rotation by distance greater than data width not supported");
		$stop();
	end
end

input [WIDTH-1:0] din;
output [WIDTH-1:0] dout;
input [DIST_WIDTH-1:0] distance;

wire [WIDTH-1:0] dout;
wire [2*WIDTH-1:0] double_din = {din,din};

genvar i;
generate
	if (GENERIC) begin
		assign dout = double_din >> distance;
	end
	else begin
		wire [WIDTH-1:0] layer;
		
		if (DIST_WIDTH == 0) begin
			// degenerate case
			assign dout = din;
		end
		else if (DIST_WIDTH == 1) begin
			// knock out the last distance line
			for (i=0;i<WIDTH;i=i+1)
			begin : two_to_one
				assign layer[i] = distance[0] ? double_din[i+1] : double_din[i];
			end		
			assign dout = layer;	
		end 
		else begin
			// knock out 2 more distance lines
			for (i=0;i<WIDTH;i=i+1)
			begin : four_to_one
				wire [3:0] dt;
				wire [1:0] st;
				assign dt[0] = double_din[i];
				assign dt[1] = double_din[i+MAX_D/4];
				assign dt[2] = double_din[i+MAX_D/2];
				assign dt[3] = double_din[i+MAX_D/2+MAX_D/4];
				assign st = {distance[DIST_WIDTH-1],distance[DIST_WIDTH-2]};
				assign layer[i] = dt[st];
			end
			if (DIST_WIDTH == 2) assign dout = layer;
			else begin
				// recurse to build the rest of the network
				rotate_internal r (.din(layer),.dout(dout),
					.distance(distance[DIST_WIDTH-3:0]));
				defparam r .WIDTH = WIDTH;
				defparam r .DIST_WIDTH = DIST_WIDTH-2;
			end
		end
	end
endgenerate

endmodule
