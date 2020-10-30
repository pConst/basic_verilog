//------------------------------------------------------------------------------
// preview_fifo.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Preview FIFO, v2
//
// The module performs just like an ordinany FIFO in show-ahead mode.
// The diffenence is that 0, 1 or 2 words may be written at once.
// Also, 0, 1 or 2 words may be requested at once.
// This gives an opportunity for the reader to "preview" up to 2 future
// fifo words without actually fetching it yet.
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

preview_fifo #(
  .WIDTH( 16 ),
  .DEPTH( 16 )     // must be at least 8
) pf (
  .clk( clk ),
  .nrst( nrst ),

  // input port
  .wrreq(  ),           // 3 bit one-hot
  .id0(  ),             // first word
  .id1(  ),             // secong word

  // output port
  .rdreq(  ),           // 3 bit one-hot
  .od0(  ),             // first word
  .od1(  ),             // second word

  .empty( [1:0] ),      // 2'b00, 2'b10 or 2'b11
  .full( [1:0] ),       // 2'b11, 2'b01 or 2'b00
  .usedw( [USED_W:0] )  // attention to the width!

);

--- INSTANTIATION TEMPLATE END ---*/


module preview_fifo #( parameter
  WIDTH = 32,
  DEPTH = 16,                    // must be at least 8

  USED_W = $clog2(DEPTH)
)(
  input clk,
  input nrst,

  // input port
  input [2:0] wrreq,             // 3'b001 - no write
                                 // 3'b010 - write one word
                                 // 3'b100 - write two words at once
  input [WIDTH-1:0] id0,         // preceding data word
  input [WIDTH-1:0] id1,         // subsequent data word
                                 // both data words are written simultaneously

  // output port
  input [2:0] rdreq,             // 3'b001 - no read
                                 // 3'b010 - read one word
                                 // 3'b100 - read two words at once
  output logic [WIDTH-1:0] od0,  // first data word (preceding)
  output logic [WIDTH-1:0] od1,  // seconfd dadta word (subsequent)

  output [1:0] empty,            // when FIFO has just one word -
                                 //  any of thse bits will be active
                                 // when FIFO has no words -
                                 //  both of these flags will be active
  output [1:0] full,             // "full" flags, logic is similar to "empty"
  output logic[USED_W:0] usedw   // word count, attention to the additional
                                 //  MSB for holding word count when full
);


// *_ptr=0 means that next read or write shoul happen with FIFO0
// *_ptr=1 means that next read or write shoul happen with FIFO1
logic wr_ptr = 1'b0;
logic rd_ptr = 1'b0;

logic [1:0] f_wrreq;
logic [1:0][WIDTH-1:0] f_wrdata;

logic [1:0] f_rdreq;
logic [1:0][WIDTH-1:0] f_rddata;

// underflow and owerflow protection flags
logic w0_valid, w1_valid, w2_valid;
logic r0_valid, r1_valid, r2_valid;
always_comb begin
  w0_valid <= ~full[0];
  w1_valid <= ~full[1];
  w2_valid <= ~|full[1:0];    // write two words is valid
  r0_valid <= ~empty[0];
  r1_valid <= ~empty[1];
  r2_valid <= ~|empty[1:0];   // read two words is valid
end


// writing internal FIFOs ======================================================
always_comb begin
  case( wrreq[2:0] )
    3'b010: begin  // writing one word
      if( wr_ptr ) begin
        f_wrreq[0] <= 1'b0;
        if( w1_valid ) begin  // protecting from overflow
          f_wrreq[1] <= 1'b1;
        end else begin
          f_wrreq[1] <= 1'b0;
        end
      end else begin
        if( w0_valid ) begin  // protecting from overflow
          f_wrreq[0] <= 1'b1;
        end else begin
          f_wrreq[0] <= 1'b0;
        end
        f_wrreq[1] <= 1'b0;
      end // wr_ptr
    end
    3'b100: begin  // writing two words
      if( w2_valid ) begin  // protecting from overflow
        f_wrreq[0] <= 1'b1;
        f_wrreq[1] <= 1'b1;
      end else begin
        f_wrreq[0] <= 1'b0;
        f_wrreq[1] <= 1'b0;
      end
    end
    default: begin  // supports valid "3'b001" case and all invalid cases
      f_wrreq[0] <= 1'b0;
      f_wrreq[1] <= 1'b0;
    end
  endcase

  if( wr_ptr ) begin
    f_wrdata[0][WIDTH-1:0] <= id1[WIDTH-1:0];
    f_wrdata[1][WIDTH-1:0] <= id0[WIDTH-1:0];
  end else begin
    f_wrdata[0][WIDTH-1:0] <= id0[WIDTH-1:0];
    f_wrdata[1][WIDTH-1:0] <= id1[WIDTH-1:0];
  end
end

