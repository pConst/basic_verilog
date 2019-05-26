
// testbench for dynamic_delay_tb.sv module

`timescale 1ns / 1ps

module dynamic_delay_tb();

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


// Module under test ==========================================================

logic [5:0] test_data = '0;
logic [3:0] sel = '0;
always_ff @(posedge clk200) begin
  if( ~nrst_once ) begin
    test_data[5:0] <= '0;
    sel[3:0] <= '0;
  end else begin
    test_data[5:0] <= test_data[5:0] + 1'b1;
    if( test_data[5:0]=='1 ) begin
      sel[3:0] <= sel[3:0] + 1'b1;
    end
  end
end


dynamic_delay #(
  .LENGTH( 3 ),
  .WIDTH( 4 )
) M (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .ena( 1'b1 ),
  .in( test_data[3:0] ),
  .sel( sel[3:0] ),
  .out(  )
);


endmodule
