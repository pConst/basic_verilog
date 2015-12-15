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

// baeckler - 03-15-2006

////////////////////////////////////////////////

module car_select_add (clk,a,b,o);

parameter BLOCK_SIZE = 14;
parameter NUM_BLOCKS = 4;

localparam DAT_WIDTH = BLOCK_SIZE * NUM_BLOCKS;

input clk;
input [DAT_WIDTH-1:0] a,b;
output [DAT_WIDTH:0] o;

// take care of the 1st block of adder chain
wire [BLOCK_SIZE:0] first_add;
reg [BLOCK_SIZE-1:0] first_add_r;
assign first_add = a[BLOCK_SIZE-1:0] + b[BLOCK_SIZE-1:0];
wire first_co = first_add[BLOCK_SIZE];

// generate the following select blocks
wire [NUM_BLOCKS-1:0] car;
assign car[0] = first_co;
reg last_c_r;
genvar i;
generate
  for (i=1; i<NUM_BLOCKS; i=i+1)
  begin : blk
	select_block cb (.clk(clk),.ci(car[i-1]),
		.a(a[i*BLOCK_SIZE+BLOCK_SIZE-1 : i*BLOCK_SIZE]),
		.b(b[i*BLOCK_SIZE+BLOCK_SIZE-1 : i*BLOCK_SIZE]),
		.o(o[i*BLOCK_SIZE+BLOCK_SIZE-1 : i*BLOCK_SIZE]),
		.co (car[i]));
	defparam cb .WIDTH = BLOCK_SIZE;
	defparam cb .USE_SLOAD = 0;
  end
endgenerate

// finish up the sum out signals
always @(posedge clk) begin
	first_add_r <= first_add[BLOCK_SIZE-1:0];
	last_c_r <= car[NUM_BLOCKS-1];
end
assign o[BLOCK_SIZE-1:0] = first_add_r;
assign o[DAT_WIDTH] = last_c_r;

endmodule

////////////////////////////////////////////////
// Compute SUM for both CIN=0 and 1, MUX the
//		result.  Registered sum out, unregistered
//		carry out
////////////////////////////////////////////////
module select_block (clk,ci,a,b,o,co); 

parameter WIDTH = 7;
parameter USE_SLOAD = 0;

input clk;
input [WIDTH-1:0] a,b;
input ci;

output [WIDTH-1:0] o;
reg [WIDTH-1:0] o;
output co;

wire [WIDTH:0] chain_o,chain_z;
wire [WIDTH:0] data_a = {1'b0,a};
wire [WIDTH:0] data_b = {1'b0,b};
wire [WIDTH+1:0] car_o,car_z;
assign car_z[0] = 1'b0;
assign car_o[0] = 1'b1;

genvar i;
generate
	for (i=0; i<=WIDTH; i=i+1)
	begin : chn
		stratixii_lcell_comb w (
			.dataa(1'b1), .datab(1'b1), .datac(1'b1), .datae(1'b1), .datag(1'b1),
			.datad(data_a[i]),
			.dataf(data_b[i]),
			.cin (car_z[i]),
			.cout (car_z[i+1]),
			.sharein (1'b0),
			.shareout (),
			.combout(),
			.sumout (chain_z[i])
		);
		defparam w .shared_arith = "off";
		defparam w .extended_lut = "off";
		defparam w .lut_mask = 64'h000000ff0000ff00; // d plus f
	
		stratixii_lcell_comb x (
			.dataa(1'b1), .datab(1'b1), .datac(1'b1), .datae(1'b1), .datag(1'b1),
			.datad(data_a[i]),
			.dataf(data_b[i]),
			.cin (car_o[i]),
			.cout (car_o[i+1]),
			.sharein (1'b0),
			.shareout (),
			.combout(),
			.sumout (chain_o[i])
		);
		defparam x .shared_arith = "off";
		defparam x .extended_lut = "off";
		defparam x .lut_mask = 64'h000000ff0000ff00; // d plus f
	end
endgenerate

assign co = (ci ? chain_o[WIDTH]: chain_z[WIDTH]);

generate
	if (USE_SLOAD) begin
		wire [WIDTH-1:0] ow;
		for (i=0; i<WIDTH; i=i+1)
		begin : regs
			stratixii_lcell_ff r (
				.clk (clk),
				.ena (1'b1),
				.datain(chain_z[i]),
				.adatasdata(chain_o[i]),
				.sclr(1'b0),
				.aload (1'b0),
				.aclr (1'b0),
				.sload (ci),

				// synthesis translate off
					.devpor (1'b1),
					.devclrn (1'b1),
				// synthesis translate on

				.regout (ow[i])
			);
		end
		always @(ow) o <= ow;
	end
	else begin
		// don't do SLOAD
		always @(posedge clk) begin
			o <= (ci ? chain_o[WIDTH-1:0] : chain_z[WIDTH-1:0]);
		end
	end

endgenerate

endmodule

////////////////////////////////////////////////

module test_add ();

parameter BLOCK_SIZE = 14;
parameter NUM_BLOCKS = 4;
parameter DAT_WIDTH = BLOCK_SIZE * NUM_BLOCKS;

reg [DAT_WIDTH-1:0] a,b;
wire [DAT_WIDTH:0] ox;
reg [DAT_WIDTH:0] oy;
reg clk,fail;

initial begin 
	clk = 0;
	a = 0;
	b = 0;
	fail = 0;
	#100000 if (!fail) $display ("PASS");
	$stop();
end

always begin
	#100 clk = ~clk;
end

car_select_add la (.clk(clk),.a(a),.b(b),.o(ox));

always @(posedge clk) begin
	oy <= a+b;
end

always @(negedge clk) begin
	a = {$random,$random};
	b = {$random,$random};
	if (ox !== oy) begin
		$display ("Mismatch at time %d",$time);
		$display ("  %x",ox);
		$display ("  %x",oy);
		fail = 1;
	end
end

endmodule