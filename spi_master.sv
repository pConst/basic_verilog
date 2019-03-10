//------------------------------------------------------------------------------
// spi_master.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Universal spi master
//
// * Supports following SPI bus modes
//          mode 0 (CPOL = 0, CPHA = 0)
//          mode 2 (CPOL = 1, CPHA = 0)
//
// * Spi clock can be made free-running (some slaves require that)
// * OE pin for bidirectional buffer connection, in case DO and DI pins are combined
//
// * Universal spi master successfully synthesize at clk speeds 200MHz and above
// * That means, that SPI clocks up to 100MHz are supported
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

spi_master #(
  .CPOL( 0 ),
  .FREE_RUNNING_SPI_CLK( 0 ),
  .MOSI_DATA_WIDTH( 8 ),
  .WRITE_MSB_FIRST( 1 ),
  .MISO_DATA_WIDTH( 8 ),
  .READ_MSB_FIRST( 1 )
) SM1 (
  .clk(  ),
  .nrst(  ),
  .spi_clk(  ),
  .spi_wr_cmd(  ),
  .spi_rd_cmd(  ),
  .spi_busy(  ),

  .mosi_data(  ),
  .miso_data(  ),

  .clk_pin(  ),
  .ncs_pin(  ),
  .mosi_pin(  ),
  .oe_pin(  ),
  .miso_pin(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module spi_master #( parameter

  bit CPOL = 0,                  // Clock polarity for SPI interface
                                 // 0 - SPI mode 0
                                 //     data updates on rising edge
                                 //     data reads on falling edge
                                 // 1 - SPI mode 2
                                 //     data updates on falling edge
                                 //     data reads on rising edge
  bit FREE_RUNNING_SPI_CLK = 0,  // 0 - clk_pin is active only when ncs_pin = 0
                                 // 1 - clk pin is always active
  bit [5:0] MOSI_DATA_WIDTH = 8, // data word width in bits
  bit WRITE_MSB_FIRST = 1,       // 0 - LSB first
                                 // 1 - MSB first
  bit [5:0] MISO_DATA_WIDTH = 8, // data word width in bits
  bit READ_MSB_FIRST = 1         // 0 - LSB first
                                 // 1 - MSB first
)(
  input clk,                     // system clock
  input nrst,                    // reset (inversed)

  input spi_clk,                 // prescaler clock
                                 // spi_clk must be >= 2 clk cycles
                                 // must be synchronous multiple of clk cycles

  input spi_wr_cmd,              // spi write command, shifting begins on rising edge
  input spi_rd_cmd,              // spi read command, shifting begins on rising edge
  output logic spi_busy,         // shifting is active

  input [MOSI_DATA_WIDTH-1:0] mosi_data,            // data for shifting out from master
  output logic [MISO_DATA_WIDTH-1:0] miso_data,     // shifted in data from slave

  output logic clk_pin,          // spi master's clock pin
  output logic ncs_pin = 1,      // spi master's chip select (inversed)
  output logic mosi_pin = 0,     // spi master's data in
  output logic oe_pin = 0,       // spi master's output enable
                                 // in case of using bidirectional buffer for SDIO pin
  input miso_pin                 // spi master's data in
);


// first extra state for getting command and buffering
// second extra state to initialize outputs
localparam WRITE_SEQ_START = 2;
localparam WRITE_SEQ_END = WRITE_SEQ_START+2*MOSI_DATA_WIDTH;

localparam READ_SEQ_START = WRITE_SEQ_END;
localparam READ_SEQ_END = READ_SEQ_START+2*MISO_DATA_WIDTH;


logic spi_clk_rise;
logic spi_clk_fall;
edge_detect ed_spi_clk (
  .clk( clk ),
  .nrst( nrst ),
  .in( spi_clk ),
  .rising( spi_clk_rise ),
  .falling( spi_clk_fall ),
  .both(  )
);

logic spi_wr_cmd_rise;
logic spi_rd_cmd_rise;
edge_detect ed_cmds [1:0] (
  .clk( {2{clk}} ),
  .nrst( {2{nrst}} ),
  .in( {spi_wr_cmd,spi_rd_cmd} ),
  .rising( {spi_wr_cmd_rise,spi_rd_cmd_rise} ),
  .falling(  ),
  .both(  )
);

// no need to synchronize miso pin because that is a slave`s responsibility
// to hold stable signal and avoid metastability


// shifting out is always LSB first
// optionally reversing miso data if requested
logic [MOSI_DATA_WIDTH-1:0] mosi_data_rev;
reverse_vector #(
  .WIDTH( MOSI_DATA_WIDTH )
) reverse_mosi_data (
  .in( mosi_data[MOSI_DATA_WIDTH-1:0] ),
  .out( mosi_data_rev[MOSI_DATA_WIDTH-1:0] )
);


logic clk_pin_before_inversion;                  // inversion is optional, see CPOL parameter
logic [7:0] sequence_cntr = 0;
logic rd_nwr = 0;                                // buffering data direction
logic [MOSI_DATA_WIDTH-1:0] mosi_data_buf = 0;   // buffering mosi_data
logic [MISO_DATA_WIDTH-1:0] miso_data_buf = 0;   // buffering miso_data

