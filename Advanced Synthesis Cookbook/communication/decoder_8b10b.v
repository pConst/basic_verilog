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
// an 8b10b decoder, based on files from Martin R and IBM paper

module decoder_8b10b (
    clk,
    rst,			
    din_ena,			// 10b data ready
    din_dat,			// 10b data input
    din_rd,				// running disparity input
    dout_val,			// data out valid		
    dout_dat,			// data out
    dout_k,				// special code
    dout_kerr,			// coding mistake detected
    dout_rderr,			// running disparity mistake detected
    dout_rdcomb,		// running disparity output (comb)
    dout_rdreg			// running disparity output (reg)
);

parameter RDERR = 1;
parameter KERR = 1;

// method = 0 is generic for comparison / test
// method = 1 is speed optimized
parameter METHOD = 1;

input       clk;
input       rst;
input       din_ena;
input [9:0] din_dat;
input       din_rd;
output      dout_val;
output[7:0] dout_dat;
output      dout_k;
output      dout_kerr;
output      dout_rderr;
output      dout_rdcomb;
output      dout_rdreg;

//reg [9:0] din_dat;

reg         dout_val;
reg   [7:0] dout_dat;
reg         dout_k;
reg         dout_kerr;
reg         dout_rderr;
reg         dout_rdreg;

wire a = din_dat[0];
wire b = din_dat[1];
wire c = din_dat[2];
wire d = din_dat[3];
wire e = din_dat[4];
wire i = din_dat[5];
wire f = din_dat[6];
wire g = din_dat[7];
wire h = din_dat[8];
wire j = din_dat[9];


//classification
wire P04 = (!a & !b & !c & !d);
wire P13 = (!a & !b & !c & d) | (!a & !b & c & !d) | (!a & b & !c & !d) | (a & !b & !c & !d);
wire P22 = (!a & !b & c & d) | (!a & b & c & !d) | (a & b & !c & !d) | (a & !b & c & !d) | (a & !b & !c & d)  | (!a & b & !c & d);
wire P31 = (a & b & c & !d) | (a & b & !c & d) | (a & !b & c & d) | (!a & b & c & d);
wire P40 = (a & b & c & d);


////////////////////////////////////////////////
// data outputs
////////////////////////////////////////////////

wire A = (P22 & !b & !c & !(e^i)) ? !a :
         (P31 & i) ? !a :
         (P13 & d & e & i) ? !a :
         (P22 & !a & !c & !(e^i)) ? !a :
         (P13 & !e) ? !a :
         (a & b & e & i) ? !a :
         (!c & !d & !e & !i) ? !a :
         a;
wire B = (P22 & b & c & !(e^i)) ? !b :
         (P31 & i) ? !b :
         (P13 & d & e & i) ? !b :
         (P22 & a & c & !(e^i)) ? !b :
         (P13 & !e) ? !b :
         (a & b & e & i) ? !b :
         (!c & !d & !e & !i) ? !b :
         b;
wire C = (P22 & b & c & !(e^i)) ? !c :
         (P31 & i) ? !c :
         (P13 & d & e & i) ? !c :
         (P22 & !a & !c & !(e^i)) ? !c :
         (P13 & !e) ? !c :
         (!a & !b & !e & !i) ? !c :
         (!c & !d & !e & !i) ? !c :
         c;
wire D = (P22 & !b & !c & !(e^i)) ? !d :
         (P31 & i) ? !d :
         (P13 & d & e & i) ? !d :
         (P22 & a & c & !(e^i)) ? !d :
         (P13 & !e) ? !d :
         (a & b & e & i) ? !d :
         (!c & !d & !e & !i) ? !d :
         d;
wire E = (P22 & !b & !c & !(e^i)) ? !e :
         (P13 & !i) ? !e :
         (P13 & d & e & i) ? !e :
         (P22 & !a & !c & !(e^i)) ? !e :
         (P13 & !e) ? !e :
         (!a & !b & !e & !i) ? !e :
         (!c & !d & !e & !i) ? !e :
         e;


