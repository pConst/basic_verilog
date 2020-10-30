//------------------------------------------------------------------------------
// preview_fifo_tb.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// testbench for preview_fifo_tb.sv module

`timescale 1ns / 1ps

module preview_fifo_tb();

logic clk200;
initial begin
  #0 clk200 = 1'b0;
  forever
    #2.5 clk200 = ~clk200;
end

logic clk400;
initial begin
  #0 clk400 = 1'b0;
  forever
    #1.25 clk400 = ~clk400;
end

logic clk33;
initial begin
  #0 clk33 = 1'b0;
  forever
    #15.151 clk33 = ~clk33;
end

logic rst;
initial begin
  #0 rst = 1'b0;
  #10.2 rst = 1'b1;
  #5 rst = 1'b0;
end

logic nrst;
assign nrst = ~rst;

logic rst_once;
initial begin
  #0 rst_once = 1'b0;
  #10.2 rst_once = 1'b1;
  #5 rst_once = 1'b0;
end

logic nrst_once;
assign nrst_once = ~rst_once;

logic [31:0] DerivedClocks;
clk_divider #(
  .WIDTH( 32 )
) cd1 (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .ena( 1'b1 ),
  .out( DerivedClocks[31:0] )
);

logic [31:0] E_DerivedClocks;
edge_detect ed1[31:0] (
  .clk( {32{clk200}} ),
  .nrst( {32{nrst_once}} ),
  .in( DerivedClocks[31:0] ),
  .rising( E_DerivedClocks[31:0] ),
  .falling(  ),
  .both(  )
);

logic [31:0] RandomNumber1;
c_rand rng1 (
  .clk( clk200 ),
  .rst( 1'b0 ),
  .reseed( rst_once ),
  .seed_val( DerivedClocks[31:0] ^ (DerivedClocks[31:0] << 1) ),
  .out( RandomNumber1[15:0] )
);

c_rand rng2 (
  .clk( clk200 ),
  .rst( 1'b0 ),
  .reseed( rst_once ),
  .seed_val( DerivedClocks[31:0] ^ (DerivedClocks[31:0] << 2) ),
  .out( RandomNumber1[31:16] )
);

logic [31:0] RandomNumber1_d1;
always_ff @(posedge clk200) begin
  RandomNumber1_d1[31:0] <= RandomNumber1[31:0];
end

// Module under test ==========================================================

`define W_ENA = yes;
`define W_2WORD_ENA = yes;

`define R_ENA = yes;
`define R_2WORD_ENA = yes;


logic dis_writes = 1'b0;
logic [2:0] wrreq;
always_ff @(posedge clk200) begin
`ifdef W_ENA
    if( ~dis_writes ) begin
      if( RandomNumber1[12:11] == 2'b11 ) begin
        wrreq[2:0] <= 3'b010;
  `ifdef W_2WORD_ENA
      end else if( RandomNumber1[12:11] == 2'b00 ) begin
        wrreq[2:0] <= 3'b100;
  `endif
      end else begin
        wrreq[2:0] <= 3'b001;
      end
    end else begin
      wrreq[2:0] <= 3'b001;
    end
`else
  wrreq[2:0] <= 3'b001;
`endif
end

logic [1:0] empty;
logic [1:0] full;
logic [5:0] usedw;

logic [7:0] od0;
logic [7:0] od1;

logic [2:0] rdreq;
always_ff @(posedge clk200) begin
`ifdef R_ENA
    if( (usedw[5:0] >= 4) ) begin //&& dis_writes ) begin
      if( RandomNumber1[14:13] == 2'b11 ) begin
        rdreq[2:0] <= 3'b010;
        //$display("RD 1 %h",od0[7:0]);
    `ifdef R_2WORD_ENA
      end else if( RandomNumber1[14:13] == 2'b00 ) begin
        rdreq[2:0] <= 3'b100;
        //$display("RD 2 %h",od0[7:0]);
        //$display("RD 2 %h",od1[7:0]);
    `endif
      end else begin
        rdreq[2:0] <= 3'b001;
      end
    end else begin
      rdreq[2:0] <= 3'b001;
    end
`else
  rdreq[2:0] <= 3'b001;
`endif
end

always_ff @(posedge clk200) begin
  if( ~nrst_once ) begin
    dis_writes <= 1'b0;
  end else begin
    if( |full[1:0] ) begin
      dis_writes <= 1'b1;
    end
  end
end

// helper bits
logic w_word;
assign w_word = (wrreq[2:0] == 3'b010);
logic w_two;
assign w_two = (wrreq[2:0] == 3'b100);

logic r_word;
assign r_word = (rdreq[2:0] == 3'b010);
logic r_two;
assign r_two = (rdreq[2:0] == 3'b100);



preview_fifo #(
  .WIDTH( 8 ),
  .DEPTH( 32 )
) M (
  .clk( clk200 ),
  .nrst( nrst_once ),

  // input port
  .wrreq( wrreq[2:0] ),
  .id0( RandomNumber1_d1[15:0] ),
  .id1( RandomNumber1_d1[31:16] ),

  // output port
  .rdreq( rdreq[2:0] ),
  .od0( od0[7:0] ),
  .od1( od1[7:0] ),

  .empty( empty[1:0] ),
  .full( full[1:0] ),
  .usedw( usedw[5:0] )
);


endmodule
