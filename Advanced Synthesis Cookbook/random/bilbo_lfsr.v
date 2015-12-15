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

//////////////////////////////////////////////////
// Generic BILBO register for 4 to 32 bits
//////////////////////////////////////////////////
module bilbo_lfsr (pin,pout,shift_in,shift_out,mode,clk,rst);
parameter WIDTH = 32;
input clk,rst;
input [1:0] mode;
input [WIDTH-1:0] pin;
output [WIDTH-1:0] pout;
input shift_in;
output shift_out;

// mode encoding
//   0 pass through
//   1 scan chain
//   2 prbs, ignore inputs
//   3 prbs with inputs (signature)

reg [WIDTH-1:0] myreg;
wire thru = (mode == 0);
wire [WIDTH-1:0] screened_pin = {WIDTH{mode[1] & mode[0]}} & pin;

// nice looking max period polys selected from
// the internet
wire [WIDTH-1:0] poly =
        (WIDTH == 4) ? 4'hc :
        (WIDTH == 5) ? 5'h1b :
        (WIDTH == 6) ? 6'h33 :
        (WIDTH == 7) ? 7'h65 :
        (WIDTH == 8) ? 8'hc3 :
        (WIDTH == 9) ? 9'h167 :
        (WIDTH == 10) ? 10'h309 :
        (WIDTH == 11) ? 11'h4ec :
        (WIDTH == 12) ? 12'hac9 :
        (WIDTH == 13) ? 13'h124d :
        (WIDTH == 14) ? 14'h2367 :
        (WIDTH == 15) ? 15'h42f9 :
        (WIDTH == 16) ? 16'h847d :
        (WIDTH == 17) ? 17'h101f5 :
        (WIDTH == 18) ? 18'h202c9 :
        (WIDTH == 19) ? 19'h402fa :
        (WIDTH == 20) ? 20'h805c1 :
        (WIDTH == 21) ? 21'h1003cb :
        (WIDTH == 22) ? 22'h20029f :
        (WIDTH == 23) ? 23'h4003da :
        (WIDTH == 24) ? 24'h800a23 :
        (WIDTH == 25) ? 25'h10001a5 :
        (WIDTH == 26) ? 26'h2000155 :
        (WIDTH == 27) ? 27'h4000227 :
        (WIDTH == 28) ? 28'h80007db :
        (WIDTH == 29) ? 29'h100004f3 :
        (WIDTH == 30) ? 30'h200003ab :
        (WIDTH == 31) ? 31'h40000169 :
        (WIDTH == 32) ? 32'h800007c3 : 0;

initial begin
  // unsupported width?  Fatality.
  #100 if (poly == 0) $stop();
end

wire lfsr_fbk = ^(myreg & poly);
wire lsb = (mode[1] ? !lfsr_fbk : shift_in);

always @(posedge clk or posedge rst) begin
  if (rst) myreg <= 0;
  else begin
     if (thru) myreg <= pin;
     else myreg <= ((myreg << 1) | lsb) ^ screened_pin;
  end
end

assign pout = myreg;
assign shift_out = myreg[WIDTH-1];

endmodule

