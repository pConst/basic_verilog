//------------------------------------------------------------------------------
// comb_repeater.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Combinational signal repeater
//
// Every stage consists of two sequential inverters
// Configurable number of stages
//
// Adapted for AMD/Xilinx devices
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

comb_repeater #(
    .LENGTH( 2 ),
    .WIDTH( 1 )
) R1 (
    .in(  ),
    .out(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module comb_repeater #( parameter
  LENGTH = 1,                  // repeater chain length
  WIDTH = 1                    // repeater bus width
)(
  input [WIDTH-1:0] in,
  output logic [WIDTH-1:0] out
);


  (* DONT_TOUCH = "TRUE" *) logic [LENGTH-1:0][WIDTH-1:0] s1; // first inverter outputs
  (* DONT_TOUCH = "TRUE" *) logic [LENGTH-1:0][WIDTH-1:0] s2; // second inverter outputs

  genvar i;
  generate
    for( i=0; i<LENGTH; i=i+1 ) begin

      always_comb begin

        if( i==(LENGTH-1) ) begin
          s1[i][WIDTH-1:0] <= ~in[WIDTH-1:0];
        end else begin
          s1[i][WIDTH-1:0] <= ~s2[i+1][WIDTH-1:0];
        end

        if( i==0 ) begin
          out[WIDTH-1:0] <= ~s1[i][WIDTH-1:0];
        end else begin
          s2[i][WIDTH-1:0] <= ~s1[i][WIDTH-1:0];
        end
      end

    end // for
  endgenerate

endmodule

