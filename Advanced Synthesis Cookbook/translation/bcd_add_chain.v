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

/////////////////////////////////////////////////////
module non_carry_add (ina,inb,sum);
parameter WIDTH = 10;

input [WIDTH-1:0] ina,inb;
output [WIDTH-1:0] sum;
wire [WIDTH-1:0] sum;

wire [WIDTH:0] cin;
assign cin[0] = 1'b0;

genvar i;
generate
  for (i=0; i<WIDTH; i=i+1) 
  begin : chn
	assign sum[i] = ina[i] ^ inb[i] ^ cin[i];
	assign cin[i+1] = (ina[i] & inb[i])	| (ina[i] & cin[i])	| (cin[i] & inb[i]);
  end
endgenerate
endmodule


/////////////////////////////////////////////////////
module bcd_digit_add (ina,inb,sum,carry_in,carry_out);
input [3:0] ina,inb;
output [3:0] sum;
input carry_in;
output carry_out;

parameter METHOD = 3;

reg carry_out;
reg [3:0] sum;

generate
  if (METHOD == 0) begin
    always @(*) begin
      case ({carry_in,ina,inb})
        9'h000 : {carry_out,sum} = 5'h00;
        9'h100 : {carry_out,sum} = 5'h01;
        9'h001 : {carry_out,sum} = 5'h01;
        9'h101 : {carry_out,sum} = 5'h02;
        9'h002 : {carry_out,sum} = 5'h02;
        9'h102 : {carry_out,sum} = 5'h03;
        9'h003 : {carry_out,sum} = 5'h03;
        9'h103 : {carry_out,sum} = 5'h04;
        9'h004 : {carry_out,sum} = 5'h04;
        9'h104 : {carry_out,sum} = 5'h05;
        9'h005 : {carry_out,sum} = 5'h05;
        9'h105 : {carry_out,sum} = 5'h06;
        9'h006 : {carry_out,sum} = 5'h06;
        9'h106 : {carry_out,sum} = 5'h07;
        9'h007 : {carry_out,sum} = 5'h07;
        9'h107 : {carry_out,sum} = 5'h08;
        9'h008 : {carry_out,sum} = 5'h08;
        9'h108 : {carry_out,sum} = 5'h09;
        9'h009 : {carry_out,sum} = 5'h09;
        9'h109 : {carry_out,sum} = 5'h10;
        9'h010 : {carry_out,sum} = 5'h01;
        9'h110 : {carry_out,sum} = 5'h02;
        9'h011 : {carry_out,sum} = 5'h02;
        9'h111 : {carry_out,sum} = 5'h03;
        9'h012 : {carry_out,sum} = 5'h03;
        9'h112 : {carry_out,sum} = 5'h04;
        9'h013 : {carry_out,sum} = 5'h04;
        9'h113 : {carry_out,sum} = 5'h05;
        9'h014 : {carry_out,sum} = 5'h05;
        9'h114 : {carry_out,sum} = 5'h06;
        9'h015 : {carry_out,sum} = 5'h06;
        9'h115 : {carry_out,sum} = 5'h07;
        9'h016 : {carry_out,sum} = 5'h07;
        9'h116 : {carry_out,sum} = 5'h08;
        9'h017 : {carry_out,sum} = 5'h08;
        9'h117 : {carry_out,sum} = 5'h09;
        9'h018 : {carry_out,sum} = 5'h09;
        9'h118 : {carry_out,sum} = 5'h10;
        9'h019 : {carry_out,sum} = 5'h10;
        9'h119 : {carry_out,sum} = 5'h11;
        9'h020 : {carry_out,sum} = 5'h02;
        9'h120 : {carry_out,sum} = 5'h03;
        9'h021 : {carry_out,sum} = 5'h03;
        9'h121 : {carry_out,sum} = 5'h04;
        9'h022 : {carry_out,sum} = 5'h04;
        9'h122 : {carry_out,sum} = 5'h05;
        9'h023 : {carry_out,sum} = 5'h05;
        9'h123 : {carry_out,sum} = 5'h06;
        9'h024 : {carry_out,sum} = 5'h06;
        9'h124 : {carry_out,sum} = 5'h07;
        9'h025 : {carry_out,sum} = 5'h07;
        9'h125 : {carry_out,sum} = 5'h08;
        9'h026 : {carry_out,sum} = 5'h08;
        9'h126 : {carry_out,sum} = 5'h09;
        9'h027 : {carry_out,sum} = 5'h09;
        9'h127 : {carry_out,sum} = 5'h10;
        9'h028 : {carry_out,sum} = 5'h10;
        9'h128 : {carry_out,sum} = 5'h11;
        9'h029 : {carry_out,sum} = 5'h11;
        9'h129 : {carry_out,sum} = 5'h12;
        9'h030 : {carry_out,sum} = 5'h03;
        9'h130 : {carry_out,sum} = 5'h04;
        9'h031 : {carry_out,sum} = 5'h04;
        9'h131 : {carry_out,sum} = 5'h05;
        9'h032 : {carry_out,sum} = 5'h05;
        9'h132 : {carry_out,sum} = 5'h06;
        9'h033 : {carry_out,sum} = 5'h06;
        9'h133 : {carry_out,sum} = 5'h07;
        9'h034 : {carry_out,sum} = 5'h07;
        9'h134 : {carry_out,sum} = 5'h08;
        9'h035 : {carry_out,sum} = 5'h08;
        9'h135 : {carry_out,sum} = 5'h09;
        9'h036 : {carry_out,sum} = 5'h09;
        9'h136 : {carry_out,sum} = 5'h10;
        9'h037 : {carry_out,sum} = 5'h10;
        9'h137 : {carry_out,sum} = 5'h11;
        9'h038 : {carry_out,sum} = 5'h11;
        9'h138 : {carry_out,sum} = 5'h12;
        9'h039 : {carry_out,sum} = 5'h12;
        9'h139 : {carry_out,sum} = 5'h13;
        9'h040 : {carry_out,sum} = 5'h04;
        9'h140 : {carry_out,sum} = 5'h05;
        9'h041 : {carry_out,sum} = 5'h05;
        9'h141 : {carry_out,sum} = 5'h06;
        9'h042 : {carry_out,sum} = 5'h06;
        9'h142 : {carry_out,sum} = 5'h07;
        9'h043 : {carry_out,sum} = 5'h07;
        9'h143 : {carry_out,sum} = 5'h08;
        9'h044 : {carry_out,sum} = 5'h08;
        9'h144 : {carry_out,sum} = 5'h09;
        9'h045 : {carry_out,sum} = 5'h09;
        9'h145 : {carry_out,sum} = 5'h10;
        9'h046 : {carry_out,sum} = 5'h10;
        9'h146 : {carry_out,sum} = 5'h11;
        9'h047 : {carry_out,sum} = 5'h11;
        9'h147 : {carry_out,sum} = 5'h12;
        9'h048 : {carry_out,sum} = 5'h12;
        9'h148 : {carry_out,sum} = 5'h13;
        9'h049 : {carry_out,sum} = 5'h13;
        9'h149 : {carry_out,sum} = 5'h14;
        9'h050 : {carry_out,sum} = 5'h05;
        9'h150 : {carry_out,sum} = 5'h06;
        9'h051 : {carry_out,sum} = 5'h06;
        9'h151 : {carry_out,sum} = 5'h07;
        9'h052 : {carry_out,sum} = 5'h07;
        9'h152 : {carry_out,sum} = 5'h08;
        9'h053 : {carry_out,sum} = 5'h08;
        9'h153 : {carry_out,sum} = 5'h09;
        9'h054 : {carry_out,sum} = 5'h09;
        9'h154 : {carry_out,sum} = 5'h10;
        9'h055 : {carry_out,sum} = 5'h10;
        9'h155 : {carry_out,sum} = 5'h11;
        9'h056 : {carry_out,sum} = 5'h11;
        9'h156 : {carry_out,sum} = 5'h12;
        9'h057 : {carry_out,sum} = 5'h12;
        9'h157 : {carry_out,sum} = 5'h13;
        9'h058 : {carry_out,sum} = 5'h13;
        9'h158 : {carry_out,sum} = 5'h14;
        9'h059 : {carry_out,sum} = 5'h14;
        9'h159 : {carry_out,sum} = 5'h15;
        9'h060 : {carry_out,sum} = 5'h06;
        9'h160 : {carry_out,sum} = 5'h07;
        9'h061 : {carry_out,sum} = 5'h07;
        9'h161 : {carry_out,sum} = 5'h08;
        9'h062 : {carry_out,sum} = 5'h08;
        9'h162 : {carry_out,sum} = 5'h09;
        9'h063 : {carry_out,sum} = 5'h09;
        9'h163 : {carry_out,sum} = 5'h10;
        9'h064 : {carry_out,sum} = 5'h10;
        9'h164 : {carry_out,sum} = 5'h11;
        9'h065 : {carry_out,sum} = 5'h11;
        9'h165 : {carry_out,sum} = 5'h12;
        9'h066 : {carry_out,sum} = 5'h12;
        9'h166 : {carry_out,sum} = 5'h13;
        9'h067 : {carry_out,sum} = 5'h13;
        9'h167 : {carry_out,sum} = 5'h14;
        9'h068 : {carry_out,sum} = 5'h14;
        9'h168 : {carry_out,sum} = 5'h15;
        9'h069 : {carry_out,sum} = 5'h15;
        9'h169 : {carry_out,sum} = 5'h16;
        9'h070 : {carry_out,sum} = 5'h07;
        9'h170 : {carry_out,sum} = 5'h08;
        9'h071 : {carry_out,sum} = 5'h08;
        9'h171 : {carry_out,sum} = 5'h09;
        9'h072 : {carry_out,sum} = 5'h09;
        9'h172 : {carry_out,sum} = 5'h10;
        9'h073 : {carry_out,sum} = 5'h10;
        9'h173 : {carry_out,sum} = 5'h11;
        9'h074 : {carry_out,sum} = 5'h11;
        9'h174 : {carry_out,sum} = 5'h12;
        9'h075 : {carry_out,sum} = 5'h12;
        9'h175 : {carry_out,sum} = 5'h13;
        9'h076 : {carry_out,sum} = 5'h13;
        9'h176 : {carry_out,sum} = 5'h14;
        9'h077 : {carry_out,sum} = 5'h14;
        9'h177 : {carry_out,sum} = 5'h15;
        9'h078 : {carry_out,sum} = 5'h15;
        9'h178 : {carry_out,sum} = 5'h16;
        9'h079 : {carry_out,sum} = 5'h16;
        9'h179 : {carry_out,sum} = 5'h17;
        9'h080 : {carry_out,sum} = 5'h08;
        9'h180 : {carry_out,sum} = 5'h09;
        9'h081 : {carry_out,sum} = 5'h09;
        9'h181 : {carry_out,sum} = 5'h10;
        9'h082 : {carry_out,sum} = 5'h10;
        9'h182 : {carry_out,sum} = 5'h11;
        9'h083 : {carry_out,sum} = 5'h11;
        9'h183 : {carry_out,sum} = 5'h12;
        9'h084 : {carry_out,sum} = 5'h12;
        9'h184 : {carry_out,sum} = 5'h13;
        9'h085 : {carry_out,sum} = 5'h13;
        9'h185 : {carry_out,sum} = 5'h14;
        9'h086 : {carry_out,sum} = 5'h14;
        9'h186 : {carry_out,sum} = 5'h15;
        9'h087 : {carry_out,sum} = 5'h15;
        9'h187 : {carry_out,sum} = 5'h16;
        9'h088 : {carry_out,sum} = 5'h16;
        9'h188 : {carry_out,sum} = 5'h17;
        9'h089 : {carry_out,sum} = 5'h17;
        9'h189 : {carry_out,sum} = 5'h18;
        9'h090 : {carry_out,sum} = 5'h09;
        9'h190 : {carry_out,sum} = 5'h10;
        9'h091 : {carry_out,sum} = 5'h10;
        9'h191 : {carry_out,sum} = 5'h11;
        9'h092 : {carry_out,sum} = 5'h11;
        9'h192 : {carry_out,sum} = 5'h12;
        9'h093 : {carry_out,sum} = 5'h12;
        9'h193 : {carry_out,sum} = 5'h13;
        9'h094 : {carry_out,sum} = 5'h13;
        9'h194 : {carry_out,sum} = 5'h14;
        9'h095 : {carry_out,sum} = 5'h14;
        9'h195 : {carry_out,sum} = 5'h15;
        9'h096 : {carry_out,sum} = 5'h15;
        9'h196 : {carry_out,sum} = 5'h16;
        9'h097 : {carry_out,sum} = 5'h16;
        9'h197 : {carry_out,sum} = 5'h17;
        9'h098 : {carry_out,sum} = 5'h17;
        9'h198 : {carry_out,sum} = 5'h18;
        9'h099 : {carry_out,sum} = 5'h18;
        9'h199 : {carry_out,sum} = 5'h19;
        default : {carry_out,sum} = 5'bxxxxx;
      endcase
    end
  end
  else if (METHOD == 1) begin
	////////////////////////////////////
	// adder and subtract 10's variant
    ////////////////////////////////////
	wire [4:0] temp_sum = ina + inb + carry_in;
    always @(*) begin
      carry_out = temp_sum[4] | 
                     temp_sum[3] & (temp_sum[2] | temp_sum[1]);
      sum = temp_sum - {carry_out,1'b0,carry_out,1'b0};
    end
  end
  else if (METHOD == 2) begin
    /////////////////////////////////////////////////
	// adder and subtract 10's variant
    //   re-expressed to discourage carry chain use
	/////////////////////////////////////////////////
	wire [5:0] temp_sum;
	non_carry_add nca (.ina({1'b0,ina,carry_in}),.inb({1'b0,inb,carry_in}),.sum(temp_sum));
		defparam nca .WIDTH = 6;
	
	always @(*) begin
      carry_out = temp_sum[5] | 
                     temp_sum[4] & (temp_sum[3] | temp_sum[2]);
      sum = temp_sum[5:1] - {carry_out,1'b0,carry_out,1'b0};
    end
  end
  else if (METHOD == 3) begin
    /////////////////////////////////////////////////
	// hard logic based on Quartus' output from method 2 
	/////////////////////////////////////////////////
	
	stratixii_lcell_comb helpr_0_I (
		.dataa(!inb[1]),
		.datab(!ina[1]),
		.datac(!carry_in),
		.datad(!ina[0]),
		.datae(!inb[0]),
		.dataf(1'b1),
		.combout(helpr_0 ),
		.shareout(),.cout(),.sharein(1'b0),.cin(1'b0),.sumout(),.datag(1'b1));
	defparam helpr_0_I .shared_arith = "off";
	defparam helpr_0_I .extended_lut = "off";
	defparam helpr_0_I .lut_mask = 64'h6669699966696999;

	stratixii_lcell_comb helpr_1_I (
		.dataa(!inb[1]),
		.datab(!ina[1]),
		.datac(!carry_in),
		.datad(!ina[0]),
		.datae(!inb[0]),
		.combout(helpr_1 ),
		.dataf(1'b1),
		.shareout(),.cout(),.sharein(1'b0),.cin(1'b0),.sumout(),.datag(1'b1));
	defparam helpr_1_I .shared_arith = "off";
	defparam helpr_1_I .extended_lut = "off";
	defparam helpr_1_I .lut_mask = 64'h1117177711171777;

	stratixii_lcell_comb sum_0_I (
		.dataa(!carry_in),
		.datab(!inb[0]),
		.datac(!ina[0]),
		.combout(sum_0),
		.datad(1'b1),.datae(1'b1),.dataf(1'b1),
		.shareout(),.cout(),.sharein(1'b0),.cin(1'b0),.sumout(),.datag(1'b1));
	defparam sum_0_I .shared_arith = "off";
	defparam sum_0_I .extended_lut = "off";
	defparam sum_0_I .lut_mask = 64'h6969696969696969;

	stratixii_lcell_comb sum_1_I (
		.dataa(!helpr_0 ),
		.datab(!helpr_1 ),
		.datac(!ina[3]),
		.datad(!inb[3]),
		.datae(!inb[2]),
		.dataf(!ina[2]),
		.combout(sum_1 ),
		.shareout(),.cout(),.sharein(1'b0),.cin(1'b0),.sumout(),.datag(1'b1));
	defparam sum_1_I .shared_arith = "off";
	defparam sum_1_I .extended_lut = "off";
	defparam sum_1_I .lut_mask = 64'h522A4AAA4AAA2AAA;

	stratixii_lcell_comb sum_2_I (
		.dataa(!helpr_0 ),
		.datab(!helpr_1 ),
		.datac(!ina[3]),
		.datad(!inb[3]),
		.datae(!inb[2]),
		.dataf(!ina[2]),
		.combout(sum_2 ),
		.shareout(),.cout(),.sharein(1'b0),.cin(1'b0),.sumout(),.datag(1'b1));
	defparam sum_2_I .shared_arith = "off";
	defparam sum_2_I .extended_lut = "off";
	defparam sum_2_I .lut_mask = 64'hCEE639993999E666;

	stratixii_lcell_comb sum_3_I (
		.dataa(!helpr_0 ),
		.datab(!helpr_1 ),
		.datac(!ina[3]),
		.datad(!inb[3]),
		.datae(!inb[2]),
		.dataf(!ina[2]),
		.combout(sum_3 ),
		.shareout(),.cout(),.sharein(1'b0),.cin(1'b0),.sumout(),.datag(1'b1));
	defparam sum_3_I .shared_arith = "off";
	defparam sum_3_I .extended_lut = "off";
	defparam sum_3_I .lut_mask = 64'hF778DEE1DEE17887;

//  This version has better area, but leaves the carry
// in two levels deep from the carry out rather than
// one.
//
//	stratixii_lcell_comb cout_cell_I (
//		.dataa(!helpr_0 ),
//		.datab(!helpr_1 ),
//		.datac(!ina[3]),
//		.datad(!inb[3]),		
//		.datae(!inb[2]),
//		.dataf(!ina[2]),		
//		.combout(cout_cell ),
//		.shareout(),.cout(),.sharein(1'b0),.cin(1'b0),.sumout(),.datag(1'b1));
//	defparam cout_cell_I .shared_arith = "off";
//	defparam cout_cell_I .extended_lut = "off";
//	defparam cout_cell_I .lut_mask = 64'h077F1FFF1FFF7FFF;

// this version is modifed to shorting the cin to cout path
	stratixii_lcell_comb cout_cell_h0_I (
		.dataa(!inb[1]),
		.datab(!ina[1] ),
		.datac(!inb[2]),
		.datad(!ina[2]),		
		.datae(!inb[3]),
		.dataf(!ina[3]),		
		.combout(cout_cell_h0 ),
		.shareout(),.cout(),.sharein(1'b0),.cin(1'b0),.sumout(),.datag(1'b1));
	defparam cout_cell_h0_I .shared_arith = "off";
	defparam cout_cell_h0_I .extended_lut = "off";
	defparam cout_cell_h0_I .lut_mask = 64'hfee0000000000000;

	stratixii_lcell_comb cout_cell_h1_I (
		.dataa(!inb[1]),
		.datab(!ina[1] ),
		.datac(!inb[2]),
		.datad(!ina[2]),		
		.datae(!inb[3]),
		.dataf(!ina[3]),		
		.combout(cout_cell_h1 ),
		.shareout(),.cout(),.sharein(1'b0),.cin(1'b0),.sumout(),.datag(1'b1));
	defparam cout_cell_h1_I .shared_arith = "off";
	defparam cout_cell_h1_I .extended_lut = "off";
	defparam cout_cell_h1_I .lut_mask = 64'hfff8800080000000;

	stratixii_lcell_comb cout_cell_I (
		.dataa(!cout_cell_h0),
		.datab(!cout_cell_h1 ),
		.datac(!ina[0]),
		.datad(!carry_in),		
		.datae(!inb[0]),
		.dataf(1'b1),		
		.combout(cout_cell ),
		.shareout(),.cout(),.sharein(1'b0),.cin(1'b0),.sumout(),.datag(1'b1));
	defparam cout_cell_I .shared_arith = "off";
	defparam cout_cell_I .extended_lut = "off";
	defparam cout_cell_I .lut_mask = 64'hcccacaaacccacaaa;

	always @(*) begin
	  sum[0] = sum_0 ;
	  sum[1] = sum_1 ;
	  sum[2] = !sum_2 ;
	  sum[3] = !sum_3 ;
	  carry_out = cout_cell ;
	end
  end  
endgenerate
endmodule

/////////////////////////////////////////////////////
module bcd_add_chain (ina,inb,sum);

parameter DEC_DIGITS = 4;
parameter METHOD = 3;

input [DEC_DIGITS*4-1:0] ina,inb;
output [DEC_DIGITS*4-1:0] sum;

wire [DEC_DIGITS:0] cin;
assign cin[0] = 1'b0;
genvar i;
generate
  for (i=0;i<DEC_DIGITS;i=i+1)
  begin : digs
    bcd_digit_add d (
      .ina(ina[(i+1)*4-1:i*4]),
      .inb(inb[(i+1)*4-1:i*4]),
      .sum(sum[(i+1)*4-1:i*4]),
      .carry_in(cin[i]),
      .carry_out(cin[i+1]));
	defparam d .METHOD = METHOD;
  end
endgenerate

endmodule
