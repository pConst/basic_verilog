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

// baeckler - 05-01-2007

module approx_fp_invsqrt (
	clk,
	in,
	out
);

parameter CORRECTION_ROUND = 1'b1;

input clk;
input [31:0] in;
output [31:0] out;
wire [31:0] out;

// Magic courtesy of Quake 3 / Well known Internet trick
//   first order approximation of 1 / sqrt(in)
//
reg [31:0] app;
always @(posedge clk) begin
	app <= 32'h5F3759DF - {1'b0, in[31:1]};
end

generate

if (!CORRECTION_ROUND) begin
	// output the approx directly
	assign out = app;
end

else begin
	// add a Newton improvement round
	reg [31:0] in_r;

	always @(posedge clk) begin
		in_r <= in;
	end
	
	wire [22:0] in_mant = in_r [22:0];
	wire [7:0] in_exp = in_r [30:23];
	wire [22:0] app_mant = app [22:0];
	wire [7:0] app_exp = app [30:23];

	reg [35:0] app_sqr_m, app_hlf_m;
	reg [8:0] app_sqr_e, app_hlf_e;
	reg [24:0] op5_m;
	reg [8:0] op5_e;
	
	// pipe layer 1
	always @(posedge clk) begin

		// app * app
		app_sqr_m <= {1'b1,app_mant[22:6]} * {1'b1,app_mant[22:6]};
		app_sqr_e <= {app_exp,1'b0} - 8'h7f;
	
		// app * in/2
		app_hlf_m <= {1'b1,app_mant[22:6]} * {1'b1,in_mant[22:6]};
		app_hlf_e <= in_exp + app_exp - 8'h7f - 8'h1;

		// 1.5 * app
		op5_m <= {1'b1,app_mant} + {1'b0,1'b1,app_mant[22:1]};
		op5_e <= app_exp;
	end


	reg [35:0] chunk_m;
	reg [8:0] chunk_e; 
	reg [24:0] op5_m_r;
	reg [8:0] op5_e_r;
	
	// pipe layer 2
	always @(posedge clk) begin
	
		// app^3 * in/2
		chunk_m <= app_sqr_m[35:18] * app_hlf_m[35:18];
		chunk_e <= app_sqr_e[7:0] + app_hlf_e[7:0] - 8'h7f;
	
		op5_m_r <= op5_m;
		op5_e_r <= op5_e;
	end

	
	// work on op5 - chunk
	//    ironically much harder to subtract than multiply FP's
	//
	
	wire [3:0] exp_delta = op5_e_r[7:0] - chunk_e[7:0];
	wire [24:0] scaled_chunk = (chunk_m[35:13] >> exp_delta) << 4;
	reg [24:0] rough_m;
	reg [7:0] rough_e;
		
	// pipe layer 3
	always @(posedge clk) begin
		rough_m <= op5_m_r - scaled_chunk;
		rough_e <= op5_e_r;
	end

	wire [31:0] scaled_m;
	wire [4:0] distance;

	scale_up sc (.in({rough_m[24:0],7'b0}),.out(scaled_m),.distance(distance));
		defparam sc .WIDTH = 32;
		defparam sc .WIDTH_DIST = 5;
	
	reg [22:0] scaled_m_r;
	reg [7:0] distance_r;
	reg [7:0] rough_e_r;
	
	// pipe_layer 4
	always @(posedge clk) begin
		scaled_m_r <= scaled_m[30:8];
		distance_r <= distance;
		rough_e_r <= rough_e;
	end
	
	reg [22:0] out_m;
	reg [7:0] out_e;
	
	// pipe layer 5
	always @(posedge clk) begin
		out_m <= scaled_m_r;
		out_e <= rough_e_r - distance_r + 1;
	end		

	assign out = {1'b0,out_e,out_m};
end

endgenerate

endmodule



