//------------------------------------------------------------------------------
// spi_master.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Universal spi master
//
// * Supports all SPI bus modes
//          mode 0 (CPOL = 0, CPHA = 0)
//          mode 1 (CPOL = 0, CPHA = 1)
//          mode 2 (CPOL = 1, CPHA = 0)
//          mode 3 (CPOL = 1, CPHA = 1)
// * Moreover, universal spi master features separate parameters to set
//         clock edge to update data by spi master and
//         clock edge to latch data by spi master
// * Spi clock can be made free-running (some slaves require that)
// * OE pin for bidirectional buffer connection, in case DO and DI pins are combined
//
// * Universal spi master successfully synthesize at clk speeds up to 200MHz
// * That means, that SPI clocks up to 50MHz are supported
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

spi_master #(
  .WRITE_WIDTH( 8 ),
  .WRITE_MSB_FIRST( 1 ),
  .WRITE_DATA_EDGE( 1 ),

  .READ_WIDTH( 8 ),
  .READ_MSB_FIRST( 1 ),
  .READ_DATA_EDGE( 1 ),

  .FREE_RUNNING_SPI_CLK( 0 )
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
  .d_out_pin(  ),
  .d_oe(  ),
  .d_in_pin(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module spi_master #( parameter

  bit [4:0] WRITE_WIDTH = 8,     // data word width in bits
  bit WRITE_MSB_FIRST = 1,       // 0 - LSB first
                                 // 1 - MSB first
  bit WRITE_DATA_EDGE = 0,       // 0 - master updates on rising edge
                                 //     slave reads data on falling edge
                                 // 1 - master updates on falling edge
                                 //     slave reads data on rising edge

  bit [4:0] READ_WIDTH = 8,      // data word width in bits
  bit READ_MSB_FIRST = 1,        // 0 - LSB first
                                 // 1 - MSB first
  bit READ_DATA_EDGE = 1,        // 0 - slave updates on rising edge
                                 //     master reads data on falling edge
                                 // 1 - slave updates on falling edge
                                 //     master reads data on rising edge

  bit FREE_RUNNING_SPI_CLK = 0   // 0 - clk_pin is active only when ncs_pin = 0
                                 // 1 - clk pin is always active
)(
  input clk,                     // system clock
  input nrst,                    // reset (inversed)

  input spi_clk,                 // prescaler clock
                                 // spi_clk must be >= 4 clk cycles
                                 // must be synchronous multiple of clk cycles

  input spi_wr_cmd,              // spi write command, shifting begins on rising edge
  input spi_rd_cmd,              // spi read command, shifting begins on rising edge
  output logic spi_busy,         // shifting is active

  input [WRITE_WIDTH-1:0] mosi_data,            // data for shifting out from master
  output logic [READ_WIDTH-1:0] miso_data = 0,  // shifted in data from slave

  output logic clk_pin = 0,      // spi master's clock pin
  output logic ncs_pin = 1,      // spi master's chip select (inversed)
  output logic d_out_pin = 0,    // spi master's data in
  output logic d_oe = 1,         // spi master's output enable
                                 // in case of slave has only one SDIO pin
  input d_in_pin                 // spi master's data out
);

// sequence_cntr[7:0]==0 - waiting for spi_wr_cmd or spi_wr_cmd
// WRITE_SEQ_START - switching mode or transaction end
// WRITE_SEQ_END - waiting for right edge to set first data

localparam WRITE_SEQ_START = 1;
localparam WRITE_SEQ_END = WRITE_SEQ_START+2*WRITE_WIDTH;

localparam READ_SEQ_START = WRITE_SEQ_END+1;
localparam READ_SEQ_END = READ_SEQ_START+2*READ_WIDTH;

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

