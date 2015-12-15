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
// baeckler - 09-18-2008
// Convert a steady 20 bit input stream into a 
// on and off 67 bit stream

module gearbox_20_67 (
	input clk,arst,
	input [19:0] din,
	input slip_to_frame,	// 1=slip until you hit a properly framed word
	output [66:0] dout,
	output reg dout_valid	
);

reg loword_valid;
reg [22:0] loword;

// worst case : want 23 bits, have 22, need to take on 20 more
// therefore we need a 42 bit buffer
reg [41:0] storage;
reg [5:0] top_ptr;
reg [2:0] schedule; // [0,1] 22 bits, [2] 23 bits
reg mv_hi, mv_md;

reg [21:0] hiword,midword;
assign dout = {hiword,midword,loword};

wire enough_bits = (top_ptr > 6'd22) || (!schedule[2] && top_ptr == 6'd22);

always @(posedge clk or posedge arst) begin
	if (arst) begin
		top_ptr <= 0;
		storage <= 0;
		loword_valid <= 0;
		schedule <= 3'b001;
		mv_hi <= 0;
		mv_md <= 0;
		dout_valid <= 0;
		hiword <= 0;
		midword <= 0;
		loword <= 0;
	end
	else begin
				
		// always take in new data - 20 bits
		storage <= {storage[21:0],din};
		loword_valid <= enough_bits;
		
		// read 22 to hi, 22 to mid, 23 to low to form 67		
		mv_hi <= schedule[0];
		mv_md <= schedule[1];
		dout_valid <= schedule[2] & enough_bits;
				
		if (loword_valid && mv_hi) hiword <= loword[22:1];
		if (loword_valid && mv_md) midword <= loword[22:1];
		
		// pull out 22 or 23 bits of data from the register
		case (top_ptr)
			6'd42: loword <= storage[41:19]; 
			6'd41: loword <= storage[40:18]; 
			6'd40: loword <= storage[39:17]; 
			6'd39: loword <= storage[38:16];
			6'd38: loword <= storage[37:15];
			6'd37: loword <= storage[36:14];
			6'd36: loword <= storage[35:13];
			6'd35: loword <= storage[34:12];
			6'd34: loword <= storage[33:11];
			6'd33: loword <= storage[32:10];
			6'd32: loword <= storage[31:9];
			6'd31: loword <= storage[30:8];
			6'd30: loword <= storage[29:7];
			6'd29: loword <= storage[28:6];
			6'd28: loword <= storage[27:5];
			6'd27: loword <= storage[26:4];
			6'd26: loword <= storage[25:3];
			6'd25: loword <= storage[24:2];
			6'd24: loword <= storage[23:1];
			6'd23: loword <= storage[22:0];
			6'd22: loword <= {storage[21:0],1'b0}; // 16 hex
	
			default: loword <= 0; // not X, just for simulation sanity
		endcase			
		
		// we are always gaining 20 and losing either 0, 22 or 23 bits
		top_ptr <= top_ptr + (!enough_bits ? 6'd20 : (schedule[2] ? -6'd3 : -6'd2)); 
		
		// when successful advance to next word
		if (enough_bits) schedule <= {schedule[1:0],schedule[2]};
		
		// Optional slip to find properly framed words
		if (slip_to_frame & loword_valid & mv_hi & (~loword[21] ^ loword[20])) 
			schedule <= 3'b001;				
		
	end	
end
		
endmodule
