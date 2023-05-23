//------------------------------------------------------------------------------
// udp_packet_tb.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// udp_packet testbench

// use this define to make some things differently in simulation
`define SIMULATION yes

`timescale 1ns / 1ps

module udp_packet_tb();

initial begin
  // Print out time markers in nanoseconds
  // Example:  $display("[T=%0t] start=%d", $realtime, start);
  $timeformat(-9, 3, " ns");

  // seed value setting is intentionally manual to achieve repeatability between sim runs
  $urandom( 1 );  // SEED value
end

logic clk200;
sim_clk_gen #(
  .FREQ( 200_000_000 ), // in Hz
  .PHASE( 0 ),          // in degrees
  .DUTY( 50 ),          // in percentage
  .DISTORT( 10 )        // in picoseconds
) clk200_gen (
  .ena( 1'b1 ),
  .clk( clk200 ),
  .clkd(  )
);

logic nrst_once;

logic [31:0] clk200_div;
clk_divider #(
  .WIDTH( 32 )
) cd1 (
  .clk( clk200 ),
  .nrst( nrst_once ),
  .ena( 1'b1 ),
  .out( clk200_div[31:0] )
);

logic [31:0] clk200_div_rise;
edge_detect ed1[31:0] (
  .clk( {32{clk200}} ),
  .anrst( {32{nrst_once}} ),
  .in( clk200_div[31:0] ),
  .rising( clk200_div_rise[31:0] ),
  .falling(  ),
  .both(  )
);

// external device "asynchronous" clock
logic clk33;
logic clk33d;
sim_clk_gen #(
  .FREQ( 200_000_000 ), // in Hz
  .PHASE( 0 ),          // in degrees
  .DUTY( 50 ),          // in percentage
  .DISTORT( 1000 )      // in picoseconds
) clk33_gen (
  .ena( 1'b1 ),
  .clk( clk33 ),
  .clkd( clk33d )
);


logic rst;
initial begin
  rst = 1'b0; // initialization
  repeat( 1 ) @(posedge clk200);

  forever begin
    repeat( 1 ) @(posedge clk200); // synchronous rise
    rst = 1'b1;
    //$urandom( 1 ); // uncomment to get the same random pattern EVERY nrst

    repeat( 2 ) @(posedge clk200); // synchronous fall, controls rst pulse width
    rst = 1'b0;

    repeat( 100 ) @(posedge clk200); // controls test body width
  end
end
logic nrst;
assign nrst = ~rst;


logic rst_once;
initial begin
  rst_once = 1'b0; // initialization
  repeat( 1 ) @(posedge clk200);

  repeat( 1 ) @(posedge clk200); // synchronous rise
  rst_once = 1'b1;

  repeat( 2 ) @(posedge clk200); // synchronous fall, controls rst_once pulse width
  rst_once = 1'b0;
end
//logic nrst_once; // declared before
assign nrst_once = ~rst_once;


// random pattern generation
logic [31:0] rnd_data;
always_ff @(posedge clk200) begin
  rnd_data[31:0] <= $urandom;
  end

initial forever begin
  @(posedge nrst);
  $display("[T=%0t] rnd_data[]=%h", $realtime, rnd_data[31:0]);
end


// helper start strobe appears unpredictable up to 20 clocks after nrst
logic start;
initial forever begin
  start = 1'b0; // initialization

  @(posedge nrst); // synchronous rise after EVERY nrst
  repeat( $urandom_range(0, 20) ) @(posedge clk200);
  start = 1'b1;

  @(posedge clk200); // synchronous fall exactly 1 clock after rise
  start = 1'b0;
end


initial begin
//  #10000 $stop;
//  #10000 $finish;
end

// sweeping pulses
logic sp = 1'b1;
logic [4:0] sp_duty_cycle = 8'd0;
initial forever begin
  if( sp_duty_cycle[4:0] == 0 ) begin
    sp = 1'b1;
    repeat( 10 ) @(posedge clk200);
  end
  sp = 1'b0;
  repeat( 1 ) @(posedge clk200);
  sp = 1'b1;
  repeat( 1 ) @(posedge clk200);
  sp = 1'b0;
  repeat( sp_duty_cycle ) @(posedge clk200);
  sp_duty_cycle[4:0] = sp_duty_cycle[4:0] + 1'b1; // overflow is expected here
end


// Module under test ===========================================================

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
      //id[31:0] <= {4{rnd_data[15:0]}};
    end else begin
      id[31:0] <= '0;
    end
  end
end


udp_packet #(
  .MODE( "BYTES" )  // "BYTES" or "NIBBLES"
) M1 (
  .clk( clk200 ),
  .nrst( nrst_once ),

  .tx_en(  ),
  .od(  )
);

udp_packet #(
  .MODE( "NIBBLES" )  // "BYTES" or "NIBBLES"
) M2 (
  .clk( clk200 ),
  .nrst( nrst_once ),

  .tx_en(  ),
  .od(  )
);

endmodule

