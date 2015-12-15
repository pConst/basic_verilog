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

// baeckler - 02-14-2006
//
// Stratix II 8:1 MUX showing 
//		Two 7-LUT implementation
//		Two 5-LUTs, one 7-LUT implementation
//		Generic implementation
//
// Both methods cost two packed ALM's
//   they have slightly different speed and routing
//   properties.  77 is currently used by default.

module eight_to_one (dat,sel,out);

parameter SEVEN_SEVEN_STYLE = 1'b0;
parameter FIVE_FIVE_STYLE = 1'b0;

input [7:0] dat;
input [2:0] sel;

output out;
wire out;

generate
if (SEVEN_SEVEN_STYLE) begin
	wire cell_tail;
	stratixii_lcell_comb lc_tail (
	  .datae(sel[1]),
	  .dataf(sel[2]),
	  .datad(sel[0]),
	  .dataa(dat[1]),
	  .datac(dat[0]),
	  .datab(dat[3]),
	  .datag(dat[2]),
	  .combout(cell_tail),
	  .cout(),.shareout(),.sumout(),.cin(1'b0),.sharein(1'b0));
	defparam lc_tail .extended_lut = "on";
	defparam lc_tail .lut_mask = 64'hff00ff00ccf0aaf0;

	stratixii_lcell_comb lc_head (
	  .datae(sel[1]),
	  .dataf(cell_tail),
	  .datad(sel[2]),
	  .dataa(dat[5]),
	  .datac(dat[4]),
	  .datab(dat[7]),
	  .datag(dat[6]),
	  .combout(out),
	  .cout(),.shareout(),.sumout(),.cin(1'b0),.sharein(1'b0));
	defparam lc_head .extended_lut = "on";
	defparam lc_head .lut_mask = 64'hccffaafff000f000;
end

else if (FIVE_FIVE_STYLE) begin
	wire m0_out, m1_out;

	stratixii_lcell_comb m0 (
		.dataa(sel[0]),
		.datab(sel[1]),
		.datac(dat[0]),
		.datad(dat[1]),
		.datae(dat[2]),
		.combout(m0_out),
		.dataf(1'b0),.datag(1'b1),
		.cout(),.shareout(),.sumout(),.cin(1'b0),.sharein(1'b0));
	defparam m0 .shared_arith = "off";
	defparam m0 .extended_lut = "off";
	defparam m0 .lut_mask = 64'h7654321076543210;

	stratixii_lcell_comb m1 (
		.dataa(sel[0]),
		.datab(sel[1]),
		.datac(dat[4]),
		.datad(dat[5]),
		.datae(dat[6]),
		.dataf(1'b0),.datag(1'b1),
		.combout(m1_out),
		.cout(),.shareout(),.sumout(),.cin(1'b0),.sharein(1'b0));
	defparam m1 .shared_arith = "off";
	defparam m1 .extended_lut = "off";
	defparam m1 .lut_mask = 64'h7654321076543210;

	stratixii_lcell_comb head (
		.dataa(sel[0]),
		.datab(sel[1]),
		.datac(dat[3]),
		.datad(m0_out),
		.datae(sel[2]),
		.dataf(m1_out),
		.datag(dat[7]),
		.combout(out),
		.cout(),.shareout(),.sumout(),.cin(1'b0),.sharein(1'b0));
	defparam head .shared_arith = "off";
	defparam head .extended_lut = "on";
	defparam head .lut_mask = 64'hF7F7F7808080F780;
end

else begin
	// let the compiler select style
	assign out = dat[sel];
end 
endgenerate
endmodule