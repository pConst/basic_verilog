onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary -childformat {{{/reverse_dimensions_tb/RD1/in[1]} -radix binary} {{/reverse_dimensions_tb/RD1/in[0]} -radix binary}} -expand -subitemconfig {{/reverse_dimensions_tb/RD1/in[1]} {-radix binary} {/reverse_dimensions_tb/RD1/in[0]} {-radix binary}} /reverse_dimensions_tb/RD1/in
add wave -noupdate -radix binary -childformat {{{/reverse_dimensions_tb/RD1/out[7]} -radix binary} {{/reverse_dimensions_tb/RD1/out[6]} -radix binary} {{/reverse_dimensions_tb/RD1/out[5]} -radix binary} {{/reverse_dimensions_tb/RD1/out[4]} -radix binary -childformat {{{[1]} -radix hexadecimal} {{[0]} -radix hexadecimal}}} {{/reverse_dimensions_tb/RD1/out[3]} -radix binary} {{/reverse_dimensions_tb/RD1/out[2]} -radix binary} {{/reverse_dimensions_tb/RD1/out[1]} -radix binary} {{/reverse_dimensions_tb/RD1/out[0]} -radix binary}} -expand -subitemconfig {{/reverse_dimensions_tb/RD1/out[7]} {-radix binary} {/reverse_dimensions_tb/RD1/out[6]} {-radix binary} {/reverse_dimensions_tb/RD1/out[5]} {-radix binary} {/reverse_dimensions_tb/RD1/out[4]} {-radix binary -childformat {{{[1]} -radix hexadecimal} {{[0]} -radix hexadecimal}}} {/reverse_dimensions_tb/RD1/out[4][1]} {-radix hexadecimal} {/reverse_dimensions_tb/RD1/out[4][0]} {-radix hexadecimal} {/reverse_dimensions_tb/RD1/out[3]} {-radix binary} {/reverse_dimensions_tb/RD1/out[2]} {-radix binary} {/reverse_dimensions_tb/RD1/out[1]} {-radix binary} {/reverse_dimensions_tb/RD1/out[0]} {-radix binary}} /reverse_dimensions_tb/RD1/out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {21806 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {4609 ps} {81173 ps}
