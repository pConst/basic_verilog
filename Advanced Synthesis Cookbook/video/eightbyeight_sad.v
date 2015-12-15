// Copyright 2008 Altera Corporation. All rights reserved.  
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

module eightbyeight_sad (
	clk,aclr,
	xpixels,
	ypixels,
	sad
);

input clk,aclr;
input [8*8*8-1:0] xpixels;
input [8*8*8-1:0] ypixels;
output reg [13:0] sad;

//////////////////////////////////
// difference pairs of pixels
//  32 units each costing 27 arithmetic cells = 864 cells
//////////////////////////////////
wire [9*32-1:0] pair_diffs_w;
genvar i;
generate 
for (i=0;i<32;i=i+1) 
begin : pairs
	wire [7:0] x0,x1,y0,y1;
	wire [8:0] sd;
	assign {x0,x1} = xpixels[16*(i+1)-1:16*i];
	assign {y0,y1} = ypixels[16*(i+1)-1:16*i];
	pair_sad ps (.a0(x0),.a1(x1),.b0(y0),.b1(y1),.sad(sd));
	assign pair_diffs_w[9*(i+1)-1:9*i] = sd;
end
endgenerate

//////////////////////////////////
// First pipeline stage
//////////////////////////////////
reg [9*32-1:0] pair_diffs;
always @(posedge clk or posedge aclr) begin
	if (aclr) pair_diffs <= 0;
	else pair_diffs <= pair_diffs_w;
end

//////////////////////////////////
// sum of pairs to form quads - 16 10 bit adders
//////////////////////////////////
wire [10*16-1:0] quad_diffs_w;
generate 
for (i=0;i<16;i=i+1) 
begin : quads
	wire [8:0] pda, pdb;
	assign {pda,pdb} = pair_diffs[2*9*(i+1)-1:2*9*i];
	assign quad_diffs_w[10*(i+1)-1:10*i] = pda + pdb;
end
endgenerate

//////////////////////////////////
// Second pipeline stage
//////////////////////////////////
reg [10*16-1:0] quad_diffs;
always @(posedge clk or posedge aclr) begin
	if (aclr) quad_diffs <= 0;
	else quad_diffs <= quad_diffs_w;
end

//////////////////////////////////
// sum of quads to form octs - 8 11 bit adders
//////////////////////////////////
wire [11*8-1:0] oct_diffs_w;
generate 
for (i=0;i<8;i=i+1) 
begin : octs
	wire [9:0] qda, qdb;
	assign {qda,qdb} = quad_diffs[2*10*(i+1)-1:2*10*i];
	assign oct_diffs_w[11*(i+1)-1:11*i] = qda + qdb;
end
endgenerate

//////////////////////////////////
// Third pipeline stage
//////////////////////////////////
reg [11*8-1:0] oct_diffs;
always @(posedge clk or posedge aclr) begin
	if (aclr) oct_diffs <= 0;
	else oct_diffs <= oct_diffs_w;
end

//////////////////////////////////
// sum of octs to form sixteens - 4 12 bit adders
//////////////////////////////////
wire [12*4-1:0] sixteen_diffs_w;
generate 
for (i=0;i<4;i=i+1) 
begin : sixteens
	wire [10:0] oda, odb;
	assign {oda,odb} = oct_diffs[2*11*(i+1)-1:2*11*i];
	assign sixteen_diffs_w[12*(i+1)-1:12*i] = oda + odb;
end
endgenerate

//////////////////////////////////
// Fourth pipeline stage
//////////////////////////////////
reg [12*4-1:0] sixteen_diffs;
always @(posedge clk or posedge aclr) begin
	if (aclr) sixteen_diffs <= 0;
	else sixteen_diffs <= sixteen_diffs_w;
end

//////////////////////////////////
// sum of sixteens to form thirty twos - 2 13 bit adders
//////////////////////////////////
wire [13*2-1:0] thirty_diffs_w;
generate 
for (i=0;i<2;i=i+1) 
begin : thirtys
	wire [11:0] sda, sdb;
	assign {sda,sdb} = sixteen_diffs[2*12*(i+1)-1:2*12*i];
	assign thirty_diffs_w[13*(i+1)-1:13*i] = sda + sdb;
end
endgenerate

//////////////////////////////////
// Fifth pipeline stage
//////////////////////////////////
reg [13*2-1:0] thirty_diffs;
always @(posedge clk or posedge aclr) begin
	if (aclr) thirty_diffs <= 0;
	else thirty_diffs <= thirty_diffs_w;
end

//////////////////////////////////
// Final adder stage
//////////////////////////////////
wire [12:0] tda, tdb;
assign {tda,tdb} = thirty_diffs;
always @(posedge clk or posedge aclr) begin
	if (aclr) sad <= 0;
	else sad <= tda + tdb;
end

endmodule

	