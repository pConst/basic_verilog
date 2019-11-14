//--------------------------------------------------------------------------------
// pulse_stretch.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
// Pulse stretcher/extender module
//   this implementftion uses a simple delay line
//   suits when LENGTH of desired output pulse is low
//   when you need wide output pulses - counter implementation will make sense


/* --- INSTANTIATION TEMPLATE BEGIN ---

pulse_stretch #(
  .LENGTH( 8 )
) ps1 (
  .clk( clk ),
  .nrst( nrst ),
  .in(  ),
  .out(  )
);

--- INSTANTIATION TEMPLATE END ---*/

module pulse_stretch #( parameter
  LENGTH = 8
)(
  input clk,
  input nrst,

  input in,
  output out
);


generate

  if ( LENGTH == 0 ) begin
    assign out = 0;

  end else if( LENGTH == 1 ) begin
    assign out = in;

  end else begin
    logic [LENGTH-1:0] shifter = '0;
    always_ff @(posedge clk) begin
      if( ~nrst ) begin
        shifter[LENGTH-1:0] <= '0;
      end else begin
        shifter[LENGTH-1:0] <= {shifter[LENGTH-2:0],in};
      end // nrst
    end // always

    assign out = |shifter[LENGTH-1:0];

  end // if LENGTH
endgenerate


endmodule

