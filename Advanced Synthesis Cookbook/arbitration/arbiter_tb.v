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


//baeckler - 02-13-2007

module arbiter_tb ();

reg [15:0] req;
reg [3:0] base;

wire [15:0] grant, grant_two;
reg fail;

// weaker unit for testing
reference_arbiter arb (.req(req),.base(base),.grant(grant));

// convert the encoded base to one hot
// ideally it would be generated in one hot
reg [15:0] decoded_base;
always @(*) begin
	decoded_base = 0;
	decoded_base[base] = 1'b1;
end

// device under test
arbiter a2 (.req(req),.grant(grant_two),.base(decoded_base));
	defparam a2 .WIDTH = 16;

always begin
	#100
	req = $random & $random & $random;
	base = $random;
	
	#5 
	if (grant !== grant_two) begin
		$display ("Mismatch at time %d",$time);
		fail = 1;
	end
end

initial begin
	fail = 0;
	#1000000 if (!fail) $display ("PASS");
	$stop();
end

endmodule


/////////////////////////////////////////
// Less efficient easier to understand
// unit for reference
/////////////////////////////////////////
module reference_arbiter (
	req,grant,base
);

input [15:0] req;
output [15:0] grant;
input [3:0] base;

// rotate the request lines
wire [15:0] b0 = base[0] ? {req[0],req[15:1]} : req[15:0] ;
wire [15:0] b1 = base[1] ? {b0[1:0],b0[15:2]} : b0[15:0] ;
wire [15:0] b2 = base[2] ? {b1[3:0],b1[15:4]} : b1[15:0] ;
wire [15:0] b3 = base[3] ? {b2[7:0],b2[15:8]} : b2[15:0] ;

// pick the lowest one for a grant
wire [15:0] rotated_grant = b3 & ~(b3-1);

// unrotate the grant
wire [15:0] b4 = base[0] ? {rotated_grant[14:0],rotated_grant[15]} : rotated_grant[15:0] ;
wire [15:0] b5 = base[1] ? {b4[13:0],b4[15:14]} : b4[15:0] ;
wire [15:0] b6 = base[2] ? {b5[11:0],b5[15:12]} : b5[15:0] ;
wire [15:0] b7 = base[3] ? {b6[7:0],b6[15:8]} : b6[15:0] ;

assign grant = b7;

endmodule