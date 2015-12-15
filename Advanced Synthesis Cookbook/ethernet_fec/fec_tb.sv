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

// baeckler 12-04-2008

module fec_tb ();

// quickie function to get the number of bits
// between the highest and lowest 1s in the 
// noise, inclusive.

function [6:0] burst_length;
    input [63:0] din;
    reg [63:0] tmp;
    burst_length = 0;
    if (din != 64'h0) begin
		tmp = din;
		while (!tmp[0]) tmp = tmp >> 1'b1;
		while (tmp != 64'h0) begin
			burst_length = burst_length + 1;
			tmp = tmp >> 1'b1;
		end			
    end
endfunction

reg clk,arst;
reg [31:0] din;
wire [31:0] tx_data,recovered;
wire parity_match;
reg [6:0] frame_word; // a frame is 66 32 bit words = 2112 bits

/////////////////////////////////
// generate some sample frame data

always @(posedge clk or posedge arst) begin
	if (arst) begin
		din <= 0;
		frame_word <= 0;
	end
	else begin
		if (frame_word == 7'd65) frame_word <= 0;
		else frame_word <= frame_word + 1'b1;
		
		if (frame_word != 7'd65) din <= din + 1'b1;		
	end		
end

/////////////////////////////////
// TX test unit

fec_gen dutt
(
	.clk,
	.arst,
	.din,
	.parity_sel(frame_word == 7'd65),
	.dout(tx_data)
);

/////////////////////////////////
// Err inject

wire [31:0] noisy_data;
reg [31:0] noise;
reg [63:0] full_noise;
integer noise_cntr, noise_burst_len = 0;
assign noisy_data = tx_data ^ noise;

always @(posedge clk or posedge arst) begin
	if (arst) begin
		noise_cntr <= 0;
		noise <= 0;
	end
	else begin
		noise_cntr <= noise_cntr + 1'b1;
		noise <= 0;
		if ((noise_cntr % 217) == 200) begin
			noise <= $random & $random & $random & $random & $random;
		end
		if ((noise_cntr % 217) == 201) begin
			full_noise[63:32] <= noise;
			noise <= $random & $random & $random & $random & $random;				
		end
		if ((noise_cntr % 217) == 202) begin
			full_noise[31:0] <= noise;			
		end
		if ((noise_cntr % 217) == 203) begin
			noise_burst_len <= burst_length(full_noise);
		end		
	end
end

/////////////////////////////////
// RX test unit

fec_check dutr 
(
    .clk,
    .arst,
    .sof(frame_word == 7'd1),	// lagged +1 from TX
    .eof(frame_word == 7'd0),
    .din(noisy_data),
    .dout(recovered),
    .parity_match
);

/////////////////////////////////
// Inspect the recovered data

localparam FRAME_STALL = 66 + 6;
reg [FRAME_STALL*32-1:0] frame_buffer;
wire [32-1:0] expected;
always @(posedge clk) begin
    frame_buffer <= {frame_buffer [(FRAME_STALL-1)*32-1:0],
		((frame_word == 7'd65) ? 32'h0 : din)};
end
assign expected = frame_buffer[FRAME_STALL*32-1:(FRAME_STALL-1)*32];

reg damaged;
always @(posedge clk) begin
	damaged <= (expected != 32'h0) && (|(expected ^ recovered));
end

/////////////////////////////////
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
