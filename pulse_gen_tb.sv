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

logic [15:0] RandomNumber1;
c_rand rng1 (
  .clk( clk200 ),
  .rst( rst_once ),
  .reseed( 1'b0 ),
  .seed_val( DerivedClocks[31:0] ),
  .out( RandomNumber1[15:0] )
);

logic start;
initial begin
  #0 start = 1'b0;
  #100 start = 1'b1;
  #10 start = 1'b0;
end

// Modules under test ==========================================================

// simple static test
pulse_gen #(
  .CNTR_WIDTH( 32 )
) pg1 (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .low_width(  32'd1 ),
  .high_width( 32'd1 ),
  .rpt( 1'b0 ),
  .start( start ),
  .busy(  ),
  .out(  )
);

// random test
pulse_gen #(
  .CNTR_WIDTH( 32 )
) pg2 (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .low_width(  {28'd0,RandomNumber1[3:0]} ),
  .high_width( {28'd0,RandomNumber1[7:4]} ),
  .rpt( 1'b1 ),
  .start( start ),
  .busy(  ),
  .out(  )
);


logic [31:0] pg3_in_high_width = '0;
logic pg3_out;
logic pg3_out_rise;

edge_detect pg3_out_ed (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .in( pg3_out ),
  .rising( pg3_out_rise ),
  .falling(  ),
  .both(  )
);

always_ff @(posedge clk200) begin
  if( ~nrst_once ) begin
     pg3_in_high_width[31:0] <= 1'b1;
  end else begin
    if( pg3_out_rise ) begin
      pg3_in_high_width[31:0] <= pg3_in_high_width[31:0] + 1'b1;
    end
  end
end

// PWM test
pulse_gen #(
  .CNTR_WIDTH( 32 )
) pg3 (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .low_width( 32'd1 ),
  .high_width( pg3_in_high_width[31:0] ),
  .rpt( 1'b1 ),
  .start( start ),
  .busy(  ),
  .out( pg3_out )
);


endmodule