always_ff @(posedge clk) begin
  if( ~nrst ) begin
    clk_pin_before_inversion <= CPOL;
    ncs_pin <= 1'b1;
    mosi_pin <= 1'b0;
    oe_pin <= 1'b0;

    sequence_cntr[7:0] <= 0;
    rd_nwr <= 0;
    mosi_data_buf[MOSI_DATA_WIDTH-1:0] <= 0;
    miso_data_buf[MISO_DATA_WIDTH-1:0] <= 0;
  end else begin

    if( FREE_RUNNING_SPI_CLK ) begin
      if ( spi_clk_rise ) begin
        clk_pin_before_inversion <= 1'b1;
      end
      if( spi_clk_fall ) begin
        clk_pin_before_inversion <= 1'b0;
      end
    end else begin  // FREE_RUNNING_SPI_CLK = 0
      if ( ~ncs_pin ) begin
        if ( spi_clk_rise ) begin
          clk_pin_before_inversion <= 1'b1;
        end
        if( spi_clk_fall ) begin
          clk_pin_before_inversion <= 1'b0;
        end
      end else begin // ncs_pin = 1
        clk_pin_before_inversion <= CPOL;
      end
    end // if( FREE_RUNNING_SPI_CLK )

// WRITE =======================================================================

    // sequence start condition
    //*cmd_rise signals are NOT synchronous with spi_clk edges
    if( sequence_cntr[7:0]==0 && (spi_wr_cmd_rise || spi_rd_cmd_rise) ) begin
      if( spi_rd_cmd_rise ) begin
        rd_nwr <= 1'b1;
      end else begin
        rd_nwr <= 1'b0;
      end
      // buffering mosi_data to avoid data change after shift_cmd issued
      if( WRITE_MSB_FIRST ) begin
        mosi_data_buf[MOSI_DATA_WIDTH-1:0] <= mosi_data_rev[MOSI_DATA_WIDTH-1:0];
      end else begin
        mosi_data_buf[MOSI_DATA_WIDTH-1:0] <= mosi_data[MOSI_DATA_WIDTH-1:0];
      end
      sequence_cntr[7:0] <= sequence_cntr[7:0] + 1'b1;
    end

    // second step of initialization, updating outputs synchronously with spi_clk edge
    if( sequence_cntr[7:0]==1 && spi_clk_rise ) begin
      ncs_pin <= 1'b0;
      oe_pin <= 1'b1;
      sequence_cntr[7:0] <= sequence_cntr[7:0] + 1'b1;
    end

    // clocking out data
    if( sequence_cntr[7:0]>=WRITE_SEQ_START && sequence_cntr[7:0]<WRITE_SEQ_END ) begin

      // we should omit this to start sequence on specific edge
      if ( spi_clk_rise ) begin
        sequence_cntr[7:0] <= sequence_cntr[7:0] + 1'b1;
      end
      if( spi_clk_fall ) begin
        // changing mosi_pin
        mosi_pin <= mosi_data_buf[0];
        // shifting out data is alvays LSB first
        mosi_data_buf[MOSI_DATA_WIDTH-1:0] <= {1'b0,mosi_data_buf[MOSI_DATA_WIDTH-1:1]};
        sequence_cntr[7:0] <= sequence_cntr[7:0] + 1'b1;
      end
    end

    // waiting for valid edge to switch direction
    if( ~rd_nwr ) begin
      // end of write transaction
      // resetting shifter to default state
      if( sequence_cntr[7:0]==WRITE_SEQ_END && spi_clk_fall ) begin
        ncs_pin <= 1'b1;
        mosi_pin <= 1'b0;
        oe_pin <= 1'b0;
        sequence_cntr[7:0] <= 0;
      end
    end else begin
      if( sequence_cntr[7:0]==WRITE_SEQ_END && spi_clk_fall ) begin
        //ncs_pin <= 1'b0;
        mosi_pin <= 1'b0;
        oe_pin <= 1'b0;
        sequence_cntr[7:0] <= sequence_cntr[7:0] + 1'b1;
      end

// READ ========================================================================

      // clocking in data
      if( sequence_cntr[7:0]>=READ_SEQ_START && sequence_cntr[7:0]<READ_SEQ_END ) begin

          if ( spi_clk_rise ) begin
            // shifting in data is alvays LSB first
            miso_data_buf[MISO_DATA_WIDTH-1:0] <= {miso_pin,miso_data_buf[MOSI_DATA_WIDTH-1:1]};
            sequence_cntr[7:0] <= sequence_cntr[7:0] + 1'b1;
          end
          // we should omit this to start sequence on specific edge
          if( spi_clk_fall ) begin
            sequence_cntr[7:0] <= sequence_cntr[7:0] + 1'b1;
          end
      end

      // waiting for valid edge to end read transaction
      if( sequence_cntr[7:0]==READ_SEQ_END && spi_clk_fall ) begin
          ncs_pin <= 1'b1;
          mosi_pin <= 1'b0;
          oe_pin <= 1'b0;
          sequence_cntr[7:0] <= 0;
      end

    end // if( ~rd_nwr )
  end // if( nrst )
end // always


logic [MISO_DATA_WIDTH-1:0] miso_data_buf_rev;
reverse_vector #(
  .WIDTH( MISO_DATA_WIDTH )
) reverse_miso_data (
  .in( miso_data_buf[MISO_DATA_WIDTH-1:0] ),
  .out( miso_data_buf_rev[MISO_DATA_WIDTH-1:0] )
);


always_comb begin

  // CPOL==1 means output clock inversion
  if( CPOL ) begin
    // inversion
    clk_pin = ~clk_pin_before_inversion;
  end else begin
    // no inversion
    clk_pin = clk_pin_before_inversion;
  end

  // shifting in is always LSB first
  // optionally reversing miso data if requested
  if( READ_MSB_FIRST ) begin
    miso_data[MISO_DATA_WIDTH-1:0] = miso_data_buf_rev[MISO_DATA_WIDTH-1:0];
  end else begin
    miso_data[MISO_DATA_WIDTH-1:0] = miso_data_buf[MISO_DATA_WIDTH-1:0];
  end

  spi_busy = (sequence_cntr[7:0] != 0);
end


endmodule
