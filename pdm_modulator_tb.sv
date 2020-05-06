//------------------------------------------------------------------------------
// pdm_modulator_tb.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// testbench for pdm_modulator.sv module


`timescale 1ns / 1ps

module pdm_modulator_tb();

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

localparam MOD_WIDTH = 5;

logic [MOD_WIDTH-1:0] sp = '0;
logic [31:0][MOD_WIDTH-1:0] sin_table =
{ 5'd16, 5'd19, 5'd22, 5'd25, 5'd27, 5'd29, 5'd31, 5'd31,
  5'd31, 5'd31, 5'd30, 5'd28, 5'd26, 5'd23, 5'd20, 5'd17,
  5'd14, 5'd11, 5'd8,  5'd5,  5'd3,  5'd1,  5'd0,  5'd0,
  5'd0,  5'd0,  5'd2,  5'd4,  5'd6,  5'd9,  5'd12, 5'd15};


always_ff @(posedge clk200) begin
  if( ~nrst_once ) begin
    sp[MOD_WIDTH-1:0] <= '0;
  end else begin
    if( E_DerivedClocks[3] ) begin
      sp[MOD_WIDTH-1:0] <= sp[MOD_WIDTH-1:0] + 1'b1;
    end
  end
end

pdm_modulator #(
  .PDM_PERIOD_DIV( MOD_WIDTH+1 ),     // MOD_WIDTH+1 is a minimum
  .MOD_WIDTH( MOD_WIDTH )
) pdm1 (
  .clk( clk200 ),
  .nrst( nrst_once ),

  .mod_setpoint( sin_table[sp[MOD_WIDTH-1:0]][MOD_WIDTH-1:0] ),
  .pdm_out(  ),

  .start_strobe(  ),
  .busy(  )
);


endmodule