wire F = (f & h & j) ? !f :
         (!c & !d & !e & !i & (h^j)) ? !f :
         (!f & !g & h & j) ? !f :
         (f & g & j) ? !f :
         (!f & !g & !h) ? !f :
         (g & h & j) ? !f :
         f;
wire G = (!f & !h & !j) ? !g :
         (!c & !d & !e & !i & (h^j)) ? !g :
         (!f & !g & h & j) ? !g :
         (f & g & j) ? !g :
         (!f & !g & !h) ? !g :
         (!g & !h & !j) ? !g :
         g;
wire H = (f & h & j) ? !h :
         (!c & !d & !e & !i & (h^j)) ? !h :
         (!f & !g & h & j) ? !h :
         (f & g & j) ? !h :
         (!f & !g & !h) ? !h :
         (!g & !h & !j) ? !h :
         h;


wire K = (c & d & e & i) |
         (!c & !d & !e & !i) |
         (P13 & !e & i & g & h & j) |
         (P31 & e & !i & !g & !h & !j);


////////////////////////////////////////////////
//running disparity - generate and err check
////////////////////////////////////////////////
wire rd1n = (P04) ? 1 :
            (P13 & !(e & i)) ? 1 :
            (P22 & !e & !i) ? 1 :
            (P13 & d & e & i) ? 1 :
            0 /* synthesis keep */;
wire rd1p = (P40) ? 1 :
            (P31 & !(!e & !i)) ? 1 :
            (P22 & e & i) ? 1 :
            (P31 & !d & !e & !i) ? 1 :
            0 /* synthesis keep */;
wire rd1e = (P13 & !d & e & i) ? 1 :
            (P22 & (e ^ i)) ? 1 :
            (P31 & d & !e & !i) ? 1 :
            0 /* synthesis keep */;

wire rd1_err = (!din_rd & rd1n) | (din_rd & rd1p);

/////////////////////////////
// factored rd1 generation
/////////////////////////////
wire [63:0] rd1_when_din_rd_0_mask = 64'hffe8e880e8808000;
wire rd1_when_din_rd_0 = rd1_when_din_rd_0_mask[din_dat[5:0]] /* synthesis keep */;
wire [63:0] rd1_when_din_rd_1_mask = 64'hfffefee8fee8e800;
wire rd1_when_din_rd_1 = rd1_when_din_rd_1_mask[din_dat[5:0]] /* synthesis keep */;
wire rd1 = din_rd ? rd1_when_din_rd_1 : rd1_when_din_rd_0;

wire rd2n = (!f & !g & !h) ? 1 :
            (!f & !g & !j) ? 1 :
            (!f & !h & !j) ? 1 :
            (!g & !h & !j) ? 1 :
            (!f & !g & h & j) ? 1 :
            0 /* synthesis keep */;
wire rd2p = (f & g & h) ? 1 :
            (f & g & j) ? 1 :
            (f & h & j) ? 1 :
            (g & h & j) ? 1 :
            (f & g & !h & !j) ? 1 :
            0 /* synthesis keep */;
wire rd2e = ((f ^ g) & (h ^ j)) ? 1 :
            0;

wire rd2_err = (!rd1 & rd2n) | (rd1 & rd2p);


// these two conditions appear in rd2p and rd2n with the
// opposite associated rdcomb output.
wire dout_rdcomb_special = (!f & !g &  h &  j) |
							( f &  g & !h & !j) /* synthesis keep */;

wire dout_rdcomb = (rd2p) ? !dout_rdcomb_special :
                   (rd2n) ? dout_rdcomb_special :
                   rd1;

