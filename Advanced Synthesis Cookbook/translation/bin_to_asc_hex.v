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

// baeckler - 04-26-2006
// convert a variable length binary word to hex.

module bin_to_asc_hex (in,out);

parameter METHOD = 1;
parameter WIDTH = 16;

localparam PAD_BITS = (WIDTH % 4) == 0 ? 0 : (4-(WIDTH%4));
localparam PADDED_WIDTH = WIDTH + PAD_BITS;
localparam NYBBLES = PADDED_WIDTH >> 2;

input [WIDTH-1:0] in;	
output [8*NYBBLES-1:0] out;

wire [PADDED_WIDTH-1:0] padded_in = {{PAD_BITS {1'b0}},in};

genvar i;
generate
	for (i=0; i<NYBBLES; i=i+1)
	begin : h
		wire [3:0] tmp_in = padded_in [4*(i+1)-1:4*i];
	
		if (METHOD == 0) begin
			// C style comparison.
			wire [7:0] tmp_out;
			assign tmp_out = (tmp_in < 10) ? ("0" | tmp_in) : ("A" + tmp_in - 10);
			assign out [8*(i+1)-1:8*i] = tmp_out;
		end
		else begin
			/////////////////////////////////////
			// METHOD = 1 is an equivalent case 
			//   statement, to make the minimizations 
			//   more obvious.
			/////////////////////////////////////
			reg [7:0] tmp_out;
			always @(tmp_in) begin
				case (tmp_in)
				   4'h0 : tmp_out = 8'b00110000;
				   4'h1 : tmp_out = 8'b00110001;
				   4'h2 : tmp_out = 8'b00110010;
				   4'h3 : tmp_out = 8'b00110011;
				   4'h4 : tmp_out = 8'b00110100;
				   4'h5 : tmp_out = 8'b00110101;
				   4'h6 : tmp_out = 8'b00110110;
				   4'h7 : tmp_out = 8'b00110111;
				   4'h8 : tmp_out = 8'b00111000;
				   4'h9 : tmp_out = 8'b00111001;
				   4'ha : tmp_out = 8'b01000001;
				   4'hb : tmp_out = 8'b01000010;
				   4'hc : tmp_out = 8'b01000011;
				   4'hd : tmp_out = 8'b01000100;
				   4'he : tmp_out = 8'b01000101;
				   4'hf : tmp_out = 8'b01000110;
				endcase
			end
			assign out [8*(i+1)-1:8*i] = tmp_out;
		end					
	end
endgenerate

endmodule

/////////////////////////////////
// quick sanity check
/////////////////////////////////

module bin_to_asc_hex_tb ();

parameter WIDTH = 16;
parameter OUT_WIDTH = 4; // Number of nybbles in WIDTH

reg [WIDTH-1:0] in;
wire [8*OUT_WIDTH-1:0] oa,ob;

bin_to_asc_hex a (.in(in),.out(oa));
bin_to_asc_hex b (.in(in),.out(ob));

initial begin
	#100000 $stop();
end

always begin
	#100 in = $random;
	#100 if (oa !== ob) $display ("Disagreement at time %d",$time);
end	

endmodule
