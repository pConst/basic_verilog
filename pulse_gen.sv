//------------------------------------------------------------------------------
// pulse_gen.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Pulse generator module, ver.2
//
// - generates one or many pulses of given width and period
// - generates constant HIGH, constant LOW, or impulse output
// - features buffered inputs, so inputs can change continiously during pulse period
// - generates LOW when idle
//
// - Pulse period is (cntr_max[]+1) cycles
// - If you need to generate constant LOW pulses, then CNTR_WIDTH should allow
//   setting cntr_low[]>cntr_max[]
//
// Example 1:
//      let CNTR_WIDTH = 8
//      let cntr_max[7:0] = 2^CNTR_WIDTH-2 = 254, pulse period is 255 cycles
//      cntr_low[7:0]==255              then output will be constant LOW
//      0<cntr_low[7:0]<=cntr_max[7:0]  then output will be generating pulse(s)
//      cntr_low[7:0]==0                then output will be constant HIGH
//
// Example 2:
//      let CNTR_WIDTH = 9
//      let cntr_max[8:0] = 255, pulse period is 256 cycles
//      cntr_low[8:0]>255               then output will be constant LOW
//      0<cntr_low[8:0]<=cntr_max[8:0]  then output will be generating pulse(s)
//      cntr_low[8:0]==0                then output will be constant HIGH
//
//      In Example 2 constant LOW state can be acheived also by disabling start
//      condition or holding reset input, so cntr_low[8:0] and cntr_max[8:0]
//      can be left 8-bit-wide actually



/* --- INSTANTIATION TEMPLATE BEGIN ---

pulse_gen #(
  .CNTR_WIDTH( 8 )
) pg1 (
  .clk( clk ),
  .nrst( nrst ),

  .start( 1'b1 ),
  .cntr_max( 255 ),
  .cntr_low( 2 ),

  .pulse_out(  ),

  .start_strobe,
  .busy(  )
);

--- INSTANTIATION TEMPLATE END ---*/

module pulse_gen #( parameter
  CNTR_WIDTH = 32
)(
  input clk,                          // system clock
  input nrst,                         // negative reset

  input start,                        // enables new period start
  input [CNTR_WIDTH-1:0] cntr_max,    // counter initilization value, should be > 0
  input [CNTR_WIDTH-1:0] cntr_low,    // transition to LOW counter value

  output logic pulse_out,                   // active HIGH output

  // status outputs
  output logic start_strobe = 1'b0,
  output busy
);


logic [CNTR_WIDTH-1:0] seq_cntr = '0;

logic seq_cntr_0;
assign seq_cntr_0 = (seq_cntr[CNTR_WIDTH-1:0] == '0);

// delayed one cycle
logic seq_cntr_0_d1;
always_ff @(posedge clk) begin
  if( ~nrst) begin
    seq_cntr_0_d1 <= 0;
  end else begin
    seq_cntr_0_d1 <= seq_cntr_0;
  end
end

// first seq_cntr_0 cycle time belongs to pulse period
// second and further seq_cntr_0 cycles are idle
assign busy = ~(seq_cntr_0 && seq_cntr_0_d1);


// buffering cntr_low untill pulse period is over to allow continiously
//  changing inputs
logic [CNTR_WIDTH-1:0] cntr_low_buf = '0;
always_ff @(posedge clk) begin
  if( ~nrst ) begin
    seq_cntr[CNTR_WIDTH-1:0] <= '0;
    cntr_low_buf[CNTR_WIDTH-1:0] <= '0;
    start_strobe <= 1'b0;
  end else begin
    if( seq_cntr_0 ) begin
      // don`t start if cntr_max[] is illegal value
      if( start && (cntr_max[CNTR_WIDTH-1:0]!='0) ) begin
        seq_cntr[CNTR_WIDTH-1:0] <= cntr_max[CNTR_WIDTH-1:0];
        cntr_low_buf[CNTR_WIDTH-1:0] <= cntr_low[CNTR_WIDTH-1:0];
        start_strobe <= 1'b1;
      end else begin
        start_strobe <= 1'b0;
      end
    end else begin
      seq_cntr[CNTR_WIDTH-1:0] <= seq_cntr[CNTR_WIDTH-1:0] - 1'b1;
      start_strobe <= 1'b0;
    end
  end // ~nrst
end

always_comb begin
  if( ~nrst ) begin
    pulse_out <= 1'b0;
  end else begin
    // busy condition guarantees LOW output when idle
    if( busy &&
        (seq_cntr[CNTR_WIDTH-1:0] >= cntr_low_buf[CNTR_WIDTH-1:0]) ) begin
      pulse_out <= 1'b1;
    end else begin
      pulse_out <= 1'b0;
    end
  end // ~nrst
end


endmodule

