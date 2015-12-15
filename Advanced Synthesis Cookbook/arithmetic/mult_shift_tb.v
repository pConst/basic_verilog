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

///////////////////////////////////////////
// Testbench
///////////////////////////////////////////
// Needs the altmult_add model in quartus/eda/sim_lib/altera_mf.v 
// as well as the stratix II atom models.

module mult_shift_tb ();

reg fail;
reg clk,ena_in,ena_out,rst,a_signed,b_signed;
reg shift_not_mult,direction_right,shift_not_rot;
reg [31:0] data_a,data_b;
wire [63:0] data_o_w, data_o_x, data_o_y, data_o_z;

mult_shift_32_32 w (
	.clk(clk),.ena_in(ena_in),.ena_out(ena_out),.rst(rst),
	.a_signed(a_signed),.b_signed(b_signed),
	.data_a(data_a),.data_b(data_b),
	.data_o(data_o_w),
	.shift_not_mult(shift_not_mult),
	.direction_right(direction_right),
	.shift_not_rot(shift_not_rot)
);	

mult_32_32 x (.clk(clk),.ena_in(ena_in),.ena_out(ena_out),.rst(rst),
	.a_signed(a_signed),.b_signed(b_signed),
	.data_a(data_a),.data_b(data_b),
	.data_o(data_o_x));

cpu_mult_cell y (.A_en(ena_out),
	.E_ctrl_mul_cell_src1_signed(a_signed),
	.E_ctrl_mul_cell_src2_signed(b_signed),
	.E_src1_mul_cell(data_a),
	.E_src2_mul_cell(data_b),
	.M_en(ena_in),
	.clk(clk),
	.reset_n(!rst),
	.A_mul_cell_result(data_o_y)
);


///////////////////////////////////////////
// functional model
///////////////////////////////////////////
reg mult_showing_r, mult_showing_rr;
wire signed [32:0] tmp_a;
wire signed [32:0] tmp_b;
wire signed [71:0] tmp_mult;
assign tmp_a = {a_signed & data_a[31],data_a};
assign tmp_b = {b_signed & data_b[31],data_b};
assign tmp_mult = tmp_a * tmp_b;

wire [31:0] tmp_shr = data_a >> data_b[4:0];
wire [31:0] tmp_shl = data_a << data_b[4:0];
wire [63:0] double_a = {data_a,data_a};
wire [63:0] signext_a = {{32{a_signed & data_a[31]}} ,data_a};
wire [31:0] tmp_ror = (double_a >> data_b[4:0]);
wire [31:0] tmp_rol = (double_a << data_b[4:0]) >> 32;
wire [31:0] tmp_asr = (signext_a >> data_b[4:0]);

wire [63:0] tmp_result = !shift_not_mult ? tmp_mult[63:0] :
			{32'b0,
			(shift_not_rot ? (direction_right ? 
								(a_signed ? tmp_asr : tmp_shr) : tmp_shl) :
							 (direction_right ? tmp_ror : tmp_rol)
			)};
	
reg [63:0] wait_x,wait_y;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		wait_x <= 0;
		wait_y <= 0;
		mult_showing_r <= 1'b0;
		mult_showing_rr <= 1'b0;

	end
	else begin
		if (ena_in) begin
			wait_x <= tmp_result[63:0];
			mult_showing_r <= !shift_not_mult;
		end
		if (ena_out) begin
			wait_y <= wait_x;
			mult_showing_rr <= mult_showing_r;
		end
	end
end
assign data_o_z = wait_y;


///////////////////////////////////////////
// test stim and verify
///////////////////////////////////////////

initial begin
  clk = 1;
  rst = 0;
  ena_in = 1;
  ena_out = 1;
  fail = 0;
  a_signed = 0;
  b_signed = 0;
  #10 rst = 1;
  #10 rst = 0;
  #5000000 if (!fail) $display ("PASS");
  $stop();
end

always @(negedge clk) begin
	ena_in = $random;
	ena_out = $random;
	shift_not_mult = $random;
	direction_right = $random;
	shift_not_rot = $random;
	a_signed = $random;
	b_signed = $random;
	data_a = $random;
	data_b = $random;
