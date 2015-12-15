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

// baeckler - 08-04-2008

module cordic_tb ();

// The output functions are approximations, this compares four signed 16 bit
// words to expected values with some error margin.

function significant_error;
	input [63:0] a,b;
	integer n,diff;
	begin
		significant_error = 1'b0;
		
		for (n=0; n<4; n=n+1)
		begin : cmp
			diff = {a[15],a[15:0]} - {b[15],b[15:0]};
			if (diff[16]) diff = -diff;
			diff = diff & 16'hffff;
			
			// This means that an absolute deviation of +/- 8 points
			// is considered to be passing for testbench purposes.  
			if (diff > 8) significant_error = 1'b1;
			
			a = a >> 16;
			b = b >> 16;
		end		
	end
endfunction


// test device
reg clk,sclr;
reg [4*16-1:0] xin,yin,zin,rot;
reg [4*16-1:0] xout,yout,zout;
wire xo,yo,zo;

cordic dut 
(
	.clk,
	.sclr,
	.xi(xin[0]),
	.yi(yin[0]),
	.zi(zin[0]),
	.rot(rot[0]),
	.valid(valid),
	.xo,
	.yo,
	.zo
);

always begin
	#5 clk = ~clk;
end

// constants for testing
reg [15:0] gain = 16'b0110100101100100; // 1.64676026
reg [15:0] inv_gain = 16'b0010011011011101; // 0.60725294
reg [15:0] pi_over_8 = 16'b0001100100100001; // 0.39269908
reg [15:0] sin_pi_over_8 = 16'b0001100001111101; // 0.38268343
reg [15:0] cos_pi_over_8 = 16'b0011101100100000; // 0.92387953
reg [15:0] neg_pi_over_3 = 16'b1011110011111010; // -1.04719755
reg [15:0] sin_neg_pi_over_3 = 16'b1100100010010011; // -0.86602540
reg [15:0] cos_neg_pi_over_3 = 16'b0010000000000000; // 0.50000000
reg [15:0] pi_over_4 = 16'b0011001001000011; // 0.78539816
reg [15:0] neg_pi_over_4 = 16'b1100110110111100; // -0.78539816
reg [15:0] gained_vec_len = 16'b0010010101000011; // 0.58221767


reg [4*16-1:0] expected_x;
reg [4*16-1:0] expected_y;
reg [4*16-1:0] expected_z;
reg fail = 1'b0;

initial begin
	clk = 0;
	sclr = 0;

	// Test questions :
	// find angle for [2,-2]
	// find angle for [1, 1]
	// find sin,cos for -pi / 3
	// find sin,cos for pi / 8
	xin = {16'h1000,	16'h1000,	inv_gain,	inv_gain};
	yin = {16'hf000,	16'h1000,	16'h0000,	16'h0000};
	zin = {16'h0000,	16'h0000,	neg_pi_over_3,pi_over_8}; 
	rot = 1'b1;

	expected_x = {gained_vec_len,gained_vec_len,cos_neg_pi_over_3,cos_pi_over_8};
	expected_y = {16'h0000,16'h0000,sin_neg_pi_over_3,sin_pi_over_8};
	expected_z = {neg_pi_over_4,pi_over_4,16'h0000,16'h0000};

	@(negedge clk) sclr = 1'b1;
	@(negedge clk) sclr = 1'b0;	

	@(posedge valid);
	@(posedge valid);
	@(posedge valid);
	rot = 1'b0;
	@(posedge valid);
	@(posedge valid);
	@(negedge valid);

	// check outputs
	if (significant_error (xout,expected_x)) begin
		$display ("Significant deviation between actual and expected X");
		fail = 1'b1;
	end
	if (significant_error (yout,expected_y)) begin
		$display ("Significant deviation between actual and expected Y");
		fail = 1'b1;
	end
	if (significant_error (zout,expected_z)) begin
		$display ("Significant deviation between actual and expected Z");
		fail = 1'b1;
	end

	if (!fail) $display ("PASS");
	$stop();
end

always @(posedge clk) begin
	if (valid) begin
		xin <= {xin[0],xin[4*16-1:1]};
		yin <= {yin[0],yin[4*16-1:1]};
		zin <= {zin[0],zin[4*16-1:1]};		

		xout <= {xo,xout[4*16-1:1]};
		yout <= {yo,yout[4*16-1:1]};
		zout <= {zo,zout[4*16-1:1]};
	end
end

endmodule
