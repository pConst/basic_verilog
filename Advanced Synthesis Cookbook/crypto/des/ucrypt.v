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

// baeckler - 01-24-2006
// DES wrappers to do UNIX style 'one way' password encryption

module ascii_to_bin (in,out);
input [7:0] in;
output [5:0] out;
wire [5:0] out;
assign out = (in>="a"?(in-59):in>="A"?(in-53):in-".");
endmodule

////////////////////////////

module bin_to_ascii (in,out);
input [5:0] in;
output [7:0] out;
wire [7:0] out;
assign out = (in>=38?(in-38+"a"):in>=12?(in-12+"A"):in+".");
endmodule

////////////////////////////

module salt_to_bin (in,out);
input [15:0] in;
output [11:0] out;
wire [11:0] out;
ascii_to_bin x (.in(in[15:8]),.out(out[5:0]) );
ascii_to_bin y (.in(in[7:0]),.out(out[11:6]) );
endmodule

////////////////////////////

module passwd_to_bin (in,out);
input [63:0] in;
output [63:0] out;
wire [63:0] out;
assign out = ((in & 64'h7f7f7f7f7f7f7f7f) << 1);
endmodule

////////////////////////////

module des_to_string (in,out);
input [63:0] in;
output[87:0] out;
wire [87:0] out;

genvar i;
generate
for (i=0;i<10;i=i+1)
	begin:dtos
		bin_to_ascii b(
			.in(in[63-6*i:58-6*i]),
			.out(out[87-8*i:80-8*i])
		);
	end
endgenerate
bin_to_ascii l (.in({in[3:0],2'b0}),
			.out(out[7:0])
		);
endmodule

////////////////////////////

// unix password crypt function
// 25 round DES with 12 bit salt
// salt,pass,and out are ASCII string format.
//
// for use in a pipeline possible to feed in 16 strings, wait, read out 16
//

module passwd_crypt (clk,rst,salt,pass,out,super_round,des_round);
input clk,rst;
input [15:0] salt;
input [63:0] pass;
output [87:0] out;
output [4:0] super_round; // 0..24 full DES
output [3:0] des_round;  // 0..15 des stage within a full round

wire [4:0] super_round;
wire [3:0] des_round;

wire [87:0] out;

wire [63:0] key;
passwd_to_bin ptob (.in(pass),.out(key));

reg [8:0] cntr;
assign {super_round,des_round} = cntr;
always @(posedge clk or posedge rst) begin
	if (rst) cntr <= 9'b0;
	else begin
		if (cntr == 9'b110001111)  // super 24, round 15
			cntr <= 9'b0;
		else 
			cntr <= cntr + 1'b1;		
	end
end

wire [63:0] des_out;
wire [63:0] block_in;
wire [11:0] salt_bin;

salt_to_bin stob (.in(salt),.out(salt_bin));

assign block_in = (cntr[8:4] == 5'b0 ? 64'b0 : des_out);
des d (.clk(clk),.rst(rst),.in(block_in),
	.out(des_out),.key(key),.salt(salt_bin));
defparam d .PIPE_16B = 1'b1;
defparam d .USE_SALT = 1'b1;

des_to_string dtos (.in(des_out),.out(out));

endmodule

