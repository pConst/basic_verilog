//--------------------------------------------------------------------------------
// pulse_stretch.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
// Pulse stretcher/extender module
//
//  - this implementftion uses a simple delay line or counter to stretch pulses
//  - WIDTH parameter sets output pulse width
//  - if you need variable output poulse width, see pulse_gen.sv module


/* --- INSTANTIATION TEMPLATE BEGIN ---

pulse_stretch #(
  .WIDTH( 8 ),
  .USE_CNTR( 0 )
) ps1 (
  .clk( clk ),
  .nrst( nrst ),
  .in(  ),
  .out(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module pulse_stretch #( parameter
  WIDTH = 8,
  USE_CNTR = 0      // ==0  - stretcher is implemented on delay line
                    // ==1  - stretcher is implemented on counter
)(
  input clk,
  input nrst,

  input in,
  output out
);


  localparam CNTR_W = $clog2(WIDTH+1);

  generate
    //==========================================================================
    if( WIDTH == 0 ) begin
      assign out = 0;

    //==========================================================================
    end else if( WIDTH == 1 ) begin
      assign out = in;

    //==========================================================================
    end else begin
      if( USE_CNTR == '0 ) begin
        // delay line

        logic [WIDTH-1:0] shifter = '0;
        always_ff @(posedge clk) begin
          if( ~nrst ) begin
            shifter[WIDTH-1:0] <= '0;
          end else begin
            // shifting
            shifter[WIDTH-1:0] <= {shifter[WIDTH-2:0],in};
          end // nrst
        end // always

        assign out = (shifter[WIDTH-1:0] != '0);

      end else begin
        // counter

        logic [CNTR_W-1:0] cntr = '0;
        always_ff @(posedge clk) begin
          if( ~nrst ) begin
            cntr[CNTR_W-1:0] <= '0;
          end else begin
            if( in ) begin
              // setting counter
              cntr[CNTR_W-1:0] <= CNTR_W'(WIDTH);
            end else if( out ) begin
              // decrementing counter
              cntr[CNTR_W-1:0] <= cntr[CNTR_W-1:0] - 1'b1;
            end
          end // nrst
        end // always

        assign out = (cntr[CNTR_W-1:0] != '0);

      end
    end // if WIDTH
  endgenerate


endmodule

