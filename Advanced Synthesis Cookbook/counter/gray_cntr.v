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

// baeckler - 06-30-2006

////////////////////////////////////////////
// Gray to bin, increment, back to gray 
//   in pure comb logic
////////////////////////////////////////////
module gray_plus_one (
	q,
	q_plus
);

parameter WIDTH = 6;

input [WIDTH-1:0] q;
output [WIDTH-1:0] q_plus;

	// Convert Q to binary wires
	//
	wire [WIDTH-1:0] q_to_bin;
	assign q_to_bin[WIDTH-1] = q[WIDTH-1];
	genvar i;
	generate
	for (i=WIDTH-2; i>=0; i=i-1)
	  begin: gry_to_bin
		assign q_to_bin[i] = q_to_bin[i+1] ^ q[i];
	  end
	endgenerate

	// increment the binary wires for q+
	// do it in gates, not a real + to encourage flattening
	//
	wire [WIDTH-1:0] inc_q;
	wire [WIDTH-1:0] inc_q_cout;
	assign inc_q[0] = !q_to_bin[0];
	assign inc_q_cout[0] = q_to_bin[0];
	generate
	for (i=1; i<WIDTH; i=i+1)
	  begin: plus_one
		assign inc_q[i] = inc_q_cout[i-1] ^ q_to_bin[i];
		assign inc_q_cout[i] = inc_q_cout[i-1] & q_to_bin[i];
	  end
	endgenerate

	// convert back to gray
	//
	assign q_plus = inc_q ^ (inc_q >> 1);

endmodule

////////////////////////////////////////////
// Gray counter
//   using simple comb logic
////////////////////////////////////////////
module gray_cntr (
	clk,
	rst,
	ena,
	sclr,
	q
);

parameter WIDTH = 20;

input clk,rst,ena,sclr;
output [WIDTH-1:0] q;

	reg [WIDTH-1:0] q;
	wire [WIDTH-1:0] q_plus;

	gray_plus_one gp (.q(q),.q_plus(q_plus));
	defparam gp .WIDTH = WIDTH;

	// handle the counter update
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			q <= 0;
		end
		else begin
			if (ena) begin
				if (sclr) q <= 0;
				else q <= q_plus;
			end
		end
	end
endmodule


