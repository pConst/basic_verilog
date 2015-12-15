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
//
// CRC32 of data with any size from 1 to 16 bytes (e.g. residues)
// the input data ports typically come from the same 128 bit 
// register, but this is not a requirement.

module crc32_dat128_any_byte (
	dat_size,
	crc_in,
	crc_out,
	dat8,dat16,dat24,dat32,
	dat40,dat48,dat56,dat64,
	dat72,dat80,dat88,dat96,
	dat104,dat112,dat120,dat128
);

input [3:0] dat_size;
input [31:0] crc_in;

output [31:0] crc_out;
wire [31:0] crc_out;

input [7:0] dat8;
input [15:0] dat16;
input [23:0] dat24;
input [31:0] dat32;
input [39:0] dat40;
input [47:0] dat48;
input [55:0] dat56;
input [63:0] dat64;

input [71:0] dat72;
input [79:0] dat80;
input [87:0] dat88;
input [95:0] dat96;
input [103:0] dat104;
input [111:0] dat112;
input [119:0] dat120;
input [127:0] dat128;

parameter METHOD = 1; // depth optimal factored
parameter REVERSE_DATA = 0; // Use LSB first

// internal data signals
wire [7:0] dat8_w;
wire [15:0] dat16_w;
wire [23:0] dat24_w;
wire [31:0] dat32_w;
wire [39:0] dat40_w;
wire [47:0] dat48_w;
wire [55:0] dat56_w;
wire [63:0] dat64_w;


wire [71:0] dat72_w;
wire [79:0] dat80_w;
wire [87:0] dat88_w;
wire [95:0] dat96_w;
wire [103:0] dat104_w;
wire [111:0] dat112_w;
wire [119:0] dat120_w;
wire [127:0] dat128_w;

//////////////////////////////////////////////////////
// Optional reversal of the data bits to do LSB
//   of data 1st.  No area cost
//////////////////////////////////////////////////////
genvar i;
generate
if (REVERSE_DATA)
begin
		for (i=0; i<128; i=i+1)
		begin : rev_128
			assign dat128_w[i] = dat128[127-i];		
		end
		for (i=0; i<120; i=i+1)
		begin : rev_120
			assign dat120_w[i] = dat120[119-i];		
		end
		for (i=0; i<112; i=i+1)
		begin : rev_112
			assign dat112_w[i] = dat112[111-i];		
		end
		for (i=0; i<104; i=i+1)
		begin : rev_104
			assign dat104_w[i] = dat104[103-i];		
		end
		for (i=0; i<96; i=i+1)
		begin : rev_96
			assign dat96_w[i] = dat96[95-i];		
		end
		for (i=0; i<88; i=i+1)
		begin : rev_88
			assign dat88_w[i] = dat88[87-i];		
		end
		for (i=0; i<80; i=i+1)
		begin : rev_80
			assign dat80_w[i] = dat80[79-i];		
		end
		for (i=0; i<72; i=i+1)
		begin : rev_72
			assign dat72_w[i] = dat72[71-i];		
		end


		for (i=0; i<64; i=i+1)
		begin : rev_64
			assign dat64_w[i] = dat64[63-i];		
		end
		for (i=0; i<56; i=i+1)
		begin : rev_56
			assign dat56_w[i] = dat56[55-i];		
		end
		for (i=0; i<48; i=i+1)
		begin : rev_48
			assign dat48_w[i] = dat48[47-i];		
		end
		for (i=0; i<40; i=i+1)
		begin : rev_40
			assign dat40_w[i] = dat40[39-i];		
		end
		for (i=0; i<32; i=i+1)
		begin : rev_32
			assign dat32_w[i] = dat32[31-i];		
		end
		for (i=0; i<24; i=i+1)
		begin : rev_24
			assign dat24_w[i] = dat24[23-i];		
		end
		for (i=0; i<16; i=i+1)
		begin : rev_16
			assign dat16_w[i] = dat16[15-i];		
		end
		for (i=0; i<8; i=i+1)
		begin : rev_8
			assign dat8_w[i] = dat8[7-i];		
		end
