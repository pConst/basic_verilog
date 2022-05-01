
# main reference clock, 1000 MHz requested
create_clock -name clk -period 1.000 -waveform {0.000 0.500} [get_ports { clk }]