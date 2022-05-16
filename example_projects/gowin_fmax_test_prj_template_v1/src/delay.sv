//------------------------------------------------------------------------------
// delay.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO -------------------------------------------------------------------------
// Static Delay for arbitrary signal, v2
// Another equivalent names for this module:
//          conveyor.sv
//          synchronizer.sv
//
// Tip for Xilinx-based implementations: Leave nrst=1'b1 and ena=1'b1 on
// purpose of inferring Xilinx`s SRL16E/SRL32E primitives
//
// CAUTION: delay module is widely used for synchronizing signals across clock
//   domains. When synchronizing, please exclude input data paths from timing
//   analysis manually by writing appropriate set_false_path SDC constraint
//
// Version 2 introduces "ALTERA_BLOCK_RAM" option to implement delays using
//   block RAM. Quartus can make shifters on block RAM automatically
//   using 'altshift_taps' internal module when "Auto Shift Register
//   Replacement" option is ON
//

/* --- INSTANTIATION TEMPLATE BEGIN ---

delay #(
    .LENGTH( 2 ),
    .WIDTH( 1 ),
    .TYPE( "CELLS" ),
    .REGISTER_OUTPUTS( "FALSE" )
) S1 (
    .clk( clk ),
    .nrst( 1'b1 ),
    .ena( 1'b1 ),

    .in(  ),
    .out(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module delay #( parameter
  LENGTH = 2,                  // delay/synchronizer chain length
  WIDTH = 1,                   // signal width

  TYPE = "CELLS",              // "ALTERA_BLOCK_RAM" infers block ram fifo
                               //   "ALTERA_TAPS" infers altshift_taps
                               //   all other values infer registers

  REGISTER_OUTPUTS = "FALSE",  // for block RAM implementations: "TRUE" means that
                               //   last delay stage will be implemented
                               //   by means of cell registers to improve timing
                               //   all other values infer block RAMs only

  CNTR_W = $clog2(LENGTH)
)(
  input clk,
  input nrst,
  input ena,

  input [WIDTH-1:0] in,
  output [WIDTH-1:0] out
);

generate

  if ( LENGTH == 0 ) begin

    assign out[WIDTH-1:0] = in[WIDTH-1:0];

  end else if( LENGTH == 1 ) begin

    logic [WIDTH-1:0] data = '0;
    always_ff @(posedge clk) begin
      if( ~nrst ) begin
        data[WIDTH-1:0] <= '0;
      end else if( ena ) begin
        data[WIDTH-1:0] <= in[WIDTH-1:0];
      end
    end
    assign out[WIDTH-1:0] = data[WIDTH-1:0];

  end else begin
    if( TYPE=="ALTERA_BLOCK_RAM" && LENGTH>=3 ) begin

      logic [WIDTH-1:0] fifo_out;
      logic full;
      logic [CNTR_W-1:0] usedw;

      logic fifo_out_ena;
      if( REGISTER_OUTPUTS=="TRUE" ) begin
        assign fifo_out_ena = (usedw[CNTR_W-1:0] == LENGTH-1);
      end else begin
        assign fifo_out_ena = full;
      end

      scfifo #(
        .LPM_WIDTH( WIDTH ),
        .LPM_NUMWORDS( LENGTH ),   // must be at least 4
        .LPM_WIDTHU( CNTR_W ),
        .LPM_SHOWAHEAD( "ON" ),
        .UNDERFLOW_CHECKING( "ON" ),
        .OVERFLOW_CHECKING( "ON" ),
        .ENABLE_ECC( "FALSE" ),
        .ALLOW_RWCYCLE_WHEN_FULL( "ON" ),
        .USE_EAB( "ON" )
      ) internal_fifo (
        .clock( clk ),
        .aclr( 1'b0 ),
        .sclr( ~nrst ),

        .data( in[WIDTH-1:0] ),
        .wrreq( ena ),
        .rdreq( ena && fifo_out_ena ),

        .q( fifo_out[WIDTH-1:0] ),
        .empty(  ),
        .full( full ),
        .almost_full(  ),
        .almost_empty(  ),
        .usedw( usedw[CNTR_W-1:0] ),
        .eccstatus(  )
      );

      logic [WIDTH-1:0] reg_out = '0;
      always_ff @(posedge clk) begin
        if( ~nrst ) begin
          reg_out[WIDTH-1:0] <= '0;
        end else if( ena && fifo_out_ena ) begin
          reg_out[WIDTH-1:0] <= fifo_out[WIDTH-1:0];
        end
      end

      if( REGISTER_OUTPUTS=="TRUE" ) begin
        assign out[WIDTH-1:0] = reg_out[WIDTH-1:0];
      end else begin
        // avoiding first word fall-through
        assign out[WIDTH-1:0] = (fifo_out_ena)?(fifo_out[WIDTH-1:0]):('0);
      end

    end else if( TYPE=="ALTERA_TAPS" && LENGTH>=2 ) begin

      logic [WIDTH-1:0] fifo_out;
      logic [CNTR_W-1:0] delay_cntr = CNTR_W'(LENGTH-1);

      logic fifo_out_ena;
      assign fifo_out_ena = (delay_cntr[CNTR_W-1:0] == '0);

      always_ff @(posedge clk) begin
        if( ~nrst ) begin
          delay_cntr[CNTR_W-1:0] <= CNTR_W'(LENGTH-1);
        end else if( ena && ~fifo_out_ena ) begin
          delay_cntr[CNTR_W-1:0] <= delay_cntr[CNTR_W-1:0] - 1'b1;
        end
      end

      altshift_taps #(
        .intended_device_family( "Cyclone V" ),
        .lpm_hint( "RAM_BLOCK_TYPE=AUTO" ),
        .lpm_type( "altshift_taps" ),
        .number_of_taps( 1 ),
        .tap_distance( (REGISTER_OUTPUTS=="TRUE")?(LENGTH-1):(LENGTH) ),  // min. of 3
        .width( WIDTH )
      ) internal_taps (
        //.aclr( 1'b0 ),
        //.sclr( ~nrst ),
        .clock( clk ),
        .clken( ena ),
        .shiftin( in[WIDTH-1:0] ),
        .shiftout( fifo_out[WIDTH-1:0] )
      );

      if( REGISTER_OUTPUTS=="TRUE" ) begin
      logic [WIDTH-1:0] reg_out = '0;
      always_ff @(posedge clk) begin
        if( ~nrst ) begin
          reg_out[WIDTH-1:0] <= '0;
        end else if( ena && fifo_out_ena ) begin
          reg_out[WIDTH-1:0] <= fifo_out[WIDTH-1:0];
        end
      end
        assign out[WIDTH-1:0] = reg_out[WIDTH-1:0];
      end else begin
        assign out[WIDTH-1:0] = fifo_out[WIDTH-1:0];
      end

    end else begin

      logic [LENGTH:1][WIDTH-1:0] data = '0;
      always_ff @(posedge clk) begin
        integer i;
        if( ~nrst ) begin
          data <= '0;
        end else if( ena ) begin
          for(i=LENGTH-1; i>0; i--) begin
            data[i+1][WIDTH-1:0] <= data[i][WIDTH-1:0];
          end
          data[1][WIDTH-1:0] <= in[WIDTH-1:0];
        end
      end
      assign out[WIDTH-1:0] = data[LENGTH][WIDTH-1:0];

    end // if TYPE
  end // if LENGTH

endgenerate

endmodule