end
else
begin
	// no reversal - pass along
	assign dat128_w = dat128;
	assign dat120_w = dat120;
	assign dat112_w = dat112;
	assign dat104_w = dat104;
	assign dat96_w = dat96;
	assign dat88_w = dat88;
	assign dat80_w = dat80;
	assign dat72_w = dat72;

	assign dat64_w = dat64;
	assign dat56_w = dat56;
	assign dat48_w = dat48;
	assign dat40_w = dat40;
	assign dat32_w = dat32;
	assign dat24_w = dat24;
	assign dat16_w = dat16;
	assign dat8_w = dat8;
end
endgenerate

//////////////////////////////////////////////////////
// define a parallel array of CRC units for one to 
//	sixteen bytes of data.
//////////////////////////////////////////////////////
	wire [31:0] co_a,co_b,co_c,co_d,co_e,co_f,co_g,co_h;
	wire [31:0] co_i,co_j,co_k,co_l,co_m,co_n,co_o,co_p;
	
	crc32_dat8  a (.crc_in (crc_in),.crc_out (co_a),.dat_in(dat8_w));
	crc32_dat16 b (.crc_in (crc_in),.crc_out (co_b),.dat_in(dat16_w));
	crc32_dat24 c (.crc_in (crc_in),.crc_out (co_c),.dat_in(dat24_w));
	crc32_dat32 d (.crc_in (crc_in),.crc_out (co_d),.dat_in(dat32_w));
	crc32_dat40 e (.crc_in (crc_in),.crc_out (co_e),.dat_in(dat40_w));
	crc32_dat48 f (.crc_in (crc_in),.crc_out (co_f),.dat_in(dat48_w));
	crc32_dat56 g (.crc_in (crc_in),.crc_out (co_g),.dat_in(dat56_w));
	crc32_dat64 h (.crc_in (crc_in),.crc_out (co_h),.dat_in(dat64_w));

	crc32_dat72 ii (.crc_in (crc_in),.crc_out (co_i),.dat_in(dat72_w));
	crc32_dat80 j (.crc_in (crc_in),.crc_out (co_j),.dat_in(dat80_w));
	crc32_dat88 k (.crc_in (crc_in),.crc_out (co_k),.dat_in(dat88_w));
	crc32_dat96 l (.crc_in (crc_in),.crc_out (co_l),.dat_in(dat96_w));
	crc32_dat104 m (.crc_in (crc_in),.crc_out (co_m),.dat_in(dat104_w));
	crc32_dat112 n (.crc_in (crc_in),.crc_out (co_n),.dat_in(dat112_w));
	crc32_dat120 o (.crc_in (crc_in),.crc_out (co_o),.dat_in(dat120_w));
	crc32_dat128 p (.crc_in (crc_in),.crc_out (co_p),.dat_in(dat128_w));

	defparam a .METHOD = METHOD;
	defparam b .METHOD = METHOD;
	defparam c .METHOD = METHOD;
	defparam d .METHOD = METHOD;
	defparam e .METHOD = METHOD;
	defparam f .METHOD = METHOD;
	defparam g .METHOD = METHOD;
	defparam h .METHOD = METHOD;

	defparam ii .METHOD = METHOD;
	defparam j .METHOD = METHOD;
	defparam k .METHOD = METHOD;
	defparam l .METHOD = METHOD;
	defparam m .METHOD = METHOD;
	defparam n .METHOD = METHOD;
	defparam o .METHOD = METHOD;
	defparam p .METHOD = METHOD;

//////////////////////////////////////////////////////
// select the CRC output according to data width
//////////////////////////////////////////////////////
generate
	for (i=0; i<32;i=i+1)
	begin : parmux
		wire [15:0] tmp_m;
		
		assign tmp_m[0] = co_a[i];
		assign tmp_m[1] = co_b[i];
		assign tmp_m[2] = co_c[i];
		assign tmp_m[3] = co_d[i];
		assign tmp_m[4] = co_e[i];
		assign tmp_m[5] = co_f[i];
		assign tmp_m[6] = co_g[i];
		assign tmp_m[7] = co_h[i];
		
		assign tmp_m[8] = co_i[i];
		assign tmp_m[9] = co_j[i];
		assign tmp_m[10] = co_k[i];
		assign tmp_m[11] = co_l[i];
		assign tmp_m[12] = co_m[i];
		assign tmp_m[13] = co_n[i];
		assign tmp_m[14] = co_o[i];
		assign tmp_m[15] = co_p[i];
		
		assign crc_out[i] = tmp_m[dat_size];
	end	
endgenerate

endmodule