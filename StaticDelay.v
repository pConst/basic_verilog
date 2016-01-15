//--------------------------------------------------------------------------------
// StaticDelay.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  Статическая задержка произвольного сигнала
//  


/*StaticDelay SD1 (
    .clk(),
    .in(),
    .out()
    );
defparam SD1.LENGTH = 2;
defparam SD1.WIDTH = 1;*/


module StaticDelay(clk, in, out);		
// there is no reset on purpose of inferring Xilinx`s SRL16E primitive

input wire clk;
input wire [(WIDTH-1):0] in;
output wire [(WIDTH-1):0] out;

parameter LENGTH = 2;   // length of each delay chain
parameter WIDTH = 1;    // independent channels

//(* keep = "true" *)
reg [(LENGTH*WIDTH-1):0] data = 0;

always @ (posedge clk) begin
	data[(LENGTH*WIDTH-1):0] <= data[(LENGTH*WIDTH-1):0] << WIDTH;
	data[(WIDTH-1):0] <= in[(WIDTH-1):0];
end

assign
    out[(WIDTH-1):0] = data[(LENGTH*WIDTH-1):((LENGTH-1)*WIDTH)];

endmodule
