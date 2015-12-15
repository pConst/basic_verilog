// Copyright 2011 Altera Corporation. All rights reserved.  
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

module x4_encoder_tb ();

reg       clk;
reg       rst_n;
reg       kin_ena;
reg       ein_ena;
reg [7:0] ein_dat;
wire       ein_rd;

wire eout_val_a;
wire [9:0] eout_dat_a;
wire  eout_rdcomb_a, eout_rdreg_a;

///////////////////////////////////////////
// x1 test units 
///////////////////////////////////////////

encoder_8b10b dut_a (
    .clk(clk),
    .rst(!rst_n),
    .kin_ena(kin_ena),
    .ein_ena(ein_ena),
    .ein_dat(ein_dat),
    .ein_rd(ein_rd),
    .eout_val(eout_val_a),
    .eout_dat(eout_dat_a),
    .eout_rdcomb(eout_rdcomb_a),
    .eout_rdreg(eout_rdreg_a)
);
assign ein_rd = eout_rdreg_a;

wire k_c,kerr_c,rderr_c;
wire [7:0] dat_c;

decoder_8b10b dut_c (  
    .clk(clk),
    .rst(!rst_n),
    .din_ena(1'b1),
    .din_dat(eout_dat_a),
    .din_rd(rdreg_c),
    .dout_val(),
    .dout_dat(dat_c),
    .dout_k(k_c),
    .dout_kerr(kerr_c),
    .dout_rderr(rderr_c),
    .dout_rdcomb(),
    .dout_rdreg(rdreg_c)
);

///////////////////////////////////////////
// x4 test units 
///////////////////////////////////////////

reg x4_clk;
reg [31:0] x4_ein_dat;
reg [3:0] x4_kin_ena;
wire [39:0] x4_eout_dat;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		x4_ein_dat <= 0;
		x4_kin_ena <= 0;
	end
	else begin
		x4_ein_dat <= (x4_ein_dat << 8) | ein_dat;
		x4_kin_ena <= (x4_kin_ena << 1) | kin_ena;
	end
end

x4_encoder_8b10b dut_b (
    .clk(x4_clk),
    .rst(!rst_n),
    .kin_ena(x4_kin_ena),            // Data in is a special code, not all are legal.      
    .ein_dat(x4_ein_dat),            // 8b data in
    .eout_dat(x4_eout_dat)           // data out
);

// break up result for visibility
wire [9:0] w0,w1,w2,w3;
assign {w0,w1,w2,w3} = x4_eout_dat;

wire [31:0] x4_dat_recovered;
wire [3:0] x4_k_recovered;
wire [3:0] x4_kerr,x4_rderr;

x4_decoder_8b10b dut_d(
	.clk(x4_clk),
	.rst(!rst_n),
	.din_dat(x4_eout_dat),         // 10b data input
	.dout_dat(x4_dat_recovered),        // data out
	.dout_k(x4_k_recovered),          // special code
	.dout_kerr(x4_kerr),       // coding mistake detected
	.dout_rderr(x4_rderr),      // running disparity mistake detected
	.dout_rdcomb(),     // running dispartiy output (comb)
	.dout_rdreg()       // running disparity output (reg)
);

///////////////////////////////////////////
// not all data for transmit is legal.
///////////////////////////////////////////
reg [3:0] tmp;
always @(negedge clk or negedge rst_n) begin
	ein_ena = $random;
	kin_ena = !ein_ena;
	tmp = $random % 4'hd;

	if (kin_ena) begin
		case (tmp)	
			// valid K signals
			4'h0 : ein_dat = 8'b000_11100;
			4'h1 : ein_dat = 8'b000_11100;
			4'h2 : ein_dat = 8'b001_11100;
			4'h3 : ein_dat = 8'b010_11100;
			4'h4 : ein_dat = 8'b011_11100;
			4'h5 : ein_dat = 8'b100_11100;
			4'h6 : ein_dat = 8'b101_11100;
			4'h7 : ein_dat = 8'b110_11100;
			4'h8 : ein_dat = 8'b111_11100;
			4'h9 : ein_dat = 8'b111_10111;
			4'ha : ein_dat = 8'b111_11011;
			4'hb : ein_dat = 8'b111_11101;
			4'hc : ein_dat = 8'b111_11110;
		//	4'hd : ein_dat = 8'b111_11111;
			default : ein_dat = 0;
		endcase
	end
	else
		ein_dat = $random;
end

///////////////////////////////////////////
// clock driver
///////////////////////////////////////////
initial begin
	clk = 0;
	x4_clk = 1;
	rst_n = 1;
	#1 rst_n = 0;
	@(negedge clk) rst_n = 1;
end

always begin
	#5 clk = ~clk;
end

always begin
	@(posedge clk);
	if (!rst_n) begin
		@(negedge clk);
		@(negedge clk);
	end
	@(negedge clk);
	x4_clk = ~x4_clk;
	@(negedge clk);
	@(negedge clk);
	x4_clk = ~x4_clk;	
	@(negedge clk);
end

endmodule 