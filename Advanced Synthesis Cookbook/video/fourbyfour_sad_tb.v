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

module fourbyfour_sad_tb ();

wire [7:0] x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,xa,xb,xc,xd,xe,xf;
wire [7:0] y0,y1,y2,y3,y4,y5,y6,y7,y8,y9,ya,yb,yc,yd,ye,yf;

reg [8*16*2-1:0] data;
reg fail;

assign {x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,xa,xb,xc,xd,xe,xf,
		y0,y1,y2,y3,y4,y5,y6,y7,y8,y9,ya,yb,yc,yd,ye,yf} = data;

wire [11:0] sad;

fourbyfour_sad fs (
	x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,xa,xb,xc,xd,xe,xf,
	y0,y1,y2,y3,y4,y5,y6,y7,y8,y9,ya,yb,yc,yd,ye,yf,
	sad
);

// compute correct answer using entirely different method
wire [12:0] diff[15:0];

genvar i;
generate 	
	for (i = 0; i<16; i = i+1)
	begin : check
		wire [12:0] j,k;
		assign j = data[i*8+7:i*8];
		assign k = data[8*16+i*8+7:8*16+i*8];
		assign diff[i] = (j > k) ? j - k : k - j;
	end
endgenerate

integer q, cume; 

always begin 
	#100 cume = 0; 
	for (q = 0; q<16; q=q+1) 
	begin : sum
		cume = cume + diff[q];
	end
end

initial begin 
	data = 0;
	fail = 0;
	#1000000
	if (!fail) $display ("PASS");
	$stop;
end

// stim generate and check
always begin
	#1000 data = {$random,$random,$random,$random,
					$random,$random,$random,$random};
	#1000 if (cume != sad) begin
		$display ("Mismatch at time %d",$time);
		fail = 1;
	end
end

endmodule
