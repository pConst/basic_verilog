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

// baeckler - 1-19-2006

module des (clk,rst,in,out,key,salt);
input clk,rst;
input [63:0] in;
input [63:0] key;
input [11:0] salt;
output [63:0] out;
wire [63:0] out;

parameter DECRYPT = 1'b0;
parameter USE_SALT = 1'b0;

// Optional pipeline latency of 8 or 16
// pipeline style A inserts regs at normal round outputs
// pipeline style B pushes back through XOR for Stratix II minimum
//   depth.  16B is generally best.
//
parameter PIPE_8A = 1'b0;  // 904  DFF, 1280 small luts 512 6LUT, depth 5
parameter PIPE_8B = 1'b0;  // 1160 DFF, 1280 small luts 512 6LUT, depth 4
parameter PIPE_16A = 1'b0; // 1856 DFF, 1280 small luts 512 6LUT, depth 3
parameter PIPE_16B = 1'b1; // 2368 DFF, 1280 small luts 512 6LUT, depth 2

    wire [55:0] iperm_key;
    wire [55:0] iperm_key_adj;
    key_init_perm kin (.in(key),.out(iperm_key));

    generate
      if (DECRYPT) begin
        key_shift adj (.in(iperm_key),.out(iperm_key_adj));
        defparam adj .SINGLE = 1'b1;
      end else begin
        assign iperm_key_adj = iperm_key;
    end
    endgenerate
    wire [63:0] d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15;
    wire [55:0] k0,k1,k2,k3,k4,k5,k6,k7,k8,k9,k10,k11,k12,k13,k14,k15;

    round r0 (.clk(clk),.rst(rst),.in(in),.out(d0),.key_in(iperm_key_adj),.key_out(k0),.salt(salt));
      defparam r0 .INIT = 1'b1;
      defparam r0 .SINGLE = 1'b1;
      defparam r0 .REVERSE = DECRYPT;
      defparam r0 .USE_SALT = USE_SALT;
      defparam r0 .PIPEA = PIPE_16A;
      defparam r0 .PIPEB = PIPE_16B;
    round r1 (.clk(clk),.rst(rst),.in(d0),.out(d1),.key_in(k0),.key_out(k1),.salt(salt));
      defparam r1 .SINGLE = 1'b1;
      defparam r1 .REVERSE = DECRYPT;
      defparam r1 .USE_SALT = USE_SALT;
      defparam r1 .PIPEA = PIPE_16A | PIPE_8A;
      defparam r1 .PIPEB = PIPE_16B | PIPE_8B;
    round r2 (.clk(clk),.rst(rst),.in(d1),.out(d2),.key_in(k1),.key_out(k2),.salt(salt));
      defparam r2 .REVERSE = DECRYPT;
      defparam r2 .USE_SALT = USE_SALT;
      defparam r2 .PIPEA = PIPE_16A;
      defparam r2 .PIPEB = PIPE_16B;
    round r3 (.clk(clk),.rst(rst),.in(d2),.out(d3),.key_in(k2),.key_out(k3),.salt(salt));
      defparam r3 .REVERSE = DECRYPT;
      defparam r3 .USE_SALT = USE_SALT;
      defparam r3 .PIPEA = PIPE_16A | PIPE_8A;
      defparam r3 .PIPEB = PIPE_16B | PIPE_8B;
    round r4 (.clk(clk),.rst(rst),.in(d3),.out(d4),.key_in(k3),.key_out(k4),.salt(salt));
      defparam r4 .REVERSE = DECRYPT;
      defparam r4 .USE_SALT = USE_SALT;
      defparam r4 .PIPEA = PIPE_16A;
      defparam r4 .PIPEB = PIPE_16B;
    round r5 (.clk(clk),.rst(rst),.in(d4),.out(d5),.key_in(k4),.key_out(k5),.salt(salt));
      defparam r5 .REVERSE = DECRYPT;
      defparam r5 .USE_SALT = USE_SALT;
      defparam r5 .PIPEA = PIPE_16A | PIPE_8A;
      defparam r5 .PIPEB = PIPE_16B | PIPE_8B;
    round r6 (.clk(clk),.rst(rst),.in(d5),.out(d6),.key_in(k5),.key_out(k6),.salt(salt));
      defparam r6 .REVERSE = DECRYPT;
      defparam r6 .USE_SALT = USE_SALT;
      defparam r6 .PIPEA = PIPE_16A;
      defparam r6 .PIPEB = PIPE_16B;
    round r7 (.clk(clk),.rst(rst),.in(d6),.out(d7),.key_in(k6),.key_out(k7),.salt(salt));
      defparam r7 .REVERSE = DECRYPT;
      defparam r7 .USE_SALT = USE_SALT;
      defparam r7 .PIPEA = PIPE_16A | PIPE_8A;
      defparam r7 .PIPEB = PIPE_16B | PIPE_8B;
    round r8 (.clk(clk),.rst(rst),.in(d7),.out(d8),.key_in(k7),.key_out(k8),.salt(salt));
      defparam r8 .SINGLE = 1'b1;
      defparam r8 .REVERSE = DECRYPT;
      defparam r8 .USE_SALT = USE_SALT;
      defparam r8 .PIPEA = PIPE_16A;
      defparam r8 .PIPEB = PIPE_16B;
    round r9 (.clk(clk),.rst(rst),.in(d8),.out(d9),.key_in(k8),.key_out(k9),.salt(salt));
      defparam r9 .REVERSE = DECRYPT;
      defparam r9 .USE_SALT = USE_SALT;
      defparam r9 .PIPEA = PIPE_16A | PIPE_8A;
      defparam r9 .PIPEB = PIPE_16B | PIPE_8B;
    round r10 (.clk(clk),.rst(rst),.in(d9),.out(d10),.key_in(k9),.key_out(k10),.salt(salt));
      defparam r10 .REVERSE = DECRYPT;
      defparam r10 .USE_SALT = USE_SALT;
      defparam r10 .PIPEA = PIPE_16A;
      defparam r10 .PIPEB = PIPE_16B;
    round r11 (.clk(clk),.rst(rst),.in(d10),.out(d11),.key_in(k10),.key_out(k11),.salt(salt));
      defparam r11 .REVERSE = DECRYPT;
      defparam r11 .USE_SALT = USE_SALT;
      defparam r11 .PIPEA = PIPE_16A | PIPE_8A;
      defparam r11 .PIPEB = PIPE_16B | PIPE_8B;
    round r12 (.clk(clk),.rst(rst),.in(d11),.out(d12),.key_in(k11),.key_out(k12),.salt(salt));
      defparam r12 .REVERSE = DECRYPT;
      defparam r12 .USE_SALT = USE_SALT;
      defparam r12 .PIPEA = PIPE_16A;
      defparam r12 .PIPEB = PIPE_16B;
    round r13 (.clk(clk),.rst(rst),.in(d12),.out(d13),.key_in(k12),.key_out(k13),.salt(salt));
      defparam r13 .REVERSE = DECRYPT;
      defparam r13 .USE_SALT = USE_SALT;
      defparam r13 .PIPEA = PIPE_16A | PIPE_8A;
      defparam r13 .PIPEB = PIPE_16B | PIPE_8B;
    round r14 (.clk(clk),.rst(rst),.in(d13),.out(d14),.key_in(k13),.key_out(k14),.salt(salt));
      defparam r14 .REVERSE = DECRYPT;
      defparam r14 .USE_SALT = USE_SALT;
      defparam r14 .PIPEA = PIPE_16A;
      defparam r14 .PIPEB = PIPE_16B;
    round r15 (.clk(clk),.rst(rst),.in(d14),.out(d15),.key_in(k14),.key_out(k15),.salt(salt));
      defparam r15 .FINAL = 1'b1;
      defparam r15 .SINGLE = 1'b1;
      defparam r15 .REVERSE = DECRYPT;
      defparam r15 .USE_SALT = USE_SALT;
      defparam r15 .PIPEA = PIPE_16A | PIPE_8A;
      defparam r15 .PIPEB = PIPE_16B | PIPE_8B;
    assign out = d15;

endmodule
