//------------------------------------------------------------------------------
// spi_master_tb.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//

`timescale 1ns / 1ps

module spi_master_tb();

logic clk800;
initial begin
  #0 clk800 = 1'b0;
  forever
    #0.625 clk800 = ~clk800;
end

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

logic oe1_pin, ncs1_pin, din1_pin, clk1_pin, clk1_pin_rise, clk1_pin_fall;
logic oe2_pin, ncs2_pin, din2_pin, clk2_pin, clk2_pin_rise, clk2_pin_fall;
logic oe3_pin, ncs3_pin, din3_pin, clk3_pin, clk3_pin_rise, clk3_pin_fall;
logic oe4_pin, ncs4_pin, din4_pin, clk4_pin, clk4_pin_rise, clk4_pin_fall;

reg [7:0] test1_data = 8'b1010_0011;
reg [7:0] test2_data = 8'b1010_0011;
reg [7:0] test3_data = 8'b1010_0011;
reg [7:0] test4_data = 8'b1010_0011;


spi_master #(
  .CPOL( 0 ),
  .FREE_RUNNING_SPI_CLK( 0 ),
  .MOSI_DATA_WIDTH( 8 ),
  .WRITE_MSB_FIRST( 1 ),
  .MISO_DATA_WIDTH( 8 ),
  .READ_MSB_FIRST( 1 )
) SM1 (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .spi_clk( DerivedClocks[0] ),
  .spi_wr_cmd( 0 ),
  .spi_rd_cmd( start ),
  .spi_busy(  ),

  .mosi_data( 8'b1010_0011 ),
  .miso_data(  ),

  .clk_pin( clk1_pin ),
  .ncs_pin( ncs1_pin ),
  .mosi_pin(  ),
  .oe_pin( oe1_pin ),
  .miso_pin( din1_pin )
);

spi_master #(
  .CPOL( 1 ),
  .FREE_RUNNING_SPI_CLK( 0 ),
  .MOSI_DATA_WIDTH( 8 ),
  .WRITE_MSB_FIRST( 1 ),
  .MISO_DATA_WIDTH( 8 ),
  .READ_MSB_FIRST( 1 )
) SM2 (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .spi_clk( DerivedClocks[0] ),
  .spi_wr_cmd( 0 ),
  .spi_rd_cmd( start ),
  .spi_busy(  ),

  .mosi_data( 8'b1010_0011 ),
  .miso_data(  ),

  .clk_pin( clk2_pin ),
  .ncs_pin( ncs2_pin ),
  .mosi_pin(  ),
  .oe_pin( oe2_pin ),
  .miso_pin( din2_pin )
);

spi_master #(
  .CPOL( 0 ),
  .FREE_RUNNING_SPI_CLK( 1 ),
  .MOSI_DATA_WIDTH( 8 ),
  .WRITE_MSB_FIRST( 0 ),
  .MISO_DATA_WIDTH( 8 ),
  .READ_MSB_FIRST( 0 )
) SM3 (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .spi_clk( DerivedClocks[0] ),
  .spi_wr_cmd( 0 ),
  .spi_rd_cmd( start ),
  .spi_busy(  ),

  .mosi_data( 8'b1010_0011 ),
  .miso_data(  ),

  .clk_pin( clk3_pin ),
  .ncs_pin( ncs3_pin ),
  .mosi_pin(  ),
  .oe_pin( oe3_pin ),
  .miso_pin( din3_pin )
);

spi_master #(
  .CPOL( 0 ),
  .FREE_RUNNING_SPI_CLK( 1 ),
  .MOSI_DATA_WIDTH( 8 ),
  .WRITE_MSB_FIRST( 0 ),
  .MISO_DATA_WIDTH( 8 ),
  .READ_MSB_FIRST( 0 )
) SM4 (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .spi_clk( DerivedClocks[0] ),
  .spi_wr_cmd( 0 ),
  .spi_rd_cmd( start ),
  .spi_busy(  ),

  .mosi_data( 8'b1010_0011 ),
  .miso_data(  ),

  .clk_pin( clk4_pin ),
  .ncs_pin( ncs4_pin ),
  .mosi_pin(  ),
  .oe_pin( oe4_pin ),
  .miso_pin( din4_pin )
);

// emulating external divice ==================================================
// that works asynchronously on clk33 clock

// clk800 emulates some high-speed "ideal" slave

edge_detect ed2[3:0] (
  .clk( {4{clk800}} ),
  .nrst( {4{1'b1}} ),
  .in( {clk1_pin, clk2_pin, clk3_pin, clk4_pin} ),
  .rising( {clk1_pin_rise, clk2_pin_rise, clk3_pin_rise, clk4_pin_rise} ),
  .falling( {clk1_pin_fall, clk2_pin_fall, clk3_pin_fall, clk4_pin_fall} ),
  .both(  )
);

always_ff @(posedge clk800) begin
  if( ~nrst_once) begin
    din1_pin <= 0;
    test1_data[7:0] = 8'b1010_0011;
  end else begin
    if( ~ncs1_pin && ~oe1_pin && clk1_pin_fall ) begin
      din1_pin <=test1_data[7];
      test1_data[7:0] <= {test1_data[6:0],1'b0};
    end
  end
end

always_ff @(posedge clk800) begin
  if( ~nrst_once) begin
    din2_pin <= 0;
    test2_data[7:0] = 8'b1010_0011;
  end else begin
    if( ~ncs2_pin && ~oe2_pin && clk2_pin_rise ) begin
      din2_pin <=test2_data[7];
      test2_data[7:0] <= {test2_data[6:0],1'b0};
    end
  end
end

always_ff @(posedge clk800) begin
  if( ~nrst_once) begin
    din3_pin <= 0;
    test3_data[7:0] = 8'b1010_0011;
  end else begin
    if( ~ncs3_pin && ~oe3_pin && clk3_pin_fall ) begin
      din3_pin <=test3_data[7];
      test3_data[7:0] <= {test3_data[6:0],1'b0};
    end
  end
end

always_ff @(posedge clk800) begin
  if( ~nrst_once) begin
    din4_pin <= 0;
    test4_data[7:0] = 8'b1010_0011;
  end else begin
    if( ~ncs4_pin && ~oe4_pin && clk4_pin_fall ) begin
      din4_pin <=test4_data[7];
      test4_data[7:0] <= {test4_data[6:0],1'b0};
    end
  end
end

endmodule
