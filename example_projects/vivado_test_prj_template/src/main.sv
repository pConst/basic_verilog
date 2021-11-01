
// main.sv
// Test project for AC701 board


module main(

  // system clock
  input SYSCLK_P,
  input SYSCLK_N,

  // gpio
  output GPIO_LED_0,
  output GPIO_LED_1,
  output GPIO_LED_2,
  output GPIO_LED_3,

  input GPIO_SW_N,
  input GPIO_SW_W,
  input GPIO_SW_S,
  input GPIO_SW_E,
  input GPIO_SW_C,

  output USER_SMA_GPIO_P,
  output USER_SMA_GPIO_N,

  // GT
  input SFP_LOS,
  output SFP_TX_DISABLE,

/*  input SFP_RX_N,
  input SFP_RX_P,

  output SFP_TX_N,
  output SFP_TX_P,

  input SFP_MGT_CLK1_N,
  input SFP_MGT_CLK1_P,*/

  output USER_SMA_CLOCK_N,
  output USER_SMA_CLOCK_P,

  // FMC_LA
  input FMC1_HPC_LA02_N,  input FMC1_HPC_LA02_P,  input FMC1_HPC_LA03_N,
  input FMC1_HPC_LA03_P,  input FMC1_HPC_LA04_N,  input FMC1_HPC_LA04_P,
  input FMC1_HPC_LA05_N,  input FMC1_HPC_LA05_P,  input FMC1_HPC_LA06_N,
  input FMC1_HPC_LA06_P,  input FMC1_HPC_LA07_N,  input FMC1_HPC_LA07_P,
  input FMC1_HPC_LA08_N,  input FMC1_HPC_LA08_P,  input FMC1_HPC_LA09_N,
  input FMC1_HPC_LA09_P,  input FMC1_HPC_LA10_N,  input FMC1_HPC_LA10_P,
  input FMC1_HPC_LA11_N,  input FMC1_HPC_LA11_P,  input FMC1_HPC_LA12_N,
  input FMC1_HPC_LA12_P,  input FMC1_HPC_LA13_N,  input FMC1_HPC_LA13_P,
  input FMC1_HPC_LA14_N,  input FMC1_HPC_LA14_P,  input FMC1_HPC_LA15_N,
  input FMC1_HPC_LA15_P,  input FMC1_HPC_LA16_N,  input FMC1_HPC_LA16_P,

  output FMC1_HPC_LA19_N,  output FMC1_HPC_LA19_P,  output FMC1_HPC_LA20_N,
  output FMC1_HPC_LA20_P,  output FMC1_HPC_LA21_N,  output FMC1_HPC_LA21_P,
  output FMC1_HPC_LA22_N,  output FMC1_HPC_LA22_P,  output FMC1_HPC_LA23_N,
  output FMC1_HPC_LA23_P,  output FMC1_HPC_LA24_N,  output FMC1_HPC_LA24_P,
  output FMC1_HPC_LA25_N,  output FMC1_HPC_LA25_P,  output FMC1_HPC_LA26_N,
  output FMC1_HPC_LA26_P,  output FMC1_HPC_LA27_N,  output FMC1_HPC_LA27_P,
  output FMC1_HPC_LA28_N,  output FMC1_HPC_LA28_P,  output FMC1_HPC_LA29_N,
  output FMC1_HPC_LA29_P,  output FMC1_HPC_LA30_N,  output FMC1_HPC_LA30_P,
  output FMC1_HPC_LA31_N,  output FMC1_HPC_LA31_P,  output FMC1_HPC_LA32_N,
  output FMC1_HPC_LA32_P,  output FMC1_HPC_LA33_N,  output FMC1_HPC_LA33_P
);


// Clocks and resets ===========================================================

logic clk200;  // replica of input clock
logic clk100;  // clock for all project logic
logic clk170;

logic sys_pll_locked;  // async!
clk_wiz_0 sys_pll (
  // Clock out ports
  .clk_out1( clk200 ),
  .clk_out2( clk100 ),
  .clk_out3( clk170 ),
  // Status and control signals
  .locked( sys_pll_locked ),
  // Clock in ports
  .clk_in1_p( SYSCLK_P ),
  .clk_in1_n( SYSCLK_N )
);    // input clk_in1_n

