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

// baeckler - 05-05-2006
// 
// This is a trick to generate case statements / LUT masks
// from an existing comb circuit.  It's handy when the structure
// of the current implementation is getting in the way.
//

module make_case_tb ();

`include "log2.inc"

localparam IN_WIDTH = 4;
localparam OUT_WIDTH = 8;
localparam LOG_OUT_WIDTH = log2(OUT_WIDTH-1);

reg [IN_WIDTH-1:0] in;
wire [OUT_WIDTH-1:0] out;

///////////////////////
// target function
///////////////////////
// drive all inputs from IN
// merge all outputs to OUT.
bin_to_asc_hex ba (.in(in),.out(out));
	defparam ba .WIDTH=IN_WIDTH;

///////////////////////
// sim loop
///////////////////////
integer n,k;
reg [(1<<IN_WIDTH)-1:0] tmp_mask;
reg [LOG_OUT_WIDTH-1:0] tmp_out;
wire [IN_WIDTH-1:0] max_mask = (1<<IN_WIDTH)-1;

initial begin
	
	////////////////////////////////////////
	// make a case statement
	////////////////////////////////////////
	$display ("// case statement version");
	$display ("case (in)");
	for (n=0; n<(1<<IN_WIDTH); n=n+1)
	begin
		in = n;
		#5
		$display ("    %d'h%x : out = %d'b%b;",
			IN_WIDTH,in,OUT_WIDTH,out);
	end
	$display ("endcase\n");
	
	////////////////////////////////////////
	// make a look up table for each output
	////////////////////////////////////////
	$display ("// look up table version");
	for (k=0; k<OUT_WIDTH; k=k+1)
	begin
		tmp_mask = 0;
		tmp_out = k;
		for (n=0; n<(1<<IN_WIDTH); n=n+1)
		begin
			in = n;
			#5
			if (out[k]) tmp_mask[n] = 1'b1;
		end
		$display ("wire [%d:0] mask%d = %d'h%x;",
			max_mask,tmp_out,{1'b0,max_mask}+1'b1,tmp_mask);
		$display ("assign out[%d] = mask%d[in];",tmp_out,tmp_out);
	end

	$stop();
end

endmodule
