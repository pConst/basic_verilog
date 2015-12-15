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

// baeckler - 06-13-2006
// compare the behavior of the 128 bit data,  any byte residue
// unit to repeated single byte calls

module crc32_128_tb ();

////////////////////////////
// 1 to 16 byte variable unit
// under test
////////////////////////////
reg [3:0] dat_size;
reg [31:0] crc_in;
wire [31:0] crc_out;
reg [127:0] dat;
reg [127:0] tmp_dat;

crc32_dat128_any_byte crc (
	.dat_size(dat_size),
	.crc_in(crc_in),
	.crc_out(crc_out),
	.dat8(dat[7:0]),
	.dat16(dat[15:0]),
	.dat24(dat[23:0]),
	.dat32(dat[31:0]),
	.dat40(dat[39:0]),
	.dat48(dat[47:0]),
	.dat56(dat[55:0]),
	.dat64(dat[63:0]),
	.dat72(dat[71:0]),
	.dat80(dat[79:0]),
	.dat88(dat[87:0]),
	.dat96(dat[95:0]),
	.dat104(dat[103:0]),
	.dat112(dat[111:0]),
	.dat120(dat[119:0]),
	.dat128(dat[127:0])
);

defparam crc .REVERSE_DATA = 1'b1; // LSB first 

////////////////////////////
// Single byte reference
// unit
////////////////////////////

reg [31:0] ref_crc_in;
wire [31:0] ref_crc_out;
reg [7:0] ref_dat_in;

crc32_dat8 ref (
	.crc_in (ref_crc_in),
	.crc_out (ref_crc_out),
	.dat_in ({ref_dat_in[0],ref_dat_in[1],ref_dat_in[2],ref_dat_in[3],
			ref_dat_in[4],ref_dat_in[5],ref_dat_in[6],ref_dat_in[7]})
);


integer n;
reg fail;

initial begin
	fail = 1'b0;
	
	#5000000
	if (!fail) $display ("PASS");
	$stop();
end

always begin
	#500

	// New random stimulus
	dat = {$random,$random,$random,$random};
	crc_in = $random;

	dat_size = $random;
	#10 tmp_dat = dat;
	#10	ref_crc_in = crc_in;
	
	// use the ref unit to iterate through the 
	// data in single bytes.
	for (n=0; n<dat_size+1; n=n+1)
	begin : spin
		ref_dat_in = tmp_dat[7:0];
		#10 if (n != dat_size) ref_crc_in = ref_crc_out;
		#10 tmp_dat = tmp_dat >> 8;
	end		

	// the 128 variable and the iterated bytes 
	// should get the same answer
	if (ref_crc_out != crc_out)
	begin
		$display ("Mismatch at time %d",$time);
		fail =  1'b1;
	end
end

endmodule