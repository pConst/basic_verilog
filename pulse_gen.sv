//--------------------------------------------------------------------------------
// pulse_gen.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
// Pulse generator module
// generates one or many pulses of given wigth
// low_wdth[] and high_wdth[] must NOT be 0

// CAUTION:
// - low_wdth[], high_wdth[] and rpt inputs are NOT buffered, so could be changed
//   interactively while pulse_gen is already performing
//   This could be beneficial for implementing PWM-like genetators with
//   variating parameters


/* --- INSTANTIATION TEMPLATE BEGIN ---

pulse_gen #(
  .CNTR_WIDTH( 32 )
) pg1 (
  .clk( clk ),
  .nrst( nrst ),
  .low_width( 2 ),
  .high_width( 2 ),
  .rpt( 1'b0 ),
  .start( 1'b1 ),
  .busy(  ),
  .out(  )
);

--- INSTANTIATION TEMPLATE END ---*/

module pulse_gen #( parameter
  CNTR_WIDTH = 32
)(

  input clk,
  input nrst,

  input [CNTR_WIDTH-1:0] low_width,
  input [CNTR_WIDTH-1:0] high_width,
  input rpt,

  input start,                  // only first front matters
  output busy,
  output logic out = 1'b0
);

logic [CNTR_WIDTH-1:0] cnt_low = '0;
logic [CNTR_WIDTH-1:0] cnt_high = '0;

enum logic [1:0] {IDLE,LOW,HIGH} gen_state;

always_ff @(posedge clk) begin
  if( ~nrst ) begin
    out = 1'b0;

    gen_state[1:0] <= IDLE;

    cnt_low[CNTR_WIDTH-1:0] <= '0;
    cnt_high[CNTR_WIDTH-1:0] <= '0;
  end else begin

    case( gen_state[1:0] )
      IDLE: begin
        if( start ) begin
          out <= 1'b0;
          // latching first pulse widths here
          if( low_width[CNTR_WIDTH-1:0] != '0) begin
            cnt_low[CNTR_WIDTH-1:0] <= low_width[CNTR_WIDTH-1:0] - 1'b1;
          end else begin
            cnt_low[CNTR_WIDTH-1:0] <= '0;
          end
          if( high_width[CNTR_WIDTH-1:0] != '0) begin
            cnt_high[CNTR_WIDTH-1:0] <= high_width[CNTR_WIDTH-1:0] - 1'b1;
          end else begin
            cnt_high[31:0] <= '0;
          end
          gen_state[1:0] <= LOW;
        end
      end // IDLE

      LOW: begin
        if( cnt_low[CNTR_WIDTH-1:0] != 0 ) begin
          out <= 1'b0;
          cnt_low[CNTR_WIDTH-1:0] <= cnt_low[CNTR_WIDTH-1:0] - 1'b1;
        end else begin
          out <= 1'b1;
          gen_state[1:0] <= HIGH;
        end
      end // LOW

      HIGH: begin
        if( cnt_high[CNTR_WIDTH-1:0] != 0 ) begin
          out <= 1'b1;
          cnt_high[CNTR_WIDTH-1:0] <= cnt_high[CNTR_WIDTH-1:0] - 1'b1;
        end else begin
          out <= 1'b0;
          if( rpt ) begin
            // latching repetitive pulse widths here
            if( low_width[CNTR_WIDTH-1:0] != '0) begin
              cnt_low[CNTR_WIDTH-1:0] <= low_width[CNTR_WIDTH-1:0] - 1'b1;
            end else begin
              cnt_low[CNTR_WIDTH-1:0] <= '0;
            end
            if( high_width[CNTR_WIDTH-1:0] != '0) begin
              cnt_high[CNTR_WIDTH-1:0] <= high_width[CNTR_WIDTH-1:0] - 1'b1;
            end else begin
              cnt_high[CNTR_WIDTH-1:0] <= '0;
            end
            gen_state[1:0] <= LOW;
          end else begin
            gen_state[1:0] <= IDLE;
          end
        end
      end // HIGH

      default: gen_state[1:0] <= IDLE;
    endcase // gen_state

  end // nrst
end

assign busy = (gen_state[1:0] != IDLE);


endmodule

