//------------------------------------------------------------------------------
// udp_packet.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// A simple hardcoded UDP packet generator
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

udp_packet #(
  .MODE( "BYTES" )  // "BYTES" or "NIBBLES"
) UP1 (
  .clk( clk ),
  .nrst( nrst ),

  .tx_en(  ),
  .od(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module udp_packet #( parameter
  MODE = "BYTES"  // "BYTES" or "NIBBLES"
)(
  input clk,
  input nrst,

  output logic tx_en = 1'b0,
  output logic [7:0] od = '0
);


  logic [15:0] seq_cntr = '0;
  logic nibble_high = 1'b0;

  logic [7:0] data_byte;

  // tx_en and od signals are late one cycle after their respective seq_cntr[]
  always_ff @(posedge clk) begin
    if( ~nrst ) begin
      tx_en = 1'b0;
      od[7:0] = '0;

      seq_cntr[15:0] <= '0;
      nibble_high <= 1'b0;
    end else begin
      if ( MODE == "BYTES" ) begin
        tx_en <= ( (seq_cntr[15:0] >=0) &&
                   (seq_cntr[15:0] <72) );

        od[7:0] <= data_byte[7:0];

        if (seq_cntr[15:0] == 255 ) begin
          // sequence reset
          seq_cntr[15:0] <= '0;
        end else begin
          seq_cntr[15:0] <= seq_cntr[15:0] + 1'b1;
        end
      end else begin
        tx_en <= ( (seq_cntr[15:0] >=0) &&
                   (seq_cntr[15:0] <72) );

        if( nibble_high ) begin
          od[7:0] <= {4'h0,data_byte[3:0]};

          if (seq_cntr[15:0] == 127 ) begin
            // sequence reset
            seq_cntr[15:0] <= '0;
          end else begin
            seq_cntr[15:0] <= seq_cntr[15:0] + 1'b1;
          end
        end else begin
          od[7:0] <= {4'h0,data_byte[7:4]};
        end // if

        nibble_high <= !nibble_high;
      end // if
    end
  end


  always_comb begin
    case ( seq_cntr[15:0] )
      // Sending the preambule and asserting tx_en
      0 : data_byte[7:0] <= 8'h55;
      1 : data_byte[7:0] <= 8'h55;
      2 : data_byte[7:0] <= 8'h55;
      3 : data_byte[7:0] <= 8'h55;
      4 : data_byte[7:0] <= 8'h55;
      5 : data_byte[7:0] <= 8'h55;
      6 : data_byte[7:0] <= 8'h55;
      7 : data_byte[7:0] <= 8'hd5;

      // Sending the UDP/IP-packet itself
      8 : data_byte[7:0] <= 8'hd8;
      9 : data_byte[7:0] <= 8'hd3;
      10: data_byte[7:0] <= 8'h85;
      11: data_byte[7:0] <= 8'h26;
      12: data_byte[7:0] <= 8'hc5;
      13: data_byte[7:0] <= 8'h78;
      14: data_byte[7:0] <= 8'h00;
      15: data_byte[7:0] <= 8'h23;

      16: data_byte[7:0] <= 8'h54;
      17: data_byte[7:0] <= 8'h3c;
      18: data_byte[7:0] <= 8'h47;
      19: data_byte[7:0] <= 8'h1b;
      20: data_byte[7:0] <= 8'h08;
      21: data_byte[7:0] <= 8'h00;
      22: data_byte[7:0] <= 8'h45;
      23: data_byte[7:0] <= 8'h00;

      24: data_byte[7:0] <= 8'h00;
      25: data_byte[7:0] <= 8'h2e;
      26: data_byte[7:0] <= 8'h00;
      27: data_byte[7:0] <= 8'h00;
      28: data_byte[7:0] <= 8'h00;
      29: data_byte[7:0] <= 8'h00;
      30: data_byte[7:0] <= 8'hc8;
      31: data_byte[7:0] <= 8'h11;

      32: data_byte[7:0] <= 8'hd6;
      33: data_byte[7:0] <= 8'h73;
      34: data_byte[7:0] <= 8'hc0;
      35: data_byte[7:0] <= 8'ha8;
      36: data_byte[7:0] <= 8'h4d;
      37: data_byte[7:0] <= 8'h21;
      38: data_byte[7:0] <= 8'hc0;
      39: data_byte[7:0] <= 8'ha8;

      40: data_byte[7:0] <= 8'h4d;
      41: data_byte[7:0] <= 8'hd9;
      42: data_byte[7:0] <= 8'hc3;
      43: data_byte[7:0] <= 8'h50;
      44: data_byte[7:0] <= 8'hc3;
      45: data_byte[7:0] <= 8'h60;
      46: data_byte[7:0] <= 8'h00;
      47: data_byte[7:0] <= 8'h1a;

      48: data_byte[7:0] <= 8'h00;
      49: data_byte[7:0] <= 8'h00;
      50: data_byte[7:0] <= 8'h01;
      51: data_byte[7:0] <= 8'h02;
      52: data_byte[7:0] <= 8'h03;
      53: data_byte[7:0] <= 8'h04;
      54: data_byte[7:0] <= 8'h01;
      55: data_byte[7:0] <= 8'h01;

      56: data_byte[7:0] <= 8'h01;
      57: data_byte[7:0] <= 8'h01;
      58: data_byte[7:0] <= 8'h01;
      59: data_byte[7:0] <= 8'h01;
      60: data_byte[7:0] <= 8'h01;
      61: data_byte[7:0] <= 8'h01;
      62: data_byte[7:0] <= 8'h01;
      63: data_byte[7:0] <= 8'h01;

      64: data_byte[7:0] <= 8'h01;
      65: data_byte[7:0] <= 8'h01;
      66: data_byte[7:0] <= 8'h01;
      67: data_byte[7:0] <= 8'h01;

      // CRC32 checksum
      68: data_byte[7:0] <= 8'he3;
      69: data_byte[7:0] <= 8'h8e;
      70: data_byte[7:0] <= 8'hdf;
      71: data_byte[7:0] <= 8'h1f;

      default: data_byte[7:0] <= '0; // pause
    endcase

  end

endmodule

