//------------------------------------------------------------------------------
// pulse_gen_tb.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// testbench for pulse_gen.sv module


`timescale 1ns / 1ps

module pulse_gen_tb();

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

// Modules under test ==========================================================

// simple static test
/*pulse_gen #(
  .CNTR_WIDTH( 8 )
) pg1 (
  .clk( clk200 ),
  .nrst( nrst_once ),

  .start( start ),
  .cntr_max( 15 ),
  .cntr_low( 0 ),

  .out(  ),
  .busy(  )
);
*/

// random test
pulse_gen #(
  .CNTR_WIDTH( 8 )
) pg1 (
  .clk( clk200 ),
  .nrst( nrst_once ),

  .start( 1'b1 ),
  .cntr_max( 16 ),
  .cntr_low( {4'b0,RandomNumber1[3:0]} ),

  .out(  ),
  .busy(  )
);


logic [31:0] in_high_width = '0;
logic out;
logic out_rise;

edge_detect out_ed (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .in( out ),
  .rising( out_rise ),
  .falling(  ),
  .both(  )
);

always_ff @(posedge clk200) begin
  if( ~nrst_once ) begin
     in_high_width[31:0] <= 1'b0;
  end else begin
    if( out_rise ) begin
      in_high_width[31:0] <= in_high_width[31:0] + 1'b1;
    end
  end
end

// PWM test
/*pulse_gen #(
  .CNTR_WIDTH( 8 )
) pg1 (
  .clk( clk200 ),
  .nrst( nrst_once ),

  .start( 1'b1 ),
  .cntr_max( 15 ),
  .cntr_low( {4'b0,in_high_width[3:0]} ),

  .out( out ),
  .busy(  )
);*/

endmodule