////////////////////////////////////////////////
// K error check - this is by far the most
//   complex expression in the decoder. 
//   It appears to require depth 3.  Please let
//   me know if you identify a depth 2 mapping.
////////////////////////////////////////////////
wire k_err;
generate
	if (METHOD == 0) begin

		assign k_err = //5b6b errors
             (P04) ? 1 :
             (P13 & !e & !i) ? 1 :
             (P31 & e & i) ? 1 :
             (P40) ? 1 :
             //3b4b errors
             ( f &  g &  h &  j) ? 1 :
             (!f & !g & !h & !j) ? 1 :

             //any 2nd phase rd error, except if rd1 is even
             (rd2_err & !rd1e) ? 1 :

             // + some odd ones, dx.7 - specials ...
             // d11.7,d13.7,d14.7,d17.7,d18.7,d20.7  use 1000/0111
             // k23.7,k27.7,k29.7,k30.7 are legal    use 1000/0111
             // other x.7                            use 0001/1110

             // P22 & xxxx01 1110 - ok, d12.7
             // P22 & xxxx10 1110 - ok, d28.7
             // P22 & 011000 1110 - ok, d0.7
             // P22 & 101000 1110 - ok, d15.7
             // P22 & 100100 1110 - ok, d16.7
             // P22 & 001100 1110 - ok, d24.7
             // P22 & 010100 1110 - ok, d31.7
             // P22 & 110000 1110 - illegal
             //       xxxx11 1110 - illegal
             ( a &  b & !c & !d & !e & !i &  f &  g &  h & !j) ? 1 :
             (                     e &  i &  f &  g &  h & !j) ? 1 :

             // P22 & xxxx01 0001 - ok, d6.7
             // P31 & xxxx01 0001 - ok, d1.7
             // P31 & xxxx10 0001 - ok, d23.7
             // P22 & xxxx10 0001 - ok, d19.7
             // P13 & xxxx11 0001 - ok, d7.7
             //       110011 0001 - ok, d24.7
             //       101011 0001 - ok, d31.7
             //       011011 0001 - ok, d16.7
             //       100111 0001 - ok, d0.7
             //       010111 0001 - ok, d15.7
             //       001111 0001 - illegal
             //       xxxx00 0001 - illegal
             (!a & !b &  c &  d &  e &  i & !f & !g & !h &  j) ? 1 :
             (                    !e & !i & !f & !g & !h &  j) ? 1 :

             //       110000 0111 - ok, k28.7
             // P13 & xxxx01 0111 = ok, kxx.7
             //       100011 0111 = ok, d17.7
             //       010011 0111 = ok, d18.7
             //       001011 0111 = ok, d20.7
             //       000111 0111 = illegal (rderr)
             // else  xxxxxx 0111 - illegal
             (!(P22 & !c & !d)        & !e & !i & !f & g & h & j) ? 1 :
             (!(P13)                  & !e &  i & !f & g & h & j) ? 1 :
             (!(P13 & (a | b | c))    &  e &  i & !f & g & h & j) ? 1 :
             (                           e & !i & !f & g & h & j) ? 1 :

             //       001111 1000 - ok, k28.7
             // P31 & xxxx10 1000 = ok, kxx.7
             //       110100 1000 - ok, d11.7
             //       101100 1000 - ok, d13.7
             //       011100 1000 - ok, d14.7
             //       111000 1000 - illegal (rderr)
             // else  xxxxxx 1000 - illegal
             (!(P22 & c & d)          &  e &  i & f & !g & !h & !j) ? 1 :
             (!(P31)                  &  e & !i & f & !g & !h & !j) ? 1 :
             (!(P31 & (!a | !b | !c)) & !e & !i & f & !g & !h & !j) ? 1 :
             (                          !e &  i & f & !g & !h & !j) ? 1 :

             0;
	end
	else if (METHOD == 1) begin
		/////////////////////////////////////
		// use the upper and lower portions only
		// to identify definite errors
		/////////////////////////////////////
		wire [63:0] kerr_mask_ai = 64'h6881800180018117;							   
		wire [63:0] kerr_mask_ej = 64'hf20000018000004f;
		wire kerr_out_ai =  kerr_mask_ai[din_dat[5:0]] /* synthesis keep */;
		wire kerr_out_ej =  kerr_mask_ej[din_dat[9:4]] /* synthesis keep */;
		wire rd2_err_lc = rd2_err /* synthesis keep */;

		wire kerr6,kerr7,kerr8,kerr9,kerr_remainder;
		stratixii_lcell_comb kerr6_I (
			.datab(!din_dat[7]),
			.datac(!din_dat[6]),
			.datad(!din_dat[8]),
			.datae(!din_dat[9]),
			.dataa(1'b1),.dataf(1'b1),.datag(1'b1),
			.cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
			.combout(kerr6 ));
		defparam kerr6_I .shared_arith = "off";
		defparam kerr6_I .extended_lut = "off";
		defparam kerr6_I .lut_mask = 64'h0C0000300C000030;

		stratixii_lcell_comb kerr7_I (
			.dataa(!din_dat[3]),
			.datab(!din_dat[7]),
			.datac(!din_dat[6]),
			.datad(!din_dat[8]),
			.datae(!din_dat[9]),
			.dataf(1'b1),.datag(1'b1),
			.cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
			.combout(kerr7 ));
		defparam kerr7_I .shared_arith = "off";
		defparam kerr7_I .extended_lut = "off";
		defparam kerr7_I .lut_mask = 64'h0002403000024030;

		stratixii_lcell_comb kerr8_I (
			.dataa(!din_dat[0]),
			.datab(!din_dat[1]),
			.datac(!din_dat[2]),
			.datad(!din_dat[4]),
			.datae(!din_dat[3]),
			.dataf(1'b1),.datag(1'b1),
			.cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
			.combout(kerr8 ));
		defparam kerr8_I .shared_arith = "off";
		defparam kerr8_I .extended_lut = "off";
		defparam kerr8_I .lut_mask = 64'h6868960868689608;

		stratixii_lcell_comb kerr9_I (
			.dataa(!din_dat[0]),
			.datab(!din_dat[1]),
			.datac(!din_dat[2]),
			.datad(!din_dat[4]),
			.datae(!din_dat[3]),
			.dataf(1'b1),.datag(1'b1),
			.cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
			.combout(kerr9 ));
		defparam kerr9_I .shared_arith = "off";
		defparam kerr9_I .extended_lut = "off";
		defparam kerr9_I .lut_mask = 64'h1001161E1001161E;

		stratixii_lcell_comb kerr_rem_I (
			.dataa(!din_dat[5]),
			.datab(!kerr6 ),
			.datac(!kerr7 ),
			.datad(!din_dat[4]),
			.datae(!kerr8 ),
			.dataf(!kerr9 ),
			.datag(1'b1),
			.cin(1'b1),.sharein(1'b0),.sumout(),.cout(),.shareout(),
			.combout(kerr_remainder ));
		defparam kerr_rem_I .shared_arith = "off";
		defparam kerr_rem_I .extended_lut = "off";
		defparam kerr_rem_I .lut_mask = 64'h2331223029110325;

		assign k_err = kerr_out_ai | kerr_out_ej | 
					rd2_err_lc & !rd1e |
					kerr_remainder;
	end
endgenerate

////////////////////////////////////////////////
// output registers
////////////////////////////////////////////////
always @(posedge clk or posedge rst)
begin
    if (rst)
    begin
        dout_k <= 0;
        dout_val <= 0;
        dout_dat <= 0;
        dout_rdreg <= 0;
        dout_rderr <= 0;
        dout_kerr <= 0;
    end
    else
    begin
        dout_val <= 0;
        if (din_ena)
        begin
            dout_k <= K;
            dout_val <= din_ena;
            dout_dat <= {H,G,F,E,D,C,B,A};
            dout_rdreg <= dout_rdcomb;
			dout_rderr <= (RDERR) ? (rd1_err | rd2_err) : 0;
            dout_kerr <= (KERR) ? k_err : 0;
        end
    end
end


endmodule
