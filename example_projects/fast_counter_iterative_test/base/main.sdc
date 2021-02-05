
create_clock -period 2.000 -waveform { 0.000 1.000 } [get_ports {clk1}]
create_clock -period 2.000 -waveform { 0.000 1.000 } [get_ports {clk2}]

derive_pll_clocks
derive_clock_uncertainty
