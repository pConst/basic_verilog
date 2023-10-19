//------------------------------------------------------------------------------
// slicer_3d.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO -------------------------------------------------------------------------
// Arbitrary slicer for 3D packed SystemVerilog arrays
// Slices along any array edge, all array sides simultaneously
//
// You can also generalize this aproach to support as many dimentions as needed
//
// This module does NOT consume any FPGA resources though it is absolutely
// synthesizable
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

slicer_3d #(
  .I3_HI( 3 ), .I3_LO( 0 ),
  .I2_HI( 3 ), .I2_LO( 0 ),
  .I1_HI( 7 ), .I1_LO( 0 ),

  .O3_HI( 2 ), .O3_LO( 1 ),
  .O2_HI( 2 ), .O2_LO( 1 ),
  .O1_HI( 2 ), .O1_LO( 1 )
) S1 (
  .in ( a[3:0][3:0][7:0] ),
  .out( b[2:1][2:1][2:1] )
);

--- INSTANTIATION TEMPLATE END ---*/


module slicer_3d #( parameter

  // input array shape
  I3_HI = 3,  // most significant size
  I3_LO = 0,

  I2_HI = 3,
  I2_LO = 0,

  I1_HI = 7,  // least significant size
  I1_LO = 0,

  // sliced array shape
  O3_HI = 2,  // most significant size
  O3_LO = 1,

  O2_HI = 2,
  O2_LO = 1,

  O1_HI = 2,  // least significant size
  O1_LO = 1
)(
  input        [I3_HI:I3_LO][I2_HI:I2_LO][I1_HI:I1_LO] in,
  output logic [O3_HI:O3_LO][O2_HI:O2_LO][O1_HI:O1_LO] out
);


  integer i,j;
  always_comb begin

    for ( i=O3_LO; i<=O3_HI; i++ ) begin
      for ( j=O2_LO; j<=O2_HI; j++ ) begin
        out[i][j][O1_HI:O1_LO] = in[i][j][O1_HI:O1_LO];
      end //j
    end //i

  end

endmodule

