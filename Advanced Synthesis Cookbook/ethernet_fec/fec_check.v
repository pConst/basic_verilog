// Copyright 2009 Altera Corporation. All rights reserved.  
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

// baeckler - 12-04-2008
// based very closely on IEEE802 July 06 10GBASEKR FEC tutorial, slide 72

module fec_check (
    input clk,arst,
    input sof,eof, // eof would be coincident with the parity word
    input [31:0] din,
    output [31:0] dout,
    output parity_match,    // perfect parity in current dout's frame
    output reg dout_repaired   // the previous dout was repaired
);
`include "reverse_32.inc"

/////////////////////////////////////
// pseudo noise descrambler
/////////////////////////////////////

wire [31:0] pn_val_w;
reg [31:0] pn_val;
reg [6:0] pn_cntr;

pn2112_table pn (
	.din(pn_cntr),
	.dout(pn_val_w)
);

always @(posedge clk) begin
	if (arst) begin
		pn_val <= 0;
		pn_cntr <= 0;
	end
	else begin
		pn_val <= pn_val_w;
		if (eof) begin
			pn_cntr <= 1'b1;
			pn_val <= 32'hffffffff;
		end
		else begin
			if (pn_cntr == 7'd65) pn_cntr <= 0;
			else pn_cntr <= pn_cntr + 1'b1;
		end
	end
end

wire [31:0] descram_din = din ^ pn_val;

/////////////////////////////////////
// syndrome the input stream
/////////////////////////////////////

reg [31:0] syndrome,parity;
wire [31:0] next_parity;
fec_parity fp (.c(parity),.d(descram_din),.co(next_parity));

always @(posedge clk or posedge arst) begin
    if (arst) begin
        syndrome <= 0;
        parity <= 0;
    end
    else begin
        syndrome <= eof ? 
					reverse_32(descram_din ^ reverse_32(parity)) :
					syndrome;
        parity <= eof ? 32'h0 : next_parity;
    end
end

/////////////////////////////////////
// stall 1 frame+ for correction
/////////////////////////////////////

localparam FRAME_STALL = 66 + 5;
reg [FRAME_STALL*32-1:0] frame_buffer;
wire [32-1:0] delayed_din;
always @(posedge clk) begin
    frame_buffer <= {frame_buffer [(FRAME_STALL-1)*32-1:0],descram_din};
end
assign delayed_din = frame_buffer[FRAME_STALL*32-1:(FRAME_STALL-1)*32];

reg [2:0] parity_match_r;
always @(posedge clk or posedge arst) begin
    if (arst) parity_match_r <= 0;
    else parity_match_r <= {parity_match_r[1:0],~|syndrome};
end
assign parity_match = parity_match_r[2];

/////////////////////////////////////
// rotated syndrome register
/////////////////////////////////////

reg [31:0] rot_syndrome;
wire [31:0] next_rot_32, next_rot_n2112;
fec_rot_32 fr32 (.c(rot_syndrome),.co(next_rot_32));
fec_rot_n2112 frn2112 (.c(syndrome),.co(next_rot_n2112));
always @(posedge clk or posedge arst) begin
    if (arst) rot_syndrome <= 0;
    else rot_syndrome <= sof ? next_rot_n2112 : next_rot_32;
end

/////////////////////////////////////
// unroll 1 word by bits
/////////////////////////////////////

wire [32*32-1:0] rsyns_w;
reg [32*32-1:0] rsyns;
assign rsyns_w [31:0] = rot_syndrome;
fec_rot_1 fr1 (.c(rot_syndrome),.co(rsyns_w[(1+1)*32-1:1*32]));
fec_rot_2 fr2 (.c(rot_syndrome),.co(rsyns_w[(2+1)*32-1:2*32]));
fec_rot_3 fr3 (.c(rot_syndrome),.co(rsyns_w[(3+1)*32-1:3*32]));
fec_rot_4 fr4 (.c(rot_syndrome),.co(rsyns_w[(4+1)*32-1:4*32]));
fec_rot_5 fr5 (.c(rot_syndrome),.co(rsyns_w[(5+1)*32-1:5*32]));
fec_rot_6 fr6 (.c(rot_syndrome),.co(rsyns_w[(6+1)*32-1:6*32]));
fec_rot_7 fr7 (.c(rot_syndrome),.co(rsyns_w[(7+1)*32-1:7*32]));
fec_rot_8 fr8 (.c(rot_syndrome),.co(rsyns_w[(8+1)*32-1:8*32]));
fec_rot_9 fr9 (.c(rot_syndrome),.co(rsyns_w[(9+1)*32-1:9*32]));
fec_rot_10 fr10 (.c(rot_syndrome),.co(rsyns_w[(10+1)*32-1:10*32]));
fec_rot_11 fr11 (.c(rot_syndrome),.co(rsyns_w[(11+1)*32-1:11*32]));
fec_rot_12 fr12 (.c(rot_syndrome),.co(rsyns_w[(12+1)*32-1:12*32]));
fec_rot_13 fr13 (.c(rot_syndrome),.co(rsyns_w[(13+1)*32-1:13*32]));
fec_rot_14 fr14 (.c(rot_syndrome),.co(rsyns_w[(14+1)*32-1:14*32]));
fec_rot_15 fr15 (.c(rot_syndrome),.co(rsyns_w[(15+1)*32-1:15*32]));
fec_rot_16 fr16 (.c(rot_syndrome),.co(rsyns_w[(16+1)*32-1:16*32]));
fec_rot_17 fr17 (.c(rot_syndrome),.co(rsyns_w[(17+1)*32-1:17*32]));
fec_rot_18 fr18 (.c(rot_syndrome),.co(rsyns_w[(18+1)*32-1:18*32]));
fec_rot_19 fr19 (.c(rot_syndrome),.co(rsyns_w[(19+1)*32-1:19*32]));
fec_rot_20 fr20 (.c(rot_syndrome),.co(rsyns_w[(20+1)*32-1:20*32]));
fec_rot_21 fr21 (.c(rot_syndrome),.co(rsyns_w[(21+1)*32-1:21*32]));
fec_rot_22 fr22 (.c(rot_syndrome),.co(rsyns_w[(22+1)*32-1:22*32]));
fec_rot_23 fr23 (.c(rot_syndrome),.co(rsyns_w[(23+1)*32-1:23*32]));
fec_rot_24 fr24 (.c(rot_syndrome),.co(rsyns_w[(24+1)*32-1:24*32]));
fec_rot_25 fr25 (.c(rot_syndrome),.co(rsyns_w[(25+1)*32-1:25*32]));
fec_rot_26 fr26 (.c(rot_syndrome),.co(rsyns_w[(26+1)*32-1:26*32]));
fec_rot_27 fr27 (.c(rot_syndrome),.co(rsyns_w[(27+1)*32-1:27*32]));
fec_rot_28 fr28 (.c(rot_syndrome),.co(rsyns_w[(28+1)*32-1:28*32]));
fec_rot_29 fr29 (.c(rot_syndrome),.co(rsyns_w[(29+1)*32-1:29*32]));
fec_rot_30 fr30 (.c(rot_syndrome),.co(rsyns_w[(30+1)*32-1:30*32]));
fec_rot_31 fr31 (.c(rot_syndrome),.co(rsyns_w[(31+1)*32-1:31*32]));

always @(posedge clk or posedge arst) begin
    if (arst) rsyns <= 0;
    else rsyns <= rsyns_w;
end

/////////////////////////////////////
// error detect array
/////////////////////////////////////

wire [32*11-1:0] err_det_w;
reg [32*11-1:0] err_det;
genvar i,j;
generate
    for (i=0;i<32;i=i+1) begin : fla
        wire low_zero = ~|rsyns[i*32+20:i*32];
        assign err_det_w[(i+1)*11-1:i*11] = {11{low_zero}} & rsyns[i*32+31:i*32+21];
    end

endgenerate

always @(posedge clk or posedge arst) begin
    if (arst) err_det <= 0;
    else err_det <= err_det_w;
end

wire [31:0] next_error;
wire [9:0] next_carry;
reg [31:0] error_reg;
reg [9:0] carry_reg;

assign next_error[31] = |{err_det[11*21+0],err_det[11*22+1],err_det[11*23+2],err_det[11*24+3],err_det[11*25+4],err_det[11*26+5],err_det[11*27+6],err_det[11*28+7],err_det[11*29+8],err_det[11*30+9],err_det[11*31+10]};
assign next_error[30] = |{err_det[11*20+0],err_det[11*21+1],err_det[11*22+2],err_det[11*23+3],err_det[11*24+4],err_det[11*25+5],err_det[11*26+6],err_det[11*27+7],err_det[11*28+8],err_det[11*29+9],err_det[11*30+10]};
assign next_error[29] = |{err_det[11*19+0],err_det[11*20+1],err_det[11*21+2],err_det[11*22+3],err_det[11*23+4],err_det[11*24+5],err_det[11*25+6],err_det[11*26+7],err_det[11*27+8],err_det[11*28+9],err_det[11*29+10]};
assign next_error[28] = |{err_det[11*18+0],err_det[11*19+1],err_det[11*20+2],err_det[11*21+3],err_det[11*22+4],err_det[11*23+5],err_det[11*24+6],err_det[11*25+7],err_det[11*26+8],err_det[11*27+9],err_det[11*28+10]};
assign next_error[27] = |{err_det[11*17+0],err_det[11*18+1],err_det[11*19+2],err_det[11*20+3],err_det[11*21+4],err_det[11*22+5],err_det[11*23+6],err_det[11*24+7],err_det[11*25+8],err_det[11*26+9],err_det[11*27+10]};
assign next_error[26] = |{err_det[11*16+0],err_det[11*17+1],err_det[11*18+2],err_det[11*19+3],err_det[11*20+4],err_det[11*21+5],err_det[11*22+6],err_det[11*23+7],err_det[11*24+8],err_det[11*25+9],err_det[11*26+10]};
assign next_error[25] = |{err_det[11*15+0],err_det[11*16+1],err_det[11*17+2],err_det[11*18+3],err_det[11*19+4],err_det[11*20+5],err_det[11*21+6],err_det[11*22+7],err_det[11*23+8],err_det[11*24+9],err_det[11*25+10]};
assign next_error[24] = |{err_det[11*14+0],err_det[11*15+1],err_det[11*16+2],err_det[11*17+3],err_det[11*18+4],err_det[11*19+5],err_det[11*20+6],err_det[11*21+7],err_det[11*22+8],err_det[11*23+9],err_det[11*24+10]};
assign next_error[23] = |{err_det[11*13+0],err_det[11*14+1],err_det[11*15+2],err_det[11*16+3],err_det[11*17+4],err_det[11*18+5],err_det[11*19+6],err_det[11*20+7],err_det[11*21+8],err_det[11*22+9],err_det[11*23+10]};
assign next_error[22] = |{err_det[11*12+0],err_det[11*13+1],err_det[11*14+2],err_det[11*15+3],err_det[11*16+4],err_det[11*17+5],err_det[11*18+6],err_det[11*19+7],err_det[11*20+8],err_det[11*21+9],err_det[11*22+10]};
assign next_error[21] = |{err_det[11*11+0],err_det[11*12+1],err_det[11*13+2],err_det[11*14+3],err_det[11*15+4],err_det[11*16+5],err_det[11*17+6],err_det[11*18+7],err_det[11*19+8],err_det[11*20+9],err_det[11*21+10]};
assign next_error[20] = |{err_det[11*10+0],err_det[11*11+1],err_det[11*12+2],err_det[11*13+3],err_det[11*14+4],err_det[11*15+5],err_det[11*16+6],err_det[11*17+7],err_det[11*18+8],err_det[11*19+9],err_det[11*20+10]};
assign next_error[19] = |{err_det[11*9+0],err_det[11*10+1],err_det[11*11+2],err_det[11*12+3],err_det[11*13+4],err_det[11*14+5],err_det[11*15+6],err_det[11*16+7],err_det[11*17+8],err_det[11*18+9],err_det[11*19+10]};
assign next_error[18] = |{err_det[11*8+0],err_det[11*9+1],err_det[11*10+2],err_det[11*11+3],err_det[11*12+4],err_det[11*13+5],err_det[11*14+6],err_det[11*15+7],err_det[11*16+8],err_det[11*17+9],err_det[11*18+10]};
assign next_error[17] = |{err_det[11*7+0],err_det[11*8+1],err_det[11*9+2],err_det[11*10+3],err_det[11*11+4],err_det[11*12+5],err_det[11*13+6],err_det[11*14+7],err_det[11*15+8],err_det[11*16+9],err_det[11*17+10]};
assign next_error[16] = |{err_det[11*6+0],err_det[11*7+1],err_det[11*8+2],err_det[11*9+3],err_det[11*10+4],err_det[11*11+5],err_det[11*12+6],err_det[11*13+7],err_det[11*14+8],err_det[11*15+9],err_det[11*16+10]};
assign next_error[15] = |{err_det[11*5+0],err_det[11*6+1],err_det[11*7+2],err_det[11*8+3],err_det[11*9+4],err_det[11*10+5],err_det[11*11+6],err_det[11*12+7],err_det[11*13+8],err_det[11*14+9],err_det[11*15+10]};
assign next_error[14] = |{err_det[11*4+0],err_det[11*5+1],err_det[11*6+2],err_det[11*7+3],err_det[11*8+4],err_det[11*9+5],err_det[11*10+6],err_det[11*11+7],err_det[11*12+8],err_det[11*13+9],err_det[11*14+10]};
assign next_error[13] = |{err_det[11*3+0],err_det[11*4+1],err_det[11*5+2],err_det[11*6+3],err_det[11*7+4],err_det[11*8+5],err_det[11*9+6],err_det[11*10+7],err_det[11*11+8],err_det[11*12+9],err_det[11*13+10]};
assign next_error[12] = |{err_det[11*2+0],err_det[11*3+1],err_det[11*4+2],err_det[11*5+3],err_det[11*6+4],err_det[11*7+5],err_det[11*8+6],err_det[11*9+7],err_det[11*10+8],err_det[11*11+9],err_det[11*12+10]};
assign next_error[11] = |{err_det[11*1+0],err_det[11*2+1],err_det[11*3+2],err_det[11*4+3],err_det[11*5+4],err_det[11*6+5],err_det[11*7+6],err_det[11*8+7],err_det[11*9+8],err_det[11*10+9],err_det[11*11+10]};
assign next_error[10] = |{err_det[11*0+0],err_det[11*1+1],err_det[11*2+2],err_det[11*3+3],err_det[11*4+4],err_det[11*5+5],err_det[11*6+6],err_det[11*7+7],err_det[11*8+8],err_det[11*9+9],err_det[11*10+10]};
assign next_error[9] = |{err_det[11*0+1],err_det[11*1+2],err_det[11*2+3],err_det[11*3+4],err_det[11*4+5],err_det[11*5+6],err_det[11*6+7],err_det[11*7+8],err_det[11*8+9],err_det[11*9+10]};
assign next_error[8] = |{err_det[11*0+2],err_det[11*1+3],err_det[11*2+4],err_det[11*3+5],err_det[11*4+6],err_det[11*5+7],err_det[11*6+8],err_det[11*7+9],err_det[11*8+10]};
assign next_error[7] = |{err_det[11*0+3],err_det[11*1+4],err_det[11*2+5],err_det[11*3+6],err_det[11*4+7],err_det[11*5+8],err_det[11*6+9],err_det[11*7+10]};
assign next_error[6] = |{err_det[11*0+4],err_det[11*1+5],err_det[11*2+6],err_det[11*3+7],err_det[11*4+8],err_det[11*5+9],err_det[11*6+10]};
assign next_error[5] = |{err_det[11*0+5],err_det[11*1+6],err_det[11*2+7],err_det[11*3+8],err_det[11*4+9],err_det[11*5+10]};
assign next_error[4] = |{err_det[11*0+6],err_det[11*1+7],err_det[11*2+8],err_det[11*3+9],err_det[11*4+10]};
assign next_error[3] = |{err_det[11*0+7],err_det[11*1+8],err_det[11*2+9],err_det[11*3+10]};
assign next_error[2] = |{err_det[11*0+8],err_det[11*1+9],err_det[11*2+10]};
assign next_error[1] = |{err_det[11*0+9],err_det[11*1+10]};
assign next_error[0] = |{err_det[11*0+10]};

assign next_carry[9] = |{err_det[11*31+0]};
assign next_carry[8] = |{err_det[11*31+1],err_det[11*30+0]};
assign next_carry[7] = |{err_det[11*31+2],err_det[11*30+1],err_det[11*29+0]};
assign next_carry[6] = |{err_det[11*31+3],err_det[11*30+2],err_det[11*29+1],err_det[11*28+0]};
assign next_carry[5] = |{err_det[11*31+4],err_det[11*30+3],err_det[11*29+2],err_det[11*28+1],err_det[11*27+0]};
assign next_carry[4] = |{err_det[11*31+5],err_det[11*30+4],err_det[11*29+3],err_det[11*28+2],err_det[11*27+1],err_det[11*26+0]};
assign next_carry[3] = |{err_det[11*31+6],err_det[11*30+5],err_det[11*29+4],err_det[11*28+3],err_det[11*27+2],err_det[11*26+1],err_det[11*25+0]};
assign next_carry[2] = |{err_det[11*31+7],err_det[11*30+6],err_det[11*29+5],err_det[11*28+4],err_det[11*27+3],err_det[11*26+2],err_det[11*25+1],err_det[11*24+0]};
assign next_carry[1] = |{err_det[11*31+8],err_det[11*30+7],err_det[11*29+6],err_det[11*28+5],err_det[11*27+4],err_det[11*26+3],err_det[11*25+2],err_det[11*24+1],err_det[11*23+0]};
assign next_carry[0] = |{err_det[11*31+9],err_det[11*30+8],err_det[11*29+7],err_det[11*28+6],err_det[11*27+5],err_det[11*26+4],err_det[11*25+3],err_det[11*24+2],err_det[11*23+1],err_det[11*22+0]};

reg last_sof;
always @(posedge clk or posedge arst) begin
    if (arst) begin
        error_reg <= 0;
        carry_reg <= 0;
        last_sof <= 0;
        dout_repaired <= 0;
    end
    else begin
        last_sof <= sof;
        error_reg <= next_error | carry_reg;
        carry_reg <= ~{11{last_sof}} & next_carry;
        dout_repaired <= |error_reg;
    end
end

assign dout = delayed_din ^ error_reg;

endmodule

