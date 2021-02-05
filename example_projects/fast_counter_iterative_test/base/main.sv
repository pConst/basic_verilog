
// Fast counter test project
// Konstantin Pavlov, pavlovconst@gmail.com


`include "define.vh"

module main(

  input clk1,
  input nrst1,

  input set1,
  input [`WIDTH-1:0] set_val1,
  input dec1,

  output logic q_is_zero1 = 1'b0,


  input clk2,
  input nrst2,

  input set2,
  input [`WIDTH-1:0] set_val2,
  input dec2,

  output logic q_is_zero2 = 1'b0
);


logic [`WIDTH-1:0] std_cntr = '0;
always_ff @(posedge clk1) begin
  if( set1 || nrst1 ) begin
    std_cntr[`WIDTH-1:0] <= set_val1[`WIDTH-1:0];
  end else if( dec1 ) begin
    std_cntr[`WIDTH-1:0] <= std_cntr[`WIDTH-1:0] - 1'b1;
  end
end

//registering all outputs
always_ff @(posedge clk1) begin
  if( ~nrst1 ) begin
    q_is_zero1 <= 1'b0;
  end else begin
    q_is_zero1 <= (std_cntr[`WIDTH-1:0] == '0);
  end
end


logic qz;
fast_counter #(
  .WIDTH( `WIDTH )
) fc (
  .clk( clk2 ),

  .set( set2 || nrst2 ),
  .set_val( set_val2 ),
  .dec( dec2 ),
  // no value output
  .q_is_zero( qz )
);

//registering all outputs
always_ff @(posedge clk1) begin
  if( ~nrst2 ) begin
    q_is_zero2 <= 1'b0;
  end else begin
    q_is_zero2 <= qz;
  end
end


endmodule
