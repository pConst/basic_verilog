onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /spi_master_tb/SM1/clk
add wave -noupdate /spi_master_tb/SM1/nrst
add wave -noupdate /spi_master_tb/SM1/spi_clk
add wave -noupdate /spi_master_tb/SM1/spi_clk_rise
add wave -noupdate /spi_master_tb/SM1/spi_clk_fall
add wave -noupdate /spi_master_tb/SM1/spi_wr_cmd_rise
add wave -noupdate /spi_master_tb/SM1/spi_wr_cmd
add wave -noupdate /spi_master_tb/SM1/spi_rd_cmd
add wave -noupdate /spi_master_tb/SM1/spi_rd_cmd_rise
add wave -noupdate /spi_master_tb/SM1/spi_busy
add wave -noupdate -radix decimal /spi_master_tb/SM1/sequence_cntr
add wave -noupdate /spi_master_tb/SM1/rd_nwr
add wave -noupdate -radix binary /spi_master_tb/SM1/data_out
add wave -noupdate -radix binary /spi_master_tb/SM1/data_in
add wave -noupdate /spi_master_tb/SM1/data_out_buf
add wave -noupdate -color Yellow /spi_master_tb/SM1/clk_pin
add wave -noupdate -color Yellow /spi_master_tb/SM1/ncs_pin
add wave -noupdate -color Yellow /spi_master_tb/SM1/d_out_pin
add wave -noupdate -color Yellow /spi_master_tb/SM1/d_oe
add wave -noupdate -color Yellow /spi_master_tb/SM1/d_in_pin
add wave -noupdate /spi_master_tb/SM1/spi_clk_rise_d2
add wave -noupdate /spi_master_tb/SM1/spi_clk_fall_d2
add wave -noupdate /spi_master_tb/SM1/d_in_pin_d2
add wave -noupdate -color {Medium Violet Red} -radix decimal /spi_master_tb/SM2/sequence_cntr
add wave -noupdate -color {Medium Violet Red} /spi_master_tb/SM2/clk_pin
add wave -noupdate -color {Medium Violet Red} /spi_master_tb/SM2/ncs_pin
add wave -noupdate -color {Medium Violet Red} /spi_master_tb/SM2/d_out_pin
add wave -noupdate -color {Medium Violet Red} /spi_master_tb/SM2/d_oe
add wave -noupdate -color {Medium Violet Red} /spi_master_tb/SM2/d_in_pin
add wave -noupdate -color {Cornflower Blue} /spi_master_tb/SM3/sequence_cntr
add wave -noupdate -color {Cornflower Blue} /spi_master_tb/SM3/clk_pin
add wave -noupdate -color {Cornflower Blue} /spi_master_tb/SM3/ncs_pin
add wave -noupdate -color {Cornflower Blue} /spi_master_tb/SM3/d_out_pin
add wave -noupdate -color {Cornflower Blue} /spi_master_tb/SM3/d_oe
add wave -noupdate -color {Cornflower Blue} /spi_master_tb/SM3/d_in_pin
add wave -noupdate -color {Orange Red} /spi_master_tb/SM4/sequence_cntr
add wave -noupdate -color {Orange Red} /spi_master_tb/SM4/clk_pin
add wave -noupdate -color {Orange Red} /spi_master_tb/SM4/ncs_pin
add wave -noupdate -color {Orange Red} /spi_master_tb/SM4/d_out_pin
add wave -noupdate -color {Orange Red} /spi_master_tb/SM4/d_oe
add wave -noupdate -color {Orange Red} /spi_master_tb/SM4/d_in_pin
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {801886 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {3706084 ps}