always_ff @(posedge clk) begin
  if( ~nrst ) begin
    wr_ptr = 1'b0;
  end else begin
    if( wr_ptr ) begin
      if( wrreq[2:0] == 3'b010 && w1_valid ) begin
        wr_ptr = ~wr_ptr;
      end
    end else begin
      if( wrreq[2:0] == 3'b010 && w0_valid ) begin
        wr_ptr = ~wr_ptr;
      end
    end
  end // nrst
end


// reading internal FIFOs ======================================================
always_comb begin
  case( rdreq[2:0] )
    3'b010: begin
      if( rd_ptr ) begin
        f_rdreq[0] <= 1'b0;
        if( r1_valid ) begin  // protecting from underflow
          f_rdreq[1] <= 1'b1;
        end else begin
          f_rdreq[1] <= 1'b0;
        end
      end else begin
        if( r0_valid ) begin  // protecting from underflow
          f_rdreq[0] <= 1'b1;
        end else begin
          f_rdreq[0] <= 1'b0;
        end
        f_rdreq[1] <= 1'b0;
      end
    end
    3'b100: begin
      if( r2_valid ) begin  // protecting from underflow
        f_rdreq[0] <= 1'b1;
        f_rdreq[1] <= 1'b1;
      end else begin
        f_rdreq[0] <= 1'b0;
        f_rdreq[1] <= 1'b0;
      end
    end
    default: begin
      f_rdreq[0] <= 1'b0;
      f_rdreq[1] <= 1'b0;
    end
  endcase

  if( rd_ptr ) begin
    od0[WIDTH-1:0] <= f_rddata[1][WIDTH-1:0];
    od1[WIDTH-1:0] <= f_rddata[0][WIDTH-1:0];
  end else begin
    od0[WIDTH-1:0] <= f_rddata[0][WIDTH-1:0];
    od1[WIDTH-1:0] <= f_rddata[1][WIDTH-1:0];
  end
end

always_ff @(posedge clk) begin
  if( ~nrst ) begin
    rd_ptr = 1'b0;
  end else begin
    if( rd_ptr ) begin
      if( rdreq[2:0] == 3'b010 && r1_valid ) begin
        rd_ptr = ~rd_ptr;
      end
    end else begin
      if( rdreq[2:0] == 3'b010 && r0_valid ) begin
        rd_ptr = ~rd_ptr;
      end
    end
  end // nrst
end

// internal FIFOs itself =======================================================

  logic [1:0][USED_W-2:0] f_usedw_i;
  logic [1:0][USED_W-1:0] f_usedw;

  scfifo #(
    .LPM_WIDTH( WIDTH ),
    .LPM_NUMWORDS( DEPTH/2 ),   // must be at least 4
    .LPM_WIDTHU( USED_W-1 ),
    .LPM_SHOWAHEAD( "ON" ),
    .UNDERFLOW_CHECKING( "ON" ),
    .OVERFLOW_CHECKING( "ON" ),
    .ENABLE_ECC( "FALSE" ),
    .ALLOW_RWCYCLE_WHEN_FULL( "ON" ),
    .USE_EAB( "ON" )
  ) internal_fifo0 (
    .clock( clk ),
    .aclr( 1'b0 ),
    .sclr( ~nrst ),

    .data( f_wrdata[0][WIDTH-1:0] ),
    .wrreq( f_wrreq[0] ),
    .rdreq( f_rdreq[0] ),

    .q( f_rddata[0][WIDTH-1:0] ),
    .empty( empty[0] ),
    .full( full[0] ),
    .usedw( f_usedw_i[0][USED_W-2:0] )
  );

  scfifo #(
    .LPM_WIDTH( WIDTH ),
    .LPM_NUMWORDS( DEPTH/2 ),   // must be at least 4
    .LPM_WIDTHU( USED_W-1 ),
    .LPM_SHOWAHEAD( "ON" ),
    .UNDERFLOW_CHECKING( "ON" ),
    .OVERFLOW_CHECKING( "ON" ),
    .ENABLE_ECC( "FALSE" ),
    .ALLOW_RWCYCLE_WHEN_FULL( "ON" ),
    .USE_EAB( "ON" )
  ) internal_fifo1 (
    .clock( clk ),
    .aclr( 1'b0 ),
    .sclr( ~nrst ),

    .data( f_wrdata[1][WIDTH-1:0] ),
    .wrreq( f_wrreq[1] ),
    .rdreq( f_rdreq[1] ),

    .q( f_rddata[1][WIDTH-1:0] ),
    .empty( empty[1] ),
    .full( full[1] ),
    .usedw( f_usedw_i[1][USED_W-2:0] )
  );

  always_comb begin
    f_usedw[0][USED_W-1:0] = ( full[0] )?
                             ( 1<<(USED_W-1) ):
                             ( {1'b0,f_usedw_i[0][USED_W-2:0]} );
    f_usedw[1][USED_W-1:0] = ( full[1] )?
                             ( 1<<(USED_W-1) ):
                             ( {1'b0,f_usedw_i[1][USED_W-2:0]} );
    usedw[USED_W:0] = f_usedw[0][USED_W-1:0] + f_usedw[1][USED_W-1:0];
  end

endmodule


