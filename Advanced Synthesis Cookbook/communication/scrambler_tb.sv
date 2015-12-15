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
// baeckler - 12-17-2008

module scrambler_tb ();

parameter WIDTH = 256;

reg clk = 0, arst = 0;

// sample data
reg [WIDTH-1:0] data_in = 0;
reg [15:0] cntr = 0;
integer k = 0;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		data_in <= 0;
		cntr <= 0;
	end
	else begin
		#1
		for (k=0; k<(WIDTH >> 4); k=k+1) begin : stim
			data_in = (data_in << 16) | cntr;
			cntr = cntr + 1'b1;
		end
	end
end

reg [WIDTH-1:0] last_data_in, last2_data_in;
reg [3:0] flushing;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		last_data_in <= 0;
		last2_data_in <= 0;
		flushing <= 4'b1111;
	end
	else begin
		last_data_in <= data_in;
		last2_data_in <= last_data_in;
		flushing <= {flushing[2:0],1'b0};
	end
end

// 1 bit LFSR model
integer n;
reg fbk;
reg [57:0] lfsr;
reg [WIDTH-1:0] lfsr_out;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		lfsr_out = 0;
		lfsr = 58'h3ff_ffff_ffff_ffff;
	end
	else begin
		for (n=0; n<WIDTH; n=n+1) begin : lf
			fbk = (lfsr[57] ^ lfsr[38] ^ data_in[n]);
			lfsr = {lfsr[56:0],fbk};
			lfsr_out[n] = fbk;	
		end		
	end
end

// XOR network scrambler
wire [WIDTH-1:0] scram_out;
scrambler # (.WIDTH(WIDTH)) duts
(
	.clk,
	.arst,
	.ena(1'b1),
	.din(data_in),		// bit 0 is to be sent first
	.dout(scram_out)
);

// XOR network descrambler
wire [WIDTH-1:0] recover_out;
descrambler # (.WIDTH(WIDTH)) dutd
(
	.clk,
	.arst,
	.ena(1'b1),
	.din(scram_out),		// bit 0 is to be sent first
	.dout(recover_out)
);

reg fail = 0;
always @(posedge clk) begin
	#1 if (lfsr_out !== scram_out) begin
		$display ("Scrambler does not match 1 bit model at time %d",$time);
		fail = 1;
	end
	if (recover_out !== last2_data_in && ~|flushing) begin
		$display ("Recovered data is not as expected at time %d",$time);
		fail = 1;	
	end
end

// clock driver
initial begin
	#1 arst = 1'b1;
	@(negedge clk) arst = 1'b0;
end

always begin
	#5 clk = ~clk;
end

initial begin
	#100000 if (!fail) $display ("PASS");
	$stop();
end
	
endmodule