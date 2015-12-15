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

// baeckler - 04-10-2006
// an 8b10b encoder, based on files from Martin R and IBM paper

module encoder_8b10b (
    clk,
    rst,
    kin_ena,		// Data in is a special code, not all are legal.	
    ein_ena,		// Data (or code) input enable
    ein_dat,		// 8b data in
    ein_rd,			// running disparity input
    eout_val,		// data out is valid
    eout_dat,		// data out
    eout_rdcomb,	// running disparity output (comb)
    eout_rdreg		// running disparity output (reg)
);

// method = 0 is generic for comparison / test
// method = 1 is speed optimized

parameter METHOD = 1;

input       clk;
input       rst;
input       kin_ena;
input       ein_ena;
input [7:0] ein_dat;
input       ein_rd;
output      eout_val;
output[9:0] eout_dat;
output      eout_rdcomb;
output      eout_rdreg;

wire        ein_rd;
wire        ein_ena;
wire  [7:0] ein_dat;
reg         eout_val;
reg   [9:0] eout_dat;

wire A = ein_dat[0];
wire B = ein_dat[1];
wire C = ein_dat[2];
wire D = ein_dat[3];
wire E = ein_dat[4];
wire F = ein_dat[5];
wire G = ein_dat[6];
wire H = ein_dat[7];
wire K = kin_ena;

reg  rd1_part /* synthesis keep */;
reg rd1;

reg  eout_rdcomb;
reg  eout_rdreg;
reg SorK;
reg  a,b,c,d,e,f,g,h,i,j;

generate
if (METHOD == 0) begin
	//classification
	wire L04 = (!A & !B & !C & !D);
	wire L13 = (!A & !B & !C & D) | (!A & !B & C & !D) | (!A & B & !C & !D) | (A & !B & !C & !D);
	wire L22 = (!A & !B & C & D) | (!A & B & C & !D) | (A & B & !C & !D) | (A & !B & C & !D) | (A & !B & !C & D)  | (!A & B & !C & D);
	wire L31 = (A & B & C & !D) | (A & B & !C & D) | (A & !B & C & D) | (!A & B & C & D);
	wire L40 = (A & B & C & D);

	wire disp0 = (!L22 & !L31 & !E);	
	wire disp1 = (L31 & !D & !E);		
	wire disp2 = (L13 &  D &  E);
	wire disp3 = (!L22 & !L13 &  E);
	wire invert_ai = !(ein_rd ? (disp3 | disp1 | K) : (disp0 | disp2));
	
	always @(*)
	begin
		a = !A ^ invert_ai;
		b = ((L04) ? 0 : (L40) ? 1 :!B) ^ invert_ai;
		c = ((L04) ? 0 : (L13 & D & E) ? 0 : !C)  ^ invert_ai;
		d = ((L40) ? 1 : !D) ^ invert_ai;
		e = ((L13 & !E) ? 0 : (L13 & D & E) ? 1 : !E) ^ invert_ai;
		i = ((L22 & !E) ? 0 : (L04 & E) ? 0 : (L13 & !D & E) ? 0 :
			(L40 & E) ? 0 : (L22 & K) ? 0 : 1) ^ invert_ai;
		
		rd1_part = (disp0 | disp2 | disp3);
		rd1 = (rd1_part | K) ^ ein_rd;
	end

	always @(*)
	begin
		SorK = ( e &  i & !rd1) | (!e & !i & rd1) | K;
	end
		
	wire disp4 = (!F & !G);
	wire disp5 = (F & G);
	wire disp6 = ((F ^ G) & K);
	wire invert_fj = !(rd1 ? disp5 : (disp4 | disp6));

	always @(*)
	begin
		f = ((F & G & H & (SorK)) ? 1 : !F) ^ invert_fj;
		g = ((!F & !G & !H) ? 0 : !G) ^ invert_fj; 
		h = (!H) ^ invert_fj;
		j = (((F ^ G) & !H) ? 0 : (F & G & H & (SorK)) ? 0 : 1) ^ invert_fj;
		eout_rdcomb = (disp4 | (F & G & H)) ^ rd1;
	end
