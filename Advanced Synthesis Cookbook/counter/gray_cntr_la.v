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

// baeckler - 06-30-2006

////////////////////////////////////////////
// Register with ENA and SCLR
////////////////////////////////////////////
module sclr_ena_reg (
	clk,
	rst,
	d,
	ena,
	sclr,		
	q
);

parameter METHOD = 1;  

input clk,rst,d,ena,sclr;
output q;
reg q;

generate
if (METHOD == 0)
begin
	//////////////////////
	// soft register
	//////////////////////
	always @(posedge clk or posedge rst) begin
		if (rst) q <= 0;
		else begin
			if (ena) begin
				if (sclr) q <= 0;
				else q <= d;
			end
		end
	end		
end
else begin
	//////////////////////
	// WYSIWYG register
	//////////////////////
	wire q_internal;
	stratixii_lcell_ff r (
		.clk(clk),
		.ena(ena),
		.datain (d),
		.sload (1'b0),
		.adatasdata (1'b1),
		.sclr (sclr),
		.aload(1'b0),
		.aclr(rst),
		// These are simulation-only chipwide
		// reset signals.  Both active low.				
		// synthesis translate_off
		.devpor(1'b1),
		.devclrn(1'b1),
		// synthesis translate on
		.regout (q_internal)	
	);
	always @(q_internal) q = q_internal;
end
endgenerate
endmodule


////////////////////////////////////////////
// Gray counter register block
////////////////////////////////////////////
module gray_cntr_la_reg (
	clk,
	rst,
	ena,
	adv_lower,	// count the LSB
	adv_upper,	// count bits 1..n
	sclr,		
	q
);

parameter METHOD = 1;

input clk,rst,ena,adv_lower,adv_upper,sclr;
output [4:0] q;
wire [4:0] q;
reg [4:0] d;

	// do the D logic for a basic gray counter 
	always @(*) begin
		d[0] = q[0] ^ adv_lower;
		d[1] = q[1] ^ (adv_upper & q[0]);
		d[2] = q[2] ^ (adv_upper & !q[0] & q[1]);
		d[3] = q[3] ^ (adv_upper & !q[0] & !q[1] & q[2]);
		d[4] = q[4] ^ (adv_upper & !q[0] & !q[1] & !q[2] & q[3]);
	end

	// install a register array	
	genvar i;
	generate
	for (i=0; i<5; i=i+1)
	begin : rg
		sclr_ena_reg r (
			.clk(clk),.rst(rst),.d(d[i]),.ena(ena),.sclr(sclr),
			.q(q[i])
		);
		defparam r .METHOD = METHOD;
	end
	endgenerate

endmodule

////////////////////////////////////////////
// Gray counter using lookahead to get
//   1 LUT depth
////////////////////////////////////////////
module gray_cntr_la (
	clk,
	rst,
	ena,
	sclr,
	q
);

// method 0 - for simulation / portability
// method 1 - make the register secondarys very explicit
parameter METHOD = 1; 

// width of the output in bits
// must be 6 or higher
parameter WIDTH = 6;

// number of 5 bit blocks of counter width, round up to next size
localparam BLOCKS = ((WIDTH % 5) != 0) ? (WIDTH / 5) + 1 : (WIDTH / 5);

// number of bits not used at the MSB end of the top block
localparam SHORT_BITS = ((WIDTH % 5) != 0) ? 5-(WIDTH % 5) : 0;

input clk,rst,ena,sclr;
output [BLOCKS*5-1:0] q;

initial begin
	if (WIDTH < 6) begin
		$display ("WIDTH less than 6 requires modification of wrap circuitry");
		$stop();
	end
end

// internal use sclr signal, to add the wrapping condition
wire sclr_int /* synthesis keep */;

	wire [5*BLOCKS-1:0] q;
	wire [BLOCKS-1:0] block_zero; // q = 00000
	wire [BLOCKS-1:0] block_max;  // q = 10000
	wire [BLOCKS-1:0] adv_lower;  // count the LSB
	wire [BLOCKS-1:0] adv_upper;  // count the other bits

	// set up an alternation between LSB increments
	// and the higher bits
	sclr_ena_reg ping_r (
		.clk(clk),.rst(rst),
		.d(!ping),
		.ena(ena),.sclr(sclr_int),
		.q(ping));
	defparam ping_r .METHOD = METHOD;
	
	// the main counter register blocks
	genvar i;
	generate
	for (i=0; i<BLOCKS; i=i+1)
	begin : gryrg
		wire [4:0] block_q;
		gray_cntr_la_reg r (
			.clk(clk),
			.rst(rst),
			.ena(ena),
			.adv_lower(adv_lower[i]),
			.adv_upper(adv_upper[i]),
			.sclr(sclr_int),
			.q(block_q)
		);
		defparam r .METHOD = METHOD;

		assign q[(i+1)*5-1:i*5] = block_q;
	
		// registered comparators
		// for == 0 and == MAX value (10000)
		if (i != 0) begin		
			sclr_ena_reg cmp_z (
				.clk(clk),.rst(rst),
				.d(~| block_q),
				.ena(ena),.sclr(sclr_int),
				.q(block_zero[i]));
			defparam cmp_z .METHOD = METHOD;
			
			// trim down the MAX number on the 
			// highest block if not all of the bits are 
			// used.
			sclr_ena_reg cmp_m (
				.clk(clk),.rst(rst),
				.d(	(i != (BLOCKS-1)) ? 
						(block_q == 5'b10000) :
						(((block_q << SHORT_BITS) & 5'b11111)
										== 5'b10000)),
				.ena(ena),.sclr(sclr_int),
				.q(block_max[i]));
			defparam cmp_m .METHOD = METHOD;
		end
	end
	endgenerate

	// block_zero and block_max [0] aren't actually used, force them to VCC
	// so that the advance logic looks better
	assign block_zero[0] = 1'b1;
	assign block_max[0] = 1'b1;
	
	// block 0 advance signals are easy	
	assign adv_lower[0] = !ping;
	assign adv_upper[0] = ping;
	
	// block 1 advance signals need to be available 1 cycle
	// ahead of time for blocks 2...
	// compare lowest block to 00011
	wire leading_adv_upper1;
	sclr_ena_reg lead_r (
			.clk(clk),.rst(rst),
			.d(ping & !q[4] & !q[3] & !q[2] & q[1] & q[0]),
			.ena(ena),.sclr(sclr_int),
			.q(leading_adv_upper1));
		defparam lead_r .METHOD = METHOD;
	
	// compare lowest block to 00001
	sclr_ena_reg up1_r (
			.clk(clk),.rst(rst),
			.d(!ping & !q[4] & !q[3] & !q[2] & !q[1] & q[0]),
			.ena(ena),.sclr(sclr_int),
			.q(adv_upper[1]));
		defparam up1_r .METHOD = METHOD;
	
	// compare lowest block to 10001
	sclr_ena_reg lo1_r (
			.clk(clk),.rst(rst),
			.d(!ping & q[4] & !q[3] & !q[2] & !q[1] & q[0]),
			.ena(ena),.sclr(sclr_int),
			.q(adv_lower[1]));
		defparam lo1_r .METHOD = METHOD;
		
	// blocks 2 and up are repeats
	generate
	for (i=2; i<BLOCKS; i=i+1)
	begin : adv
		// when to advance the lower portion
		sclr_ena_reg advl_r (
			.clk(clk),.rst(rst),
			.d(leading_adv_upper1 & block_max[i-1] & (&block_zero[i-2:0])),
			.ena(ena),.sclr(sclr_int),
			.q(adv_lower[i]));
		defparam advl_r .METHOD = METHOD;
		
		// when to advance the upper portion
		sclr_ena_reg advu_r (
			.clk(clk),.rst(rst),
			.d(leading_adv_upper1 & block_zero[i-1] & (&block_zero[i-2:0])),
			.ena(ena),.sclr(sclr_int),
			.q(adv_upper[i]));
		defparam advu_r .METHOD = METHOD;
	end	
	endgenerate

	// additional SCLR condition when the counter is 
	// completely maxed.  Otherwise it would wait one cycle too
	// long to wrap.
	assign sclr_int = sclr | (adv_upper[BLOCKS-1] & block_max[BLOCKS-1]);
			
endmodule

