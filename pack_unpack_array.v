//------------------------------------------------------------------------------
// pack_unpack_array.v
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// This module defines macros for pacing and unpacking 2D and 3D vectors
//   to pass them through parent module`s ports
// Verilog-2001 standard does not allow multi-dimensional vectors to appear in
//   ports. These macros allow to bypass the violation

genvar pk_i;
genvar pk_j;

`define PACK_ARRAY_2D(PK_DIM1,PK_DIM0,PK_SRC,PK_DEST) generate for(pk_i=0; pk_i<(PK_DIM1); pk_i=pk_i+1) begin; assign PK_DEST[((PK_DIM0)*pk_i+((PK_DIM0)-1)):((PK_DIM0)*pk_i)] = PK_SRC[pk_i][((PK_DIM0)-1):0]; end; endgenerate
`define UNPACK_ARRAY_2D(PK_DIM1,PK_DIM0,PK_DEST,PK_SRC) generate for(pk_i=0; pk_i<(PK_DIM1); pk_i=pk_i+1) begin; assign PK_DEST[pk_i][((PK_DIM0)-1):0] = PK_SRC[((PK_DIM0)*pk_i+(PK_DIM0-1)):((PK_DIM0)*pk_i)]; end; endgenerate

`define PACK_ARRAY_3D(PK_DIM2,PK_DIM1,PK_DIM0,PK_SRC,PK_DEST) generate for(pk_i=0; pk_i<(PK_DIM1); pk_i=pk_i+1) begin; for(pk_j=0; pk_j<(PK_DIM1); pk_j=pk_j+1) begin; assign PK_DEST[(((PK_DIM1)*pk_j+((PK_DIM1)-1))+((PK_DIM0)*pk_i+((PK_DIM0)-1))):((PK_DIM0)*pk_i)*pk_j] = PK_SRC[pk_j][pk_i][((PK_DIM0)-1):0]; end; end; endgenerate
`define UNPACK_ARRAY_3D(PK_DIM2,PK_DIM1,PK_DIM0,PK_DEST,PK_SRC) generate for(pk_i=0; pk_i<(PK_DIM1); pk_i=pk_i+1) begin; for(pk_j=0; pk_j<(PK_DIM1); pk_j=pk_j+1) begin; assign PK_DEST[pk_j][pk_i][((PK_DIM0)-1):0] = PK_SRC[(((PK_DIM1)*pk_j+((PK_DIM1)-1))+((PK_DIM0)*pk_i+((PK_DIM0)-1))):((PK_DIM0)*pk_i)*pk_j]; end; end; endgenerate


// === USAGE EXAMPLE BEGIN =====================================================
//
// `include "pack_unpack_array.v"
//
// module example (
//   input  [63:0] pack_64,
//   output [63:0] pack_64_out
// );
//
//   // unpacking arrays
//     wire [7:0] in_2d [7:0];
//     `UNPACK_ARRAY_2D(8,8,pack_64,in_2d)
//     wire [7:0] in_3d [1:0][3:0];
//     `UNPACK_ARRAY_3D(2,4,8,pack_64,in_3d)
//
//   // working with unpacked arrays
//     wire [7:0] in_3d_modified [1:0][3:0];
//     assign in_3d_modified = ~in_3d;
//
//   // packing data back
//     `PACK_ARRAY_3D(2,4,8,in_3d_modified,pack_64_out)
//
// endmodule
//
// === USAGE EXAMPLE END =======================================================


// === FORMATTED VERSION BEGIN =================================================
//
// genvar pk_i;
// genvar pk_j;

// `define PACK_ARRAY_2D(PK_DIM1,PK_DIM0,PK_SRC,PK_DEST)
// generate
//   for(pk_i=0; pk_i<(PK_DIM1); pk_i=pk_i+1) begin;
//     assign PK_DEST[((PK_DIM0)*pk_i+((PK_DIM0)-1)):((PK_DIM0)*pk_i)] =
//       PK_SRC[pk_i][((PK_DIM0)-1):0];
//   end;
// endgenerate

// `define UNPACK_ARRAY_2D(PK_DIM1,PK_DIM0,PK_DEST,PK_SRC)
// generate
//   for(pk_i=0; pk_i<(PK_DIM1); pk_i=pk_i+1) begin;
//     assign PK_DEST[pk_i][((PK_DIM0)-1):0] =
//       PK_SRC[((PK_DIM0)*pk_i+(PK_DIM0-1)):((PK_DIM0)*pk_i)];
//   end;
// endgenerate

// `define PACK_ARRAY_3D(PK_DIM2,PK_DIM1,PK_DIM0,PK_SRC,PK_DEST)
// generate
//   for(pk_i=0; pk_i<(PK_DIM1); pk_i=pk_i+1) begin;
//     for(pk_j=0; pk_j<(PK_DIM1); pk_j=pk_j+1) begin;
//       assign PK_DEST[(((PK_DIM1)*pk_j+((PK_DIM1)-1))+((PK_DIM0)*pk_i+((PK_DIM0)-1))):((PK_DIM0)*pk_i)*pk_j] =
//         PK_SRC[pk_j][pk_i][((PK_DIM0)-1):0];
//     end;
//   end;
// endgenerate

// `define UNPACK_ARRAY_3D(PK_DIM2,PK_DIM1,PK_DIM0,PK_DEST,PK_SRC)
// generate
//   for(pk_i=0; pk_i<(PK_DIM1); pk_i=pk_i+1) begin;
//     for(pk_j=0; pk_j<(PK_DIM1); pk_j=pk_j+1) begin;
//       assign PK_DEST[pk_j][pk_i][((PK_DIM0)-1):0] =
//         PK_SRC[(((PK_DIM1)*pk_j+((PK_DIM1)-1))+((PK_DIM0)*pk_i+((PK_DIM0)-1))):((PK_DIM0)*pk_i)*pk_j];
//     end;
//   end;
// endgenerate
//
// === FORMATTED VERSION END ===================================================

