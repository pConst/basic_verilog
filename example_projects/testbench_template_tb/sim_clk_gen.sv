//------------------------------------------------------------------------------
// sim_clk_gen.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Testbench clock generator written in System Verilog
//

`timescale 1ns / 1ps

module sim_clk_gen #( parameter
  FREQ  = 200_000_000,  // in Hz
  PHASE = 0,            // in degrees
  DUTY  = 50,           // in percentage
  DISTORT = 200         // in picoseconds
)(
  input  ena,
  output logic clk,     // ideal clock
  output logic clkd     // distorted clock
);

  real clk_pd     = 1.0 / FREQ * 1e9;        // convert to ns
  real clk_on     = DUTY / 100.0 * clk_pd;
  real clk_off    = (100.0 - DUTY) / 100.0 * clk_pd;
  real start_dly  = clk_pd / 4 * PHASE / 90;

  logic do_clk;

  initial begin
    $display("FREQ      = %0d Hz", FREQ);
    $display("PHASE     = %0d deg", PHASE);
    $display("DUTY      = %0d %%",  DUTY);
    $display("DISTORT   = %0d ps", DISTORT);

    $display("PERIOD    = %0.3f ns", clk_pd);
    $display("CLK_ON    = %0.3f ns", clk_on);
    $display("CLK_OFF   = %0.3f ns", clk_off);
    $display("START_DLY = %0.3f ns", start_dly);
  end

  initial begin
    clk <= 0;
    do_clk <= 1;
  end

  always @ (posedge ena or negedge ena) begin
    if (ena) begin
      #(start_dly) do_clk = 1;
    end else begin
      #(start_dly) do_clk = 0;
    end
  end

  always @(posedge do_clk) begin
    if( do_clk ) begin
      clk = 1;
      while ( do_clk ) begin
        #(clk_on)  clk = 0;
        #(clk_off) clk = 1;
      end
      clk = 0;
    end
  end

  always @(*) begin
    clkd = #($urandom_range(0, DISTORT)*1ps) clk;
  end

endmodule

