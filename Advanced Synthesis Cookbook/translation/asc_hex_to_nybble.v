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

// baeckler - 05-01-2006
// Converts upper or lower case hex byte to 4 bit binary

module asc_hex_to_nybble (in,out);
input [7:0] in;

output [3:0] out;
reg [3:0] out;

// method 1 is smaller, faster, and will output garbage for
//		non-hex characters.
//
// method 0 will output 0 for non-hex chars
//
parameter METHOD = 1;

generate
if (METHOD == 0) begin
	
	//////////////////////////////////////
	// METHOD = 0
	// illegal input bytes must output 0
	//////////////////////////////////////
	always @(in) begin
		case (in)
			"0" : out = 4'h0;
			"1" : out = 4'h1;
			"2" : out = 4'h2;
			"3" : out = 4'h3;
			"4" : out = 4'h4;
			"5" : out = 4'h5;
			"6" : out = 4'h6;
			"7" : out = 4'h7;
			"8" : out = 4'h8;
			"9" : out = 4'h9;
			"A", "a" : out = 4'ha;
			"B", "b" : out = 4'hb;
			"C", "c" : out = 4'hc;
			"D", "d" : out = 4'hd;
			"E", "e" : out = 4'he;
			"F", "f" : out = 4'hf;
			default : out = 4'b0;
		endcase
	end
end
else begin
	
	//////////////////////////////////////
	// METHOD = 1
	// illegal input bytes are don't care
	//////////////////////////////////////
	
	// 0:9 30 - 39 hex	
	// A:F 41 - 46 hex
	// a:f 61 - 66 hex
	always @(in) begin
		if (!in[6])	begin
			// numeric
			out = in[3:0];
		end
		else begin
			// Alpha - made these on paper
			// many variants would work			
			out[3] = 1'b1;
			out[2] = in[2] | (in[1] & in[0]);
			out[1] = in[0] ^ in[1];
			out[0] = !in[0];
		end
	end
end
endgenerate

endmodule
 

module asc_hex_to_nybble_tb ();
	
	wire [3:0] ao,bo;
	
	reg [22*8-1:0] test_str = "0123456789ABCDEFabcdef";
	reg [22*4-1:0] test_hex ='h0123456789abcdefabcdef;

	asc_hex_to_nybble a (.in(test_str[7:0]),.out(ao));
		defparam a .METHOD = 0;

	asc_hex_to_nybble b (.in(test_str[7:0]),.out(bo));
		defparam b .METHOD = 1;

	integer stim;
	initial begin
		for (stim = 0; stim<22; stim=stim+1)
		begin
			#10
			if (bo !== ao || bo != test_hex[3:0]) begin
				$display ("Mismatch on case %d",stim);
			end
			#10
			test_hex = test_hex >> 4;
			test_str = test_str >> 8;
		end
		$stop();
	end
	
endmodule