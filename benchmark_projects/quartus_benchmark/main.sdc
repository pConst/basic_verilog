
# main reference clock, 100 MHz
create_clock -period 10.000 -waveform { 0.000 5.000 } [get_ports {clk}]

derive_pll_clocks
derive_clock_uncertainty
