//--------------------------------------------------------------------------------
// StaticDelay.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  Static Delay for arbitrary signal
//  Also may serve as a FPGA clock domain input synchronizer - base technique to get rid of metastability issues
//  TIP: Do not use reset on purpose of inferring Xilinx`s SRL16E primitive

/* --- INSTANTIATION TEMPLATE BEGIN ---

StaticDelay SD1 (
    .clk(),
    .nrst( 1'b1 ),
    .in(),
    .out()
    );
defparam SD1.LENGTH = 2;
defparam SD1.WIDTH = 1;

--- INSTANTIATION TEMPLATE END ---*/


//(* keep_hierarchy = "yes" *)
module StaticDelay(clk,nrst,in,out);

input wire clk;
input wire nrst;
input wire [(WIDTH-1):0] in;
output wire [(WIDTH-1):0] out;

parameter LENGTH = 2;   // length of each delay/synchronizer chain
parameter WIDTH = 1;    // independent channels

(* KEEP = "TRUE" *)(* ASYNC_REG = "TRUE" *) reg [(LENGTH*WIDTH-1):0] data = 0;

always @ (posedge clk) begin
	if (~nrst) begin
		data[(LENGTH*WIDTH-1):0] <= 0;
	end
	else begin
	data[(LENGTH*WIDTH-1):0] <= data[(LENGTH*WIDTH-1):0] << WIDTH;
	data[(WIDTH-1):0] <= in[(WIDTH-1):0];
end
end

assign
    out[(WIDTH-1):0] = data[(LENGTH*WIDTH-1):((LENGTH-1)*WIDTH)];

endmodule