// input synchronizer for d_in_pin in clk domain, 2 cycles delay
// making similar delay for clk edges for read operation timing
logic d_in_pin_d2;
logic spi_clk_rise_d2;
logic spi_clk_fall_d2;
delay #(
    .LENGTH( 2 )
) d_in_pin_synch [2:0] (
    .clk( {3{clk}} ),
    .nrst( {3{nrst}} ),
    .ena( {3{1'b1}} ),
    .in( {d_in_pin,spi_clk_rise,spi_clk_fall} ),
    .out( {d_in_pin_d2,spi_clk_rise_d2,spi_clk_fall_d2} )
);

logic [7:0] sequence_cntr = 0;
logic rd_nwr = 0;                           // buffering data direction
logic [WRITE_WIDTH-1:0] mosi_data_buf = 0;   // buffering mosi_data

always_ff @(posedge clk) begin
  if( ~nrst ) begin
    miso_data[READ_WIDTH-1:0] <= 0;

    clk_pin <= ~WRITE_DATA_EDGE;
    ncs_pin <= 1'b1;
    d_out_pin <= 1'b0;
    d_oe <= 1'b1;
    sequence_cntr[7:0] <= 0;
    rd_nwr <= 0;
    mosi_data_buf[WRITE_WIDTH-1:0] <= 0;
  end else begin

    if( FREE_RUNNING_SPI_CLK ) begin
      if ( spi_clk_rise ) begin
        clk_pin <= 1'b1;
      end
      if( spi_clk_fall ) begin
        clk_pin <= 1'b0;
      end
    end else begin  // FREE_RUNNING_SPI_CLK = 0
      if ( ~ncs_pin &&
           // fixing extra clock glitch in the end of read transaction
           ~((sequence_cntr[7:0] == READ_SEQ_END) &&
           (WRITE_DATA_EDGE != READ_DATA_EDGE)) ) begin
        if ( spi_clk_rise ) begin
          clk_pin <= 1'b1;
        end
        if( spi_clk_fall ) begin
          clk_pin <= 1'b0;
        end
      end else begin // ncs_pin = 1
        clk_pin <= ~WRITE_DATA_EDGE;
      end
    end

// WRITE =======================================================================

    // sequence start condition
    if( sequence_cntr[7:0]==0 && (spi_wr_cmd_rise || spi_rd_cmd_rise) ) begin
      // outputs should NOT be updated here
      if( spi_rd_cmd_rise ) begin
        rd_nwr <= 1'b1;
      end else begin
        rd_nwr <= 1'b0;
      end
      sequence_cntr[7:0] <= 1;
      // buffering mosi_data to avoid data change after shift_cmd issued
      mosi_data_buf[WRITE_WIDTH-1:0] <= mosi_data[WRITE_WIDTH-1:0];
    end

    // clocking out data
    if( sequence_cntr[7:0]>=WRITE_SEQ_START && sequence_cntr[7:0]<WRITE_SEQ_END ) begin

      if( WRITE_DATA_EDGE ) begin
        // we should omit this edge when sequence_cntr[7:0]==WRITE_SEQ_START
        if ( spi_clk_rise && (sequence_cntr[7:0]!=WRITE_SEQ_START) ) begin
          sequence_cntr[7:0] <= sequence_cntr[7:0] + 1'b1;
        end
        if( spi_clk_fall ) begin
          // changing d_out_pin
          d_out_pin <= mosi_data_buf[WRITE_WIDTH-1];
          // shifting out data
          if( WRITE_MSB_FIRST ) begin
            mosi_data_buf[WRITE_WIDTH-1:0] <= {mosi_data_buf[WRITE_WIDTH-2:0],1'b0};
          end else begin
            mosi_data_buf[WRITE_WIDTH-1:0] <= {1'b0,mosi_data_buf[WRITE_WIDTH-1:1]};
          end
          // spi output starts on WRITE_DATA_EDGE edge, to set first data
          if( sequence_cntr[7:0]==WRITE_SEQ_START ) begin
            ncs_pin <= 1'b0;
            d_oe <= 1'b1;
          end
          sequence_cntr[7:0] <= sequence_cntr[7:0] + 1'b1;
        end
      end else begin  // WRITE_DATA_EDGE == 0
        if ( spi_clk_rise ) begin
          // changing d_out_pin
          d_out_pin <= mosi_data_buf[WRITE_WIDTH-1];
          // shifting out data
          if( WRITE_MSB_FIRST ) begin
            mosi_data_buf[WRITE_WIDTH-1:0] <= {mosi_data_buf[WRITE_WIDTH-2:0],1'b0};
          end else begin
            mosi_data_buf[WRITE_WIDTH-1:0] <= {1'b0,mosi_data_buf[WRITE_WIDTH-1:1]};
          end
          // spi output starts on WRITE_DATA_EDGE edge, to set first data
          if( sequence_cntr[7:0]==WRITE_SEQ_START ) begin
            ncs_pin <= 1'b0;
            d_oe <= 1'b1;
          end
          sequence_cntr[7:0] <= sequence_cntr[7:0] + 1'b1;
        end
        // we should omit this edge when sequence_cntr[7:0]==WRITE_SEQ_START
        if( spi_clk_fall && (sequence_cntr[7:0]!=WRITE_SEQ_START) ) begin
          sequence_cntr[7:0] <= sequence_cntr[7:0] + 1'b1;
        end
      end // if( WRITE_DATA_EDGE )
    end

    // waiting for valid edge to switch direction
    if( ~rd_nwr ) begin
      // end of write transaction
      // resetting shifter to default state
      if( sequence_cntr[7:0]==WRITE_SEQ_END &&
        ( (~WRITE_DATA_EDGE && spi_clk_rise) ||
          (WRITE_DATA_EDGE && spi_clk_fall)) ) begin
        ncs_pin <= 1'b1;
        d_out_pin <= 1'b0;
        d_oe <= 1'b1;
        sequence_cntr[7:0] <= 0;
      end
    end else begin
      if( sequence_cntr[7:0]==WRITE_SEQ_END &&
        ( (~WRITE_DATA_EDGE && spi_clk_rise) ||
          (WRITE_DATA_EDGE && spi_clk_fall)) ) begin
        //ncs_pin <= 1'b0;
        d_out_pin <= 1'b0;
        d_oe <= 1'b0;
        sequence_cntr[7:0] <= sequence_cntr[7:0] + 1'b1;
      end

// READ ========================================================================

// In some combinations of WRITE_DATA_EDGE and READ_DATA_EDGE and slave timing -
// we will get false first bit(s) when reading data. That is not a bug. To get valid
// read data - increment READ_WIDTH and ommit first received bit(s)


      // clocking in data
      // spi_clk edges and d_in_pin are 2 cycles delayed
      if( sequence_cntr[7:0]>=READ_SEQ_START && sequence_cntr[7:0]<READ_SEQ_END ) begin

        if( READ_DATA_EDGE ) begin
          if ( spi_clk_rise_d2 && (sequence_cntr[7:0]!=READ_SEQ_START) ) begin
            // shifting in delayed data
            if( READ_MSB_FIRST ) begin
              miso_data[READ_WIDTH-1:0] <= {miso_data[READ_WIDTH-2:0],d_in_pin_d2};
            end else begin
              miso_data[READ_WIDTH-1:0] <= {d_in_pin_d2,miso_data[WRITE_WIDTH-1:1]};
            end
            sequence_cntr[7:0] <= sequence_cntr[7:0] + 1'b1;
          end
          // we should omit this edge when sequence_cntr[7:0]==READ_SEQ_START
          if( spi_clk_fall_d2 ) begin
            sequence_cntr[7:0] <= sequence_cntr[7:0] + 1'b1;
          end
        end else begin  // READ_DATA_EDGE = 0
          // we should omit this edge when sequence_cntr[7:0]==READ_SEQ_START
          if( spi_clk_rise_d2 ) begin
            sequence_cntr[7:0] <= sequence_cntr[7:0] + 1'b1;
          end
          if ( spi_clk_fall_d2 && (sequence_cntr[7:0]!=READ_SEQ_START) ) begin
            // shifting in delayed data
            if( READ_MSB_FIRST ) begin
              miso_data[READ_WIDTH-1:0] <= {miso_data[READ_WIDTH-2:0],d_in_pin_d2};
            end else begin
              miso_data[READ_WIDTH-1:0] <= {d_in_pin_d2,miso_data[WRITE_WIDTH-1:1]};
            end
            sequence_cntr[7:0] <= sequence_cntr[7:0] + 1'b1;
          end
        end // if( READ_DATA_EDGE )
      end

      // waiting for valid edge to end read transaction
      if( sequence_cntr[7:0]==READ_SEQ_END &&
        ( (~READ_DATA_EDGE && spi_clk_rise_d2) ||
          (READ_DATA_EDGE && spi_clk_fall_d2)) ) begin
          ncs_pin <= 1'b1;
          d_out_pin <= 1'b0;
          d_oe <= 1'b1;
          sequence_cntr[7:0] <= 0;
      end

    end // if( ~rd_nwr )
  end // if( nrst )
end // always

always_comb begin
  spi_busy = (sequence_cntr[7:0] != 0);
end

endmodule
