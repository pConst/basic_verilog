//------------------------------------------------------------------------------
// moving_average_tb.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// testbench for moving_average.sv module
//

`timescale 1ns / 1ps

module moving_average_tb();

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

logic [15:0] RandomNumber1;
c_rand rng1 (
  .clk(clk200),
  .rst(rst_once),
  .reseed(1'b0),
  .seed_val(DerivedClocks[31:0]),
  .out( RandomNumber1[15:0] )
);

logic start;
initial begin
  #0 start = 1'b0;
  #100 start = 1'b1;
  #20 start = 1'b0;
end

// Module under test ==========================================================

logic [15:0] seq_cntr = '0;

logic [31:0] id = '0;
always_ff @(posedge clk200) begin
  if( ~nrst_once ) begin
    seq_cntr[15:0] <= '0;
    id[31:0] <= '0;
  end else begin
    // incrementing sequence counter
    if( seq_cntr[15:0]!= '1 ) begin
      seq_cntr[15:0] <= seq_cntr[15:0] + 1'b1;
    end

    if( seq_cntr[15:0]<300 ) begin
      id[31:0] <= '1;
      //id[31:0] <= {4{RandomNumber1[15:0]}};
    end else begin
      id[31:0] <= '0;
    end
  end
end

moving_average #(
  .DEPTH( 255 ),
  .DATA_W( 32 )
) MA (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .ena( 1'b1 ),

  .id( id[31:0] ),
  .od(  )
);

endmodule
