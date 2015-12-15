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

// baeckler - 12-15-2006

// pipelined Rijndael / AES256 encrypt and decrypt units

////////////////////////////////////
// Encrypt using 256 bit key
////////////////////////////////////
module aes_256 (clk,clr,dat_in,dat_out,key,inv_key);
input clk,clr;
input [127:0] dat_in;
input [255:0] key;
output [127:0] dat_out;
output [255:0] inv_key;

parameter LATENCY = 14; // currently allowed 0,14
localparam ROUND_LATENCY = (LATENCY == 14 ? 1 : 0);
wire [127:0] start1,start2,start3,start4,start5;
wire [127:0] start6,start7,start8,start9,start10;
wire [127:0] start11,start12,start13,start14;
wire [255:0] key1,key2,key3,key4,key5;
wire [255:0] key6,key7,key8,key9,key10;
wire [255:0] key11,key12,key13,key14;

assign start1 = dat_in ^ key[255:128];
assign key1 = key;

    aes_round_256 r1 (
        .clk(clk),.clr(clr),
        .dat_in(start1),.key_in(key1),
        .dat_out(start2),.key_out(key2),
        .skip_mix_col(1'b0),
        .rconst(8'h01));
        defparam r1 .LATENCY = ROUND_LATENCY;
        defparam r1 .KEY_EVOLVE_TYPE = 0;
    aes_round_256 r2 (
        .clk(clk),.clr(clr),
        .dat_in(start2),.key_in(key2),
        .dat_out(start3),.key_out(key3),
        .skip_mix_col(1'b0),
        .rconst(8'h01));
        defparam r2 .LATENCY = ROUND_LATENCY;
        defparam r2 .KEY_EVOLVE_TYPE = 1;
    aes_round_256 r3 (
        .clk(clk),.clr(clr),
        .dat_in(start3),.key_in(key3),
        .dat_out(start4),.key_out(key4),
        .skip_mix_col(1'b0),
        .rconst(8'h02));
        defparam r3 .LATENCY = ROUND_LATENCY;
        defparam r3 .KEY_EVOLVE_TYPE = 0;
    aes_round_256 r4 (
        .clk(clk),.clr(clr),
        .dat_in(start4),.key_in(key4),
        .dat_out(start5),.key_out(key5),
        .skip_mix_col(1'b0),
        .rconst(8'h02));
        defparam r4 .LATENCY = ROUND_LATENCY;
        defparam r4 .KEY_EVOLVE_TYPE = 1;
    aes_round_256 r5 (
        .clk(clk),.clr(clr),
        .dat_in(start5),.key_in(key5),
        .dat_out(start6),.key_out(key6),
        .skip_mix_col(1'b0),
        .rconst(8'h04));
        defparam r5 .LATENCY = ROUND_LATENCY;
        defparam r5 .KEY_EVOLVE_TYPE = 0;
    aes_round_256 r6 (
        .clk(clk),.clr(clr),
        .dat_in(start6),.key_in(key6),
        .dat_out(start7),.key_out(key7),
        .skip_mix_col(1'b0),
        .rconst(8'h04));
        defparam r6 .LATENCY = ROUND_LATENCY;
        defparam r6 .KEY_EVOLVE_TYPE = 1;
    aes_round_256 r7 (
        .clk(clk),.clr(clr),
        .dat_in(start7),.key_in(key7),
        .dat_out(start8),.key_out(key8),
        .skip_mix_col(1'b0),
        .rconst(8'h08));
        defparam r7 .LATENCY = ROUND_LATENCY;
        defparam r7 .KEY_EVOLVE_TYPE = 0;
    aes_round_256 r8 (
        .clk(clk),.clr(clr),
        .dat_in(start8),.key_in(key8),
        .dat_out(start9),.key_out(key9),
        .skip_mix_col(1'b0),
        .rconst(8'h08));
        defparam r8 .LATENCY = ROUND_LATENCY;
        defparam r8 .KEY_EVOLVE_TYPE = 1;
    aes_round_256 r9 (
        .clk(clk),.clr(clr),
        .dat_in(start9),.key_in(key9),
        .dat_out(start10),.key_out(key10),
        .skip_mix_col(1'b0),
        .rconst(8'h10));
        defparam r9 .LATENCY = ROUND_LATENCY;
        defparam r9 .KEY_EVOLVE_TYPE = 0;
    aes_round_256 r10 (
        .clk(clk),.clr(clr),
        .dat_in(start10),.key_in(key10),
        .dat_out(start11),.key_out(key11),
        .skip_mix_col(1'b0),
        .rconst(8'h10));
        defparam r10 .LATENCY = ROUND_LATENCY;
        defparam r10 .KEY_EVOLVE_TYPE = 1;
    aes_round_256 r11 (
        .clk(clk),.clr(clr),
        .dat_in(start11),.key_in(key11),
        .dat_out(start12),.key_out(key12),
        .skip_mix_col(1'b0),
        .rconst(8'h20));
        defparam r11 .LATENCY = ROUND_LATENCY;
        defparam r11 .KEY_EVOLVE_TYPE = 0;
    aes_round_256 r12 (
        .clk(clk),.clr(clr),
        .dat_in(start12),.key_in(key12),
        .dat_out(start13),.key_out(key13),
        .skip_mix_col(1'b0),
        .rconst(8'h20));
        defparam r12 .LATENCY = ROUND_LATENCY;
        defparam r12 .KEY_EVOLVE_TYPE = 1;
    aes_round_256 r13 (
        .clk(clk),.clr(clr),
        .dat_in(start13),.key_in(key13),
        .dat_out(start14),.key_out(key14),
        .skip_mix_col(1'b0),
        .rconst(8'h40));
        defparam r13 .LATENCY = ROUND_LATENCY;
        defparam r13 .KEY_EVOLVE_TYPE = 0;
    aes_round_256 r14 (
        .clk(clk),.clr(clr),
        .dat_in(start14),.key_in(key14),
        .dat_out(dat_out),.key_out(inv_key),
        .skip_mix_col(1'b1),
        .rconst(8'h40));
        defparam r14 .LATENCY = ROUND_LATENCY;
        defparam r14 .KEY_EVOLVE_TYPE = 1;
endmodule

////////////////////////////////////
// Inverse (Decrypt) using 256 bit key
////////////////////////////////////
module inv_aes_256 (clk,clr,dat_in,dat_out,inv_key);
input clk,clr;
input [127:0] dat_in;
input [255:0] inv_key;
output [127:0] dat_out;

parameter LATENCY = 14; // currently allowed 0,14
localparam ROUND_LATENCY = (LATENCY == 14 ? 1 : 0);
wire [127:0] start1,start2,start3,start4,start5;
wire [127:0] start6,start7,start8,start9,start10;
wire [127:0] start11,start12,start13,start14;
wire [127:0] unkeyd_out;
wire [255:0] last_key;
wire [255:0] key1,key2,key3,key4,key5;
wire [255:0] key6,key7,key8,key9,key10;
wire [255:0] key11,key12,key13,key14;

assign start1 = dat_in;
assign key1 = inv_key;

    inv_aes_round_256 r1 (
        .clk(clk),.clr(clr),
        .dat_in(start1),.key_in(key1),
        .dat_out(start2),.key_out(key2),
        .skip_mix_col(1'b1),
        .rconst(8'h40));
        defparam r1 .LATENCY = ROUND_LATENCY;
        defparam r1 .KEY_EVOLVE_TYPE = 1;
    inv_aes_round_256 r2 (
        .clk(clk),.clr(clr),
        .dat_in(start2),.key_in(key2),
        .dat_out(start3),.key_out(key3),
        .skip_mix_col(1'b0),
        .rconst(8'h40));
        defparam r2 .LATENCY = ROUND_LATENCY;
        defparam r2 .KEY_EVOLVE_TYPE = 0;
    inv_aes_round_256 r3 (
        .clk(clk),.clr(clr),
        .dat_in(start3),.key_in(key3),
        .dat_out(start4),.key_out(key4),
        .skip_mix_col(1'b0),
        .rconst(8'h20));
        defparam r3 .LATENCY = ROUND_LATENCY;
        defparam r3 .KEY_EVOLVE_TYPE = 1;
    inv_aes_round_256 r4 (
        .clk(clk),.clr(clr),
        .dat_in(start4),.key_in(key4),
        .dat_out(start5),.key_out(key5),
        .skip_mix_col(1'b0),
        .rconst(8'h20));
        defparam r4 .LATENCY = ROUND_LATENCY;
        defparam r4 .KEY_EVOLVE_TYPE = 0;
    inv_aes_round_256 r5 (
        .clk(clk),.clr(clr),
        .dat_in(start5),.key_in(key5),
        .dat_out(start6),.key_out(key6),
        .skip_mix_col(1'b0),
        .rconst(8'h10));
        defparam r5 .LATENCY = ROUND_LATENCY;
        defparam r5 .KEY_EVOLVE_TYPE = 1;
    inv_aes_round_256 r6 (
        .clk(clk),.clr(clr),
        .dat_in(start6),.key_in(key6),
        .dat_out(start7),.key_out(key7),
        .skip_mix_col(1'b0),
        .rconst(8'h10));
        defparam r6 .LATENCY = ROUND_LATENCY;
        defparam r6 .KEY_EVOLVE_TYPE = 0;
    inv_aes_round_256 r7 (
        .clk(clk),.clr(clr),
        .dat_in(start7),.key_in(key7),
        .dat_out(start8),.key_out(key8),
        .skip_mix_col(1'b0),
        .rconst(8'h08));
        defparam r7 .LATENCY = ROUND_LATENCY;
        defparam r7 .KEY_EVOLVE_TYPE = 1;
    inv_aes_round_256 r8 (
        .clk(clk),.clr(clr),
        .dat_in(start8),.key_in(key8),
        .dat_out(start9),.key_out(key9),
        .skip_mix_col(1'b0),
        .rconst(8'h08));
        defparam r8 .LATENCY = ROUND_LATENCY;
        defparam r8 .KEY_EVOLVE_TYPE = 0;
    inv_aes_round_256 r9 (
        .clk(clk),.clr(clr),
        .dat_in(start9),.key_in(key9),
        .dat_out(start10),.key_out(key10),
        .skip_mix_col(1'b0),
        .rconst(8'h04));
        defparam r9 .LATENCY = ROUND_LATENCY;
        defparam r9 .KEY_EVOLVE_TYPE = 1;
    inv_aes_round_256 r10 (
        .clk(clk),.clr(clr),
        .dat_in(start10),.key_in(key10),
        .dat_out(start11),.key_out(key11),
        .skip_mix_col(1'b0),
        .rconst(8'h04));
        defparam r10 .LATENCY = ROUND_LATENCY;
        defparam r10 .KEY_EVOLVE_TYPE = 0;
    inv_aes_round_256 r11 (
        .clk(clk),.clr(clr),
        .dat_in(start11),.key_in(key11),
        .dat_out(start12),.key_out(key12),
        .skip_mix_col(1'b0),
        .rconst(8'h02));
        defparam r11 .LATENCY = ROUND_LATENCY;
        defparam r11 .KEY_EVOLVE_TYPE = 1;
    inv_aes_round_256 r12 (
        .clk(clk),.clr(clr),
        .dat_in(start12),.key_in(key12),
        .dat_out(start13),.key_out(key13),
        .skip_mix_col(1'b0),
        .rconst(8'h02));
        defparam r12 .LATENCY = ROUND_LATENCY;
        defparam r12 .KEY_EVOLVE_TYPE = 0;
    inv_aes_round_256 r13 (
        .clk(clk),.clr(clr),
        .dat_in(start13),.key_in(key13),
        .dat_out(start14),.key_out(key14),
        .skip_mix_col(1'b0),
        .rconst(8'h01));
        defparam r13 .LATENCY = ROUND_LATENCY;
        defparam r13 .KEY_EVOLVE_TYPE = 1;
    inv_aes_round_256 r14 (
        .clk(clk),.clr(clr),
        .dat_in(start14),.key_in(key14),
        .dat_out(unkeyd_out),.key_out(last_key),
        .skip_mix_col(1'b0),
        .rconst(8'h01));
        defparam r14 .LATENCY = ROUND_LATENCY;
        defparam r14 .KEY_EVOLVE_TYPE = 0;
assign dat_out = last_key[255:128] ^ unkeyd_out;

endmodule
