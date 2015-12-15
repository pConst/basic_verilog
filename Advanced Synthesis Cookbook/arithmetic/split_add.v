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

// baeckler - 09-01-2006
//
// Example of adder using 2 carry chains, with the carry between them on standard
// routing.  This technique is useful when very long chains are causing placement
// difficulty.  Should use exactly WIDTH+2 cells.

module split_add (a,b,o);

parameter LS_WIDTH = 10;
parameter MS_WIDTH = 10;
parameter WIDTH = LS_WIDTH + MS_WIDTH;

input [WIDTH-1:0] a,b;
output [WIDTH-1:0] o;
wire [WIDTH-1:0] o;

// Build the less significant adder with an extra bit on the top to get
// the carry chain onto the normal routing.  The keep pragma prevents
// synthesis from undoing the split.

wire [LS_WIDTH-1+1:0] ls_adder;
wire cross_carry = ls_adder[LS_WIDTH] /* synthesis keep */;
assign ls_adder = {1'b0,a[LS_WIDTH-1:0]} + {1'b0,b[LS_WIDTH-1:0]};

// Build the more significant adder with an extra low bit to incorporate
// the carry from the split lower chain.

wire [MS_WIDTH-1+1:0] ms_adder;
assign ms_adder = {a[WIDTH-1:WIDTH-MS_WIDTH],cross_carry} + 
		{b[WIDTH-1:WIDTH-MS_WIDTH],cross_carry};

// collect the sum back together, drop the two internal bits
assign o = {ms_adder[MS_WIDTH:1],ls_adder[LS_WIDTH-1:0]};

endmodule

/////////////////////////////////

module split_add_tb ();
    parameter LS_WIDTH = 15;
    parameter MS_WIDTH = 20;
    parameter WIDTH = LS_WIDTH + MS_WIDTH;

    reg [WIDTH-1:0] a,b;
    wire [WIDTH-1:0] oa,ob;

    assign ob = a + b; // functional model
    split_add s (.a(a),.b(b),.o(oa));
        defparam s .LS_WIDTH = LS_WIDTH;
        defparam s .MS_WIDTH = MS_WIDTH;

    always begin
        #100 
		a = {$random,$random};
		b = {$random,$random}; 
		#10 if (oa !== ob) begin
           $display ("Mismatch at time %d",$time);
           $stop();
        end
    end

    initial begin
        #1000000 $display ("PASS");
        $stop();
    end
endmodule