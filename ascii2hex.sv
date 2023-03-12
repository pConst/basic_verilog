//------------------------------------------------------------------------------
// hex2ascii.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Converts 8-bit human-readable ASCII char to 4-bit binary nibble
// For example, "F" char becomes 4'b1111, "4" char becomes 4'b0100
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

ascii2hex AH (
  .ascii(  ),
  .hex(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module ascii2hex (
  input  [7:0] ascii,
  output [3:0] hex
);

  always_comb begin
    case( ascii[7:0] )
      8'd48        : hex[3:0] = 4'h0;
      8'd49        : hex[3:0] = 4'h1;
      8'd50        : hex[3:0] = 4'h2;
      8'd51        : hex[3:0] = 4'h3;
      8'd52        : hex[3:0] = 4'h4;
      8'd53        : hex[3:0] = 4'h5;
      8'd54        : hex[3:0] = 4'h6;
      8'd55        : hex[3:0] = 4'h7;
      8'd56        : hex[3:0] = 4'h8;
      8'd57        : hex[3:0] = 4'h9;

      8'd65, 8'd97 : hex[3:0] = 4'hA;  // lowercase and capital letters
      8'd66, 8'd98 : hex[3:0] = 4'hB;
      8'd67, 8'd99 : hex[3:0] = 4'hC;
      8'd68, 8'd100: hex[3:0] = 4'hD;
      8'd69, 8'd101: hex[3:0] = 4'hE;
      8'd70, 8'd102: hex[3:0] = 4'hF;

      default      : hex[3:0] = 4'h0;
    endcase

endmodule

