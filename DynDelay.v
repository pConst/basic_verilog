//--------------------------------------------------------------------------------
// DynDelay.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  Dynamic delay for arbitrary signal
//  

/* --- INSTANTIATION TEMPLATE BEGIN ---

DynDelay DD1 (
	.clk(  ),
    .nrst( 1'b1 ),
	.in(  ),
	.sel(  ),
	.out(  )
	);
defparam DD1.LENGTH = 8;

--- INSTANTIATION TEMPLATE END ---*/


//(* keep_hierarchy = "yes" *)
module DynDelay(clk,nrst,in,sel,out);

input wire clk;
input wire nrst;
input wire in;
input wire [(LENGTH-1):0] sel;	// output selector
output reg out;

parameter LENGTH = 8;

(* keep = "true" *) reg [(LENGTH-1):0] data = 0;

integer i;

always @ (posedge clk) begin
	if (~nrst) begin
		data[(LENGTH-1):0] <= 0;
		out <= 0;
	end
	else begin
		data[0] <= in;
		for (i=1; i<LENGTH; i=i+1) begin
			data[i] <= data[i-1];
		end
		out <= data[sel[(LENGTH-1):0]];
	end
end

endmodule