logic sys_pll_locked_clk100;
delay #(
    .LENGTH( 2 ),
    .WIDTH( 1 )
) locked_sync (
    .clk( clk100 ),
    .nrst( 1'b1 ),
    .ena( 1'b1 ),
    .in( sys_pll_locked ),
    .out( sys_pll_locked_clk100 )
);

OBUFDS #(
  .IOSTANDARD("DEFAULT"),
  .SLEW("SLOW")
  ) sma_obuf (
  .O( USER_SMA_CLOCK_P ),
  .OB( USER_SMA_CLOCK_N ),
  .I( clk170 )
);

logic [4:0] gpio_sw;
delay #(
    .LENGTH( 2 ),
    .WIDTH( 5 )
) gpio_sw_sync (
    .clk( clk100 ),
    .nrst( 1'b1 ),
    .ena( 1'b1 ),
    .in( {GPIO_SW_C, GPIO_SW_N, GPIO_SW_E, GPIO_SW_S, GPIO_SW_W} ),
    .out( gpio_sw[4:0] )
);

// stretching all buttons for debounce and required reset width
logic [4:0] gpio_sws;
pulse_stretch #(
  .WIDTH( 15 ),
  .USE_CNTR( 1 )
) buttons_stretch [4:0] (
  .clk( {5{clk100}} ),
  .nrst( {5{1'b1}} ),
  .in( gpio_sw[4:0] ),
  .out( gpio_sws[4:0] )
);

logic gpio_sws_front;
edge_detect s_sw_front (
  .clk( clk100 ),
  .nrst( 1'b1 ),
  .in( gpio_sws[1] ),
  .rising( gpio_sws_front ),
  .falling(  ),
  .both(  )
);

assign nrst = ~gpio_sws[4];                                         // key C

// IO ==========================================================================

logic [3:0] gpio_leds;
assign {GPIO_LED_3,GPIO_LED_2,GPIO_LED_1,GPIO_LED_0} = gpio_leds[3:0];

logic gpio_sma_out;
OBUFDS #(
  .IOSTANDARD( "DEFAULT" ),
  .SLEW( "SLOW" )
) OBUFDS_sma_out (
  .O( USER_SMA_GPIO_P ),
  .OB( USER_SMA_GPIO_N ),
  .I( gpio_sma_out )
);

logic [29:0] fmc_la_in;
assign fmc_la_in[29:0] =
       {FMC1_HPC_LA02_N,FMC1_HPC_LA02_P,FMC1_HPC_LA03_N,FMC1_HPC_LA03_P,
        FMC1_HPC_LA04_N,FMC1_HPC_LA04_P,FMC1_HPC_LA05_N,FMC1_HPC_LA05_P,
        FMC1_HPC_LA06_N,FMC1_HPC_LA06_P,FMC1_HPC_LA07_N,FMC1_HPC_LA07_P,
        FMC1_HPC_LA08_N,FMC1_HPC_LA08_P,FMC1_HPC_LA09_N,FMC1_HPC_LA09_P,
        FMC1_HPC_LA10_N,FMC1_HPC_LA10_P,FMC1_HPC_LA11_N,FMC1_HPC_LA11_P,
        FMC1_HPC_LA12_N,FMC1_HPC_LA12_P,FMC1_HPC_LA13_N,FMC1_HPC_LA13_P,
        FMC1_HPC_LA14_N,FMC1_HPC_LA14_P,FMC1_HPC_LA15_N,FMC1_HPC_LA15_P,
        FMC1_HPC_LA16_N,FMC1_HPC_LA16_P};

logic [29:0] fmc_la_out;
assign {FMC1_HPC_LA19_N,FMC1_HPC_LA19_P,FMC1_HPC_LA20_N,FMC1_HPC_LA20_P,
        FMC1_HPC_LA21_N,FMC1_HPC_LA21_P,FMC1_HPC_LA22_N,FMC1_HPC_LA22_P,
        FMC1_HPC_LA23_N,FMC1_HPC_LA23_P,FMC1_HPC_LA24_N,FMC1_HPC_LA24_P,
        FMC1_HPC_LA25_N,FMC1_HPC_LA25_P,FMC1_HPC_LA26_N,FMC1_HPC_LA26_P,
        FMC1_HPC_LA27_N,FMC1_HPC_LA27_P,FMC1_HPC_LA28_N,FMC1_HPC_LA28_P,
        FMC1_HPC_LA29_N,FMC1_HPC_LA29_P,FMC1_HPC_LA30_N,FMC1_HPC_LA30_P,
        FMC1_HPC_LA31_N,FMC1_HPC_LA31_P,FMC1_HPC_LA32_N,FMC1_HPC_LA32_P,
        FMC1_HPC_LA33_N,FMC1_HPC_LA33_P} = fmc_la_out[29:0];


logic [31:0] clk100_div;
clk_divider #(
  .WIDTH( 32 )
) cd_1 (
  .clk( clk100 ),
  .nrst( 1'b1 ),
  .ena( 1'b1 ),
  .out( clk100_div[31:0] )
);

assign gpio_sma_out = clk100_div[26];

assign SFP_TX_DISABLE = 1'b1;

// =============================================================================


endmodule

