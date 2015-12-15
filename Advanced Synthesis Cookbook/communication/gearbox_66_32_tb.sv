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

module gearbox_66_32_tb ();

reg clk,arst;
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

wire din_ready;

always @(posedge clk) begin
	if (!arst) begin
		if (din_ready) begin
			sample_data <= {
				sample_data[65:0],
				sample_data [66*SAMPLE_WORDS-1:66]
			};		
		end
	end
end	 

wire [65:0] sample_word_66 = sample_data[65:0];
wire [63:0] trimmed_sample_word_66 = sample_word_66 >> 2;

//////////////////////////////////////////////////////
// DUT - convert the 66 bit words into 32 bits

wire [31:0] sample_word_32;
wire sample_word_valid;

gearbox_66_32 dut (
	.clk,
	.arst,
	.din(sample_word_66),
	.din_valid(1'b1),
	.din_ready,
	.dout(sample_word_32),
	.dout_valid(sample_word_valid),
	.dout_ready(1'b1)
);

//////////////////////////////////////////////////////
// recover the 66 to check

reg fail = 0;
reg [4:0] flushing;

always @(posedge clk or posedge arst) begin
	if (arst) flushing <= 0;
	else if (~&flushing) flushing <= flushing + 1'b1;
end

wire [65:0] recovered_66;
wire recovered_66_valid;
reg [63:0] trimmed_dout;
always @(posedge clk) begin
	if (recovered_66_valid) trimmed_dout <= recovered_66 >> 2;
	
	if (&flushing &&
		trimmed_dout[63:56] !== "b" &&
		trimmed_dout[63:56] !== "y" &&
		trimmed_dout[63:56] !== "m" &&
		trimmed_dout[63:56] !== "t" &&
		trimmed_dout[63:56] !== "c" &&
		trimmed_dout[63:56] !== "g" &&
		trimmed_dout[63:56] !== "H" &&
		trimmed_dout[63:56] !== 8'hff)
	begin
		$display ("Bad recovered data at time %d",$time);
		fail = 1;
	end	
end

wire [6:0] slip_count;

gearbox_32_66 rec (
	.clk,.arst,
	.din(sample_word_32),  // bit 0 is sent first
	.din_valid(sample_word_valid),
	.slip_to_frame,
	.dout(recovered_66), // bit 0 is sent first
	.dout_valid(recovered_66_valid),
	.slip_count
);

////////////////////////////////////
// clock driver

initial begin
	#100000 if (!fail) $display ("PASS");
	$stop();
end

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
