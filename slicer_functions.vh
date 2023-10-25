//------------------------------------------------------------------------------
// slicer_functions.vh
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//  Arbitrary slice functions for 2D and 3D packed SystemVerilog arrays
//  Slices along any array edge, all array sides simultaneously
//
//  You can also generalize this aproach to support as many dimentions as needed
//
//  This module does NOT consume any FPGA resources though it is absolutely
//  synthesizable
//
//  Parametrized classes are supported by Vivado, NOT supported by Quartus.
//  Please use slicer_2d.sv and slicer_3d.sv conventional modules instead.
//
//  Call syntax:
//  ============
//  assign a[2:1][2:1] = slicer_functions#(
//    .I2_HI( 3 ), .I2_LO( 0 ), .I1_HI( 7 ),  .I1_LO( 0 ),
//    .O2_HI( 2 ), .O2_LO( 1 ), .O1_HI( 2 ),  .O1_LO( 1 ) )::slice2d( b[3:0][7:0] );
//
//  assign c[2:1][2:1][2:1] = slicer_functions#( .T( my_data_type ),
//    .I3_HI( 3 ), .I3_LO( 0 ), .I2_HI( 3 ), .I2_LO( 0 ),
//    .I1_HI( 7 ), .I1_LO( 0 ), .O3_HI( 2 ), .O3_LO( 1 ),
//    .O2_HI( 2 ), .O2_LO( 1 ), .O1_HI( 2 ), .O1_LO( 1 ) )::slice3d_t( d[3:0][3:0][7:0] );
//


virtual class slicer_functions #( parameter

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
  O1_LO = 1,

  type T = int
);


  static function [O2_HI:O2_LO][O1_HI:O1_LO] slice2d(
    input [I2_HI:I2_LO][I1_HI:I1_LO] in
  );

    integer i;
    for ( i=O2_LO; i<=O2_HI; i++ ) begin
      slice2d[i][O1_HI:O1_LO] = in[i][O1_HI:O1_LO];
    end //i
  endfunction


  static function [O3_HI:O3_LO][O2_HI:O2_LO][O1_HI:O1_LO] slice3d(
    input [I3_HI:I3_LO][I2_HI:I2_LO][I1_HI:I1_LO] in
  );

    integer i,j;
    for ( i=O3_LO; i<=O3_HI; i++ ) begin
      for ( j=O2_LO; j<=O2_HI; j++ ) begin
        slice3d[i][j][O1_HI:O1_LO] = in[i][j][O1_HI:O1_LO];
      end //j
    end //i
  endfunction


  // Custom data type versions =================================================

  static function T [O2_HI:O2_LO][O1_HI:O1_LO] slice2d_t(
    input T [I2_HI:I2_LO][I1_HI:I1_LO] in
  );

    integer i;
    for ( i=O2_LO; i<=O2_HI; i++ ) begin
      slice2d_t[i][O1_HI:O1_LO] = in[i][O1_HI:O1_LO];
    end //i
  endfunction


  static function T [O3_HI:O3_LO][O2_HI:O2_LO][O1_HI:O1_LO] slice3d_t(
    input T [I3_HI:I3_LO][I2_HI:I2_LO][I1_HI:I1_LO] in
  );

    integer i,j;
    for ( i=O3_LO; i<=O3_HI; i++ ) begin
      for ( j=O2_LO; j<=O2_HI; j++ ) begin
        slice3d_t[i][j][O1_HI:O1_LO] = in[i][j][O1_HI:O1_LO];
      end //j
    end //i
  endfunction

endclass

