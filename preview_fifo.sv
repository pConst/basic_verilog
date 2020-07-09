//------------------------------------------------------------------------------
// preview_fifo.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// module performs just like an ordinany FIFO in show-ahead mode
// the diffenence is that 0,1 or 2 words may be requested at once
// reader can also "preview" future fifo elements without actually fetching it


/* --- INSTANTIATION TEMPLATE BEGIN ---

preview_fifo #( parameter
  .WIDTH( 16 ),
  .DEPTH( 16 ),
) pf (
  .clk( clk ),
  .nrst( nrst ),

  // input port
  .wrreq(  ),
  .ena(  ),
  .id0(  ),
  .id1(  ),

  // output port
  .valid(  ),
  .shift_req_oh(  ),
  .od(  ),
  .od(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module preview_fifo #( parameter
  WIDTH = 32,
  DEPTH = 16,                     // should be power of 2

  USED_W = $clog2(DEPTH)
)(
  input clk,
  input nrst,

  // input port
  output wrreq,                   // request to make a write
  input ena,                      // write data to fifo command
  input [WIDTH-1:0] id0,          // preceding data word
  input [WIDTH-1:0] id1,          // subsequent data word
                                  // both data words are written simultaneously

  // output port
  output valid,                   // data outputs have valid data
  input [2:0] shift_req_oh,       // 3'b001 - no shift
                                  // 3'b010 - shift one word
                                  // 3'b100 - shift two words at once
  output logic [WIDTH-1:0] od0,   // first data word (preceding)
  output logic [WIDTH-1:0] od1,   // seconfd dadta word (subsequent)


  // debug ports
  output logic fail = 1'b0
);


// pointer to the first data word
logic ptr = 1'b0;

logic [WIDTH-1:0] fifo_d0;
logic [WIDTH-1:0] fifo_d1;

logic rdreq0 = 1'b0;
logic rdreq1 = 1'b0;

logic empty0;
logic empty1;

logic full0;
logic full1;

// usedw0[] == usedw1[] OR usedw0[] == (usedw1[]-1) combinations are possible
logic [USED_W-1:0] usedw0;
logic [USED_W-1:0] usedw1;

scfifo #(
  .LPM_WIDTH( WIDTH ),
  .LPM_NUMWORDS( DEPTH ),
  .LPM_WIDTHU( USED_W ),
  .LPM_SHOWAHEAD( "ON" ),
  .UNDERFLOW_CHECKING( "ON" ),
  .OVERFLOW_CHECKING( "ON" ),
  .ALMOST_FULL_VALUE( DEPTH-4 ),
  .ALMOST_EMPTY_VALUE( 0+4 ),
  .ENABLE_ECC( "FALSE" ),
  .ALLOW_RWCYCLE_WHEN_FULL( "ON" ),
  .USE_EAB( "ON" ),
  .MAXIMIZE_SPEED( 5 ),
  .DEVICE_FAMILY( "Cyclone V" )
) internal_fifo0 (
  .clock( clk ),
  .aclr( 1'b0 ),
  .sclr( ~nrst ),

  .data( id0[WIDTH-1:0] ),
  .wrreq( ena ),
  .rdreq( rdreq0 ),

  .q( fifo_d0[WIDTH-1:0] ),
  .empty( empty0 ),
  .full( full0 ),
  .almost_full(  ),
  .almost_empty(  ),
  .usedw( usedw0[USED_W-1:0] ),
  .eccstatus(  )  // [1:0]
);

scfifo #(
  .LPM_WIDTH( WIDTH ),
  .LPM_NUMWORDS( DEPTH ),
  .LPM_WIDTHU( USED_W ),
  .LPM_SHOWAHEAD( "ON" ),
  .UNDERFLOW_CHECKING( "ON" ),
  .OVERFLOW_CHECKING( "ON" ),
  .ALMOST_FULL_VALUE( DEPTH-4 ),
  .ALMOST_EMPTY_VALUE( 0+4 ),
  .ENABLE_ECC( "FALSE" ),
  .ALLOW_RWCYCLE_WHEN_FULL( "ON" ),
  .USE_EAB( "ON" ),
  .MAXIMIZE_SPEED( 5 ),
  .DEVICE_FAMILY( "Cyclone V" )
) internal_fifo1 (
  .clock( clk ),
  .aclr( 1'b0 ),
  .sclr( ~nrst ),

  .data( id1[WIDTH-1:0] ),
  .wrreq( ena ),
  .rdreq( rdreq1 ),

  .q( fifo_d1[WIDTH-1:0] ),
  .empty( empty1 ),
  .full( full1 ),
  .almost_full(  ),
  .almost_empty(  ),
  .usedw( usedw1[USED_W-1:0] ),
  .eccstatus(  )  // [1:0]
);


always_ff @(posedge clk) begin
  if( ~nrst ) begin
    ptr <= 1'b0;
    fail <= 1'b0;
  end else begin
    if( ptr ) begin  // d1 fifo has one extra unaligned word
      case( shift_req_oh[2:0] )
        3'b010: begin
          ptr <= ~ptr;
          od0[WIDTH-1:0] <= od1[WIDTH-1:0];
          od1[WIDTH-1:0] <= fifo_d1[WIDTH-1:0];
          rdreq0 = 1'b0;
          rdreq1 = 1'b1;
        end
        3'b100: begin
          //ptr <= ptr;
          od0[WIDTH-1:0] <= fifo_d0[WIDTH-1:0];
          od1[WIDTH-1:0] <= fifo_d1[WIDTH-1:0];
          rdreq0 = 1'b1;
          rdreq1 = 1'b1;
        end
        default: ; // do nothing
      endcase
    end else begin  // aligned data
      unique case( shift_req_oh[2:0] )
        3'b010: begin
          ptr <= ~ptr;
          od0[WIDTH-1:0] <= od1[WIDTH-1:0];
          od1[WIDTH-1:0] <= fifo_d0[WIDTH-1:0];
          rdreq0 = 1'b1;
          rdreq1 = 1'b0;
        end
        3'b100: begin
          //ptr <= ptr;
          od0[WIDTH-1:0] <= fifo_d1[WIDTH-1:0];
          od1[WIDTH-1:0] <= fifo_d0[WIDTH-1:0];
          rdreq0 = 1'b1;
          rdreq1 = 1'b1;
        end
        default: ; // do nothing
      endcase
    end // if

    if( |shift_req_oh[2:1] && empty0 ) begin
      fail <= 1'b1;
    end

  end // ~nrst
end

// valid is when both output ports show valid data
assign valid = ~empty1;

// extra cycles for request and data propagation
assign wrreq = (usedw0[USED_W-1:0] < (DEPTH-4));

endmodule