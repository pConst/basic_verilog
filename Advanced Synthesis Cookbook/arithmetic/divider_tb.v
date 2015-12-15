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

////////////////////////////////////////////////////
// sanity check for divider.v
////////////////////////////////////////////////////

module divider_tb ();

parameter WIDTH_N = 10;
parameter WIDTH_D = 10;

reg clk,rst,load;

reg [WIDTH_N-1:0] n;
reg [WIDTH_D-1:0] d;
wire [WIDTH_N-1:0] q_a,q_b;
wire [WIDTH_D-1:0] r_a,r_b;
wire ready_a,ready_b;

/////////////////
// radix 4 DUT
/////////////////
divider_rad4 dva (.clk(clk),.rst(rst),.load(load),
		.n(n),.d(d),.q(q_a),.r(r_a),.ready(ready_a));

	defparam dva .WIDTH_N = WIDTH_N;
	defparam dva .WIDTH_D = WIDTH_D;

/////////////////
// plain DUT
/////////////////
divider dvb (.clk(clk),.rst(rst),.load(load),
		.n(n),.d(d),.q(q_b),.r(r_b),.ready(ready_b));

	defparam dvb .WIDTH_N = WIDTH_N;
	defparam dvb .WIDTH_D = WIDTH_D;

/////////////////
// simple model
/////////////////
integer expected_q = 0, expected_r = 0;
always @(posedge clk or posedge rst) begin
	if (rst) begin
		expected_q <= 0;
		expected_r <= 0;
	end
	else begin
		if (load) begin
			expected_q <= n/d;
			expected_r <= n%d;
		end
	end
end

/////////////////
// start test
/////////////////
reg fail;
initial begin
	clk = 0;
	rst = 0; 
	fail = 0;
	load = 0;
	#10 rst = 1;
	#10 rst = 0;
	#10000000 if (!fail) $display ("PASS"); else $display ("FAIL");
	$display ("%d correct answers",tests);
	$stop;
end


always begin
	#100 clk = ~clk;
end

////////////////////
// stim generation
////////////////////
integer tests = 0;
always @(posedge clk) begin
	#10
	if (!load & ready_a & ready_b)
	begin
		@(negedge clk);
		load = 1;
		n = $random;
		d = $random;
		// don't divide by zero
		if (d == 0) d = 1;

		@(posedge clk);
		@(negedge clk);
		load = 0;
		tests = tests + 1;	
	end
end	

////////////////////
// answer checking
////////////////////
always @(posedge ready_a)
begin
	#10 
	if (q_a != expected_q || r_a != expected_r) begin
			$display ("Mismatch on unit A at time %d : %d %d vs %d %d",
				$time,q_a,r_a,expected_q,expected_r);
		fail = 1;
	end
end

always @(posedge ready_b)
begin
	#10 
	if (q_b != expected_q || r_b != expected_r) begin
			$display ("Mismatch on unit B at time %d : %d %d vs %d %d",
				$time,q_b,r_b,expected_q,expected_r);
		fail = 1;
	end
end

endmodule

