//--------------------------------------------------------------------------------
// DynDelay.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  Генератор задержки произвольного сигнала
//  


/* DynDelay DD1 (
	.clk(),
	.in(),
	.sel(),
	.out()
	);
defparam DD1.LENGTH = 8;*/


//(* keep_hierarchy = "yes" *)
module DynDelay(clk, in, sel, out);

input wire clk;
input wire in;
input wire [(LENGTH-1):0] sel;	// output selector
output reg out;

parameter LENGTH = 8;

(* keep = "true" *) reg [(LENGTH-1):0] data = 0;

integer i;

always @ (posedge clk) begin
    data[0] <= in;
    for (i=1; i<LENGTH; i=i+1) begin
        data[i] <= data[i-1];
    end
    out <= data[sel[(LENGTH-1):0]];
end

endmodule