end

always begin 
  #500 clk = ~clk;	
end

always @(negedge clk) begin

	// compare pure multiplier against altmult version
	#10 if (data_o_x !== data_o_y) begin
		$display ("Simple MULT Mismatch at time %d",$time);
		fail = 1;
	end

	// compare multshift unit against functional model
	if (data_o_w !== data_o_z) begin
		$display ("Shift MULT unit Mismatch at time %d",$time);
		fail = 1;
	end

	// when in multiply mode compare between mult and multshift
	// units
	if (mult_showing_rr) begin
		if (data_o_x !== data_o_z) begin
			$display ("Mult showing - cross unit mismatch at time %d",$time);
			fail = 1;
		end
	end
end

endmodule

///////////////////////////////////////////////////////
// altmult based multiplier used by NIOS, for
// testing purposes.
//
// The altmult_add model is in the quartus/eda/sim_lib/altera_mf.v 
// library.
///////////////////////////////////////////////////////

module cpu_mult_cell (
                       // inputs:
                        A_en,
                        E_ctrl_mul_cell_src1_signed,
                        E_ctrl_mul_cell_src2_signed,
                        E_src1_mul_cell,
                        E_src2_mul_cell,
                        M_en,
                        clk,
                        reset_n,

                       // outputs:
                        A_mul_cell_result
                     )
;

  output  [ 63: 0] A_mul_cell_result;
  input            A_en;
  input            E_ctrl_mul_cell_src1_signed;
  input            E_ctrl_mul_cell_src2_signed;
  input   [ 31: 0] E_src1_mul_cell;
  input   [ 31: 0] E_src2_mul_cell;
  input            M_en;
  input            clk;
  input            reset_n;

  wire    [ 63: 0] A_mul_cell_result;
  wire             mul_clr;
  assign mul_clr = ~reset_n;
  altmult_add the_altmult_add
    (
      .aclr0 (mul_clr),
      .aclr1 (mul_clr),
      .clock0 (clk),
      .clock1 (clk),
      .dataa (E_src1_mul_cell),
      .datab (E_src2_mul_cell),
      .ena0 (M_en),
      .ena1 (A_en),
      .result (A_mul_cell_result),
      .signa (E_ctrl_mul_cell_src1_signed),
      .signb (E_ctrl_mul_cell_src2_signed)
    );

  defparam the_altmult_add.addnsub_multiplier_aclr1 = "UNUSED",
           the_altmult_add.addnsub_multiplier_pipeline_aclr1 = "UNUSED",
           the_altmult_add.addnsub_multiplier_register1 = "CLOCK0",
           the_altmult_add.dedicated_multiplier_circuitry = "YES",
           the_altmult_add.input_aclr_a0 = "ACLR0",
           the_altmult_add.input_aclr_b0 = "ACLR0",
           the_altmult_add.input_register_a0 = "CLOCK0",
           the_altmult_add.input_register_b0 = "CLOCK0",
           the_altmult_add.input_source_a0 = "DATAA",
           the_altmult_add.input_source_b0 = "DATAB",
           the_altmult_add.lpm_type = "altmult_add",
           the_altmult_add.multiplier1_direction = "ADD",
           the_altmult_add.multiplier_register0 = "UNREGISTERED",
           the_altmult_add.number_of_multipliers = 1,
           the_altmult_add.output_aclr = "ACLR1",
           the_altmult_add.output_register = "CLOCK1",
           the_altmult_add.signed_aclr_a = "ACLR0",
           the_altmult_add.signed_aclr_b = "ACLR0",
           the_altmult_add.signed_pipeline_register_a = "UNREGISTERED",
           the_altmult_add.signed_pipeline_register_b = "UNREGISTERED",
           the_altmult_add.signed_register_a = "CLOCK0",
           the_altmult_add.signed_register_b = "CLOCK0",
           the_altmult_add.width_a = 32,
           the_altmult_add.width_b = 32,
           the_altmult_add.width_result = 64;


endmodule

