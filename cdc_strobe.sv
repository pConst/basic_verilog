//------------------------------------------------------------------------------
// cdc_strobe.sv
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// Clock crossing setup for single-pulse strobes
// Strobes could trigger transfers of almost-static data between clock doamins
//
// -  Maximum input strobe rate is every second clk1 clock cycle
//
// -  Input strobe may span several clock cycles, but it will be considered one
//    event and only one single-cycle strobe will be generated to the output
//
// -  When clk2 is essentially less than clk1 it is possible that strb2 will
//    remain HIGH for several consecutive clk2 cycles. On the output every
//    HIGH cycle should be considered as a separate strobe event
//
// -  When clk2 is essentially less than clk1 - output strobes could even
//    "overlap" or miss. In this case, please restrict input strobe event rate
//
// -  cdc_strobe module features a 2 clock cycles propagation delay
//
//
//
// False_path constraint is required from all nodes with "_FP_ATTR" suffix
//
// For Quartus:
// set_false_path -from [get_registers {*_FP_ATTR*}]
//
// For Vivado:
// set_false_path -from [get_cells -hier -filter {NAME =~ *_FP_ATTR*}]
//


/* --- INSTANTIATION TEMPLATE BEGIN ---

cdc_strobe cdc_wr_req (
  .arst( 1'b0 ),

  .clk1( clk1 ),
  .nrst1( 1'b1 ),
  .strb1( wr_req_clk1 ),

  .clk2( {8{clk2}} ),
  .nrst2( 1'b1 ),
  .strb2( wr_req_clk2 )
);

--- INSTANTIATION TEMPLATE END ---*/


module cdc_strobe (
  input arst,         // async reset

  input clk1,         // clock domain 1 clock
  input nrst1,        // clock domain 1 reset (inversed)
  input strb1,        // clock domain 1 strobe

  input clk2,         // clock domain 2 clock
  input nrst2,        // clock domain 2 reset (inversed)
  output strb2        // clock domain 2 strobe
);

  // buffering strb1
  logic strb1_b = 1'b0;
  always @(posedge clk1 or posedge arst) begin
    if( arst ) begin
      strb1_b <= '0;
    end else if( ~nrst1 ) begin  // Quartus demands to split these if conditions
      strb1_b <= '0;
    end else begin
      strb1_b <= strb1;
    end
  end

  // strb1 edge detector
  // prevents secondary strobe generation in case strb1 is not one-cycle-high
  logic strb1_ed;
  assign strb1_ed = ( ~strb1_b && strb1 );

  // 2 bit gray counter, it must NEVER be reset
  logic [1:0] gc_FP_ATTR = '0;
  always @(posedge clk1 or posedge arst) begin
    if( arst ) begin
      // nop
    end else begin
      if( strb1_ed ) begin
        gc_FP_ATTR[1:0] <= {gc_FP_ATTR[0],~gc_FP_ATTR[1]}; // incrementing counter
      end
    end
  end

  // buffering counter value on clk2
  // gray counter doesnt need a synchronizer
  logic [1:0][1:0] gc_b = '0;
  always @(posedge clk2 or posedge arst) begin
    if( arst ) begin
      gc_b[1:0] <= {2{gc_FP_ATTR[1:0]}};
    end else if( ~nrst2 ) begin  // Quartus demands to split these if conditions
      gc_b[1:0] <= {2{gc_FP_ATTR[1:0]}};
    end else begin
      gc_b[1:0] <= {gc_b[0],gc_FP_ATTR[1:0]}; // shifting left
    end
  end

  // gray_bit_b edge detector
  assign strb2 = ( gc_b[1][1:0] != gc_b[0][1:0] );


endmodule

