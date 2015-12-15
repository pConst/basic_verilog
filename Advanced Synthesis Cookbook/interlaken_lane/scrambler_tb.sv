`timescale 1 ps / 1 ps
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

module scrambler (
	clk,
	reset,
	lane_number,
	word_is_scrambler_state,
	word_is_synchronization,
	word_is_to_be_scrambled,
	data_in,
	Data
);

input clk;
input reset;
input [3:0] lane_number;
input word_is_scrambler_state;
input word_is_synchronization;
input word_is_to_be_scrambled;
input [63:0] data_in;
output [63:0] Data;

reg [63:0] Data;
reg [57:0] Poly;

wire [63:0] next;

assign next[63] = Poly[57] ^ Poly[38];
assign next[62] = Poly[56] ^ Poly[37];
assign next[61] = Poly[55] ^ Poly[36];
assign next[60] = Poly[54] ^ Poly[35];
assign next[59] = Poly[53] ^ Poly[34];
assign next[58] = Poly[52] ^ Poly[33];
assign next[57] = Poly[51] ^ Poly[32];
assign next[56] = Poly[50] ^ Poly[31];
assign next[55] = Poly[49] ^ Poly[30];
assign next[54] = Poly[48] ^ Poly[29];
assign next[53] = Poly[47] ^ Poly[28];
assign next[52] = Poly[46] ^ Poly[27];
assign next[51] = Poly[45] ^ Poly[26];
assign next[50] = Poly[44] ^ Poly[25];
assign next[49] = Poly[43] ^ Poly[24];
assign next[48] = Poly[42] ^ Poly[23];
assign next[47] = Poly[41] ^ Poly[22];
assign next[46] = Poly[40] ^ Poly[21];
assign next[45] = Poly[39] ^ Poly[20];
assign next[44] = Poly[38] ^ Poly[19];
assign next[43] = Poly[37] ^ Poly[18];
assign next[42] = Poly[36] ^ Poly[17];
assign next[41] = Poly[35] ^ Poly[16];
assign next[40] = Poly[34] ^ Poly[15];
assign next[39] = Poly[33] ^ Poly[14];
assign next[38] = Poly[32] ^ Poly[13];
assign next[37] = Poly[31] ^ Poly[12];
assign next[36] = Poly[30] ^ Poly[11];
assign next[35] = Poly[29] ^ Poly[10];
assign next[34] = Poly[28] ^ Poly[9];
assign next[33] = Poly[27] ^ Poly[8];
assign next[32] = Poly[26] ^ Poly[7];
assign next[31] = Poly[25] ^ Poly[6];
assign next[30] = Poly[24] ^ Poly[5];
assign next[29] = Poly[23] ^ Poly[4];
assign next[28] = Poly[22] ^ Poly[3];
assign next[27] = Poly[21] ^ Poly[2];
assign next[26] = Poly[20] ^ Poly[1];
assign next[25] = Poly[19] ^ Poly[0];
assign next[24] = Poly[57] ^ Poly[38] ^ Poly[18];
assign next[23] = Poly[56] ^ Poly[37] ^ Poly[17];
assign next[22] = Poly[55] ^ Poly[36] ^ Poly[16];
assign next[21] = Poly[54] ^ Poly[35] ^ Poly[15];
assign next[20] = Poly[53] ^ Poly[34] ^ Poly[14];
assign next[19] = Poly[52] ^ Poly[33] ^ Poly[13];
assign next[18] = Poly[51] ^ Poly[32] ^ Poly[12];
assign next[17] = Poly[50] ^ Poly[31] ^ Poly[11];
assign next[16] = Poly[49] ^ Poly[30] ^ Poly[10];
assign next[15] = Poly[48] ^ Poly[29] ^ Poly[9];
assign next[14] = Poly[47] ^ Poly[28] ^ Poly[8];
assign next[13] = Poly[46] ^ Poly[27] ^ Poly[7];
assign next[12] = Poly[45] ^ Poly[26] ^ Poly[6];
assign next[11] = Poly[44] ^ Poly[25] ^ Poly[5];
assign next[10] = Poly[43] ^ Poly[24] ^ Poly[4];
assign next[9] = Poly[42] ^ Poly[23] ^ Poly[3];
assign next[8] = Poly[41] ^ Poly[22] ^ Poly[2];
assign next[7] = Poly[40] ^ Poly[21] ^ Poly[1];
assign next[6] = Poly[39] ^ Poly[20] ^ Poly[0];
assign next[5] = Poly[57] ^ Poly[19];
assign next[4] = Poly[56] ^ Poly[18];
assign next[3] = Poly[55] ^ Poly[17];
assign next[2] = Poly[54] ^ Poly[16];
assign next[1] = Poly[53] ^ Poly[15];
assign next[0] = Poly[52] ^ Poly[14];


always @(posedge clk) begin
	if(reset) begin
		Poly <= {{54{1'b1}}, lane_number[3:0]}; //reset each lane differently
		Data <= 64'b0;
	end else if(word_is_to_be_scrambled) begin
		Poly <= next[57:0];
		Data <= data_in[63:0] ^ {Poly[57:0], next[63:58]};
	end else if(word_is_synchronization) begin
		Data <= 64'h78f678f678f678f6;
	end else if(word_is_scrambler_state) begin
		Data <= {6'b001010 , Poly[57:0]};
	end
end

endmodule

///////////////////////////////////////////////////////////

module scrambler_b (
	clk,
	reset,
	lane_number,
	word_is_scrambler_state,
	word_is_synchronization,
	word_is_to_be_scrambled,
	data_in,
	Data
);

input clk;
input reset;
input [3:0] lane_number;
input word_is_scrambler_state;
input word_is_synchronization;
input word_is_to_be_scrambled;
input [63:0] data_in;
output [63:0] Data;

reg [63:0] Data;
reg [57:0] Poly;

wire [63:0] next;

assign next = {Poly,Poly[57:52]} ^ 
			{Poly[38:0],Poly[38:14]} ^ 
			{39'b0,Poly[57:39],6'b0};
  
always @(posedge clk) begin
	if(reset) begin
		Poly <= {{54{1'b1}}, lane_number[3:0]}; //reset each lane differently
		Data <= 64'b0;
	end else if(word_is_to_be_scrambled) begin
		Poly <= next[57:0];
		Data <= data_in[63:0] ^ {Poly[57:0], next[63:58]};
	end else if(word_is_synchronization) begin
		Data <= 64'h78f678f678f678f6;
	end else if(word_is_scrambler_state) begin
		Data <= {6'b001010 , Poly[57:0]};
	end
end

endmodule

///////////////////////////////////////////////////////////

module scrambler_tb ();

reg	clk,reset;
reg [3:0] lane_number = 2;
reg word_is_scrambler_state = 0;
reg word_is_synchronization = 0;
reg word_is_to_be_scrambled = 1'b1;

reg [63:0] data_in = 0;
wire [63:0] Data;
wire [63:0] Data_b;
wire [63:0] Data_c;

scrambler dut (
	.clk(clk),
	.reset(reset),
	.lane_number(lane_number),
	.word_is_scrambler_state(word_is_scrambler_state),
	.word_is_synchronization(word_is_synchronization),
	.word_is_to_be_scrambled(word_is_to_be_scrambled),
	.data_in(data_in),
	.Data(Data)
);

scrambler_b dut_b (
	.clk(clk),
	.reset(reset),
	.lane_number(lane_number),
	.word_is_scrambler_state(word_is_scrambler_state),
	.word_is_synchronization(word_is_synchronization),
	.word_is_to_be_scrambled(word_is_to_be_scrambled),
	.data_in(data_in),
	.Data(Data_b)
);

scrambler_lfsr dut_c (
	.clk(clk),
	.arst(reset),
	.load(1'b0),
	.verify(1'b0),
	.load_d(58'h0),
	.evolve(1'b1),
	.q(Data_c),
	.verify_pass(),
	.verify_fail()	
);

reg [63:0] last_c;
always @(posedge clk) begin
	if (reset) last_c <= 0;
	else last_c <= Data_c;
end

defparam dut_c .RESET_VAL = {{54{1'b1}}, 4'h2};

initial begin
	clk = 0;
	reset = 1'b1;
	@(negedge clk) reset = 1'b0;
end

always begin
	#5 clk = ~clk;
end

reg fail = 0;

always @(posedge clk) begin
	#1 if (Data !== Data_b) begin
		$display ("Mismatch at time %d",$time);
		fail = 1;
	end
	if (Data !== last_c) begin
		$display ("Mismatch at time %d",$time);
		fail = 1;
	end
end

initial begin 
	#10000000
	if (!fail) $display ("PASS");
	$stop();
end

	
endmodule