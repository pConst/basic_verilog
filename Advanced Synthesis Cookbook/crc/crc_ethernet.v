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

// baeckler - 04-03-2006
//
// typical Ethernet FCS style CRC-32 for Stratix II
//   variable data width, 1..4 bytes
//
// Testbench at bottom does the ASCII 1..9 test.
//   
module crc_ethernet (
	aclr,
	clk,
	ena,
	init,
	dat_size,
	crc_out,
	dat
);

input [1:0] dat_size; // 0=1 byte .. 3=4 bytes.
input [31:0] dat;
input clk;
input ena;				// deactivate me for power savings
input aclr;				// async rst to 0
input init;				// sync load 111...
output [31:0] crc_out;  // reversed and inverted

reg [31:0] crc_out;  

wire [31:0] crc_rin_wire;
wire [31:0] crc_rout_wire;

// 32 bit register bank, initializes to 111.. on the init signal.
crc_register rg (
	.d(crc_rin_wire),
	.q(crc_rout_wire),
	.clk(clk),
	.init(init),
	.sclr(1'b0),
	.ena(ena),
	.aclr(aclr));

// parallel array of CRC XORs
crc32_dat32_any_byte cr (
	.dat_size(dat_size),
	.crc_in(crc_rout_wire),
	.crc_out(crc_rin_wire),
	.dat8 (dat[7:0]),
	.dat16 ({dat[7:0],dat[15:8]}),
	.dat24 ({dat[7:0],dat[15:8],dat[23:16]}),
	.dat32 ({dat[7:0],dat[15:8],dat[23:16],dat[31:24]})
);
defparam cr .REVERSE_DATA = 1;

// reverse and invert the CRC output lines
integer i;
always @(crc_rout_wire) begin
  for (i=0;i<32;i=i+1) 
  begin
    crc_out[i] = !crc_rout_wire[31-i];
  end
end

endmodule

////////////////////////////////////////   
// testbench
////////////////////////////////////////   
module crc_ethernet_tb ();

reg clk,init;
reg [1:0] dat_size;
wire [31:0] crc_out;
reg [31:0] dat;
reg aclr;

crc_ethernet ce (.aclr(aclr),.clk(clk),.ena(1'b1),
	.init(init),.dat_size(dat_size),.crc_out(crc_out),
	.dat(dat)
);

initial begin
	aclr = 0;
	clk = 0;
	dat = 0;
	init = 0;
	dat_size = 0;
	#10 aclr = 1;
	#10 aclr = 0;

	// sync reset to all 1's (internally)
	init = 1;
	#10 clk = 1;
	#10 clk = 0;
	init = 0;
	$display ("After Init : %x",crc_out);

	// apply "1234"
	dat_size = 2'b11; // 4 byte
	dat = "1234";
	#10 clk = 1;
	#10 clk = 0;
	$display ("After 1234 : %x",crc_out);

	// apply "5678"
	dat = "5678";
	#10 clk = 1;
	#10 clk = 0;
	$display ("After 5678 : %x",crc_out);


	// apply "9"
	dat_size = 2'b00; // 1 byte residue
	dat = {24'b0,"9"}; // upper 24 bits are don't care
	#10 clk = 1;
	#10 clk = 0;
	$display ("After 9 : %x",crc_out);


	//check it
	if (crc_out != 32'hcbf43926) begin
		$display ("Failed 1233456789 test");
	end
	else begin
		$display ("Passed 1233456789 test");
	end
	$stop();
end

endmodule
