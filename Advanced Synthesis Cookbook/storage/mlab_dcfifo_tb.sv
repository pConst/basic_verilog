// Copyright 2010 Altera Corporation. All rights reserved.  
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

`timescale 1 ps/1 ps

module mlab_dcfifo_tb ();

parameter LABS_WIDE = 1;

reg arst = 1'b0;

reg wrclk = 0;
reg [LABS_WIDE*20-1:0] real_wrdata = 0;

reg wrreq = 1'b0;
wire wrfull;

reg rdclk = 0;
wire [LABS_WIDE*20-1:0] rddata;
reg [LABS_WIDE*20-1:0] last_rddata = 0;
reg rdreq = 1'b0;
wire rdempty;	
wire [5:0] rdused;
wire [5:0] wrused;
wire parity_err;

///////////////////
// simple stim + check

wire [LABS_WIDE*20-1:0] wrdata = wrreq ? real_wrdata : 0;

always @(posedge wrclk) begin
	wrreq <= !wrfull & $random & $random;
	if (wrreq) real_wrdata <= real_wrdata + 1'b1;
end

always @(posedge rdclk) begin
	rdreq <= (|rdused[5:2]) & $random & !rdreq;
end

reg fail = 0;
reg last_rdreq = 1'b0;
reg last2_rdreq = 1'b0;
always @(posedge rdclk) begin
	last_rdreq <= rdreq;
	last2_rdreq <= last_rdreq;
	if (last2_rdreq) begin
		last_rddata <= rddata;
		if (rddata !== (last_rddata + 1'b1)) begin
			$display ("Mismatch at time %d",$time);
			fail = 1'b1;
		end
	end	
end

//////////////

mlab_dcfifo dut (.*);
defparam dut .LABS_WIDE = LABS_WIDE;

//////////////

initial begin
	arst = 1'b0;
	#1 arst = 1'b1;
	#100 arst = 1'b0;
end

always begin
	#1600 wrclk = ~wrclk;
end

always begin
	#1900 rdclk = ~rdclk;
end

initial begin
	#10000000 if (!fail) $display ("PASS");
	$stop();
end

endmodule
