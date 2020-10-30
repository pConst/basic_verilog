//--------------------------------------------------------------------------------
// dynamic_delay.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  Dynamic delay for arbitrary signal.
//
//  Incoming data elements have WIDTH bits each. Module does serialization of
//  input data and outputs flattened bits, based on provided selector value.
//  You can perform delays bit-wize, not just element-wize.
//
//  CAUTION: Be careful selecting last, most-delayed "WIDTH" number of bits.
//           The module intentionally does NOT implement "out of range"
//           checks. Please handle them externally.



/* --- INSTANTIATION TEMPLATE BEGIN ---

dynamic_delay #(
  .LENGTH( 3 ),
  .WIDTH( 4 )
) M (
  .clk( clk ),
  .nrst( nrst ),
  .ena( 1'b1 ),
  .in( in_data[3:0] ),
  .sel( sel[3:0] ),
  .out( out_data[3:0] )
);

--- INSTANTIATION TEMPLATE END ---*/


module dynamic_delay #( parameter
  LENGTH = 63,                        // maximum delay chain length
  WIDTH = 4,                          // data width

  SEL_W = $clog2( (LENGTH+1)*WIDTH )  // output selector width
                                      //  plus one is for zero delay element
)(
  input clk,
  input nrst,
  input ena,
  input [WIDTH-1:0] in,               // input data
                                      // bit in[0] is the "oldest" one
                                      // bit in[WIDTH] is considered the most recent
  input [SEL_W-1:0] sel,              // output selector
  output logic [WIDTH-1:0] out        // output data
);



logic [(LENGTH+1)-1:0][WIDTH-1:0] data = '0;

// packed vector includes extra bits
logic [(LENGTH+1)*WIDTH-1:0] pack_data;
assign pack_data[(LENGTH+1)*WIDTH-1:0] = data;

integer i;
always_ff @(posedge clk) begin
  if( ~nrst ) begin
    // reset all data except zero element
    for( i=1; i<(LENGTH+1); i=i+1 ) begin
      data[i][WIDTH-1:0] <= '0;
    end
  end else if (ena) begin
    for( i=1; i<(LENGTH+1); i=i+1 ) begin
      data[i][WIDTH-1:0] <= data[i-1][WIDTH-1:0];
    end
  end
end

integer j;
always_comb begin
  // zero element assignment
  data[0][WIDTH-1:0] <= in[WIDTH-1:0];

  // output selector, sel==0 gives non-delayed output
  for( j=0; j<WIDTH; j=j+1 ) begin
    out[j] <= pack_data[sel[SEL_W-1:0]+j];
  end
end

endmodule
