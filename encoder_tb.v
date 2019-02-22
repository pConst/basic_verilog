//--------------------------------------------------------------------------------
// encoder_tb.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//
//

`timescale 1ns / 1ps

module encoder_tb();

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

wire [31:0] DerivedClocks;
ClkDivider CD1 (
    .clk(clk200),
    .nrst(nrst),
    .out(DerivedClocks[31:0]));
defparam CD1.WIDTH = 32;

wire [31:0] E_DerivedClocks;
EdgeDetect ED1 (
    .clk(clk200),
    .nrst(nrst),
    .in(DerivedClocks[31:0]),
    .rising(E_DerivedClocks[31:0]),
    .falling(),
    .both()
    );
defparam ED1.WIDTH = 32;

wire [15:0] RandomNumber1;
reg rst_once;
initial begin
        #10.2 rst_once = 1;
        #5 rst_once = 0;
end

c_rand RNG1 (
    .clk(clk200),
    .rst(rst_once),
    .reseed(1'b0),
    .seed_val(DerivedClocks[15:0]),
    .out(RandomNumber1[15:0]));

reg start;
initial begin
        #100.2 start = 1;
        #5 start = 0;
end

//=================================================

wire p,m;
encoder E1(
	.clk(clk200),
	.nrst(nrst),
	.incA(RandomNumber1[0]),
	.incB(RandomNumber1[1]),
	.plus1(p),
	.minus1(m)
	);

endmodule
