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

// baeckler - 06-18-2007
//
// simulate with "vsim -pli float_vpi.dll"
//
// To build the float_vpi Modelsim plug in see
// Coconut utility directory - file build_float_vpi.sh
//

module approx_fp_div_tb ();

////////////////////////
// define the latency here
////////////////////////
parameter LATENCY = 5;

wire [31:0] q;
reg clk = 0;
reg [31:0] nf,df;
reg [31:0] qf[LATENCY:0];

////////////////////////
// test unit 
////////////////////////

approx_fp_div dut (.a(nf), .b(df), .q(q), .clk(clk));

////////////////////////
// C based model
////////////////////////
always @(posedge clk) begin
	qf[0] <= $float_div (nf,df);
end

genvar i;
generate
for (i=1; i<=LATENCY; i=i+1)
begin: output_latency
	always @(posedge clk) begin
		qf[i] <= qf[i-1];
	end
end
endgenerate

////////////////////////
// stimulus 
////////////////////////
initial begin
	nf = $rand_float;
	df = $rand_float;
end

always @(negedge clk) begin
	nf = $rand_float;
	df = $rand_float;
end

always begin
	#10 clk = ~clk;
end

////////////////////////
// check
////////////////////////
integer err_bar;
reg fail = 0;

always @(posedge clk) begin
	#5 err_bar = $float_err_bar (q,qf[LATENCY]);
	if (err_bar > 200) begin
		$display ("Mismatch - Error greater than 2.00 pct at time %d",$time);
		fail = 1'b1;
	end
end

initial begin
	#2000000 if (!fail) $display ("PASS");
	$stop();
end

endmodule
