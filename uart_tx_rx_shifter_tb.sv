//------------------------------------------------------------------------------
// uart_tx_rx_shifter_tb.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// testbench for uart_tx_rx_shifter_tb.sv module

`timescale 1ns / 1ps

module uart_tx_rx_shifter_tb();

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


// Module under test ==========================================================

`define STB  1
`define DB   8
`define SPB  2

logic tx_busy;
logic serial_data;

logic start;

// continious transfer (no automatic data check implemented)
assign start = 1'b1;

// random transfer (features automatic data check)
//assign start = ~tx_busy && &RandomNumber1[11:8];

uart_tx_shifter #(
  .START_BITS( `STB ),
  .DATA_BITS( `DB ),
  .STOP_BITS( `SPB )
) tx1 (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .tx_data( RandomNumber1[`DB-1:0] ),
  .tx_start( start ),
  .tx_busy( tx_busy ),
  .txd( serial_data )
);

logic data_valid;
logic [`DB-1:0] data_rcvd;
uart_rx_shifter #(
  .START_BITS( `STB ),
  .DATA_BITS( `DB ),
  .STOP_BITS( `SPB ),
  .SYNCHRONIZE_RXD( 1 )     // 0 - disabled; 1 - enabled
) rx1 (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .rx_data( data_rcvd[`DB-1:0] ),
  .rx_valid( data_valid ),
  .rxd( serial_data )
);


logic [`DB-1:0] data_sent;
fifo #(
  .DEPTH( 8 ),
  .DATA_W( `DB )
) data_check_fifo (
  .clk( clk200 ),
  .rst( 1'b0 ),

  .w_req( start ),
  .w_data( RandomNumber1[`DB-1:0] ),

  .r_req( data_valid ),
  .r_data( data_sent[`DB-1:0] ),

  .cnt(  ),
  .empty(  ),
  .full(  )
);

logic success = 1'b1;
always_ff @(posedge clk200) begin
  if( data_valid ) begin
    if( data_sent[`DB-1:0] != data_rcvd[`DB-1:0] ) begin
      success <= 1'b0;
    end
  end
end

endmodule
