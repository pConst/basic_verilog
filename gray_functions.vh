//------------------------------------------------------------------------------
// gray_functions.vh
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//  Gray code parametrizable converter functions
//
//  Parametrized classes are supported by Vivado, NOT supported by Quartus.
//  Please use bin2gray.sv and gray2bin.sv conventional modules instead.
//
//  Call syntax:
//  ============
//  assign a[63:0] = gray_functions#(64)::bin2gray( b[63:0] );
//  assign c[255:0] = gray_functions#(256)::gray2bin( d[255:0] );
//


virtual class gray_functions #( parameter
  WIDTH = 32
);

  static function [WIDTH-1:0] bin2gray(
    input [WIDTH-1:0] bin
  );

    bin2gray[WIDTH-1:0] = bin[WIDTH-1:0] ^ ( bin[WIDTH-1:0] >> 1 );
  endfunction


  static function [WIDTH-1:0] gray2bin(
    input [WIDTH-1:0] gray
  );

    gray2bin[WIDTH-1:0] = '0;

    for( integer i=0; i<WIDTH; i++ ) begin
      gray2bin[WIDTH-1:0] ^= gray[WIDTH-1:0] >> i;
    end
  endfunction

endclass

