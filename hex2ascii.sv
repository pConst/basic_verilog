//------------------------------------------------------------------------------
// hex2ascii.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Converts 4-bit binary nibble to 8-bit human-readable ASCII char
// For example, 4'b1111 befomes an "F" char, 4'b0100 becomes "4" char
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

hex2ascii HA (
  .hex(  ),
  .ascii(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module hex2ascii (
  input [3:0] hex,
  output [7:0] ascii
);

  always_comb begin
    if( hex[3:0] < 4'hA ) begin
      ascii[7:0] = hex[3:0] + 8'd48;   // 0 hex -> 48 ascii
    end else begin
      ascii[7:0] = hex[3:0] + 8'd55;   // A hex -> 65 ascii
    end
  end

endmodule

