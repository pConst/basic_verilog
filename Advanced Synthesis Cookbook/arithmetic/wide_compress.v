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


// baeckler - 03-14-2006

////////////////////////////////////////////////////////
// wide 3:2 compressor
////////////////////////////////////////////////////////
module compress_32 (a,b,c,oo,ot);
parameter WIDTH = 16;
input [WIDTH-1:0] a,b,c;
output [WIDTH-1:0] oo,ot;

genvar i;
generate
	for (i=0; i<WIDTH; i=i+1)
	begin : cmp
		assign oo[i] = a[i] ^ b[i] ^ c[i];
		assign ot[i] = (a[i] & b[i]) | (a[i] & c[i]) | (b[i] & c[i]);			
	end
endgenerate
endmodule

////////////////////////////////////////////////////////
// wide 4:2 compressor (with cin and cout)
//   the carry signal cannot ripple through more than one
//   stage. 
////////////////////////////////////////////////////////
module compress_42 (ci,a,b,c,d,co,oo,ot);
parameter WIDTH = 16;
input ci;
input [WIDTH-1:0] a,b,c,d;
output [WIDTH-1:0] oo,ot;
output co;

wire [WIDTH-1:0] internal_o;
wire [WIDTH-1:0] internal_t;

compress_32 i (.a(a),.b(b),.c(c),.oo(internal_o),.ot(internal_t));
	defparam i .WIDTH = WIDTH;

compress_32 o (.a({internal_t[WIDTH-2:0],ci}),
				.b(d),
				.c(internal_o),
				.oo(oo),.ot(ot));
	defparam o .WIDTH = WIDTH;
assign co = internal_t[WIDTH-1];
endmodule

///////////////////////////////////////////////////////
//   Quick sanity check 
////////////////////////////////////////////////////////
module compress_test ();

parameter WIDTH = 16;

reg fail;
reg [WIDTH-1:0] a,b,c,d;
wire [WIDTH+2-1:0] out_x, out_y;

assign out_x = a + b + c + d;

wire [WIDTH-1:0] oo,ot;
wire co;
compress_42 cmp (.ci(1'b0),.a(a),.b(b),.c(c),.d(d),.co(co),.oo(oo),.ot(ot));
	defparam cmp .WIDTH = WIDTH;

assign out_y = {co,oo} + (ot<<1);

initial begin
	a = 0; b = 0; c = 0; d = 0;
	fail = 0;
	#10000
	if (!fail) $display ("PASS");
	$stop();
end

always begin 
	#50 a = $random; b = $random; c = $random; d = $random;
	#50 if (out_x !== out_y) begin
		fail = 1;
		$display ("Mismatch at time %d",$time);
	end
end

endmodule