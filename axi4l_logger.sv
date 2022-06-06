//------------------------------------------------------------------------------
// axi4l_logger.sv
// published as part of https://github.com/pConst/basic_verilog
// Konstantin Pavlov, pavlovconst@gmail.com
//------------------------------------------------------------------------------

// INFO ------------------------------------------------------------------------
// AXI4-Lite logger
// Sniffs all AXI transactions and stores address and data to fifo
//
// - optimized for `AXI_ADDR_WIDTH = 32 and `AXI_DATA_WIDTH = 32
//

/* --- INSTANTIATION TEMPLATE BEGIN ---

axi4l_logger AL (
  .clk_axi(  ),
  .anrst_axi(  ),

  // axi interface here

  .clk(  ),

  .empty(  )
  .r_req(  ),
  .r_rnw(  ),
  .r_addr(  ),
  .r_data(  )
);

--- INSTANTIATION TEMPLATE END ---*/


module axi4l_logger #( parameter
  bit [`AXI_ADDR_WIDTH-1:0] REG_ADDRESS_FROM = '0, // register address
  bit [`AXI_ADDR_WIDTH-1:0] REG_ADDRESS_TO = '1    //   space to log
)(
  input clk_axi,      // axi clock
  input anrst_axi,    // axi async reset (inversed)

  input [`AXI_ADDR_WIDTH-1:0]        s_axi_araddr,         // axil
  input [1:0]                        s_axi_arburst,
  input [3:0]                        s_axi_arcache,
  input [`AXI_LEN_WIDTH-1:0]         s_axi_arlen,
  input [0:0]                        s_axi_arlock,
  input [2:0]                        s_axi_arprot,         // axil // NU here
  input [3:0]                        s_axi_arqos,
  input                              s_axi_arready,        // axil
  input [3:0]                        s_axi_arregion,
  input [`AXI_SIZE_WIDTH-1:0]        s_axi_arsize,
  input                              s_axi_arvalid,        // axil

  input [`AXI_ADDR_WIDTH-1:0]        s_axi_awaddr,         // axil
  input [1:0]                        s_axi_awburst,
  input [3:0]                        s_axi_awcache,
  input [`AXI_LEN_WIDTH-1:0]         s_axi_awlen,
  input [0:0]                        s_axi_awlock,
  input [2:0]                        s_axi_awprot,         // axil // NU here
  input [3:0]                        s_axi_awqos,
  input                              s_axi_awready,        // axil
  input [3:0]                        s_axi_awregion,
  input [`AXI_SIZE_WIDTH-1:0]        s_axi_awsize,
  input                              s_axi_awvalid,        // axil

  input                              s_axi_bready,         // axil
  input [1:0]                        s_axi_bresp,          // axil
  input                              s_axi_bvalid,         // axil

  input [`AXI_DATA_WIDTH-1:0]        s_axi_rdata,          // axil
  input                              s_axi_rlast,
  input                              s_axi_rready,         // axil
  input [1:0]                        s_axi_rresp,          // axil
  input                              s_axi_rvalid,         // axil

  input [`AXI_DATA_WIDTH-1:0]        s_axi_wdata,          // axil
  input                              s_axi_wlast,
  input                              s_axi_wready,         // axil
  input [`AXI_DATA_BYTES-1:0]        s_axi_wstrb,          // axil
  input                              s_axi_wvalid,         // axil

  // fifo output interface
  input clk,
  output empty,
  input r_req,

  output r_rnw,
  output [`AXI_ADDR_WIDTH-1:0] r_addr,
  output [`AXI_DATA_WIDTH-1:0] r_data
);


  logic aw_w_req;   // axi addr write request
  logic ar_w_req;   // axi addr read request

  logic aw_w_req_d1;
  logic ar_w_req_d1;
  always_ff @( posedge clk_axi or negedge anrst_axi ) begin
    if( ~anrst_axi ) begin
      aw_w_req_d1 <= 1'b0;
      ar_w_req_d1 <= 1'b0;
    end else begin
      aw_w_req_d1 <= aw_w_req;
      ar_w_req_d1 <= ar_w_req;
    end
  end


// WRITE =======================================================================

  logic aw_en = 1'b1;
  always_ff @( posedge clk_axi or negedge anrst_axi ) begin
    if ( ~anrst_axi ) begin
      aw_en <= 1'b1;
    end else begin
      if (~s_axi_awready && s_axi_awvalid && s_axi_wvalid && aw_en) begin
        aw_en <= 1'b0;
      end else if (s_axi_bready && s_axi_bvalid) begin
        aw_en <= 1'b1;
      end
    end
  end

  logic [`AXI_DATA_WIDTH-1:0] s_axi_awaddr_buf = '0;
  always_ff @( posedge clk_axi or negedge anrst_axi ) begin
    if ( ~anrst_axi ) begin
      s_axi_awaddr_buf[`AXI_DATA_WIDTH-1:0] <= '0;
    end else begin
      if (~s_axi_awready && s_axi_awvalid && s_axi_wvalid && aw_en) begin
        s_axi_awaddr_buf[`AXI_DATA_WIDTH-1:0] <= s_axi_awaddr[`AXI_DATA_WIDTH-1:0];
      end
    end
  end

  always_comb begin
    aw_w_req = s_axi_wready && s_axi_wvalid && s_axi_awready && s_axi_awvalid &&
        (s_axi_awaddr_buf[`AXI_ADDR_WIDTH-1:0] >= REG_ADDRESS_FROM[`AXI_ADDR_WIDTH-1:0]) &&
        (s_axi_awaddr_buf[`AXI_ADDR_WIDTH-1:0] <= REG_ADDRESS_TO[`AXI_ADDR_WIDTH-1:0]);
  end


// READ ========================================================================

  logic [`AXI_ADDR_WIDTH-1:0] s_axi_araddr_buf = '0;
  always_ff @( posedge clk_axi or negedge anrst_axi ) begin
    if ( ~anrst_axi ) begin
      s_axi_araddr_buf[`AXI_ADDR_WIDTH-1:0] <= '0;
    end else begin
      if (~s_axi_arready && s_axi_arvalid) begin
        s_axi_araddr_buf[`AXI_ADDR_WIDTH-1:0]  <= s_axi_araddr[`AXI_ADDR_WIDTH-1:0];
      end
    end
  end

  always_comb begin
    ar_w_req = s_axi_arready && s_axi_arvalid && ~s_axi_rvalid &&
      (s_axi_araddr_buf[`AXI_ADDR_WIDTH-1:0] >= REG_ADDRESS_FROM[`AXI_ADDR_WIDTH-1:0]) &&
      (s_axi_araddr_buf[`AXI_ADDR_WIDTH-1:0] <= REG_ADDRESS_TO[`AXI_ADDR_WIDTH-1:0]);
  end


// FIFO ========================================================================

  // fifo inputs
  logic [31:0] w_addr_f;
  logic [31:0] w_data_f;
  logic [31:0] w_rnwr_f;
  logic fifo_wren;

  assign fifo_wren = aw_w_req_d1 || ar_w_req_d1;

  always_comb begin
    if( aw_w_req_d1 ) begin
      w_addr_f[31:0] = s_axi_awaddr_buf[31:0];
      w_data_f[31:0] = s_axi_wdata[31:0];
      w_rnwr_f[31:0] = '0;
    end else if( ar_w_req_d1 ) begin
      w_addr_f[31:0] = s_axi_araddr_buf[31:0];
      w_data_f[31:0] = s_axi_rdata[31:0];
      w_rnwr_f[31:0] = 32'b1;
    end else begin
      w_addr_f[31:0] = '0;
      w_data_f[31:0] = '0;
      w_rnwr_f[31:0] = '0;
    end
  end

  // fifo outputs
  logic [31:0] r_addr_f;
  logic [31:0] r_data_f;
  logic [31:0] r_rnwr_f;


  logic fifo_wren_filt;

  // comment this line to undefine
  `define FILTER_REPETITIVE_READS yes

`ifdef FILTER_REPETITIVE_READS
  logic [31:0] last_w_addr_f;
  logic [31:0] last_w_data_f;
  logic [31:0] last_w_rnwr_f;
  always_ff @( posedge clk_axi or negedge anrst_axi ) begin
    if( ~anrst_axi ) begin
      last_w_addr_f[31:0] <= '0;
      last_w_data_f[31:0] <= '0;
      last_w_rnwr_f[31:0] <= '0;
    end else begin
      if( fifo_wren ) begin
        if( w_rnwr_f ) begin
          // buffering only RD operations
          last_w_addr_f[31:0] <= w_addr_f[31:0];
          last_w_data_f[31:0] <= w_data_f[31:0];
          last_w_rnwr_f[31:0] <= w_rnwr_f[31:0];
        end else begin
          // resetting on WR operations
          last_w_addr_f[31:0] <= '0;
          last_w_data_f[31:0] <= '0;
          last_w_rnwr_f[31:0] <= '0;
        end
      end // fifo_wren

    end
  end

  // filtering out repetitive RD operations where address and data are identical
  assign fifo_wren_filt = fifo_wren &&
                       ~( (last_w_addr_f[31:0] == w_addr_f[31:0]) &&
                          (last_w_data_f[31:0] == w_data_f[31:0]) &&
                          (last_w_rnwr_f[31:0] == w_rnwr_f[31:0]) );
`else
  // no filtering
  assign fifo_wren_filt = fifo_wren;
`endif


  FIFO18E1 #(
    .ALMOST_EMPTY_OFFSET     ( 13'h0006      ), // min. value is 6 for FWFT mode, Sets the almost empty threshold
    .ALMOST_FULL_OFFSET      ( 13'h0005      ), // min. value is 4, Sets almost full threshold
    .DATA_WIDTH              ( 36            ), // Sets data width to 4-36
    .DO_REG                  ( 1             ), // Enable output register ( 1-0 ) Must be 1 if EN_SYN = FALSE
    .EN_SYN                  ( "FALSE"       ), // Specifies FIFO as dual-clock ( FALSE ) or Synchronous ( TRUE )
    .FIFO_MODE               ( "FIFO18_36"   ), // Sets mode to FIFO18 or FIFO18_36
    .FIRST_WORD_FALL_THROUGH ( "TRUE"        ), // Sets the FIFO FWFT to FALSE, TRUE
    .INIT                    ( 36'h000000000 ), // Initial values on output port
    .SIM_DEVICE              ( "7SERIES"     ), // Must be set to "7SERIES" for simulation behavior
    .SRVAL                   ( 36'h000000000 )  // Set/Reset value for output port
   ) addr_fifo_b (
    .RST         ( ~anrst_axi         ), // 1-bit input: Asynchronous Reset
    .RSTREG      ( 1'b0               ), // 1-bit input: Output register set/reset

    .WRCLK       ( clk_axi            ), // 1-bit input: Write clock
    .WREN        ( fifo_wren_filt     ), // 1-bit input: Write enable
    .DI          ( w_addr_f[31:0]     ), // 32-bit input: Data input
    .DIP         ( 4'b0               ), // 4-bit input: Parity input
    .FULL        (                    ), // 1-bit output: Full flag
    .ALMOSTFULL  (                    ), // 1-bit output: Almost full flag
    .WRCOUNT     (                    ), // 12-bit output: Write count
    .WRERR       (                    ), // 1-bit output: Write error

    .RDCLK       ( clk                ), // 1-bit input: Read clock
    .REGCE       ( 1'b1               ), // 1-bit input: Clock enable
    .RDEN        ( r_req              ), // 1-bit input: Read enable
    .DO          ( r_addr_f[31:0]     ), // 32-bit output: Data output
    .DOP         (                    ), // 4-bit output: Parity data output
    .EMPTY       ( empty              ), // 1-bit output: Empty flag
    .ALMOSTEMPTY (                    ), // 1-bit output: Almost empty flag
    .RDCOUNT     (                    ), // 12-bit output: Read count
    .RDERR       (                    )  // 1-bit output: Read error
  );

  FIFO18E1 #(
    .ALMOST_EMPTY_OFFSET     ( 13'h0006      ), // min. value is 6 for FWFT mode, Sets the almost empty threshold
    .ALMOST_FULL_OFFSET      ( 13'h0005      ), // min. value is 4, Sets almost full threshold
    .DATA_WIDTH              ( 36            ), // Sets data width to 4-36
    .DO_REG                  ( 1             ), // Enable output register ( 1-0 ) Must be 1 if EN_SYN = FALSE
    .EN_SYN                  ( "FALSE"       ), // Specifies FIFO as dual-clock ( FALSE ) or Synchronous ( TRUE )
    .FIFO_MODE               ( "FIFO18_36"   ), // Sets mode to FIFO18 or FIFO18_36
    .FIRST_WORD_FALL_THROUGH ( "TRUE"        ), // Sets the FIFO FWFT to FALSE, TRUE
    .INIT                    ( 36'h000000000 ), // Initial values on output port
    .SIM_DEVICE              ( "7SERIES"     ), // Must be set to "7SERIES" for simulation behavior
    .SRVAL                   ( 36'h000000000 )  // Set/Reset value for output port
   ) data_fifo_b (
    .RST         ( ~anrst_axi         ), // 1-bit input: Asynchronous Reset
    .RSTREG      ( 1'b0               ), // 1-bit input: Output register set/reset

    .WRCLK       ( clk_axi            ), // 1-bit input: Write clock
    .WREN        ( fifo_wren_filt     ), // 1-bit input: Write enable
    .DI          ( w_data_f[31:0]     ), // 32-bit input: Data input
    .DIP         ( 4'b0               ), // 4-bit input: Parity input
    .FULL        (                    ), // 1-bit output: Full flag
    .ALMOSTFULL  (                    ), // 1-bit output: Almost full flag
    .WRCOUNT     (                    ), // 12-bit output: Write count
    .WRERR       (                    ), // 1-bit output: Write error

    .RDCLK       ( clk                ), // 1-bit input: Read clock
    .REGCE       ( 1'b1               ), // 1-bit input: Clock enable
    .RDEN        ( r_req              ), // 1-bit input: Read enable
    .DO          ( r_data_f[31:0]     ), // 32-bit output: Data output
    .DOP         (                    ), // 4-bit output: Parity data output
    .EMPTY       (                    ), // 1-bit output: Empty flag
    .ALMOSTEMPTY (                    ), // 1-bit output: Almost empty flag
    .RDCOUNT     (                    ), // 12-bit output: Read count
    .RDERR       (                    )  // 1-bit output: Read error
  );

  FIFO18E1 #(
    .ALMOST_EMPTY_OFFSET     ( 13'h0006      ), // min. value is 6 for FWFT mode, Sets the almost empty threshold
    .ALMOST_FULL_OFFSET      ( 13'h0005      ), // min. value is 4, Sets almost full threshold
    .DATA_WIDTH              ( 36            ), // Sets data width to 4-36
    .DO_REG                  ( 1             ), // Enable output register ( 1-0 ) Must be 1 if EN_SYN = FALSE
    .EN_SYN                  ( "FALSE"       ), // Specifies FIFO as dual-clock ( FALSE ) or Synchronous ( TRUE )
    .FIFO_MODE               ( "FIFO18_36"   ), // Sets mode to FIFO18 or FIFO18_36
    .FIRST_WORD_FALL_THROUGH ( "TRUE"        ), // Sets the FIFO FWFT to FALSE, TRUE
    .INIT                    ( 36'h000000000 ), // Initial values on output port
    .SIM_DEVICE              ( "7SERIES"     ), // Must be set to "7SERIES" for simulation behavior
    .SRVAL                   ( 36'h000000000 )  // Set/Reset value for output port
   ) rnmr_fifo_b (
    .RST         ( ~anrst_axi         ), // 1-bit input: Asynchronous Reset
    .RSTREG      ( 1'b0               ), // 1-bit input: Output register set/reset

    .WRCLK       ( clk_axi            ), // 1-bit input: Write clock
    .WREN        ( fifo_wren_filt     ), // 1-bit input: Write enable
    .DI          ( w_rnwr_f[31:0]     ), // 32-bit input: Data input
    .DIP         ( 4'b0               ), // 4-bit input: Parity input
    .FULL        (                    ), // 1-bit output: Full flag
    .ALMOSTFULL  (                    ), // 1-bit output: Almost full flag
    .WRCOUNT     (                    ), // 12-bit output: Write count
    .WRERR       (                    ), // 1-bit output: Write error

    .RDCLK       ( clk                ), // 1-bit input: Read clock
    .REGCE       ( 1'b1               ), // 1-bit input: Clock enable
    .RDEN        ( r_req              ), // 1-bit input: Read enable
    .DO          ( r_rnwr_f[31:0]     ), // 32-bit output: Data output
    .DOP         (                    ), // 4-bit output: Parity data output
    .EMPTY       (                    ), // 1-bit output: Empty flag
    .ALMOSTEMPTY (                    ), // 1-bit output: Almost empty flag
    .RDCOUNT     (                    ), // 12-bit output: Read count
    .RDERR       (                    )  // 1-bit output: Read error
  );

  assign r_rnw = r_rnwr_f[0];
  assign r_addr[31:0] = r_addr_f[31:0];
  assign r_data[31:0] = r_data_f[31:0];

endmodule

