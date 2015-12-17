//--------------------------------------------------------------------------------
// Synch.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  Синхронизатор для входных сигналов.
//  Стандартный метод подавления метастабильности.

(* keep_hierarchy = "yes" *) module Synch(clk, in, out);

input wire clk;
input wire in;
output wire out;

parameter LENGTH = 2;   // length of each sincronizer chain
//parameter WIDTH = 1;    // independent channels

//(* keep = "true" *)
reg [(LENGTH-1):0] data = 0;
integer i;

always @ (posedge clk) begin
    data[0] <= in;
    for (i=1; i<LENGTH; i=i+1) begin
        data[i] <= data[i-1];
    end
end

assign
    out = data[LENGTH-1];

endmodule
