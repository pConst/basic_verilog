//------------------------------------------------------------------------------
// main_tb.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Testbench template with basic clocking, reset and random stimulus signals

// use this define to make some things differently in simulation
`define SIMULATION yes

`timescale 1ns / 1ps

module main_tb();

logic clk200;
initial begin
  #0 clk200 = 1'b0;
  forever
    #2.5 clk200 = ~clk200;
end

// external device "asynchronous" clock
logic clk33a;
initial begin
  #0 clk33a = 1'b0;
  forever
    #7 clk33a = ~clk33a;
end

logic clk33;
//assign clk33 = clk33a;
always @(*) begin
  clk33 = #($urandom_range(0, 2000)*10ps) clk33a;
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


module_under_test #(
  .DEPTH( 255 ),
  .DATA_W( 32 )
) M (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .ena( 1'b1 ),

  .id( id[31:0] ),
  .od(  )
);

// emulating external divice ==================================================
// that works asynchronously on clk33 clock

assign ADC1_SCLKOUT = clk33;

logic [15:0] test_data = 16'b1010_1100_1100_1111;
logic [7:0] adc1_seq_cntr = 0;
always_ff @(posedge clk33) begin
  if( adc1_seq_cntr[7:0]==0 && ~ADC1_nCONV ) begin
    ADC1_BUSY <= 1'b1;
    ADC1_SDOUT <= test_data[15];
    test_data[15:0] <= {test_data[14:0],1'b0};
    adc1_seq_cntr[7:0] <= 1;
  end

  if( adc1_seq_cntr[7:0]>0 && adc1_seq_cntr[7:0]<33 && ADC1_SCLKOUT) begin
    ADC1_SCLKOUT <= ~ADC1_SCLKOUT;
    // emulating adc1 data
    ADC1_SDOUT <= test_data[15];
    test_data[15:0] <= {test_data[14:0],1'b0};
    adc1_seq_cntr[7:0] <= adc1_seq_cntr[7:0] + 1'b1;
  end

  if( adc1_seq_cntr[7:0]>0 && adc1_seq_cntr[7:0]<33 && ~ADC1_SCLKOUT) begin
    ADC1_SCLKOUT <= ~ADC1_SCLKOUT;
    adc1_seq_cntr[7:0] <= adc1_seq_cntr[7:0] + 1'b1;
  end

  if( adc1_seq_cntr[7:0]==33 ) begin
    ADC1_BUSY <= 0;
    ADC1_SCLKOUT <= 0;
    ADC1_SDOUT <= 0;
    adc1_seq_cntr[7:0] <= 0;
  end
end

endmodule

