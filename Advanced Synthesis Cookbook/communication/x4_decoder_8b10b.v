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

module x4_decoder_8b10b (
	input         clk,
	input         rst,
	input [39:0]  din_dat,         // 10b data input
	output [31:0] dout_dat,        // data out
	output [3:0]  dout_k,          // special code
	output [3:0]  dout_kerr,       // coding mistake detected
	output [3:0]  dout_rderr,      // running disparity mistake detected
	output [3:0]  dout_rdcomb,     // running dispartiy output (comb)
	output [3:0]  dout_rdreg       // running disparity output (reg)
);

parameter METHOD = 1;

decoder_8b10b dec3(
    .clk (clk),
    .rst (rst),
    .din_ena(1'b1),                   // Data (or code) input enable
    .din_dat(din_dat[39 : 30]),       // 8b data in
    .din_rd(dout_rdreg[0]),           // running disparity input
    .dout_val(),
    .dout_kerr(dout_kerr[3]),
    .dout_dat(dout_dat[31 : 24]),     // data out
    .dout_k(dout_k[3]),
    .dout_rderr(dout_rderr[3]),
    .dout_rdcomb(dout_rdcomb[3]),     // running disparity output (comb)
    .dout_rdreg(dout_rdreg[3])        // running disparity output (reg)
);
defparam dec3.METHOD = METHOD;
	
decoder_8b10b dec2(
    .clk (clk),
    .rst (rst),
    .din_ena(1'b1),                   // Data (or code) input enable
    .din_dat(din_dat[29 : 20]),       // 8b data in
    .din_rd(dout_rdcomb[3]),          // running disparity input
    .dout_val(),
    .dout_kerr(dout_kerr[2]),
    .dout_dat(dout_dat[23 : 16]),     // data out
    .dout_k(dout_k[2]),
    .dout_rderr(dout_rderr[2]),
    .dout_rdcomb(dout_rdcomb[2]),     // running disparity output (comb)
    .dout_rdreg(dout_rdreg[2])        // running disparity output (reg)
);
defparam dec2.METHOD = METHOD;
	
decoder_8b10b dec1(
    .clk (clk),
    .rst (rst),
    .din_ena(1'b1),                   // Data (or code) input enable
    .din_dat(din_dat[19 : 10]),       // 8b data in
    .din_rd(dout_rdcomb[2]),          // running disparity input
    .dout_val(),
    .dout_kerr(dout_kerr[1]),
    .dout_dat(dout_dat[15 : 8]),      // data out
    .dout_k(dout_k[1]),
    .dout_rderr(dout_rderr[1]),
    .dout_rdcomb(dout_rdcomb[1]),     // running disparity output (comb)
    .dout_rdreg(dout_rdreg[1])        // running disparity output (reg)
);
defparam dec1.METHOD = METHOD;

decoder_8b10b dec0(
    .clk (clk),
    .rst (rst),
    .din_ena(1'b1),                   // Data (or code) input enable
    .din_dat(din_dat[9 : 0]),         // 8b data in
    .din_rd(dout_rdcomb[1]),          // running disparity input
    .dout_val(),
    .dout_kerr(dout_kerr[0]),
    .dout_dat(dout_dat[7 : 0]),       // data out
    .dout_k(dout_k[0]),
    .dout_rderr(dout_rderr[0]),
    .dout_rdcomb(dout_rdcomb[0]),     // running disparity output (comb)
    .dout_rdreg(dout_rdreg[0])        // running disparity output (reg)
);
defparam dec0.METHOD = METHOD;

endmodule
