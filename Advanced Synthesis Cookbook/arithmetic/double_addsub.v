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

// baeckler - 02-09-06
//
// This computes the sum of +/- A and +/- B in a single ternary adder chain.
// -A is equivalent to ~A + 1  (2's complement)
// This can be implemented in Stratix II hardware using a ternary adder 
// where two channels handle the positive or inverted data and the third
// adjusts for 0,1,or 2 +1's
//
// A and B are treated as unsigned, output is signed 2's comp
//

module double_addsub (a,b,negate_a,negate_b,sum);

parameter WIDTH = 8;
parameter HW_CELLS = 1'b1;

input [WIDTH-1:0] a;
input [WIDTH-1:0] b;
input negate_a, negate_b;

output [WIDTH+1:0] sum;
wire [WIDTH+1:0] sum;

genvar i;
generate

if (HW_CELLS) begin
	
	wire [WIDTH+1:0] cin,sin;

	assign cin[0] = 1'b0;
	assign sin[0] = 1'b0;
	for (i=0; i<WIDTH; i=i+1) 
	begin : das
		stratixii_lcell_comb w (
			.dataa(negate_b),
			.datab(negate_a),
			.datac(b[i]),
			.datad(a[i]),
			
			 // unused
			.datae(1'b0),
			.dataf(1'b0),
			.datag(1'b0),
			
			.cin(cin[i]),
			.sharein(sin[i]),
			.sumout(sum[i]),
			.cout(cin[i+1]),	
			.combout(),
			.shareout(sin[i+1])
		);

		defparam w .shared_arith = "on";
		defparam w .extended_lut = "off";
		defparam w .lut_mask = 
			i == 0 ? 64'h0000724e00000ff0 :
			i == 1 ? 64'h00001ac80000e11e :
					 64'h0000124800006996;
	end

	stratixii_lcell_comb t0 (
		.dataa(negate_b),
		.datab(negate_a),
		.datac(1'b0),
		.datad(1'b0),
		
		// unused
		.datae(1'b0),
		.dataf(1'b0),
		.datag(1'b0),
			
		.cin(cin[WIDTH]),
		.sharein(sin[WIDTH]),
		.sumout(sum[WIDTH]),
		.cout(cin[WIDTH+1]),
		.combout(),	
		.shareout(sin[WIDTH+1])
	);

	defparam t0 .shared_arith = "on";
	defparam t0 .extended_lut = "off";
	defparam t0 .lut_mask = 64'h0000124800006996;

	stratixii_lcell_comb t1 (
		.dataa(negate_b),
		.datab(negate_a),
		.datac(1'b0),
		.datad(1'b0),
		
		// unused
		.datae(1'b0),
		.dataf(1'b0),
		.datag(1'b0),
			
		.cin(cin[WIDTH+1]),
		.sharein(sin[WIDTH+1]),
		.sumout(sum[WIDTH+1]),
		.cout(),
		.combout(),	
		.shareout()
	);

	defparam t1 .shared_arith = "on";
	defparam t1 .extended_lut = "off";
	defparam t1 .lut_mask = 64'h0000124800006996;

end

else begin
	
	wire [WIDTH+3:0] tmp_sum;
	reg [WIDTH+1:0] tmp_c;

	always @(negate_a or negate_b) begin
		tmp_c = 0;
		tmp_c [1:0] = {negate_a & negate_b, negate_a ^ negate_b};
	end

	ternary_add t ( .a( {negate_a,negate_a, a ^ {WIDTH{negate_a}}} ),
					.b( {negate_b,negate_b, b ^ {WIDTH{negate_b}}} ),
					.c( tmp_c ),
					.o( tmp_sum ) );
	defparam t .WIDTH = WIDTH+2;
	assign sum = tmp_sum[WIDTH+1:0];
end

endgenerate
endmodule