//--------------------------------------------------------------------------------
// Counter project, 201512
// Main_TB.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  Testbench template with basic clocking, periodic reset
//  and random stimulus signals

`timescale 1ns / 1ps

module Main_TB();

reg TB_clk200;
initial begin
        #0 TB_clk200 = 0;
        forever 
            #5 TB_clk200 = ~TB_clk200;
end

reg TB_rst;
initial begin
        #40 TB_rst = 1;
        #10 TB_rst = 0;
        //#10000;
        forever begin
            #9950 TB_rst = ~TB_rst;
            #50 TB_rst = ~TB_rst;
        end
end

wire [31:0] TB_DerivedClocks;
ClkDivider CD1 (
    .clk(TB_clk200),
    .nrst(1'b1),
    .out(TB_DerivedClocks[31:0]));
defparam CD1.WIDTH = 32;



wire [15:0] TB_RandomNumber1;
reg TB_rst1;
initial begin
        #40 TB_rst1 = 1;
        #10 TB_rst1 = 0;
end

c_rand RNG1 (
    .clk(TB_clk200),
    .rst(TB_rst1),
    .reseed(1'b0),
    .seed_val(TB_DerivedClocks[15:0]),
    .out(TB_RandomNumber1[15:0]));

wire out1,out2;
Main M(		// module under test
    TB_clk,~TB_clk,
    TB_rst,
    out1,out2   // for compiler not to remove logic
);
    
endmodule
	