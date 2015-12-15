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

// baeckler - 02-15-2007

module	vga_driver	(
		r,g,b,
		current_x,current_y,request,
		vga_r,vga_g,vga_b,vga_hs,vga_vs,vga_blank,vga_clock,
		clk27,rst27);

input [9:0]	r,g,b;
output [9:0] current_x;
output [9:0] current_y;
output request;

output [9:0] vga_r, vga_g, vga_b;
output vga_hs, vga_vs, vga_blank, vga_clock;

input clk27, rst27;	

////////////////////////////////////////////////////////////

//	Horizontal	Timing
parameter	H_FRONT	=	16;
parameter	H_SYNC	=	96;
parameter	H_BACK	=	48;
parameter	H_ACT	=	640;
parameter	H_BLANK	=	H_FRONT+H_SYNC+H_BACK;
parameter	H_TOTAL	=	H_FRONT+H_SYNC+H_BACK+H_ACT;

//	Vertical Timing
parameter	V_FRONT	=	11;
parameter	V_SYNC	=	2;
parameter	V_BACK	=	31;
parameter	V_ACT	=	480;
parameter	V_BLANK	=	V_FRONT+V_SYNC+V_BACK;
parameter	V_TOTAL	=	V_FRONT+V_SYNC+V_BACK+V_ACT;

////////////////////////////////////////////////////////////

reg [9:0] h_cntr, v_cntr, current_x, current_y;
reg h_active, v_active, vga_hs, vga_vs;

assign	vga_blank = h_active & v_active;
assign	vga_clock = ~clk27;
assign	vga_r = r;
assign	vga_g = g;
assign	vga_b = b;
assign	request	= ((h_cntr>=H_BLANK && h_cntr<H_TOTAL)	&&
						 (v_cntr>=V_BLANK && v_cntr<V_TOTAL));

always @(posedge clk27) begin
	if(rst27) begin
		h_cntr <= 0;
		v_cntr <= 0;
		vga_hs <= 1'b1;
		vga_vs <= 1'b1;
		current_x <= 0;
		current_y <= 0;
		h_active <= 1'b0;
		v_active <= 1'b0;
	end
	else begin
		if(h_cntr != H_TOTAL) begin
			h_cntr <= h_cntr + 1'b1;
			if (h_active) current_x <= current_x + 1'b1;
			if (h_cntr == H_BLANK-1) h_active <= 1'b1;
		end
		else begin
			h_cntr	<= 0;
			h_active <= 1'b0;
			current_x <= 0;
		end
		
		if(h_cntr == H_FRONT-1) begin
			vga_hs <= 1'b0;
		end		
		
		if (h_cntr == H_FRONT+H_SYNC-1) begin
			vga_hs <= 1'b1;
			
			if(v_cntr != V_TOTAL) begin
				v_cntr <= v_cntr + 1'b1;
				if (v_active) current_y <= current_y + 1'b1;
				if (v_cntr == V_BLANK-1) v_active <= 1'b1;
			end
			else begin
				v_cntr <= 0;
				current_y <= 0;
				v_active <= 1'b0;
			end
			if(v_cntr == V_FRONT-1) vga_vs <= 1'b0;
			if(v_cntr == V_FRONT+V_SYNC-1) vga_vs <= 1'b1;
		end
	end
end

endmodule