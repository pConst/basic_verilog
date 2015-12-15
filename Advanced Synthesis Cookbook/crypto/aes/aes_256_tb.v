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
// stim and responses taken from the FIPS 197 doc (2001) appendix C.3


module aes_256_tb ();

reg [127:0] plain;
reg [255:0] key;
wire [127:0] sub1;
wire [127:0] shftr1;
wire [127:0] mix1;
wire [255:0] key1,key2;
wire [127:0] start2,start3;
wire [127:0] full_out,pipe_out;
reg clk,clr;


initial begin
  clk = 0;
  clr = 0;
  #10 clr = 1;
  #10 clr = 0;
  plain = 128'h00112233445566778899aabbccddeeff;
  key   = {	128'h000102030405060708090a0b0c0d0e0f,
			128'h101112131415161718191a1b1c1d1e1f};
end

///////////////////////////////////////////////////
// Execute the initial round using building blocks
///////////////////////////////////////////////////
sub_bytes sb1 (.in(plain ^ key[255:128]),.out(sub1));
shift_rows sr1 (.in(sub1),.out(shftr1));
mix_columns mx1 (.in(shftr1),.out(mix1));
evolve_key_256 ek1 (.key_in(key),.rconst(8'h1),.key_out(key1));
	defparam ek1 .KEY_EVOLVE_TYPE = 0;
assign start2 = key1[255:128] ^ mix1;

///////////////////////////////////////////////////
// Execute the 2nd round using a composite "round"
///////////////////////////////////////////////////
aes_round_256 r2 (
	.clk(1'b0),.clr(1'b0),
	.dat_in(start2),
	.dat_out(start3),
	.rconst(8'h2),
	.skip_mix_col(1'b0),
	.key_in(key1),.key_out(key2)
);
	defparam r2 .KEY_EVOLVE_TYPE = 1;
	defparam r2 .LATENCY = 0;

wire [255:0] inv_key,pipe_inv_key;
wire [127:0] recovered,pipe_recovered;

///////////////////////////////////////////////////
// full 256 bit cipher, no pipeline
///////////////////////////////////////////////////
aes_256 rf (.clk(1'b0),.clr(1'b0),
	.dat_in(plain),.key(key),.dat_out(full_out),.inv_key(inv_key));
defparam rf .LATENCY = 0;

// full 256 bit decipher, no pipeline
inv_aes_256 irf (.clk(1'b0),.clr(1'b0),
	.dat_in(full_out),.inv_key(inv_key),.dat_out(recovered));
defparam irf .LATENCY = 0;

///////////////////////////////////////////////////
// full 256 bit cipher, 14 pipeline
///////////////////////////////////////////////////
aes_256 rp (.clk(clk),.clr(clr),
	.dat_in(plain),.key(key),.dat_out(pipe_out),
	.inv_key(pipe_inv_key));
defparam rp .LATENCY = 14;

// full 256 bit decipher, 14 pipeline
inv_aes_256 irp (.clk(clk),.clr(clr),
	.dat_in(pipe_out),.inv_key(pipe_inv_key),.dat_out(pipe_recovered));
defparam irp .LATENCY = 14;

reg [127:0] expected [0:13];
integer n;

///////////////////////////////////////////////////
// test
///////////////////////////////////////////////////
	
initial begin
	$display ("Testing Building blocks...");

	#100 if (start2 != 128'h4f63760643e0aa85efa7213201a4e705) begin
		$display ("Initial round building blocks aren't working");
		$display ("Actual value %x",start2);
		$stop();
	end
	#100 if (start3 != 128'h1859fbc28a1c00a078ed8aadc42f6109) begin
		$display ("Second round composite isn't working");
		$display ("Actual value %x",start3);
		$stop();
	end

	#100 $display ("Building Blocks OK.  Testing full encipher");
	
	#100 if (full_out != 128'h8ea2b7ca516745bfeafc49904b496089) begin
		$display ("Full encipher 256 no pipeline not working");
		$stop();
	end
	
	#100 $display ("Full encipher OK.  Testing decipher");
	
	#100 if (recovered != plain) begin
		$display ("Full decipher 256 no pipeline not working");
		$stop();
	end
	
	#100 $display ("Full decipher OK.  Testing pipeline");
	
	// test the pipelined version
	//  fill the pipe, save expected encrypt result
	for (n=0; n<14; n=n+1)
	begin
		#100 expected[n] = full_out;
		$display ("save expected %x",full_out);
		#100 clk = ~clk;
		#100 clk = ~clk;
		key = key + 1;
		plain = plain + 1;
	end
	
	// drain the pipe and check encrypts against expected
	for (n=0; n<14; n=n+1)
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

	plain = plain - 14;

	// drain the pipe and check decrypts against expected
	for (n=0; n<14; n=n+1)
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
