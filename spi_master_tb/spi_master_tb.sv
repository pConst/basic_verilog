//------------------------------------------------------------------------------
// spi_master_tb.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//

`timescale 1ns / 1ps

module spi_master_tb();

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
  #20 start = 1'b0;
end

// Module under test ==========================================================

logic oe1_pin, din1_pin, clk1_pin, clk1_pin_rise, clk1_pin_fall;
logic oe2_pin, din2_pin, clk2_pin, clk2_pin_rise, clk2_pin_fall;
logic oe3_pin, din3_pin, clk3_pin, clk3_pin_rise, clk3_pin_fall;
logic oe4_pin, din4_pin, clk4_pin, clk4_pin_rise, clk4_pin_fall;

edge_detect ed2[3:0] (
  .clk( {4{clk200}} ),
  .nrst( {4{1'b1}} ),
  .in( {clk1_pin, clk2_pin, clk3_pin, clk4_pin} ),
  .rising( {clk1_pin_rise, clk2_pin_rise, clk3_pin_rise, clk4_pin_rise} ),
  .falling( {clk1_pin_fall, clk2_pin_fall, clk3_pin_fall, clk4_pin_fall} ),
  .both(  )
);

reg [7:0] test1_data = 8'b1010_0011;
reg [7:0] test2_data = 8'b1010_0011;
reg [7:0] test3_data = 8'b1010_0011;
reg [7:0] test4_data = 8'b1010_0011;

spi_master #(
  .WRITE_WIDTH( 8 ),
  .WRITE_MSB_FIRST( 1 ),
  .WRITE_DATA_EDGE( 1 ),

  .READ_WIDTH( 8 ),
  .READ_MSB_FIRST( 1 ),
  .READ_DATA_EDGE( 1 ),

  .FREE_RUNNING_SPI_CLK( 0 )
) SM1 (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .spi_clk( DerivedClocks[1] ),
  .spi_wr_cmd( 0 ),
  .spi_rd_cmd( start ),
  .spi_busy(  ),

  .mosi_data( 8'b1010_0011 ),
  .miso_data(  ),

  .clk_pin( clk1_pin ),
  .ncs_pin(  ),
  .d_out_pin(  ),
  .d_oe( oe1_pin ),
  .d_in_pin( din1_pin )
);

spi_master #(
  .WRITE_WIDTH( 8 ),
  .WRITE_MSB_FIRST( 1 ),
  .WRITE_DATA_EDGE( 0 ),

  .READ_WIDTH( 8 ),
  .READ_MSB_FIRST( 1 ),
  .READ_DATA_EDGE( 0 ),

  .FREE_RUNNING_SPI_CLK( 0 )
) SM2 (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .spi_clk( DerivedClocks[1] ),
  .spi_wr_cmd( 0 ),
  .spi_rd_cmd( start ),
  .spi_busy(  ),

  .mosi_data( 8'b1010_0011 ),
  .miso_data(  ),

  .clk_pin( clk2_pin ),
  .ncs_pin(  ),
  .d_out_pin(  ),
  .d_oe( oe2_pin ),
  .d_in_pin( din2_pin )
);

spi_master #(
  .WRITE_WIDTH( 8 ),
  .WRITE_MSB_FIRST( 1 ),
  .WRITE_DATA_EDGE( 1 ),

  .READ_WIDTH( 8 ),
  .READ_MSB_FIRST( 1 ),
  .READ_DATA_EDGE( 0 ),

  .FREE_RUNNING_SPI_CLK( 0 )
) SM3 (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .spi_clk( DerivedClocks[1] ),
  .spi_wr_cmd( 0 ),
  .spi_rd_cmd( start ),
  .spi_busy(  ),

  .mosi_data( 8'b1010_0011 ),
  .miso_data(  ),

  .clk_pin( clk3_pin ),
  .ncs_pin(  ),
  .d_out_pin(  ),
  .d_oe( oe3_pin ),
  .d_in_pin( din3_pin )
);

spi_master #(
  .WRITE_WIDTH( 8 ),
  .WRITE_MSB_FIRST( 1 ),
  .WRITE_DATA_EDGE( 0 ),

  .READ_WIDTH( 8 ),
  .READ_MSB_FIRST( 1 ),
  .READ_DATA_EDGE( 1 ),

  .FREE_RUNNING_SPI_CLK( 0 )
) SM4 (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .spi_clk( DerivedClocks[1] ),
  .spi_wr_cmd( 0 ),
  .spi_rd_cmd( start ),
  .spi_busy(  ),

  .mosi_data( 8'b1010_0011 ),
  .miso_data(  ),

  .clk_pin( clk4_pin ),
  .ncs_pin(  ),
  .d_out_pin(  ),
  .d_oe( oe4_pin ),
  .d_in_pin( din4_pin )
);

// emulating external divice ==================================================
// that works asynchronously on clk33 clock

always_ff @(posedge clk200) begin
  if( ~nrst_once) begin
    din1_pin <= 0;
    test1_data[7:0] = 8'b1010_0011;
  end else begin
    if( ~oe1_pin && clk1_pin_rise ) begin
      din1_pin <=test1_data[7];
      test1_data[7:0] <= {test1_data[6:0],1'b0};
    end
  end
end

always_ff @(posedge clk200) begin
  if( ~nrst_once) begin
    din2_pin <= 0;
    test2_data[7:0] = 8'b1010_0011;
  end else begin
    if( ~oe2_pin && clk2_pin_fall ) begin
      din2_pin <=test2_data[7];
      test2_data[7:0] <= {test2_data[6:0],1'b0};
    end
  end
end

always_ff @(posedge clk200) begin
  if( ~nrst_once) begin
    din3_pin <= 0;
    test3_data[7:0] = 8'b1010_0011;
  end else begin
    if( ~oe3_pin && clk3_pin_fall ) begin
      din3_pin <=test3_data[7];
      test3_data[7:0] <= {test3_data[6:0],1'b0};
    end
  end
end

always_ff @(posedge clk200) begin
  if( ~nrst_once) begin
    din4_pin <= 0;
    test4_data[7:0] = 8'b1010_0011;
  end else begin
    if( ~oe4_pin && clk4_pin_fall ) begin
      din4_pin <=test4_data[7];
      test4_data[7:0] <= {test4_data[6:0],1'b0};
    end
  end
end

endmodule
