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

// baeckler - 06-16-2006

module counter_tb ();

parameter WIDTH = 8;
parameter MOD_VAL = 67;

reg clk,ena,sload,rst,sclear,inc_not_dec;
reg [WIDTH-1:0] sdata;

//////////////////////
// Units for test
//////////////////////
wire [WIDTH-1:0] c_q;
integer c_q_expect;
cntr c (.clk(clk),.ena(ena),.rst(rst),
	.sload(sload),.sdata(sdata),.sclear(sclear),.q(c_q));
defparam c .WIDTH = WIDTH;

wire [WIDTH-1:0] cud_q;
reg [WIDTH-1:0] cud_q_expect; // this guy can go negative
cntr_updn cud (.clk(clk),.ena(ena),.rst(rst),
	.sload(sload),.sdata(sdata),.sclear(sclear),
	.inc_not_dec(inc_not_dec), .q(cud_q));
defparam cud .WIDTH = WIDTH;

wire [WIDTH-1:0] cm_q;
integer cm_q_expect;
cntr_modulus cm (.clk(clk),.ena(ena),.rst(rst),
	.sload(sload),.sdata(sdata),.sclear(sclear),.q(cm_q));
defparam cm .WIDTH = WIDTH;
defparam cm .MOD_VAL = MOD_VAL;

wire [WIDTH-1:0] cmla_q;
integer cmla_q_expect;
cntr_modulus_la cmla (.clk(clk),.ena(ena),.rst(rst),
	.sload(sload),.sdata(sdata),.sclear(sclear),.q(cmla_q));
defparam cmla .WIDTH = WIDTH;
defparam cmla .MOD_VAL = MOD_VAL;

/////////////////////////////////////////
// Stimulus generation and check
/////////////////////////////////////////
reg fail;
initial begin 
	clk = 0;
	rst = 0;
	#10 rst = 1;
	#10 rst = 0;
	ena = 0;
	inc_not_dec = 0;
	sclear = 0;
	sload = 0;
	sdata = 0;
	fail = 0;
	#100000000 if (!fail) $display ("PASS");
	$stop();
end

always begin
	#100 clk = ~clk;
end

always @(negedge clk) begin
	if (c_q != c_q_expect[WIDTH-1:0] ||
		cud_q != cud_q_expect[WIDTH-1:0] ||
		cm_q != cm_q_expect[WIDTH-1:0] ||
		cmla_q != cmla_q_expect[WIDTH-1:0])
	begin
		$display ("Mismatch at time %d",$time);
		fail = 1;
	end

	#10
	sload = $random & $random;
	sdata = $random;
	ena = $random | $random;
	sclear = $random & $random;
end

/////////////////////////////////////////
// expected behavior
/////////////////////////////////////////
always @(posedge clk or posedge rst) begin
	if (rst) begin
		c_q_expect = 0;
		cud_q_expect = 0;
		cm_q_expect = 0;
		cmla_q_expect = 0;
	end
	else begin
		if (ena) begin
			if (sclear) begin
				c_q_expect = 0;
				cud_q_expect = 0;
				cm_q_expect = 0;
				cmla_q_expect = 0;
			end
			else if (sload) begin
				c_q_expect = sdata;
				cud_q_expect = sdata;
				cm_q_expect = sdata;
				cmla_q_expect = sdata;
			end
			else begin
				c_q_expect = c_q_expect + 1;
				cud_q_expect = inc_not_dec ? (cud_q_expect + 1) : (cud_q_expect - 1);
		
				// Note:
				// this is not the same as a real modulus
				// if you have used the sload to get above
				// the working range		

				cm_q_expect = cm_q_expect + 1;
				if (cm_q_expect[WIDTH-1:0] == MOD_VAL) begin
					cm_q_expect = 0;
				end

				cmla_q_expect = cm_q_expect;
			end						
		end
	end
end

endmodule