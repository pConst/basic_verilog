//--------------------------------------------------------------------------------
// ActionBurst_tb.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//
//

`timescale 1ns / 1ps

module ActionBurst_tb();

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
wire nrst = ~rst;

reg rst_once;
initial begin       // initializing non-X data before PLL starts
        #10.2 rst_once = 1;
        #5 rst_once = 0;
end
initial begin
        #510.2 rst_once = 1;    // PLL starts at 500ns, clock appears, so doing the reset for modules
        #5 rst_once = 0;
end
wire nrst_once = ~rst_once;

wire [31:0] DerivedClocks;
ClkDivider CD1 (
    .clk(clk200),
    .nrst(nrst_once),
    .out(DerivedClocks[31:0]));
defparam CD1.WIDTH = 32;

wire [31:0] E_DerivedClocks;
EdgeDetect ED1 (
    .clk(clk200),
    .nrst(nrst_once),
    .in(DerivedClocks[31:0]),
    .rising(E_DerivedClocks[31:0]),
    .falling(),
    .both()
    );
defparam ED1.WIDTH = 32;

wire [15:0] RandomNumber1;
c_rand RNG1 (
    .clk(clk200),
    .rst(rst_once),
    .reseed(1'b0),
    .seed_val(DerivedClocks[31:0]),
    .out(RandomNumber1[15:0]));

reg start;
initial begin
        #100.2 start = 1;
        #5 start = 0;
end

wire out;
ActionBurst AB1 (
    .clk(clk200),
    .nrst(nrst),
	.step_wdth(32'd1),
	.start(1'b1),
	.busy(),
    .out(out)
    );
defparam AB1.WIDTH = 32;



endmodule
