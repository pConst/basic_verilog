//--------------------------------------------------------------------------------
// Synch.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  Синхронизатор для входных сигналов.
//  Стандартный метод подавления метастабильности.

//(* keep_hierarchy = "yes" *)
module Synch(clk, nrst, in, out);		// aka "static delay"

input wire clk;
input wire nrst;
input wire [(WIDTH-1):0] in;
output wire [(WIDTH-1):0] out;

parameter LENGTH = 2;   // length of each synchronizer chain
parameter WIDTH = 1;    // independent channels

(* keep = "true" *) reg [(LENGTH*WIDTH-1):0] data = 0;

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
