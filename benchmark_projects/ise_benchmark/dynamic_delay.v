//--------------------------------------------------------------------------------
// dynamic_delay.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//
//
//  WARNING!
//  This is an adapted verilog version of the Dynamic delay module
//  Please use original "dynamic_delay.sv" where it is posibble


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
  output [WIDTH-1:0] out              // output data
);


reg [(LENGTH+1)*WIDTH-1:WIDTH] data = 0;

wire [(LENGTH+1)*WIDTH-1:0] pack_data;
assign pack_data[(LENGTH+1)*WIDTH-1:0] =
  { data[(LENGTH+1)*WIDTH-1:WIDTH], in[WIDTH-1:0] };

integer i;
always@(posedge clk) begin
  if( ~nrst ) begin
    // reset all data except zero element
    for( i=2; i<(LENGTH+2); i=i+1 ) begin
      data[i*WIDTH-1-:WIDTH] <= 0;
    end
  end else if (ena) begin
    for( i=3; i<(LENGTH+2); i=i+1 ) begin
      data[i*WIDTH-1-:WIDTH] <= data[(i-1)*WIDTH-1-:WIDTH];
    end
    // zero element assignment
    data[2*WIDTH-1-:WIDTH] <= in[WIDTH-1:0];
  end
end

// output selector, sel==0 gives non-delayed output
assign out[WIDTH-1:0] = pack_data[sel[SEL_W-1:0]+:WIDTH];


endmodule
