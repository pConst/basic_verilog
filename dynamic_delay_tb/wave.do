onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dynamic_delay_tb/M/LENGTH
add wave -noupdate /dynamic_delay_tb/M/WIDTH
add wave -noupdate /dynamic_delay_tb/M/SEL_W
add wave -noupdate /dynamic_delay_tb/M/clk
add wave -noupdate /dynamic_delay_tb/M/nrst
add wave -noupdate /dynamic_delay_tb/M/ena
add wave -noupdate -radix hexadecimal -childformat {{{/dynamic_delay_tb/M/in[3]} -radix hexadecimal} {{/dynamic_delay_tb/M/in[2]} -radix hexadecimal} {{/dynamic_delay_tb/M/in[1]} -radix hexadecimal} {{/dynamic_delay_tb/M/in[0]} -radix hexadecimal}} -expand -subitemconfig {{/dynamic_delay_tb/M/in[3]} {-radix hexadecimal} {/dynamic_delay_tb/M/in[2]} {-radix hexadecimal} {/dynamic_delay_tb/M/in[1]} {-radix hexadecimal} {/dynamic_delay_tb/M/in[0]} {-radix hexadecimal}} /dynamic_delay_tb/M/in
add wave -noupdate -radix hexadecimal /dynamic_delay_tb/M/sel
add wave -noupdate -radix hexadecimal -childformat {{{/dynamic_delay_tb/M/out[3]} -radix hexadecimal} {{/dynamic_delay_tb/M/out[2]} -radix hexadecimal} {{/dynamic_delay_tb/M/out[1]} -radix hexadecimal} {{/dynamic_delay_tb/M/out[0]} -radix hexadecimal}} -subitemconfig {{/dynamic_delay_tb/M/out[3]} {-radix hexadecimal} {/dynamic_delay_tb/M/out[2]} {-radix hexadecimal} {/dynamic_delay_tb/M/out[1]} {-radix hexadecimal} {/dynamic_delay_tb/M/out[0]} {-radix hexadecimal}} /dynamic_delay_tb/M/out
add wave -noupdate -radix hexadecimal /dynamic_delay_tb/M/data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1330926 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 209
configure wave -valuecolwidth 100
configure wave -justifyvalue right
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {3620021 ps} {5306117 ps}
