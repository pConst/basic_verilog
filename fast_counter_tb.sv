//------------------------------------------------------------------------------
// main_tb.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Testbench for fast_counter.sv

// use this define to make some things differently in simulation
`define SIMULATION yes

`timescale 1ns / 1ps

module fast_counter_tb();

logic clk200;
initial begin
  #0 clk200 = 1'b0;
  forever
    #2.5 clk200 = ~clk200;
end

// external device "asynchronous" clock
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
  //#10000;
  forever begin
    #9985 rst = ~rst;
    #5 rst = ~rst;
  end
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

logic start;
initial begin
  #0 start = 1'b0;
  #100 start = 1'b1;
  #20 start = 1'b0;
end

// Module under test ==========================================================


logic inc = 1'b0;
logic dec = 1'b0;
logic set = 1'b0;

logic [7:0] seq_cntr = '0;
always_ff @(posedge clk200) begin
  if( ~nrst_once ) begin
    seq_cntr[7:0] <= '0;
  end else begin
    seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
  end

/*  if( seq_cntr[7:0]>5 ) begin
    inc = 1'b1;
  end else begin
    inc = 1'b0;
  end*/

  if( seq_cntr[7:0]>5 ) begin
    dec = 1'b1;
  end else begin
    dec = 1'b0;
  end

  if( seq_cntr[7:0]==5 ) begin
    set = 1'b1;
  end else begin
    set = 1'b0;
  end

end



`define WIDTH 14

logic [`WIDTH-1:0] q;
fast_counter #(
  .WIDTH( `WIDTH )
) fc (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .inc( inc ),
  .dec( dec ),
  .set( set ),
  .set_val( RandomNumber1[`WIDTH-1:0] ),
  .q( q[`WIDTH-1:0] ),
  .q_is_zero(  )
);

logic [`WIDTH-1:0] q_d1 = '0;
always_ff @(posedge clk200) begin
  if( ~nrst_once ) begin
    q_d1[`WIDTH-1:0] <= '0;
  end else begin
    q_d1[`WIDTH-1:0] <= q[`WIDTH-1:0];
  end
end

logic success_dec;
assign success_dec = (q_d1[`WIDTH-1:0] == (q[`WIDTH-1:0]+1'b1));
logic success_inc;
assign success_inc = (q_d1[`WIDTH-1:0] == (q[`WIDTH-1:0]-1'b1));

endmodule

