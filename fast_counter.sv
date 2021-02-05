//------------------------------------------------------------------------------
// fast_counter.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//
// - This is a synthetic fast counter which appears faster than a standard one
//   generated from pure Verilog code
//
// - My tests show that it is on average 30MHz faster in direct comparisons for
//   counters from 5 to 32 bit widths in Cyclone V
//
// - Use this counter only when counter performance is your last and ultimate
//   resort to conquer timings. Fast counter is area-unefficient thing.
//
// - fast_counter_iterative_test project in the repo shows fast counter`s advantage
//   https://github.com/pConst/basic_verilog/fast_counter_iterative_test/
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

fast_counter #(
  .WIDTH( 14 )
) fc (
  .clk( clk ),

  .set(  ),           // highest priority operation, use it like a reset also
  .set_val(  ),
  .dec(  ),

  .q(  ),
  .q_is_zero(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module fast_counter #( parameter
  WIDTH = 8
)(
  input clk,

  input set,
  input [WIDTH-1:0] set_val,

  input dec,

  output [WIDTH-1:0] q,
  output q_is_zero
);


const logic [5:0][15:0] lsb_bits_init = { 16'b0000000000000001,
                                          16'b1000000000000000,
                                          16'b1111111100000000,
                                          16'b1111000011110000,
                                          16'b1100110011001100,
                                          16'b1010101010101010 };


logic [WIDTH-4-1:0] msb_bits = '0;
logic [5:0][15:0] lsb_bits = lsb_bits_init;

logic [16*6-1:0] lsb_bits_flat;
assign lsb_bits_flat[16*6-1:0] = lsb_bits;


integer i,j;
always_ff @(posedge clk) begin
  if( set ) begin

    msb_bits[WIDTH-4-1:0] <= set_val[WIDTH-1:4];
    for( i=0; i<6; i++ ) begin
      for( j=0; j<16; j++ ) begin
        lsb_bits[i][j] <= lsb_bits_init[i][(set_val[3:0]+j) % 16];
      end
    end

  end else if( dec ) begin

    if( lsb_bits[5][0] ) begin
      msb_bits[WIDTH-4-1:0] <= msb_bits[WIDTH-4-1:0] - 1'b1;
    end
    for( i=0; i<6; i++ ) begin
      for( j=0; j<16; j++ ) begin
        if( j==0 ) begin
          lsb_bits[i][j] <= lsb_bits[i][15];
        end else begin
          lsb_bits[i][j] <= lsb_bits[i][j-1];
        end
      end
    end

  end
end


assign q[WIDTH-1:4] = msb_bits[WIDTH-4-1:0];
assign q[3] = lsb_bits[3][0],
       q[2] = lsb_bits[2][0],
       q[1] = lsb_bits[1][0],
       q[0] = lsb_bits[0][0];

assign q_is_zero = ~|q[WIDTH-1:0];

endmodule

