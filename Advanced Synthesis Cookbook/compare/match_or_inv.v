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

// baeckler - 05-13-2005
// 
// Efficient implementation of 
//    (bus_a == bus_b) || (bus_a == ~bus_b);
//
// for Stratix II hardware.   Use optimization technique = speed
//

module match_or_inv (bus_a,bus_b,match_or_inv);

parameter WIDTH = 32;

localparam GROUPS_OF_THREE = WIDTH/3;

input [WIDTH-1:0] bus_a;
input [WIDTH-1:0] bus_b;

output match_or_inv;

wire [GROUPS_OF_THREE - 1 : 0] groups /* synthesis keep */;
wire [GROUPS_OF_THREE + WIDTH-(3*GROUPS_OF_THREE) - 1 : 0] reduced_a;
wire [GROUPS_OF_THREE + WIDTH-(3*GROUPS_OF_THREE) - 1 : 0] reduced_b;
wire reduced_result;

genvar i;
generate 

  // simplify each block of 3 vs 3 bus bits into a six LUT and a 1 bit problem
  for (i=0; i<GROUPS_OF_THREE; i=i+1)
  begin : triples
  	wire [2:0] part_a;
  	wire [2:0] part_b;
    wire m_or_i;
  	assign part_a = bus_a[i*3+2:i*3];
  	assign part_b = bus_b[i*3+2:i*3];
  	assign groups[i] = (part_a == part_b || part_a == ~part_b);
	assign reduced_a[i] = bus_a[i*3];
	assign reduced_b[i] = bus_b[i*3];
  end

  // take care of bus bits when the width isn't a multiple of 3
  for (i=0; i<WIDTH-(3*GROUPS_OF_THREE); i=i+1)
  begin : residue
    	assign reduced_a[GROUPS_OF_THREE + i] = bus_a[3*GROUPS_OF_THREE + i];
    	assign reduced_b[GROUPS_OF_THREE + i] = bus_b[3*GROUPS_OF_THREE + i];
  end
endgenerate

// if the remaining problem is big enough tackle it recursively
// otherwise just build the gates
generate
  if  ((GROUPS_OF_THREE + WIDTH-(3*GROUPS_OF_THREE)) > 3)
  begin
	match_or_inv helper (.bus_a(reduced_a),.bus_b(reduced_b),.match_or_inv(reduced_result));
	defparam helper .WIDTH = (GROUPS_OF_THREE + WIDTH-(3*GROUPS_OF_THREE));
  end
  else
  begin
	assign reduced_result = (reduced_a == reduced_b || reduced_a == ~reduced_b);
  end   
endgenerate

// Final answer is the & of all 3 input results and the sub problem result
assign match_or_inv = (& groups) && reduced_result;

endmodule