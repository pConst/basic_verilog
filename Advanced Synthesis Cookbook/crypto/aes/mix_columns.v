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

// baeckler - 03-08-2006
// Handle the rijndael mix_columns and inverse
//
// input and output ordering is
//  (msb) s0,c s1,c s2,c s3,c (lsb)

////////////////////////////////////////////////////
// One column mixing operation
////////////////////////////////////////////////////
module mix_one_column (in,out);

input [4*8-1:0] in;
output [4*8-1:0] out;
wire [4*8-1:0] out;

function [7:0] mult2;
	input [7:0] n;
	begin
		mult2 = {n[6],n[5],n[4],n[3]^n[7],n[2]^n[7],n[1],n[0]^n[7],n[7]};
	end
endfunction

function [7:0] mult3;
	input [7:0] n;
	begin
		mult3 = mult2(n) ^ n;
	end
endfunction

wire [7:0] s0_i,s1_i,s2_i,s3_i;
wire [7:0] s0_o,s1_o,s2_o,s3_o;

assign {s0_i,s1_i,s2_i,s3_i} = in;

assign s0_o = mult2(s0_i) ^ mult3(s1_i) ^ s2_i ^ s3_i;
assign s1_o = s0_i ^ mult2(s1_i) ^ mult3(s2_i) ^ s3_i;
assign s2_o = s0_i ^ s1_i ^ mult2(s2_i) ^ mult3(s3_i);
assign s3_o = mult3(s0_i) ^ s1_i ^ s2_i ^ mult2(s3_i);

assign out = {s0_o,s1_o,s2_o,s3_o};

endmodule

////////////////////////////////////////////////////
// mix_columns implemented as 4 single col mixers
////////////////////////////////////////////////////
module mix_columns (in,out);
input [16*8-1 : 0] in;
output [16*8-1 : 0] out;
wire [16*8-1 : 0] out;

genvar i;
generate
    for (i=0; i<4; i=i+1)
    begin : mx
       mix_one_column m (.in(in[32*i+31:32*i]),
						.out(out[32*i+31:32*i]));
    end
endgenerate
endmodule

////////////////////////////////////////////////////
// Inverse One column mixing operation
////////////////////////////////////////////////////
module inv_mix_one_column (in,out);

input [4*8-1:0] in;
output [4*8-1:0] out;
wire [4*8-1:0] out;

function [7:0] mult2;
	input [7:0] n;
	begin
		mult2 = {n[6],n[5],n[4],n[3]^n[7],n[2]^n[7],n[1],n[0]^n[7],n[7]};
	end
endfunction

function [7:0] mult4;
	input [7:0] n;
	begin
		mult4 = {n[5],	n[4],	n[3]^n[7],	n[2]^n[7]^n[6],
				n[6]^n[1],	n[0]^n[7],	n[6]^n[7],	n[6]};
	end
endfunction

function [7:0] mult8;
	input [7:0] n;
	begin
		mult8 = {n[4],	n[3]^n[7],	n[2]^n[7]^n[6],	n[5]^n[6]^n[1],
				n[5]^n[0]^n[7],	n[6]^n[7],	n[6]^n[5],	n[5]};
	end
endfunction

// equivalent to mult8 ^ mult2
function [7:0] multa;
	input [7:0] n;
	begin
		multa = {n[4]^n[6],	n[3]^n[7]^n[5],	n[4]^n[2]^n[7]^n[6],	n[5]^n[6]^n[1]^n[3]^n[7],
				n[5]^n[0]^n[2],	n[6]^n[7]^n[1],	n[0]^n[7]^n[6]^n[5],	n[7]^n[5]};
	end
endfunction

// equivalent to mult8 ^ mult4
function [7:0] multc;
	input [7:0] n;
	begin
		multc = {n[4]^n[5],	n[4]^n[3]^n[7],	n[2]^n[3]^n[6],	n[2]^n[5]^n[7]^n[1],
				n[6]^n[1]^n[5]^n[0]^n[7],	n[6]^n[0],	n[7]^n[5],	n[6]^n[5]};
	end
endfunction

function [7:0] mult9;
	input [7:0] n;
	begin
		mult9 = mult8(n) ^ n;
	end
endfunction

function [7:0] multb;
	input [7:0] n;
	begin
		multb = multa(n) ^ n;
	end
endfunction

function [7:0] multd;
	input [7:0] n;
	begin
		multd = multc(n) ^ n;
	end
endfunction

function [7:0] multe;
	input [7:0] n;
	begin
		multe = {n[5]^n[4]^n[6],	n[4]^n[3]^n[7]^n[5],	n[4]^n[2]^n[3]^n[6],	n[5]^n[2]^n[1]^n[3],
				n[6]^n[1]^n[5]^n[0]^n[2],	n[6]^n[0]^n[1],	n[0]^n[5],	n[7]^n[5]^n[6]};
	end
endfunction

wire [7:0] s0_i,s1_i,s2_i,s3_i;
wire [7:0] s0_o,s1_o,s2_o,s3_o;

assign {s0_i,s1_i,s2_i,s3_i} = in;

assign s0_o = multe(s0_i) ^ multb(s1_i) ^ multd(s2_i) ^ mult9(s3_i);
assign s1_o = mult9(s0_i) ^ multe(s1_i) ^ multb(s2_i) ^ multd(s3_i);
assign s2_o = multd(s0_i) ^ mult9(s1_i) ^ multe(s2_i) ^ multb(s3_i);
assign s3_o = multb(s0_i) ^ multd(s1_i) ^ mult9(s2_i) ^ multe(s3_i);

assign out = {s0_o,s1_o,s2_o,s3_o};

endmodule

////////////////////////////////////////////////////
// inv_mix_columns implemented as 4 single col mixers
////////////////////////////////////////////////////
module inv_mix_columns (in,out);
input [16*8-1 : 0] in;
output [16*8-1 : 0] out;
wire [16*8-1 : 0] out;

genvar i;
generate
    for (i=0; i<4; i=i+1)
    begin : mx
       inv_mix_one_column m (.in(in[32*i+31:32*i]),
						.out(out[32*i+31:32*i]));
    end
endgenerate
endmodule


////////////////////////////////////////////////////
// Quick sanity checker testbench 
////////////////////////////////////////////////////
module mix_col_test ();
reg [31:0] dat;
wire [31:0] mix;
wire [31:0] inv;
reg fail = 0;

mix_one_column mc (.in(dat),.out(mix));
inv_mix_one_column imc (.in(mix),.out(inv));

initial begin 
	dat = 0;
	fail = 0;
	#100000
	if (!fail) $display ("PASS");
	$stop();
end

always begin
	#50 dat = $random;
	#50 if (inv != dat) begin
		$display ("Mismatch at time %d",$time);
		fail = 1;
	end
end
endmodule