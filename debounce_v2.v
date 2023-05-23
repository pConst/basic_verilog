//------------------------------------------------------------------------------
// debounce_v2.v
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Button debounce v2
//
// - sampling inputs using configurable divided clock (this is the
//   simplest form of low-pass filter)
//
// - in contrast with debounce_v1.v this implementation is switching output only
//   when input had stable level IN ALL CLOCK CYCLES within the sample window
//   (this gives some form of hysteresis in case we sample unstable data)
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

debounce_v2 #(
  .WIDTH( 4 ),
  .SAMPLING_FACTOR( 16 )
) DB1 (
  .clk( clk ),
  .nrst( 1'b1 ),
  .ena( 1'b1 ),
  .in( btn[3:0] ),
  .out( btn_db[3:0] )
);

--- INSTANTIATION TEMPLATE END ---*/


module debounce_v2 #( parameter
  WIDTH = 1,
  SAMPLING_FACTOR = 16,   // 0 - sampling every clk
                          // 1 - sampling on clk/2
                          // 2 - sampling on clk/4 etc....

  // only one or none should be enabled
  TREAT_UNSTABLE_AS_HIGH = 0,
  TREAT_UNSTABLE_AS_LOW = 0
)(
  input clk,
  input nrst,
  input ena,

  input  [WIDTH-1:0] in,
  output reg [WIDTH-1:0] out = 0
);


  localparam SAMPLING_RANGE = 32;


  wire [SAMPLING_RANGE-1:0] s_clk;
  clk_divider #(
    .WIDTH( SAMPLING_RANGE )
  ) clk_div (
    .clk( clk ),
    .nrst( nrst ),
    .ena( 1'b1 ),
    .out( s_clk[SAMPLING_RANGE-1:0] )
  );

  wire [SAMPLING_RANGE-1:0] s_clk_rise;
  edge_detect #(
    .WIDTH( SAMPLING_RANGE )
  ) clk_div_ed (
    .clk( clk ),
    .anrst( nrst ),
    .in( s_clk[SAMPLING_RANGE-1:0] ),
    .rising( s_clk_rise[SAMPLING_RANGE-1:0] )
  );

  wire do_sample;
  assign do_sample = s_clk_rise[SAMPLING_FACTOR];


  reg [WIDTH-1:0] in_is_high = 0;
  reg [WIDTH-1:0] in_is_low = 0;

  integer i;
  always @(posedge clk) begin
    if (~nrst) begin
      out[WIDTH-1:0] <= 0;

      in_is_high[WIDTH-1:0] <= 0;
      in_is_low[WIDTH-1:0] <= 0;
    end else if (ena && do_sample) begin

      // making decisions for outputs
      for (i = 0; i < WIDTH; i=i+1) begin
        case ( {in_is_high[i],in_is_low[i]} )
          2'b01: out[i] <= 1'b0;
          2'b10: out[i] <= 1'b1;
          default: begin
                      if (TREAT_UNSTABLE_AS_HIGH) begin
                        out[i] <= 1'b1;
                      end else if (TREAT_UNSTABLE_AS_LOW) begin
                        out[i] <= 1'b0;
                      end
                   end
        endcase
      end // for

      // resetting flags to initialize new sample window
      in_is_high[WIDTH-1:0] <= 0;
      in_is_low[WIDTH-1:0] <= 0;

    end else begin

      // collecting data
      for (i = 0; i < WIDTH; i=i+1) begin
        if ( in[i] ) begin
          in_is_high[i] <= 1'b1;
        end else begin
          in_is_low[i] <= 1'b1;
        end
      end // for

    end // if
  end

endmodule

