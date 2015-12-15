// Copyright 2010 Altera Corporation. All rights reserved.  
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

`timescale 1 ps / 1 ps
// baeckler - 01-15-2010
// MLAB based wide shift register w/enable.

module mlab_delay #
(
	parameter BITS_PER_WORD = 9, // 1 parity per word
	parameter WORDS = 46,		// needs to be even for Stratix IV MLAB, 9 bit
	parameter LATENCY = 10		// min 3, which is not appropriate for MLAB anyway
								// max 33
	
)(
	input clk,
	input ena,
	input [BITS_PER_WORD * WORDS - 1 : 0]  din,
	output [BITS_PER_WORD * WORDS - 1 : 0]  dout,
	output parity_error
);

///////////////////////////
// work out the widths
///////////////////////////

localparam BLOCK_WIDTH = 20;   // 20 bits per lab, fixed by architecture
localparam STORAGE_WORD = (BITS_PER_WORD+1) * WORDS; 
localparam LABS_WIDE = (STORAGE_WORD / BLOCK_WIDTH);

// sanity check
// synthesis translate off
initial begin
	if (LABS_WIDE * BLOCK_WIDTH != STORAGE_WORD) begin
		$display ("Error in parameters to mlab delay %d labs of %d",
			LABS_WIDE,BLOCK_WIDTH);
		$display (" vs %d bit storage word",STORAGE_WORD);
		$stop();
	end
end
// synthesis translate on

localparam LAB_ADDR_BITS = 5;  // 32 words deep, fixed by architecture
localparam ADDR_BITS = 
			(LATENCY < 6) ? 2 : 
			(LATENCY < 10) ? 3 : 
			(LATENCY < 18) ? 4 : 5;
			
localparam PAD_BITS = LAB_ADDR_BITS-ADDR_BITS;
localparam ADDR_OFS = LATENCY - 2;

// sanity check
// synthesis translate off
	initial begin
		if (LATENCY < 3 || LATENCY > 33) begin : chk
			$display ("Bad LATENCY parameter");
			$stop();
		end
	end
// synthesis translate on

//////////////////////////////////
// add parity to input
//////////////////////////////////

wire [STORAGE_WORD-1:0] din_par;
insert_parity ip (
	.din (din),
	.dout (din_par)
);
defparam ip .WORDS = WORDS;
defparam ip .BITS_PER_WORD = BITS_PER_WORD;

//////////////////////////////////
// write address pointer marches
//////////////////////////////////

reg [ADDR_BITS-1:0] wraddr = 0;
always @(posedge clk) begin
	if (ena) wraddr <= wraddr + 1'b1;
end

//////////////////////////////////
// read address pointer -
//  set realtive to the write to recover from (upset, bad init, etc)
//////////////////////////////////

reg [ADDR_BITS-1:0] rdaddr = 0;
always @(posedge clk) begin
	if (ena) rdaddr <= wraddr - ADDR_OFS;
end

//////////////////////////////////
// storage array
//////////////////////////////////

wire [LAB_ADDR_BITS-1:0] pad_rdaddr, pad_wraddr;

assign pad_rdaddr[ADDR_BITS-1:0] = rdaddr;
assign pad_wraddr[ADDR_BITS-1:0] = wraddr;

// zero out any extra address bits
genvar i;
generate
	for (i=0; i<PAD_BITS; i=i+1) begin : pad
		assign pad_rdaddr[LAB_ADDR_BITS-1-i] = 1'b0;
		assign pad_wraddr[LAB_ADDR_BITS-1-i] = 1'b0;		
	end
endgenerate

wire [STORAGE_WORD-1:0] dout_par;
wire [LABS_WIDE-1:0] perr, perr_in;
assign perr_in = {perr[LABS_WIDE-2:0],1'b0};

generate
	for (i=0; i<LABS_WIDE; i=i+1) begin : mbk
		mlab_sr_cells m (
			.clk (clk),
			.ena (ena),
			.din(din_par[(i+1)*BLOCK_WIDTH-1:i*BLOCK_WIDTH]),
			.we(1'b1),
			.wraddr(pad_wraddr),
			
			.rdaddr(pad_rdaddr),
			.dout(dout_par[(i+1)*BLOCK_WIDTH-1:i*BLOCK_WIDTH]),
			.parity_err_in(perr_in[i]),
			.parity_err_out(perr[i])
		);			
	end
endgenerate

assign parity_error = perr[LABS_WIDE-1];

//////////////////////////////////
// remove parity bits
//////////////////////////////////

remove_parity rp (
	.din (dout_par),
	.dout (dout)
);
defparam rp .WORDS = WORDS;
defparam rp .BITS_PER_WORD = BITS_PER_WORD;

endmodule 