end
else if (METHOD == 1) begin
	wire rdout_x,rdout_y;
	
	stratixii_lcell_comb rdoutx (
		  .dataa (!B),.datab (!D),.datac (!E),.datad (!A),.datae (!C),.dataf (!K),.datag(1'b1),
		  .cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
		  .combout(rdout_x));
		defparam rdoutx .lut_mask = 64'h157E7EE800000000;
		defparam rdoutx .shared_arith = "off";
		defparam rdoutx .extended_lut = "off";
	
	stratixii_lcell_comb rdouty (
		  .dataa (!H),.datab (!ein_rd),.datac (!F),.datad (!G),.datae (!rdout_x),.dataf (!rdout_x),.datag(1'b1),
		  .cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
		  .combout(rdout_y));
		defparam rdouty .lut_mask = 64'h3CC99663699CC336;
		defparam rdouty .shared_arith = "off";
		defparam rdouty .extended_lut = "off";

	always @(*) begin
		eout_rdcomb = rdout_y;

		case ({ein_rd,ein_dat[4:0],kin_ena})
			7'h00 : {i,e,d,c,b,a} = 6'h39;
			7'h01 : {i,e,d,c,b,a} = 6'h39;
			7'h02 : {i,e,d,c,b,a} = 6'h2e;
			7'h03 : {i,e,d,c,b,a} = 6'h2e;
			7'h04 : {i,e,d,c,b,a} = 6'h2d;
			7'h05 : {i,e,d,c,b,a} = 6'h2d;
			7'h06 : {i,e,d,c,b,a} = 6'h23;
			7'h07 : {i,e,d,c,b,a} = 6'h23;
			7'h08 : {i,e,d,c,b,a} = 6'h2b;
			7'h09 : {i,e,d,c,b,a} = 6'h2b;
			7'h0a : {i,e,d,c,b,a} = 6'h25;
			7'h0b : {i,e,d,c,b,a} = 6'h25;
			7'h0c : {i,e,d,c,b,a} = 6'h26;
			7'h0d : {i,e,d,c,b,a} = 6'h26;
			7'h0e : {i,e,d,c,b,a} = 6'h07;
			7'h0f : {i,e,d,c,b,a} = 6'h07;
			7'h10 : {i,e,d,c,b,a} = 6'h27;
			7'h11 : {i,e,d,c,b,a} = 6'h27;
			7'h12 : {i,e,d,c,b,a} = 6'h29;
			7'h13 : {i,e,d,c,b,a} = 6'h29;
			7'h14 : {i,e,d,c,b,a} = 6'h2a;
			7'h15 : {i,e,d,c,b,a} = 6'h2a;
			7'h16 : {i,e,d,c,b,a} = 6'h0b;
			7'h17 : {i,e,d,c,b,a} = 6'h0b;
			7'h18 : {i,e,d,c,b,a} = 6'h2c;
			7'h19 : {i,e,d,c,b,a} = 6'h2c;
			7'h1a : {i,e,d,c,b,a} = 6'h0d;
			7'h1b : {i,e,d,c,b,a} = 6'h0d;
			7'h1c : {i,e,d,c,b,a} = 6'h0e;
			7'h1d : {i,e,d,c,b,a} = 6'h0e;
			7'h1e : {i,e,d,c,b,a} = 6'h3a;
			7'h1f : {i,e,d,c,b,a} = 6'h3a;
			7'h20 : {i,e,d,c,b,a} = 6'h36;
			7'h21 : {i,e,d,c,b,a} = 6'h36;
			7'h22 : {i,e,d,c,b,a} = 6'h31;
			7'h23 : {i,e,d,c,b,a} = 6'h31;
			7'h24 : {i,e,d,c,b,a} = 6'h32;
			7'h25 : {i,e,d,c,b,a} = 6'h32;
			7'h26 : {i,e,d,c,b,a} = 6'h13;
			7'h27 : {i,e,d,c,b,a} = 6'h33;
			7'h28 : {i,e,d,c,b,a} = 6'h34;
			7'h29 : {i,e,d,c,b,a} = 6'h34;
			7'h2a : {i,e,d,c,b,a} = 6'h15;
			7'h2b : {i,e,d,c,b,a} = 6'h35;
			7'h2c : {i,e,d,c,b,a} = 6'h16;
			7'h2d : {i,e,d,c,b,a} = 6'h36;
			7'h2e : {i,e,d,c,b,a} = 6'h17;
			7'h2f : {i,e,d,c,b,a} = 6'h17;
			7'h30 : {i,e,d,c,b,a} = 6'h33;
			7'h31 : {i,e,d,c,b,a} = 6'h33;
			7'h32 : {i,e,d,c,b,a} = 6'h19;
			7'h33 : {i,e,d,c,b,a} = 6'h39;
			7'h34 : {i,e,d,c,b,a} = 6'h1a;
			7'h35 : {i,e,d,c,b,a} = 6'h3a;
			7'h36 : {i,e,d,c,b,a} = 6'h1b;
			7'h37 : {i,e,d,c,b,a} = 6'h1b;
			7'h38 : {i,e,d,c,b,a} = 6'h1c;
			7'h39 : {i,e,d,c,b,a} = 6'h3c;
			7'h3a : {i,e,d,c,b,a} = 6'h1d;
			7'h3b : {i,e,d,c,b,a} = 6'h1d;
			7'h3c : {i,e,d,c,b,a} = 6'h1e;
			7'h3d : {i,e,d,c,b,a} = 6'h1e;
			7'h3e : {i,e,d,c,b,a} = 6'h35;
			7'h3f : {i,e,d,c,b,a} = 6'h35;
			7'h40 : {i,e,d,c,b,a} = 6'h06;
			7'h41 : {i,e,d,c,b,a} = 6'h39;
			7'h42 : {i,e,d,c,b,a} = 6'h11;
			7'h43 : {i,e,d,c,b,a} = 6'h2e;
			7'h44 : {i,e,d,c,b,a} = 6'h12;
			7'h45 : {i,e,d,c,b,a} = 6'h2d;
			7'h46 : {i,e,d,c,b,a} = 6'h23;
			7'h47 : {i,e,d,c,b,a} = 6'h1c;
			7'h48 : {i,e,d,c,b,a} = 6'h14;
			7'h49 : {i,e,d,c,b,a} = 6'h2b;
			7'h4a : {i,e,d,c,b,a} = 6'h25;
			7'h4b : {i,e,d,c,b,a} = 6'h1a;
			7'h4c : {i,e,d,c,b,a} = 6'h26;
			7'h4d : {i,e,d,c,b,a} = 6'h19;
			7'h4e : {i,e,d,c,b,a} = 6'h38;
			7'h4f : {i,e,d,c,b,a} = 6'h38;
			7'h50 : {i,e,d,c,b,a} = 6'h18;
			7'h51 : {i,e,d,c,b,a} = 6'h27;
			7'h52 : {i,e,d,c,b,a} = 6'h29;
			7'h53 : {i,e,d,c,b,a} = 6'h16;
			7'h54 : {i,e,d,c,b,a} = 6'h2a;
			7'h55 : {i,e,d,c,b,a} = 6'h15;
			7'h56 : {i,e,d,c,b,a} = 6'h0b;
			7'h57 : {i,e,d,c,b,a} = 6'h34;
			7'h58 : {i,e,d,c,b,a} = 6'h2c;
			7'h59 : {i,e,d,c,b,a} = 6'h13;
			7'h5a : {i,e,d,c,b,a} = 6'h0d;
			7'h5b : {i,e,d,c,b,a} = 6'h32;
			7'h5c : {i,e,d,c,b,a} = 6'h0e;
			7'h5d : {i,e,d,c,b,a} = 6'h31;
			7'h5e : {i,e,d,c,b,a} = 6'h05;
			7'h5f : {i,e,d,c,b,a} = 6'h3a;
			7'h60 : {i,e,d,c,b,a} = 6'h09;
			7'h61 : {i,e,d,c,b,a} = 6'h09;
			7'h62 : {i,e,d,c,b,a} = 6'h31;
			7'h63 : {i,e,d,c,b,a} = 6'h0e;
			7'h64 : {i,e,d,c,b,a} = 6'h32;
			7'h65 : {i,e,d,c,b,a} = 6'h0d;
			7'h66 : {i,e,d,c,b,a} = 6'h13;
			7'h67 : {i,e,d,c,b,a} = 6'h0c;
			7'h68 : {i,e,d,c,b,a} = 6'h34;
			7'h69 : {i,e,d,c,b,a} = 6'h0b;
			7'h6a : {i,e,d,c,b,a} = 6'h15;
			7'h6b : {i,e,d,c,b,a} = 6'h0a;
			7'h6c : {i,e,d,c,b,a} = 6'h16;
			7'h6d : {i,e,d,c,b,a} = 6'h09;
			7'h6e : {i,e,d,c,b,a} = 6'h28;
			7'h6f : {i,e,d,c,b,a} = 6'h28;
			7'h70 : {i,e,d,c,b,a} = 6'h0c;
			7'h71 : {i,e,d,c,b,a} = 6'h33;
			7'h72 : {i,e,d,c,b,a} = 6'h19;
			7'h73 : {i,e,d,c,b,a} = 6'h06;
			7'h74 : {i,e,d,c,b,a} = 6'h1a;
			7'h75 : {i,e,d,c,b,a} = 6'h05;
			7'h76 : {i,e,d,c,b,a} = 6'h24;
			7'h77 : {i,e,d,c,b,a} = 6'h24;
			7'h78 : {i,e,d,c,b,a} = 6'h1c;
			7'h79 : {i,e,d,c,b,a} = 6'h03;
			7'h7a : {i,e,d,c,b,a} = 6'h22;
			7'h7b : {i,e,d,c,b,a} = 6'h22;
			7'h7c : {i,e,d,c,b,a} = 6'h21;
			7'h7d : {i,e,d,c,b,a} = 6'h21;
			7'h7e : {i,e,d,c,b,a} = 6'h0a;
			7'h7f : {i,e,d,c,b,a} = 6'h0a;
		endcase

		case (ein_dat[4:0])
			5'h00 : rd1_part = 1'b1;	
			5'h01 : rd1_part = 1'b1;
			5'h02 : rd1_part = 1'b1;
			5'h03 : rd1_part = 1'b0;
			5'h04 : rd1_part = 1'b1;
			5'h05 : rd1_part = 1'b0;
			5'h06 : rd1_part = 1'b0;
			5'h07 : rd1_part = 1'b0;
			5'h08 : rd1_part = 1'b1;
			5'h09 : rd1_part = 1'b0;
			5'h0a : rd1_part = 1'b0;
			5'h0b : rd1_part = 1'b0;
			5'h0c : rd1_part = 1'b0;
			5'h0d : rd1_part = 1'b0;
			5'h0e : rd1_part = 1'b0;
			5'h0f : rd1_part = 1'b1;
			5'h10 : rd1_part = 1'b1;
			5'h11 : rd1_part = 1'b0;
			5'h12 : rd1_part = 1'b0;
			5'h13 : rd1_part = 1'b0;
			5'h14 : rd1_part = 1'b0;
			5'h15 : rd1_part = 1'b0;
			5'h16 : rd1_part = 1'b0;
			5'h17 : rd1_part = 1'b1;
			5'h18 : rd1_part = 1'b1;
			5'h19 : rd1_part = 1'b0;
			5'h1a : rd1_part = 1'b0;
			5'h1b : rd1_part = 1'b1;
			5'h1c : rd1_part = 1'b0;
			5'h1d : rd1_part = 1'b1;
			5'h1e : rd1_part = 1'b1;
			5'h1f : rd1_part = 1'b1;
		endcase
	end
		
	wire disp4 = (!F & !G);
	wire disp5 = (F & G);
	wire disp6 = ((F ^ G) & K);
	wire invert_fj = !(((rd1_part | K) ^ ein_rd) ? disp5 : (disp4 | disp6));
	
	always @(*)
	begin
		g = (!(!F & !H) & !G) ^ invert_fj; 
		h = (!H) ^ invert_fj;
	end

	wire f0,f1,f2,f3,f4;

	stratixii_lcell_comb f0_I (
		.dataa(!ein_dat[3]),
		.datab(!ein_dat[4]),
		.datac(!ein_dat[1]),
		.datad(!ein_dat[2]),
		.datae(!ein_dat[0]),
		.dataf(1'b1),.datag(1'b1),
		.cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
		.combout(f0 ));
	defparam f0_I .shared_arith = "off";
	defparam f0_I .extended_lut = "off";
	defparam f0_I .lut_mask = 64'h0224244002242440;

	stratixii_lcell_comb f1_I (
		.dataa(!ein_rd),
		.datab(!ein_dat[7]),
		.datac(!ein_dat[6]),
		.datad(!ein_dat[5]),
		.datae(!kin_ena),
		.dataf(1'b1),.datag(1'b1),
		.cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
		.combout(f1 ));
	defparam f1_I .shared_arith = "off";
	defparam f1_I .extended_lut = "off";
	defparam f1_I .lut_mask = 64'h0F03AA590F03AA59;

	stratixii_lcell_comb f2_I (
		.dataa(!ein_rd),
		.datab(!ein_dat[7]),
		.datac(!ein_dat[6]),
		.datad(!ein_dat[5]),
		.datae(!kin_ena),
		.dataf(1'b1),.datag(1'b1),
		.cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
		.combout(f2 ));
	defparam f2_I .shared_arith = "off";
	defparam f2_I .extended_lut = "off";
	defparam f2_I .lut_mask = 64'h00F355A600F355A6;

	stratixii_lcell_comb f3_I (
		.dataa(!f4 ),
		.datab(!f0 ),
		.datac(!ein_rd),
		.datad(!f1 ),
		.datae(!f2 ),
		.dataf(1'b1),.datag(1'b1),
		.cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
		.combout(f3 ));
	defparam f3_I .shared_arith = "off";
	defparam f3_I .extended_lut = "off";
	defparam f3_I .lut_mask = 64'h7800FF597800FF59;

	stratixii_lcell_comb f4_I (
		.dataa(!ein_dat[3]),
		.datab(!ein_dat[4]),
		.datac(!ein_dat[1]),
		.datad(!ein_dat[2]),
		.datae(!ein_dat[0]),
		.dataf(1'b1),.datag(1'b1),
		.cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
		.combout(f4 ));
	defparam f4_I .shared_arith = "off";
	defparam f4_I .extended_lut = "off";
	defparam f4_I .lut_mask = 64'h055E5EE8055E5EE8;

	always @(*)
	begin
		f = f3;
	end

	wire j0,j1,j2,j3,j4,j5;

	stratixii_lcell_comb j0_I (
		.dataa(!ein_dat[1]),
		.datab(!ein_dat[3]),
		.datac(!ein_dat[4]),
		.datad(!ein_dat[2]),
		.datae(!ein_dat[0]),
		.dataf(1'b1),.datag(1'b1),
		.cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
		.combout(j0 ));
	defparam j0_I .shared_arith = "off";
	defparam j0_I .extended_lut = "off";
	defparam j0_I .lut_mask = 64'h117676E8117676E8;

	stratixii_lcell_comb j1_I (
		.dataa(!ein_dat[1]),
		.datab(!ein_dat[3]),
		.datac(!ein_dat[4]),
		.datad(!ein_dat[2]),
		.datae(!ein_dat[0]),
		.dataf(1'b1),.datag(1'b1),
		.cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
		.combout(j1 ));
	defparam j1_I .shared_arith = "off";
	defparam j1_I .extended_lut = "off";
	defparam j1_I .lut_mask = 64'h0418182004181820;

		stratixii_lcell_comb j2_I (
		.dataa(!ein_rd),
		.datab(!ein_dat[7]),
		.datac(!ein_dat[5]),
		.datad(!ein_dat[6]),
		.datae(!kin_ena),
		.dataf(1'b1),.datag(1'b1),
		.cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
		.combout(j2 ));
	defparam j2_I .shared_arith = "off";
	defparam j2_I .extended_lut = "off";
	defparam j2_I .lut_mask = 64'h5339A6665339A666;

	stratixii_lcell_comb j3_I (
		.datac(!ein_dat[5]),
		.datad(!ein_dat[6]),
		.datae(!kin_ena),
		.dataa(1'b1),.datab(1'b1),.dataf(1'b1),.datag(1'b1),
		.cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
		.combout(j3 ));
	defparam j3_I .shared_arith = "off";
	defparam j3_I .extended_lut = "off";
	defparam j3_I .lut_mask = 64'hF00F0000F00F0000;

	stratixii_lcell_comb j4_I (
		.datab(!ein_dat[7]),
		.datac(!ein_dat[5]),
		.datad(!ein_dat[6]),
		.datae(!kin_ena),
		.dataa(1'b1),.dataf(1'b1),.datag(1'b1),
		.cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
		.combout(j4 ));
	defparam j4_I .shared_arith = "off";
	defparam j4_I .extended_lut = "off";
	defparam j4_I .lut_mask = 64'h0003000000030000;

	stratixii_lcell_comb j5_I (
		.dataa(!j0 ),
		.datab(!j1 ),
		.datac(!j2 ),
		.datad(!j3 ),
		.datae(!j4 ),
		.dataf(1'b1),.datag(1'b1),
		.cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
		.combout(j5 ));
	defparam j5_I .shared_arith = "off";
	defparam j5_I .extended_lut = "off";
	defparam j5_I .lut_mask = 64'hF07870A6F07870A6;

	always @(*)
	begin
		j = j5;
	end
end

endgenerate

always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        eout_rdreg <= 0;
        eout_val <= 0;
        eout_dat <= 0;
    end
    else
    begin
        eout_val <= 0;
       if (ein_ena | kin_ena)
        begin
            eout_rdreg <= eout_rdcomb;
            eout_val <=  ein_ena | kin_ena;
            eout_dat <= {j,h,g,f,i,e,d,c,b,a};
        end
    end
end


endmodule
