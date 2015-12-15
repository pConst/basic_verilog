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

// baeckler - 03-07-2006

// pipelined AES / aes encrypt and decrypt units

////////////////////////////////////
// Encrypt using 128 bit key
////////////////////////////////////
module aes_128 (clk,clr,dat_in,dat_out,key,inv_key);
input clk,clr;
input [127:0] dat_in;
input [127:0] key;
output [127:0] dat_out;
output [127:0] inv_key;

parameter LATENCY = 10; // currently allowed 0,10
localparam ROUND_LATENCY = (LATENCY == 10 ? 1 : 0);
wire [127:0] start1,start2,start3,start4,start5;
wire [127:0] start6,start7,start8,start9,start10;
wire [127:0] key1,key2,key3,key4,key5;
wire [127:0] key6,key7,key8,key9,key10;

assign start1 = dat_in ^ key;
assign key1 = key;

    aes_round_128 r1 (
        .clk(clk),.clr(clr),
        .dat_in(start1),.key_in(key1),
        .dat_out(start2),.key_out(key2),
        .skip_mix_col(1'b0),
        .rconst(8'h01));
        defparam r1 .LATENCY = ROUND_LATENCY;
    aes_round_128 r2 (
        .clk(clk),.clr(clr),
        .dat_in(start2),.key_in(key2),
        .dat_out(start3),.key_out(key3),
        .skip_mix_col(1'b0),
        .rconst(8'h02));
        defparam r2 .LATENCY = ROUND_LATENCY;
    aes_round_128 r3 (
        .clk(clk),.clr(clr),
        .dat_in(start3),.key_in(key3),
        .dat_out(start4),.key_out(key4),
        .skip_mix_col(1'b0),
        .rconst(8'h04));
        defparam r3 .LATENCY = ROUND_LATENCY;
    aes_round_128 r4 (
        .clk(clk),.clr(clr),
        .dat_in(start4),.key_in(key4),
        .dat_out(start5),.key_out(key5),
        .skip_mix_col(1'b0),
        .rconst(8'h08));
        defparam r4 .LATENCY = ROUND_LATENCY;
    aes_round_128 r5 (
        .clk(clk),.clr(clr),
        .dat_in(start5),.key_in(key5),
        .dat_out(start6),.key_out(key6),
        .skip_mix_col(1'b0),
        .rconst(8'h10));
        defparam r5 .LATENCY = ROUND_LATENCY;
    aes_round_128 r6 (
        .clk(clk),.clr(clr),
        .dat_in(start6),.key_in(key6),
        .dat_out(start7),.key_out(key7),
        .skip_mix_col(1'b0),
        .rconst(8'h20));
        defparam r6 .LATENCY = ROUND_LATENCY;
    aes_round_128 r7 (
        .clk(clk),.clr(clr),
        .dat_in(start7),.key_in(key7),
        .dat_out(start8),.key_out(key8),
        .skip_mix_col(1'b0),
        .rconst(8'h40));
        defparam r7 .LATENCY = ROUND_LATENCY;
    aes_round_128 r8 (
        .clk(clk),.clr(clr),
        .dat_in(start8),.key_in(key8),
        .dat_out(start9),.key_out(key9),
        .skip_mix_col(1'b0),
        .rconst(8'h80));
        defparam r8 .LATENCY = ROUND_LATENCY;
    aes_round_128 r9 (
        .clk(clk),.clr(clr),
        .dat_in(start9),.key_in(key9),
        .dat_out(start10),.key_out(key10),
        .skip_mix_col(1'b0),
        .rconst(8'h1b));
        defparam r9 .LATENCY = ROUND_LATENCY;
    aes_round_128 r10 (
        .clk(clk),.clr(clr),
        .dat_in(start10),.key_in(key10),
        .dat_out(dat_out),.key_out(inv_key),
        .skip_mix_col(1'b1),
        .rconst(8'h36));
        defparam r10 .LATENCY = ROUND_LATENCY;
endmodule

////////////////////////////////////
// Inverse (Decrypt) using 128 bit key
////////////////////////////////////
module inv_aes_128 (clk,clr,dat_in,dat_out,inv_key);
input clk,clr;
input [127:0] dat_in;
input [127:0] inv_key;
output [127:0] dat_out;

parameter LATENCY = 10; // currently allowed 0,10
localparam ROUND_LATENCY = (LATENCY == 10 ? 1 : 0);
wire [127:0] start1,start2,start3,start4,start5;
wire [127:0] start6,start7,start8,start9,start10;
wire [127:0] unkeyd_out,last_key;
wire [127:0] key1,key2,key3,key4,key5;
wire [127:0] key6,key7,key8,key9,key10;

assign start1 = dat_in;
assign key1 = inv_key;

    inv_aes_round_128 r1 (
        .clk(clk),.clr(clr),
        .dat_in(start1),.key_in(key1),
        .dat_out(start2),.key_out(key2),
        .skip_mix_col(1'b1),
        .rconst(8'h36));
        defparam r1 .LATENCY = ROUND_LATENCY;
    inv_aes_round_128 r2 (
        .clk(clk),.clr(clr),
        .dat_in(start2),.key_in(key2),
        .dat_out(start3),.key_out(key3),
        .skip_mix_col(1'b0),
        .rconst(8'h1b));
        defparam r2 .LATENCY = ROUND_LATENCY;
    inv_aes_round_128 r3 (
        .clk(clk),.clr(clr),
        .dat_in(start3),.key_in(key3),
        .dat_out(start4),.key_out(key4),
        .skip_mix_col(1'b0),
        .rconst(8'h80));
        defparam r3 .LATENCY = ROUND_LATENCY;
    inv_aes_round_128 r4 (
        .clk(clk),.clr(clr),
        .dat_in(start4),.key_in(key4),
        .dat_out(start5),.key_out(key5),
        .skip_mix_col(1'b0),
        .rconst(8'h40));
        defparam r4 .LATENCY = ROUND_LATENCY;
    inv_aes_round_128 r5 (
        .clk(clk),.clr(clr),
        .dat_in(start5),.key_in(key5),
        .dat_out(start6),.key_out(key6),
        .skip_mix_col(1'b0),
        .rconst(8'h20));
        defparam r5 .LATENCY = ROUND_LATENCY;
    inv_aes_round_128 r6 (
        .clk(clk),.clr(clr),
        .dat_in(start6),.key_in(key6),
        .dat_out(start7),.key_out(key7),
        .skip_mix_col(1'b0),
        .rconst(8'h10));
        defparam r6 .LATENCY = ROUND_LATENCY;
    inv_aes_round_128 r7 (
        .clk(clk),.clr(clr),
        .dat_in(start7),.key_in(key7),
        .dat_out(start8),.key_out(key8),
        .skip_mix_col(1'b0),
        .rconst(8'h08));
        defparam r7 .LATENCY = ROUND_LATENCY;
    inv_aes_round_128 r8 (
        .clk(clk),.clr(clr),
        .dat_in(start8),.key_in(key8),
        .dat_out(start9),.key_out(key9),
        .skip_mix_col(1'b0),
        .rconst(8'h04));
        defparam r8 .LATENCY = ROUND_LATENCY;
    inv_aes_round_128 r9 (
        .clk(clk),.clr(clr),
        .dat_in(start9),.key_in(key9),
        .dat_out(start10),.key_out(key10),
        .skip_mix_col(1'b0),
        .rconst(8'h02));
        defparam r9 .LATENCY = ROUND_LATENCY;
    inv_aes_round_128 r10 (
        .clk(clk),.clr(clr),
        .dat_in(start10),.key_in(key10),
        .dat_out(unkeyd_out),.key_out(last_key),
        .skip_mix_col(1'b0),
        .rconst(8'h01));
        defparam r10 .LATENCY = ROUND_LATENCY;
assign dat_out = last_key ^ unkeyd_out;

endmodule
