//--------------------------------------------------------------------------------
// PulseGen_test project, 201512
// Main_tb.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//
//

`timescale 1ns / 1ps

module Main_tb();

reg clk200;
initial begin
        #0 clk200 = 1;
        forever 
            #2.5 clk200 = ~clk200;
end

reg rst;
initial begin
        #10.2 rst = 1;
        #5 rst = 0;
        //#10000;
        forever begin
            #9985 rst = ~rst;
            #5 rst = ~rst;
        end
end

wire [31:0] DerivedClocks;
ClkDivider CD1 (
    .clk(clk200),
    .nrst(1'b1),
    .out(DerivedClocks[31:0]));
defparam CD1.WIDTH = 32;

wire [15:0] RandomNumber1;
reg rst1;
initial begin
        #10.2 rst1 = 1;
        #5 rst1 = 0;
end

c_rand RNG1 (
    .clk(clk200),
    .rst(rst1),
    .reseed(1'b0),
    .seed_val(DerivedClocks[15:0]),
    .out(RandomNumber1[15:0]));

reg start;
initial begin
        #100.2 start = 1;
        #5 start = 0;
end

wire [15:0] out;
Synch S1 (clk200,nrst,RandomNumber1[15:0],out[15:0]);
defparam S1.WIDTH = 16;
defparam S1.LENGTH = 3;
    
endmodule
	