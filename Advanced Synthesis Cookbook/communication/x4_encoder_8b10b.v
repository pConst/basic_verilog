// Copyright 2009 Altera Corporation. All rights reserved.  
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

module x4_encoder_8b10b (
    input clk,
    input rst,
    input [3:0] kin_ena,             // Data in is a special code, not all are legal.      
    input [31 : 0] ein_dat,          // 8b data in
    output [39 : 0] eout_dat           // data out
);

parameter METHOD = 1;

wire [3:0] eout_rdcomb;
wire [3:0] eout_rdreg;
wire [3:0] eout_val;                   // not used, since ein_ena not used in cascaded version

encoder_8b10b enc3(
    .clk (clk),
    .rst (rst),
    .kin_ena(kin_ena[3]),             // Data in is a special code, not all are legal.      
    .ein_ena(1'b1),                   // Data (or code) input enable
    .ein_dat(ein_dat[31 : 24]),       // 8b data in
    .ein_rd(eout_rdreg[0]),           // running disparity input
    .eout_val(eout_val[3]),           // data out is valid
    .eout_dat(eout_dat[39 : 30]),     // data out
    .eout_rdcomb(eout_rdcomb[3]),     // running disparity output (comb)
    .eout_rdreg(eout_rdreg[3])        // running disparity output (reg)
);
	defparam enc3.METHOD = METHOD;
	
encoder_8b10b enc2(
    .clk (clk),
    .rst (rst),
    .kin_ena(kin_ena[2]),             // Data in is a special code, not all are legal.      
    .ein_ena(1'b1),                   // Data (or code) input enable
    .ein_dat(ein_dat[23 : 16]),       // 8b data in
    .ein_rd(eout_rdcomb[3]),          // running disparity input
    .eout_val(eout_val[2]),           // data out is valid
    .eout_dat(eout_dat[29 : 20]),     // data out
    .eout_rdcomb(eout_rdcomb[2]),     // running disparity output (comb)
    .eout_rdreg(eout_rdreg[2])        // running disparity output (reg)
);
	defparam enc2.METHOD = METHOD;
	
encoder_8b10b enc1(
    .clk (clk),
    .rst (rst),
    .kin_ena(kin_ena[1]),             // Data in is a special code, not all are legal.      
    .ein_ena(1'b1),                   // Data (or code) input enable
    .ein_dat(ein_dat[15 : 8]),        // 8b data in
    .ein_rd(eout_rdcomb[2]),          // running disparity input
    .eout_val(eout_val[1]),           // data out is valid
    .eout_dat(eout_dat[19 : 10]),     // data out
    .eout_rdcomb(eout_rdcomb[1]),     // running disparity output (comb)
    .eout_rdreg(eout_rdreg[1])        // running disparity output (reg)
);
	defparam enc1.METHOD = METHOD;

encoder_8b10b enc0(
    .clk (clk),
    .rst (rst),
    .kin_ena(kin_ena[0]),             // Data in is a special code, not all are legal.      
    .ein_ena(1'b1),                   // Data (or code) input enable
    .ein_dat(ein_dat[7 : 0]),         // 8b data in
    .ein_rd(eout_rdcomb[1]),          // running disparity input
    .eout_val(eout_val[0]),           // data out is valid
    .eout_dat(eout_dat[9 : 0]),      // data out
    .eout_rdcomb(eout_rdcomb[0]),     // running disparity output (comb)
    .eout_rdreg(eout_rdreg[0])        // running disparity output (reg)
);
	defparam enc0.METHOD = METHOD;

endmodule
