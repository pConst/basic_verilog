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

// baeckler - 07-10-2006

module soft_ecc_ram_16bit_tb ();

`include "log2.inc"

parameter NUM_WORDS = 512;
localparam ADDR_WIDTH = log2(NUM_WORDS-1);
parameter RAM_RD_LATENCY = 4;


parameter DATA_BITS = 16;
localparam DATA_MASK = {DATA_BITS{1'b1}};

reg clk,rst;

	reg	[ADDR_WIDTH-1:0]  address_a;
	reg	[ADDR_WIDTH-1:0]  address_b;
	reg	[DATA_BITS-1:0]  data_a;
	reg	[DATA_BITS-1:0]  data_b;
	reg   wren_a;
	reg   wren_b;
	wire [DATA_BITS-1:0]  q_a;
	wire [DATA_BITS-1:0]  q_b;
	wire  [2:0] err_a;
	wire  [2:0] err_b;

//////////////////////////////////
// ECC RAM under test
//////////////////////////////////
soft_ecc_ram_16bit sr (
	.rst(rst),
	.address_a(address_a),
	.address_b(address_b),
	.clock_a(clk),
	.clock_b(clk),
	.data_a(data_a),
	.data_b(data_b),
	.wren_a(wren_a),
	.wren_b(wren_b),
	.q_a(q_a),
	.q_b(q_b),
	.err_a(err_a),
	.err_b(err_b)
);


//////////////////////////////////
// test pattern control
//////////////////////////////////

reg [2:0] state;
parameter STATE_FILL_A = 0, STATE_READ_A = 1, STATE_READ_B = 2,
	STATE_FILL_B = 3, STATE_READ_BOTH = 4;

reg [10:0] cntr;
reg [2:0] last_state;
always @(posedge clk or posedge rst) begin
	if (rst) begin
		cntr <= 0;
		last_state <= STATE_FILL_A;
	end
	else begin
		if (state != last_state) cntr <= 0;
		else cntr <= cntr + 1'b1;	
		last_state <= state;
	end
end

initial begin 
	clk = 0;
	rst = 0;
	#10 rst = 1;
	#10 rst = 0;		
end

always begin
	#100 clk = ~clk;
end

always @(posedge clk or posedge rst) begin
	if (rst) begin
		address_a <= 0;
		address_b <= 0;
		data_a <= 0;
		data_b <= 123;
		wren_a <= 1'b1;
		wren_b <= 1'b0;
		state <= STATE_FILL_A;
	end
	else begin
		if (state == STATE_FILL_A) begin
			if (&address_a) begin
				state <= STATE_READ_A;
				wren_a <= 1'b0;
			end
			address_a <= address_a + 1'b1;
			data_a <= data_a + 1'b1;
		end				
		else if (state == STATE_READ_A) begin
			if (&address_a) begin
				state <= STATE_READ_B;
			end
			address_a <= address_a + 1'b1;
			if (address_a !== 0 &&
				cntr >= RAM_RD_LATENCY &&
				q_a !== (cntr-RAM_RD_LATENCY)) begin
					$display ("Mismatch in state read A");
					$display ("  Expected %x",(cntr-RAM_RD_LATENCY));
					$display ("  Read %x",q_a);
					#100 $stop();
				end
		end
		else if (state == STATE_READ_B) begin
			if (&address_b) begin
				state <= STATE_FILL_B;
				wren_b <= 1'b1;
			end
			address_b <= address_b + 1'b1;
			if (address_b !== 0 &&
				cntr >= RAM_RD_LATENCY &&
				q_b !== ((cntr-RAM_RD_LATENCY) & DATA_MASK)) begin
					$display ("Mismatch in state read B");
					#100 $stop();
				end
		end
		else if (state == STATE_FILL_B) begin
			if (&address_b) begin
				state <= STATE_READ_BOTH;
				wren_a <= 1'b0;
				wren_b <= 1'b0;
			end
			address_b <= address_b + 1'b1;
			data_b <= data_b + 1'b1;
		end
		else if (state == STATE_READ_BOTH) begin
			if (&address_b) begin
				state <= STATE_FILL_A;
				data_a <= 0;
				data_b <= 123;
				wren_a <= 1'b1;

				// stop after one test cycle
				$display ("PASS");
				$stop();

			end
			address_a <= address_a + 1'b1;
			address_b <= address_b + 1'b1;
			if (address_b !== 0 &&
				cntr >= RAM_RD_LATENCY &&
				q_b !== ((cntr-RAM_RD_LATENCY+123) & DATA_MASK)) begin
					$display ("Mismatch in state read both");
					#100 $stop();
				end
		end
	end
end

endmodule
