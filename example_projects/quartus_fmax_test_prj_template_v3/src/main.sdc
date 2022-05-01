
# main reference clock, 500 MHz
create_clock -period 2.000 -waveform { 0.000 1.000 } [get_ports {clk}]

derive_pll_clocks
derive_clock_uncertainty