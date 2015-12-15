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

// baeckler - 03-08-2006
// stim and responses taken from the FIPS 197 doc (2001) 
// Appendix B

module aes_128_tb ();

reg [127:0] plain;
reg [127:0] key;
wire [127:0] sub1;
wire [127:0] shftr1;
wire [127:0] mix1;
wire [127:0] key1,key2;
wire [127:0] start2,start3;
wire [127:0] full_out,pipe_out;
reg clk,clr;


initial begin
  clk = 0;
  clr = 0;
  #10 clr = 1;
  #10 clr = 0;
  plain = 128'h3243f6a8885a308d313198a2e0370734;
  key   = 128'h2b7e151628aed2a6abf7158809cf4f3c;
end

// initial round building blocks
sub_bytes sb1 (.in(plain ^ key),.out(sub1));
shift_rows sr1 (.in(sub1),.out(shftr1));
mix_columns mx1 (.in(shftr1),.out(mix1));
evolve_key_128 ek1 (.key_in(key),.rconst(8'h1),
			.key_out(key1));
assign start2 = key1 ^ mix1;

// 2nd round in composite layer
aes_round_128 r2 (
	.clk(1'b0),.clr(1'b0),
	.dat_in(start2),
	.dat_out(start3),
	.rconst(8'h2),
	.skip_mix_col(1'b0),
	.key_in(key1),.key_out(key2)
);

wire [127:0] inv_key,pipe_inv_key,recovered,pipe_recovered;

// full 128 bit cipher, no pipeline
aes_128 rf (.clk(1'b0),.clr(1'b0),
	.dat_in(plain),.key(key),.dat_out(full_out),.inv_key(inv_key));
defparam rf .LATENCY = 0;

// full 128 bit decipher, no pipeline
inv_aes_128 irf (.clk(1'b0),.clr(1'b0),
	.dat_in(full_out),.inv_key(inv_key),.dat_out(recovered));
defparam irf .LATENCY = 0;

// full 128 bit cipher, ten pipeline
aes_128 rp (.clk(clk),.clr(clr),
	.dat_in(plain),.key(key),.dat_out(pipe_out),
	.inv_key(pipe_inv_key));
defparam rp .LATENCY = 10;

// full 128 bit decipher, ten pipeline
inv_aes_128 irp (.clk(clk),.clr(clr),
	.dat_in(pipe_out),.inv_key(pipe_inv_key),.dat_out(pipe_recovered));
defparam irp .LATENCY = 10;

reg [127:0] expected [0:9];
integer n;
	
initial begin
	$display ("Testing Building blocks...");

	#100 if (start2 != 128'ha49c7ff2689f352b6b5bea43026a5049) begin
		$display ("Initial round building blocks aren't working");
		$stop();
	end
	#100 if (start3 != 128'haa8f5f0361dde3ef82d24ad26832469a) begin
		$display ("Second round composite isn't working");
		$stop();
	end
	#100 if (full_out != 128'h3925841d02dc09fbdc118597196a0b32) begin
		$display ("Full encipher 128 no pipeline not working");
		$stop();
	end
	#100 if (recovered != plain) begin
		$display ("Full decipher 128 no pipeline not working");
		$stop();
	end
	
	#100 $display ("Blocks OK. Testing pipelined operation");
	
	// test the pipelined version
	//  fill the pipe, save expected encrypt result
	for (n=0; n<10; n=n+1)
	begin
		#100 expected[n] = full_out;
		$display ("save expected %x",full_out);
		#100 clk = ~clk;
		#100 clk = ~clk;
		key = key + 1;
		plain = plain + 1;
	end
	
	// drain the pipe and check encrypts against expected
	for (n=0; n<10; n=n+1)
	begin
		#100 
		$display ("read back %x",pipe_out);		
		if (expected[n] != pipe_out) begin
			$display ("Pipeline output is incorrect time %d",$time);
			$stop();
		end
		#100 clk = ~clk;
		#100 clk = ~clk;
	end

	plain = plain - 10;

	// drain the pipe and check decrypts against expected
	for (n=0; n<10; n=n+1)
	begin
		#100 
		$display ("read back %x",pipe_recovered);		
		if (plain != pipe_recovered) begin
			$display ("Pipeline output is incorrect time %d",$time);
			$stop();
		end
		#100 clk = ~clk;
		plain = plain + 1;
		#100 clk = ~clk;
	end

	
	$display ("PASS");
	$stop();
	
end

endmodule
