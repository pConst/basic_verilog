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

// baeckler - 04-04-2006
//
// This verifies the transitive behavior of the 32 and 64 bit
// variable width data CRC-32's.  More to test the output MUX
// wiring than the CRC's themselves.  

module crc32_tb ();

reg [63:0] dat64;

wire [7:0] dat8 = dat64[7:0];
wire [15:0] dat16 = dat64[16:0];
wire [23:0] dat24 = dat64[24:0];
wire [31:0] dat32 = dat64[31:0];

wire [39:0] dat40 = dat64[39:0];
wire [47:0] dat48 = dat64[48:0];
wire [55:0] dat56 = dat64[55:0];

wire [31:0] upper_dat = dat64[63:32];
wire [7:0] upper_dat8 = upper_dat[7:0];
wire [15:0] upper_dat16 = upper_dat[16:0];
wire [23:0] upper_dat24 = upper_dat[24:0];
wire [31:0] upper_dat32 = upper_dat[31:0];

reg [31:0] crc_in;
reg [2:0] dat_size;

///////////////////////////////////////////////
// paste two 32 data units together to make a 64
///////////////////////////////////////////////
wire [31:0] crc_outa,crc_outb;
reg [1:0] dat_size32a, dat_size32b;
reg [31:0] crc_out32s;

crc32_dat32_any_byte d32a (
	.dat_size(dat_size32a),
	.crc_in(crc_in),
	.crc_out(crc_outa),
	.dat8(dat8),.dat16(dat16),.dat24(dat24),.dat32(dat32)
);
defparam d32a .REVERSE_DATA = 1'b1;

crc32_dat32_any_byte d32b (
	.dat_size(dat_size32b),
	.crc_in(crc_outa),
	.crc_out(crc_outb),
	.dat8(upper_dat8),.dat16(upper_dat16),.dat24(upper_dat24),
	.dat32(upper_dat32)
);
defparam d32b .REVERSE_DATA = 1'b1;

always @(*) begin
	dat_size32b = dat_size[1:0];
	if (dat_size[2]) begin
		dat_size32a = 2'b11;
		crc_out32s = crc_outb;
	end
	else begin
		dat_size32a = dat_size[1:0];
		crc_out32s = crc_outa;
	end	 
end

///////////////////////////////////////////////
// 64 data unit
///////////////////////////////////////////////
wire [31:0] crc_out64;

crc32_dat64_any_byte d64 (
	.dat_size(dat_size),
	.crc_in(crc_in),
	.crc_out(crc_out64),
	.dat8(dat8),.dat16(dat16),.dat24(dat24),.dat32(dat32),
	.dat40(dat40),.dat48(dat48),.dat56(dat56),.dat64(dat64)
);
defparam d64 .REVERSE_DATA = 1'b1;


///////////////////////////////////////////////
// Compare
///////////////////////////////////////////////

reg fail;

initial begin
	dat64 = 0;
	dat_size = 0;
	crc_in = 32'hffffffff;
	fail = 0;
	#500000 
	if (!fail) $display ("PASS");
	$stop();
end

always begin
	#100
	crc_in = $random;
	dat64 = {$random,$random};
	dat_size = $random;

	#100
	if (crc_out32s !== crc_out64) begin
		$display ("Mismatch at time %d",$time);
		fail = 1;
	end
end

endmodule