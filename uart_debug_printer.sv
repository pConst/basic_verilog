//------------------------------------------------------------------------------
// uart_debug_printer.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Debug data printer to UART terminal
// This particular module prints out one R/W bit and two 32-bit words in HEX format
// Could be easily adapted for other data formats
//
// Features:
//  - fifo-like input interface
//  - built-in UART transmitter
//  - compatible with all sorts of UART-to-USB dongles
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

uart_debug_printer #(
  .CLK_HZ( 100_000_000 ),
  .BAUD( 115200 )
) UP (
  .clk(  ),
  .anrst(  ),

  .empty(  ),
  .r_req(  ),
  .r_rnw(  ),   // fifo data, 1 bit
  .r_addr(  ),  // fifo data, 32 bit
  .r_data(  ),  // fifo data, 32 bit

  .uart_txd(  )
);

--- INSTANTIATION TEMPLATE END ---*/


// synopsys translate_off
`define SIMULATION yes
// synopsys translate_on

module uart_debug_printer #( parameter
  CLK_HZ = 100_000_000,
  BAUD = 115200
)(
  input clk,    // clock 100MHz
  input anrst,  // async reset

  // fifo output
  input empty,                // data valid flag
  output logic r_req = 1'b0,  // data request acknowledge
  input r_rnw,                // read/nwrite bit
  input [31:0] r_addr,        // first 32 bit word
  input [31:0] r_data,        // second 32 bit word

  // UART TX
  output uart_txd             // UART tx pin
);

  logic tx_start = 1'b0;
  logic tx_busy;

  // character sequencer
  logic [7:0] seq_cntr = '0;
  logic [7:0] tx_char = '0;
  always_ff @( posedge clk or negedge anrst ) begin
    if ( ~anrst ) begin
      r_req = 1'b0;
      tx_start = 1'b0;

      seq_cntr[7:0] <= '0;
      tx_char[7:0] <= '0;
    end else begin
      case ( seq_cntr[7:0] )

        8'd0: begin
          if( ~empty && ~tx_busy ) begin
            tx_char[7:0] <= (r_rnw)?(8'd82):(8'd87); //  "R"/"W" symbol
            seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
            tx_start <= 1'b1;
          end else begin
            tx_start <= 1'b0;
          end
        end
        8'd1: begin
          if( ~tx_start && ~tx_busy ) begin
            tx_char[7:0] <= 8'd32; // "_" divider symbol =======================
            seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
            tx_start <= 1'b1;
          end else begin
            tx_start <= 1'b0;
          end
        end


        8'd2: begin
          if( ~tx_start && ~tx_busy ) begin
            tx_char[7:0] <= hex2ascii(r_addr[31:28]);
            seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
            tx_start <= 1'b1;
          end else begin
            tx_start <= 1'b0;
          end
        end
        8'd3: begin
          if( ~tx_start && ~tx_busy ) begin
            tx_char[7:0] <= hex2ascii(r_addr[27:24]);
            seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
            tx_start <= 1'b1;
          end else begin
            tx_start <= 1'b0;
          end
        end
        8'd4: begin
          if( ~tx_start && ~tx_busy ) begin
            tx_char[7:0] <= hex2ascii(r_addr[23:20]);
            seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
            tx_start <= 1'b1;
          end else begin
            tx_start <= 1'b0;
          end
        end
        8'd5: begin
          if( ~tx_start && ~tx_busy ) begin
            tx_char[7:0] <= hex2ascii(r_addr[19:16]);
            seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
            tx_start <= 1'b1;
          end else begin
            tx_start <= 1'b0;
          end
        end
        8'd6: begin
          if( ~tx_start && ~tx_busy ) begin
            tx_char[7:0] <= 8'd95; // "_" symbol
            seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
            tx_start <= 1'b1;
          end else begin
            tx_start <= 1'b0;
          end
        end
        8'd7: begin
          if( ~tx_start && ~tx_busy ) begin
            tx_char[7:0] <= hex2ascii(r_addr[15:12]);
            seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
            tx_start <= 1'b1;
          end else begin
            tx_start <= 1'b0;
          end
        end
        8'd8: begin
          if( ~tx_start && ~tx_busy ) begin
            tx_char[7:0] <= hex2ascii(r_addr[11:8]);
            seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
            tx_start <= 1'b1;
          end else begin
            tx_start <= 1'b0;
          end
        end
        8'd9: begin
          if( ~tx_start && ~tx_busy ) begin
            tx_char[7:0] <= hex2ascii(r_addr[7:4]);
            seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
            tx_start <= 1'b1;
          end else begin
            tx_start <= 1'b0;
          end
        end
        8'd10: begin
          if( ~tx_start && ~tx_busy ) begin
            tx_char[7:0] <= hex2ascii(r_addr[3:0]);
            seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
            tx_start <= 1'b1;
          end else begin
            tx_start <= 1'b0;
          end
        end

        8'd11: begin
          if( ~tx_start && ~tx_busy ) begin
            tx_char[7:0] <= 8'd32; // "-" divider symbol =======================
            seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
            tx_start <= 1'b1;
          end else begin
            tx_start <= 1'b0;
          end
        end

        8'd12: begin
          if( ~tx_start && ~tx_busy ) begin
            tx_char[7:0] <= hex2ascii(r_data[31:28]);
            seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
            tx_start <= 1'b1;
          end else begin
            tx_start <= 1'b0;
          end
        end
        8'd13: begin
          if( ~tx_start && ~tx_busy ) begin
            tx_char[7:0] <= hex2ascii(r_data[27:24]);
            seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
            tx_start <= 1'b1;
          end else begin
            tx_start <= 1'b0;
          end
        end
        8'd14: begin
          if( ~tx_start && ~tx_busy ) begin
            tx_char[7:0] <= hex2ascii(r_data[23:20]);
            seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
            tx_start <= 1'b1;
          end else begin
            tx_start <= 1'b0;
          end
        end
        8'd15: begin
          if( ~tx_start && ~tx_busy ) begin
            tx_char[7:0] <= hex2ascii(r_data[19:16]);
            seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
            tx_start <= 1'b1;
          end else begin
            tx_start <= 1'b0;
          end
        end
        8'd16: begin
          if( ~tx_start && ~tx_busy ) begin
            tx_char[7:0] <= 8'd95; // "_" symbol
            seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
            tx_start <= 1'b1;
          end else begin
            tx_start <= 1'b0;
          end
        end
        8'd17: begin
          if( ~tx_start && ~tx_busy ) begin
            tx_char[7:0] <= hex2ascii(r_data[15:12]);
            seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
            tx_start <= 1'b1;
          end else begin
            tx_start <= 1'b0;
          end
        end
        8'd18: begin
          if( ~tx_start && ~tx_busy ) begin
            tx_char[7:0] <= hex2ascii(r_data[11:8]);
            seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
            tx_start <= 1'b1;
          end else begin
            tx_start <= 1'b0;
          end
        end
        8'd19: begin
          if( ~tx_start && ~tx_busy ) begin
            tx_char[7:0] <= hex2ascii(r_data[7:4]);
            seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
            tx_start <= 1'b1;
          end else begin
            tx_start <= 1'b0;
          end
        end
        8'd20: begin
          if( ~tx_start && ~tx_busy ) begin
            tx_char[7:0] <= hex2ascii(r_data[3:0]);
            seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
            tx_start <= 1'b1;
          end else begin
            tx_start <= 1'b0;
          end
        end

        8'd21: begin
          if( ~tx_start && ~tx_busy ) begin
            tx_char[7:0] <= 8'd13; // "CR" symbol
            seq_cntr[7:0] <= seq_cntr[7:0] + 1'b1;
            r_req <= 1'b1;  // fifo data ack begin
            tx_start <= 1'b1;
          end else begin
            tx_start <= 1'b0;
          end
        end

        8'd22: begin
          if( ~tx_busy ) begin
            tx_start <= 1'b0;
            seq_cntr[7:0] <= '0;
          end
          r_req <= 1'b0;  // fifo data ack end
        end

      default : seq_cntr[7:0] <= '0;
    endcase

    end
  end

  uart_tx #(
`ifdef SIMULATION
    .CLK_HZ( 100 ),
    .BAUD( 10 )
`else
    .CLK_HZ( CLK_HZ ),     // in Hertz
    .BAUD( BAUD )          // max. BAUD is CLK_HZ / 2
`endif
  ) uart_tx_b (
    .clk( clk ),
    .nrst( 1'b1 ),
    //.tx_do_sample(  ),
    .tx_data( tx_char[7:0] ),
    .tx_start( tx_start ),
    .tx_busy( tx_busy ),
    .txd( uart_txd )
  );


  function [7:0] hex2ascii(
    input [3:0] hex
  );
    if( hex[3:0] < 4'hA ) begin
      hex2ascii[7:0] = hex[3:0] + 8'd48; // 0 hex -> 48 ascii
    end else begin
      hex2ascii[7:0] = hex[3:0] + 8'd55; // A hex -> 65 ascii
    end // if
  endfunction

endmodule

