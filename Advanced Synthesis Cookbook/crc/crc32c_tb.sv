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

// baeckler - 09-25-2008
// sanity checking and diagnostics for the CRC32c

module crc32c_tb ();

wire [1:0] status_bits = 2'b00;
wire [63:0] sync_word = 64'h78f678f678f678f6;
wire [63:0] scram_state = {6'b001010,58'h0};
wire [63:0] skip_word = {6'b000111,58'h0};
wire [63:0] diag = {6'b011001,24'h000000,status_bits,32'h00000000};

wire [31:0] cc0_out,cc1_out,cc2_out,cc3_out,cc4_out,cc5_out;

// first stage
crc32c_dat64 cc0 (
	.crc_in(32'hffffffff),
	.dat_in(sync_word),
	.crc_out(cc0_out)
);
defparam cc0 .METHOD = 0;

// alternate first stage
wire [31:0] sync_word_evolved, f_evolved, cc0_alt_out;
crc32c_dat64_only cc_a0 (.d(sync_word),.crc_out(sync_word_evolved));
	defparam cc_a0 .METHOD = 0;
	
crc32c_zer64 cc_a1 (.c(32'hffffffff),.crc_out(f_evolved));
	defparam cc_a1 .METHOD = 0;
	
assign cc0_alt_out = sync_word_evolved ^ f_evolved;

// second stage
crc32c_dat64 cc1 (
	.crc_in(cc0_out),
	.dat_in(scram_state),
	.crc_out(cc1_out)
);
defparam cc1 .METHOD = 1;

crc32c_dat64 cc2 (
	.crc_in(cc1_out),
	.dat_in(skip_word),
	.crc_out(cc2_out)
);
defparam cc2 .METHOD = 0;

crc32c_dat64 cc3 (
	.crc_in(cc2_out),
	.dat_in(64'hb5),
	.crc_out(cc3_out)
);
defparam cc3 .METHOD = 1;

crc32c_dat64 cc4 (
	.crc_in(32'h21e1cebf),
	.dat_in(64'hba),
	.crc_out(cc4_out)
);
defparam cc4 .METHOD = 0;

crc32c_dat64 cc5 (
	.crc_in(cc4_out),
	.dat_in(diag),
	.crc_out(cc5_out)
);
defparam cc5 .METHOD = 0;

// alternate cc5
wire [31:0] diag_evolved,a6_out, alt_cc5_out;
crc32c_dat64_only cc_a5 (.d(diag),.crc_out(diag_evolved));
	defparam cc_a5 .METHOD = 1;
	
crc32c_zer64 cc_a6 (.c(cc4_out),.crc_out(a6_out));
	defparam cc_a6 .METHOD = 1;
	
assign alt_cc5_out = a6_out ^ diag_evolved;


wire [31:0] cc6_out;
crc32c_dat64 cc6 (
	.crc_in(cc4_out),
	.dat_in(diag | (32'h2bdb65fc)), // ^ 32'hffffffff)),
	.crc_out(cc6_out)
);
defparam cc6 .METHOD = 0;


initial begin
	#5 
	if (cc0_out !== cc0_alt_out ||
		cc5_out !== alt_cc5_out) begin
		$display ("The decomposition into data and crc halves is incorrect");
		$stop();
	end
	
	$display ("CRC 32c of first 3 words is %x",cc2_out);
	if (cc2_out !== 32'hd49b6ab8) begin
		$display ("There is something wrong with the polynomial / XOR network");
		$stop();
	end
	
	#5 $display ("PASS");
	$stop();
end

endmodule

