//------------------------------------------------------------------------------
// pos2bin_tb.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// testbench for pos2bin module


`timescale 1ns / 1ps

module pos2bin_tb();

logic clk200;
initial begin
  #0 clk200 = 1;
  forever
    #2.5 clk200 = ~clk200;
end

logic rst;
initial begin
  #10.2 rst = 1;
  #5 rst = 0;
  //#10000;
  forever begin
    #9985 rst = ~rst;
    #5 rst = ~rst;
  end
end

logic nrst;
assign nrst = ~rst;

logic rst_once;
initial begin       // initializing non-X data before PLL starts
  #10.2 rst_once = 1;
  #5 rst_once = 0;
end
initial begin
  #510.2 rst_once = 1;    // PLL starts at 500ns, clock appears, so doing the reset for modules
  #5 rst_once = 0;
end

logic nrst_once;
assign nrst_once = ~rst_once;

logic [31:0] DerivedClocks;
ClkDivider #(
  .WIDTH( 32 )
) CD1 (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .out( DerivedClocks[31:0] )
);

logic [31:0] E_DerivedClocks;
EdgeDetect ED1[31:0] (
  .clk( {32{clk200}} ),
  .nrst( {32{nrst_once}} ),
  .in( DerivedClocks[31:0] ),
  .rising( E_DerivedClocks[31:0] ),
  .falling(  ),
  .both(  )
);

logic [15:0] RandomNumber1;
c_rand RNG1 (
  .clk( clk200 ),
  .rst( rst_once ),
  .reseed( 1'b0 ),
  .seed_val( DerivedClocks[31:0] ),
  .out( RandomNumber1[15:0] )
);

logic start;
initial begin
  #0 start = 1'b0;
  #100.2 start = 1'b1;
  #5 start = 1'b0;
end

// Module under test ==========================================================

logic [15:0] pos;
bin2pos  #(
  .BIN_WIDTH( 4 )
) BP1 (
  .bin( RandomNumber1[3:0] ),
  .pos( pos[15:0] )
);

logic insert_err_multi_hot;
assign insert_err_multi_hot = &RandomNumber1[7:4];

logic insert_err_no_hot;
assign insert_err_no_hot = &RandomNumber1[11:8];


logic [15:0] inpos;
always_comb begin
  if ( insert_err_multi_hot ) begin
    inpos[15:0] = pos[15:0] | RandomNumber1[15:0];
  end else if ( insert_err_no_hot ) begin
    inpos[15:0] = 0;
  end else begin
    inpos[15:0] = pos[15:0];
  end
end


logic [3:0] bin2;
logic e1,e2;
pos2bin #(
  .BIN_WIDTH( 4 )
) PB1 (
  .pos( inpos[15:0] ),
  .bin( bin2[3:0] ),

  .err_no_hot( e1 ),
  .err_multi_hot( e2 )
);

endmodule
