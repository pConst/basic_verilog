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

// baeckler - 03-31-2006
//
// mult_32_32 : 32 x 32 pipelined multiply with sign control
//
// mult_shift_32_32 : 32 x 32 pipelined multiply with sign control 
//			and shift-rot mode.  Derived from NIOS ALU design.
//

///////////////////////////////////////////
// 18 x 18 mult native building block
///////////////////////////////////////////

module mac_mult_18_18 (clk,ena,rst,sign_a,sign_b,data_a,data_b,data_o);
input clk,ena,rst;
input sign_a,sign_b;
input [17:0] data_a;
input [17:0] data_b;
output [35:0] data_o;

parameter GND_SIGNA = "false";
parameter GND_SIGNB = "false";

stratixii_mac_mult mult_a (
  .signa(sign_a),
  .signb(sign_b),
  .sourcea(1'b0),
  .sourceb(1'b0),
  .round(1'b0),
  .saturate(1'b0),
  .clk({1'b0,1'b0,1'b0,clk}),
  .aclr({1'b0,1'b0,1'b0,rst}),
  .ena({1'b1,1'b1,1'b1,ena}),
  .dataa(data_a),
  .datab(data_b),
  .scanina(18'b0),
  .scaninb(18'b0),
  .scanouta(),
  .scanoutb(),
  
  // synthesis translate off
  // simulation only ports
  .devpor(1'b1),
  .devclrn(1'b1),
  .zeroacc(1'b0),
  .mode(1'b0),
  // synthesis translate on
  
  .dataout(data_o)  
 );

defparam mult_a .dataa_width = 18;
defparam mult_a .datab_width = 18;
defparam mult_a .dataa_clock = "0";
defparam mult_a .datab_clock = "0";
defparam mult_a .signa_clock = "0";
defparam mult_a .signb_clock = "0";
defparam mult_a .output_clock = "none";
defparam mult_a .dataa_clear = "0";
defparam mult_a .datab_clear = "0";
defparam mult_a .signa_clear = "0";
defparam mult_a .signb_clear = "0";
defparam mult_a .output_clear = "none";
defparam mult_a .round_clock = "none";
defparam mult_a .saturate_clock = "none";
defparam mult_a .mode_clock = "none";
defparam mult_a .zeroacc_clock = "none";
defparam mult_a .round_clear = "none";
defparam mult_a .saturate_clear = "none";
defparam mult_a .mode_clear = "none";
defparam mult_a .zeroacc_clear = "none";
defparam mult_a .bypass_multiplier = "no";
defparam mult_a .dynamic_mode = "no";
defparam mult_a .signa_internally_grounded = GND_SIGNA;
defparam mult_a .signb_internally_grounded = GND_SIGNB;
endmodule

///////////////////////////////////////////
// 36 x 36 MAC output building block
///////////////////////////////////////////

module mac_out (clk,ena_in,ena_out,rst,sign_a,sign_b,data_a,data_b,data_c,data_d,data_o);
input clk,ena_in,ena_out,rst;
input sign_a,sign_b;
input [35:0] data_a,data_b,data_c,data_d;
output [71:0] data_o;

stratixii_mac_out m_out (
  .multabsaturate(1'b0),
  .multcdsaturate(1'b0),
  .signa(sign_a),
  .signb(sign_b),
  .clk({1'b0,1'b0,clk,clk}),
  .aclr({1'b0,1'b0,rst,1'b0}),
  .ena({1'b1,1'b1,ena_out,ena_in}),
  .dataa(data_a),
  .datab(data_b),
  .datac(data_c),
  .datad(data_d),
  .dataout(data_o),
  
  // synthesis translate off
  // simulation only ports
  .saturate(1'b0),
  .saturate1(1'b0),
  .devpor(1'b1),
  .devclrn(1'b1),
  .zeroacc(1'b0),
  .zeroacc1(1'b0),
  .mode0(1'b0),
  .mode1(1'b0),
  .accoverflow(),
  // synthesis translate on

  .round0(1'b0),
  .round1(1'b0),
  .addnsub0(1'b0),
  .addnsub1(1'b0)
);
defparam m_out .operation_mode = "36_bit_multiply";
defparam m_out .dataa_width = 36;
defparam m_out .datab_width = 36;
defparam m_out .datac_width = 36;
defparam m_out .datad_width = 36;
defparam m_out .dataout_width = 72;
defparam m_out .addnsub0_clock = "none";
defparam m_out .addnsub1_clock = "none";
defparam m_out .zeroacc_clock = "none";
defparam m_out .signa_clock = "0";
defparam m_out .signb_clock = "0";
defparam m_out .round0_clock = "none";
defparam m_out .round1_clock = "none";
defparam m_out .saturate_clock = "none";
defparam m_out .multabsaturate_clock = "none";
defparam m_out .multcdsaturate_clock = "none";
defparam m_out .mode0_clock = "none";
defparam m_out .mode1_clock = "none";
defparam m_out .zeroacc1_clock = "none";
defparam m_out .saturate1_clock = "none";
defparam m_out .output_clock = "1";
defparam m_out .addnsub0_pipeline_clock = "none";
defparam m_out .addnsub1_pipeline_clock = "none";
defparam m_out .zeroacc_pipeline_clock = "none";
defparam m_out .signa_pipeline_clock = "none";
defparam m_out .signb_pipeline_clock = "none";
defparam m_out .round0_pipeline_clock = "none";
defparam m_out .round1_pipeline_clock = "none";
defparam m_out .saturate_pipeline_clock = "none";
defparam m_out .multabsaturate_pipeline_clock = "none";
defparam m_out .multcdsaturate_pipeline_clock = "none";
defparam m_out .mode0_pipeline_clock = "none";
defparam m_out .mode1_pipeline_clock = "none";
defparam m_out .zeroacc1_pipeline_clock = "none";
defparam m_out .saturate1_pipeline_clock = "none";
defparam m_out .addnsub0_clear = "none";
defparam m_out .addnsub1_clear = "none";
defparam m_out .zeroacc_clear = "none";
defparam m_out .signa_clear = "1";
defparam m_out .signb_clear = "1";
defparam m_out .round0_clear = "none";
defparam m_out .round1_clear = "none";
defparam m_out .saturate_clear = "none";
defparam m_out .multabsaturate_clear = "none";
defparam m_out .multcdsaturate_clear = "none";
defparam m_out .mode0_clear = "none";
defparam m_out .mode1_clear = "none";
defparam m_out .zeroacc1_clear = "none";
defparam m_out .saturate1_clear = "none";
defparam m_out .output_clear = "1";
defparam m_out .addnsub0_pipeline_clear = "none";
defparam m_out .addnsub1_pipeline_clear = "none";
defparam m_out .zeroacc_pipeline_clear = "none";
defparam m_out .signa_pipeline_clear = "none";
defparam m_out .signb_pipeline_clear = "none";
defparam m_out .round0_pipeline_clear = "none";
defparam m_out .round1_pipeline_clear = "none";
defparam m_out .saturate_pipeline_clear = "none";
defparam m_out .multabsaturate_pipeline_clear = "none";
defparam m_out .multcdsaturate_pipeline_clear = "none";
defparam m_out .mode0_pipeline_clear = "none";
defparam m_out .mode1_pipeline_clear = "none";
defparam m_out .zeroacc1_pipeline_clear = "none";
defparam m_out .saturate1_pipeline_clear = "none";
defparam m_out .output1_clock = "none";
defparam m_out .output2_clock = "none";
defparam m_out .output3_clock = "none";
defparam m_out .output4_clock = "none";
defparam m_out .output5_clock = "none";
defparam m_out .output6_clock = "none";
defparam m_out .output7_clock = "none";
defparam m_out .output1_clear = "none";
defparam m_out .output2_clear = "none";
defparam m_out .output3_clear = "none";
defparam m_out .output4_clear = "none";
defparam m_out .output5_clear = "none";
defparam m_out .output6_clear = "none";
defparam m_out .output7_clear = "none";
defparam m_out .dataa_forced_to_zero = "no";
defparam m_out .datac_forced_to_zero = "no";
endmodule

///////////////////////////////////////////
// 32x32 mult with sign control
///////////////////////////////////////////

module mult_32_32 (clk,ena_in,ena_out,rst,a_signed,b_signed,data_a,data_b,data_o);
input clk,ena_in,ena_out,rst;
input a_signed,b_signed;
input [31:0] data_a,data_b;
output [63:0] data_o;

wire [35:0] m0_out,m1_out,m2_out,m3_out;
wire [71:0] m_out;

mac_mult_18_18 m0 (.clk(clk),.ena(ena_in),.rst(rst),
		.sign_a(a_signed), .sign_b(b_signed),
		.data_a({data_a[13:0],4'b0}),
		.data_b({data_b[13:0],4'b0}),
		.data_o(m0_out));
	defparam m0 .GND_SIGNA = "true";
	defparam m0 .GND_SIGNB = "true";

mac_mult_18_18 m1 (.clk(clk),.ena(ena_in),.rst(rst),
		.sign_a(a_signed), .sign_b(b_signed),
		.data_a(data_a[31:14]),
		.data_b(data_b[31:14]),
		.data_o(m1_out));
	defparam m1 .GND_SIGNA = "false";
	defparam m1 .GND_SIGNB = "false";

mac_mult_18_18 m2 (.clk(clk),.ena(ena_in),.rst(rst),
		.sign_a(a_signed), .sign_b(b_signed),
		.data_a(data_a[31:14]),
		.data_b({data_b[13:0],4'b0}),
		.data_o(m2_out));
	defparam m2 .GND_SIGNA = "false";
	defparam m2 .GND_SIGNB = "true";

mac_mult_18_18 m3 (.clk(clk),.ena(ena_in),.rst(rst),
		.sign_a(a_signed), .sign_b(b_signed),
		.data_a({data_a[13:0],4'b0}),
		.data_b(data_b[31:14]),
		.data_o(m3_out));
	defparam m3 .GND_SIGNA = "true";
	defparam m3 .GND_SIGNB = "false";

mac_out mo (.clk(clk),.ena_in(ena_in),.ena_out(ena_out),.rst(rst),
		.sign_a(a_signed), .sign_b(b_signed),
		.data_a(m0_out),.data_b(m1_out),.data_c(m2_out),.data_d(m3_out),
		.data_o(m_out));

assign data_o = m_out[71:8];

endmodule


///////////////////////////////////////////////////
// 32x32 mult with sign control / shift / rotate
///////////////////////////////////////////////////

module mult_shift_32_32 (clk,ena_in,ena_out,rst,
		shift_not_mult,direction_right,shift_not_rot,
		a_signed,b_signed,
		data_a,data_b,data_o
);
input clk,ena_in,ena_out,rst;
input a_signed,b_signed;
input shift_not_mult,direction_right,shift_not_rot;
input [31:0] data_a,data_b;
output [63:0] data_o;

wire [35:0] m0_out,m1_out,m2_out,m3_out;
wire [71:0] m_out;

wire [31:0] data_b_adj;

// ignore sign A when rotating
wire a_sign_int = a_signed & (!shift_not_mult | shift_not_rot);

// ignore sign B when rotating or shifting
wire b_sign_int = b_signed & !shift_not_mult;

// compute 2^n using 5 bits of input B for shift and rotate modes
// before the 1st clock edge.
wire [31:0] data_b_twon /* synthesis keep */;
genvar i;
generate
  for (i=0; i<32; i=i+1)
  begin : twon
	assign data_b_twon[i] = (!direction_right && (data_b[4:0] ==  i)) ||
		(direction_right && (data_b[4:0] ==  (32-i))) ||
		(direction_right && (data_b[4:0] == 0) && (i == 0));
  end
endgenerate
assign data_b_adj = shift_not_mult ? data_b_twon : data_b;

// create delayed shift controls.
reg shift_not_mult_r,direction_right_r,shift_not_rot_r;
reg shift_not_mult_rr,direction_right_rr,shift_not_rot_rr;
always @(posedge clk or posedge rst) begin
	if (rst) begin
		shift_not_mult_r <= 1'b0;
		direction_right_r <= 1'b0;
		shift_not_rot_r <= 1'b0;
		shift_not_mult_rr <= 1'b0;
		direction_right_rr <= 1'b0;
		shift_not_rot_rr <= 1'b0;
	end
	else begin
		if (ena_in) begin
			shift_not_mult_r <= shift_not_mult;
			shift_not_rot_r <= shift_not_rot;
			
			// if some joker asks for right 0 change it to
			// left 0.
			direction_right_r <= (|data_b[4:0]) && direction_right;
		end
		
		if (ena_out) begin
			shift_not_mult_rr <= shift_not_mult_r;
			direction_right_rr <= direction_right_r;
			shift_not_rot_rr <= shift_not_rot_r;
		end
	end
end

// 32 x 32 MAC multiplier
mac_mult_18_18 m0 (.clk(clk),.ena(ena_in),.rst(rst),
		.sign_a(a_sign_int), .sign_b(b_sign_int),
		.data_a({data_a[13:0],4'b0}),
		.data_b({data_b_adj[13:0],4'b0}),
		.data_o(m0_out));
	defparam m0 .GND_SIGNA = "true";
	defparam m0 .GND_SIGNB = "true";

mac_mult_18_18 m1 (.clk(clk),.ena(ena_in),.rst(rst),
		.sign_a(a_sign_int), .sign_b(b_sign_int),
		.data_a(data_a[31:14]),
		.data_b(data_b_adj[31:14]),
		.data_o(m1_out));
	defparam m1 .GND_SIGNA = "false";
	defparam m1 .GND_SIGNB = "false";

mac_mult_18_18 m2 (.clk(clk),.ena(ena_in),.rst(rst),
		.sign_a(a_sign_int), .sign_b(b_sign_int),
		.data_a(data_a[31:14]),
		.data_b({data_b_adj[13:0],4'b0}),
		.data_o(m2_out));
	defparam m2 .GND_SIGNA = "false";
	defparam m2 .GND_SIGNB = "true";

mac_mult_18_18 m3 (.clk(clk),.ena(ena_in),.rst(rst),
		.sign_a(a_sign_int), .sign_b(b_sign_int),
		.data_a({data_a[13:0],4'b0}),
		.data_b(data_b_adj[31:14]),
		.data_o(m3_out));
	defparam m3 .GND_SIGNA = "true";
	defparam m3 .GND_SIGNB = "false";

mac_out mo (.clk(clk),.ena_in(ena_in),.ena_out(ena_out),.rst(rst),
		.sign_a(a_sign_int), .sign_b(b_sign_int),
		.data_a(m0_out),.data_b(m1_out),.data_c(m2_out),.data_d(m3_out),
		.data_o(m_out));

// output side shifter logic
assign data_o = !shift_not_mult_rr ? m_out[71:8] : 
			(shift_not_rot_rr ? (direction_right_rr ? m_out[71:40] : m_out[39:8])
						   : (m_out[71:40] | m_out[39:8]));

endmodule
