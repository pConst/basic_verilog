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

// 16  30  24  14  30  14  16  16  27  12  10   7  18  24   1  18   9  30   6  30   9  30  16  30  21  30   6   0   0  30  30  11   9  17  30   1  12   2   2   7  28  30   1   1  30   7  30  30  30  14  22   5  23   4   0   7   5   8   0  14  10   8   5   3 
// 29  14  16  23  16  20  18  14  14  24  21   6  30  30  21  12   0  24  12   0   3  29   6  14  28  28  21  19  29  29   9  23   0  18   0  13   0  23   0  30   0  25  26  30   0   0  25  23  16   0  22  27  25   2  22  20   0   8  16   0   7   0   0   0 
module word_stream_scramble (clk,rst,ena,din,dout,dout_valid);

`include "log2.inc"

parameter WORD_LEN = 32;
parameter SCRAMBLE = 1'b1; // 0 for undo

localparam HIST_WORDS = 31;
localparam PERIOD = 64;
localparam NUM_SEL = log2(HIST_WORDS-1);
localparam CNTR_BITS = log2(PERIOD-1);
localparam PAD_WORDS = (1<<NUM_SEL)-HIST_WORDS;

input clk,rst,ena;
input [WORD_LEN-1:0] din;
output [WORD_LEN-1:0] dout;
output dout_valid;

// din history shift register
reg [HIST_WORDS * WORD_LEN-1 : 0] history;
always @(posedge clk) begin
    if (ena) begin
        if (rst) history <= 0;
        else history <= {history[(HIST_WORDS-1)*WORD_LEN-1:0],din};
    end
end

// parallel access pipelined read mux
reg [NUM_SEL-1:0] sel;
pipelined_word_mux pwm (
    .clk(clk), .rst(rst),.ena(ena),
    .sel(sel),
    .din({{PAD_WORDS*WORD_LEN{1'b0}},history}),
    .dout(dout));
  defparam pwm .WORD_LEN = WORD_LEN;
  defparam pwm .NUM_WORDS_IN = HIST_WORDS+PAD_WORDS;
  defparam pwm .SEL_PER_LAYER = 2;
  defparam pwm .BALANCE_SELECTS = 1'b0;

// scrambling sequence counter
reg [CNTR_BITS-1:0] cntr;
always @(posedge clk) begin
    if (ena) begin
       if (rst) cntr <= 0;
       else cntr <= cntr + 1'b1;
    end
end

// scramble pattern table to drive read select
always @(posedge clk) begin
    if (ena) begin
        if (rst) sel <= 0;
        else begin
            case (cntr)
            6'h0 : sel <= (SCRAMBLE ? 5'h1 : 5'hd);
            6'h1 : sel <= (SCRAMBLE ? 5'h10 : 5'h6);
            6'h2 : sel <= (SCRAMBLE ? 5'ha : 5'h1e);
            6'h3 : sel <= (SCRAMBLE ? 5'h13 : 5'h1e);
            6'h4 : sel <= (SCRAMBLE ? 5'h16 : 5'h15);
            6'h5 : sel <= (SCRAMBLE ? 5'h8 : 5'h4);
            6'h6 : sel <= (SCRAMBLE ? 5'hf : 5'h1a);
            6'h7 : sel <= (SCRAMBLE ? 5'h8 : 5'h1e);
            6'h8 : sel <= (SCRAMBLE ? 5'h10 : 5'he);
            6'h9 : sel <= (SCRAMBLE ? 5'h12 : 5'h0);
            6'ha : sel <= (SCRAMBLE ? 5'h1e : 5'h14);
            6'hb : sel <= (SCRAMBLE ? 5'he : 5'h13);
            6'hc : sel <= (SCRAMBLE ? 5'h1c : 5'h14);
            6'hd : sel <= (SCRAMBLE ? 5'ha : 5'h12);
            6'he : sel <= (SCRAMBLE ? 5'h1c : 5'h1d);
            6'hf : sel <= (SCRAMBLE ? 5'h13 : 5'hc);
            6'h10 : sel <= (SCRAMBLE ? 5'h11 : 5'h10);
            6'h11 : sel <= (SCRAMBLE ? 5'h4 : 5'h0);
            6'h12 : sel <= (SCRAMBLE ? 5'ha : 5'h3);
            6'h13 : sel <= (SCRAMBLE ? 5'ha : 5'h4);
            6'h14 : sel <= (SCRAMBLE ? 5'hc : 5'h0);
            6'h15 : sel <= (SCRAMBLE ? 5'h0 : 5'h0);
            6'h16 : sel <= (SCRAMBLE ? 5'h9 : 5'h18);
            6'h17 : sel <= (SCRAMBLE ? 5'h7 : 5'h0);
            6'h18 : sel <= (SCRAMBLE ? 5'h4 : 5'h6);
            6'h19 : sel <= (SCRAMBLE ? 5'h0 : 5'h16);
            6'h1a : sel <= (SCRAMBLE ? 5'h7 : 5'h11);
            6'h1b : sel <= (SCRAMBLE ? 5'h5 : 5'hb);
            6'h1c : sel <= (SCRAMBLE ? 5'h16 : 5'h1a);
            6'h1d : sel <= (SCRAMBLE ? 5'h6 : 5'h14);
            6'h1e : sel <= (SCRAMBLE ? 5'h1e : 5'h10);
            6'h1f : sel <= (SCRAMBLE ? 5'he : 5'h3);
            6'h20 : sel <= (SCRAMBLE ? 5'h1e : 5'h15);
            6'h21 : sel <= (SCRAMBLE ? 5'h1f : 5'h18);
            6'h22 : sel <= (SCRAMBLE ? 5'h16 : 5'h10);
            6'h23 : sel <= (SCRAMBLE ? 5'hd : 5'h2);
            6'h24 : sel <= (SCRAMBLE ? 5'h11 : 5'he);
            6'h25 : sel <= (SCRAMBLE ? 5'h2 : 5'h19);
            6'h26 : sel <= (SCRAMBLE ? 5'hc : 5'h18);
            6'h27 : sel <= (SCRAMBLE ? 5'h1f : 5'h12);
            6'h28 : sel <= (SCRAMBLE ? 5'h16 : 5'hc);
            6'h29 : sel <= (SCRAMBLE ? 5'h2 : 5'h13);
            6'h2a : sel <= (SCRAMBLE ? 5'h0 : 5'h4);
            6'h2b : sel <= (SCRAMBLE ? 5'hd : 5'h11);
            6'h2c : sel <= (SCRAMBLE ? 5'h2 : 5'hc);
            6'h2d : sel <= (SCRAMBLE ? 5'hd : 5'h2);
            6'h2e : sel <= (SCRAMBLE ? 5'h11 : 5'h0);
            6'h2f : sel <= (SCRAMBLE ? 5'h1b : 5'h13);
            6'h30 : sel <= (SCRAMBLE ? 5'ha : 5'h5);
            6'h31 : sel <= (SCRAMBLE ? 5'he : 5'h19);
            6'h32 : sel <= (SCRAMBLE ? 5'h1c : 5'hd);
            6'h33 : sel <= (SCRAMBLE ? 5'h10 : 5'h1f);
            6'h34 : sel <= (SCRAMBLE ? 5'h2 : 5'h11);
            6'h35 : sel <= (SCRAMBLE ? 5'h6 : 5'h14);
            6'h36 : sel <= (SCRAMBLE ? 5'hd : 5'h1c);
            6'h37 : sel <= (SCRAMBLE ? 5'h16 : 5'h1e);
            6'h38 : sel <= (SCRAMBLE ? 5'h1c : 5'h1e);
            6'h39 : sel <= (SCRAMBLE ? 5'h12 : 5'h5);
            6'h3a : sel <= (SCRAMBLE ? 5'h1d : 5'hf);
            6'h3b : sel <= (SCRAMBLE ? 5'h1a : 5'h10);
            6'h3c : sel <= (SCRAMBLE ? 5'he : 5'h0);
            6'h3d : sel <= (SCRAMBLE ? 5'h16 : 5'hc);
            6'h3e : sel <= (SCRAMBLE ? 5'hd : 5'h8);
            6'h3f : sel <= (SCRAMBLE ? 5'h1a : 5'h10);
            endcase
        end
    end
end

// indicate (fresh) valid output data
reg dout_active, dout_valid;
always @(posedge clk) begin
    if (ena & rst) begin
       dout_valid <= 1'b0;
       dout_active <= 1'b0;
    end else begin
       if (cntr == 6'h11) dout_active <= 1'b1;
       dout_valid <= dout_active & ena;
    end
end

endmodule
