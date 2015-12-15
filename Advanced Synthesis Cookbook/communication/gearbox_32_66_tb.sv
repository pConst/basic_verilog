// Copyright 2011 Altera Corporation. All rights reserved.  
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

module gearbox_32_66_tb ();

reg clk,arst;
wire [31:0] din;  // bit 0 is sent first
reg din_valid = 1'b1;
reg slip_to_frame = 1'b1;

////////////////////////////////////
// provide some simple framed data

localparam SAMPLE_WORDS = 9;

reg [66*SAMPLE_WORDS-1:0] sample_data = {
	"be going", 2'b01,
	"y I must", 2'b01,
	"me to sa", 2'b01,
	"tay I ca", 2'b10,
	"cannot s", 2'b01,
	"going. I", 2'b01,
	"must be ", 2'b10,
	"Hello I ", 2'b01,
	64'hffff_ffff_ffff_ffff, 2'b10	
};

always @(posedge clk) begin
	if (!arst) begin
		sample_data <= {
				sample_data[31:0],
				sample_data [66*SAMPLE_WORDS-1:32]
			};		
	end
end	 

//////////////////////////////////////////////////////
// the gearbox should be able to lock on ANY 32 bit
// view of the sample data.  Try 66 offsets.  

wire [64*66-1:0] douts;
wire [8*66-1:0] slip_counts;

genvar i;
generate
	for (i=0; i<66; i=i+1)
	begin : dut_lp
		wire [65:0] dout; // bit 0 is sent first
		wire dout_valid;
		wire [6:0] slip_count;

		// trim off the framing so the hex / ASCII is readable
		reg [64:0] trimmed_dout;
		always @(posedge clk) begin
			if (dout_valid) trimmed_dout <= dout >> 2;
		end

		// test unit
		gearbox_32_66 dut (
			.clk,.arst,
			.din(sample_data[31+i:i]),  // bit 0 is sent first
			.din_valid,
			.slip_to_frame,
			.dout, // bit 0 is sent first
			.dout_valid,
			.slip_count
		);
		
		// gather up the outputs for observation
		assign douts [64*(i+1)-1:64*i] = trimmed_dout;
		assign slip_counts [8*(i+1)-1:8*i] = {1'b0,slip_count};				
	end
endgenerate

////////////////////////////////////
// sanity check that the gearboxes find the appropriate
// indices.   They may be offset by 66 if they hit false 
// framing matches.

integer n;
reg fail = 1'b0;
initial begin
	#5000
	for (n=0; n<66; n=n+1) begin
		if (((2*66-n) % 66) != (slip_counts[8*(n+1)-1-:8] % 66))
		begin
			$display ("DUT %d is not at the expected slip index",n);			
			fail = 1'b1;
		end		
	end
	if (!fail) $display ("PASS");
	$stop();	
end

////////////////////////////////////
// clock driver

always begin
	#5 clk = ~clk;
end

initial begin
	clk = 0;
	arst = 0;
	#1 arst = 1'b1;
	@(negedge clk) arst = 1'b0;
end


endmodule

