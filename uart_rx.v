//------------------------------------------------------------------------------
// uart_rx.v
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
//  Straightforward yet simple UART receiver implementation
//    for FPGA written in Verilog
//
//  Expects at least one stop bit
//  Features continuous data aquisition at BAUD levels up to CLK_HZ / 2
//  Features early asynchronous 'busy' reset
//
//  see also "uart_rx.sv" for equivalent SystemVerilog version
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

uart_rx #(
  .CLK_HZ( 200_000_000 ),  // in Hertz
  .BAUD( 9600 )            // max. BAUD is CLK_HZ / 2
)(
  .clk(  ),
  .nrst(  ),

  .rx_data(  ),
  .rx_done(  ),
  .rxd(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module uart_rx #( parameter
  CLK_HZ = 200_000_000,
  BAUD = 9600,
  bit [15:0] BAUD_DIVISOR_2 = CLK_HZ / BAUD / 2
)(
  input clk,
  input nrst,

  output reg [7:0] rx_data = 0,
  output reg rx_busy = 1'b0,
  output rx_done,  // read strobe
  output rx_err,
  input rxd
);


// synchronizing external rxd pin to avoid metastability
wire rxd_s;
delay #(
  .LENGTH( 2 ),
  .WIDTH( 1 )
) rxd_synch (
  .clk( clk ),
  .nrst( nrst ),
  .ena( 1'b1 ),
  .in( rxd ),
  .out( rxd_s )
);


wire start_bit_strobe;
edge_detect rxd_fall_detector (
  .clk( clk ),
  .anrst( nrst ),
  .in( rxd_s ),
  .falling( start_bit_strobe )
);


reg [15:0] rx_sample_cntr = (BAUD_DIVISOR_2 - 1'b1);

wire rx_do_sample;
assign rx_do_sample = (rx_sample_cntr[15:0] == 1'b0);


// {rx_data[7:0],rx_data_9th_bit} is actually a shift register
reg rx_data_9th_bit = 1'b0;
always @ (posedge clk) begin
  if( ~nrst ) begin
    rx_busy <= 1'b0;
    rx_sample_cntr <= (BAUD_DIVISOR_2 - 1'b1);
    {rx_data[7:0],rx_data_9th_bit} <= 0;
  end else begin
    if( ~rx_busy ) begin
      if( start_bit_strobe ) begin

        // wait for 1,5-bit period till next sample
        rx_sample_cntr[15:0] <= (BAUD_DIVISOR_2 * 3 - 1'b1);
        rx_busy <= 1'b1;
        {rx_data[7:0],rx_data_9th_bit} <= 9'b10000000_0;

      end
    end else begin

      if( rx_sample_cntr[15:0] == 0 ) begin
        // wait for 1-bit-period till next sample
        rx_sample_cntr[15:0] <= (BAUD_DIVISOR_2 * 2 - 1'b1);
      end else begin
        // counting and sampling only when 'busy'
        rx_sample_cntr[15:0] <= rx_sample_cntr[15:0] - 1'b1;
      end

      if( rx_do_sample ) begin
        if( rx_data_9th_bit == 1'b1 ) begin
          // early asynchronous 'busy' reset
          rx_busy <= 1'b0;
        end else begin
          {rx_data[7:0],rx_data_9th_bit} <= {rxd_s, rx_data[7:0]};
        end
      end

    end // ~rx_busy
  end // ~nrst
end

always @* begin
  // rx_done and rx_busy fall simultaneously
  rx_done <= rx_data_9th_bit && rx_do_sample && rxd_s;
  rx_err <= rx_data_9th_bit && rx_do_sample && ~rxd_s;
end

endmodule

