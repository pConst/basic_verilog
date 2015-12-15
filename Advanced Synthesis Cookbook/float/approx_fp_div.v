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

// liu - 07-16-2007

module approx_fp_div (a, b, q, clk);

	input [31:0] a, b;
	input clk;
	output [31:0] q;

	reg a_sign, b_sign, q_sign;
	reg [7:0] a_exp, b_exp, q_exp;
	reg [22:0] a_frac, q_frac;
	reg [5:0] b_frac /*synthesis keep*/;

	//input, output interface
	always @ (posedge clk)
	begin
		a_sign <= a[31];
		a_exp <= a[30:23];
		a_frac <= a[22:0];

		b_sign <= b[31];
		b_exp <= b[30:23];
		b_frac <= b[22:17];
	end

	//stage 1

	//sign bit and exp
	reg q_sign_reg1;
	reg [7:0] q_exp_reg1;
	always @ (posedge clk)
	begin
		q_sign_reg1 <= a_sign ^ b_sign;
		q_exp_reg1 <= {1'b0, a_exp} + 9'h7e - {1'b0, b_exp};
	end
		
	//frac bits
	wire [23:0] a0_tmp;
	assign a0_tmp = {1'b1, a_frac};

	//Get estimation e0
	reg [6:0] e0_reg1;
	wire [6:0] e0 /*synthesis keep*/;
	reg [23:0] a0_reg1;
	always @ (posedge clk)
	begin
		e0_reg1 <= e0;
		a0_reg1 <= a0_tmp;
	end
	approx_fp_div_lut tbl1(.in(b_frac), .out(e0));
	
	//Stage 2
	//Product
	wire [31:0] product;
	reg q_sign_reg2, q_sign_reg3, q_sign_reg4;
	reg [7:0] q_exp_reg2, q_exp_reg3, q_exp_reg4, q_exp_plus;
	always @ (posedge clk)
	begin
		q_sign_reg2 <= q_sign_reg1;
		q_sign_reg3 <= q_sign_reg2;
		q_sign_reg4 <= q_sign_reg3;
		q_exp_reg2 <= q_exp_reg1;
		q_exp_reg3 <= q_exp_reg2;
		q_exp_reg4 <= q_exp_reg3;
		q_exp_plus <= q_exp_reg3 + 1'b1;
	end
	
	mult_3tick mult1(
		.clk(clk),
		.a_in({12'b0,a0_reg1}),
		.b_in({29'b1,e0_reg1}),
		.o(product));
	
	//Stage3
	wire [22:0] q_frac_tmp;
	assign q_frac_tmp = (product[31])? product[30:8] : product[29:7];
	
	always @(posedge clk)
	begin
		q_sign <= q_sign_reg4;
		q_exp <= (product[31])? q_exp_plus : q_exp_reg4;
		q_frac <= q_frac_tmp;
	end
	assign q = {q_sign, q_exp, q_frac};

endmodule

