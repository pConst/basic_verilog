//--------------------------------------------------------------------------------
// debounce.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
// Debounce for two inpus signal samples
// Signal may and maynot be periodic
// Switches up and down with 3 ticks delay


/* --- INSTANTIATION TEMPLATE BEGIN ---

debounce DB1 (
	.clk(),
	.nrst( 1'b1 ),
	.en( 1'b1 ),
	.in(),
	.out()
	);
defparam DB1.WIDTH = 1;

--- INSTANTIATION TEMPLATE END ---*/


module debounce(clk,nrst,en,in,out);

input wire clk;
input wire nrst;
input wire en;

input wire [(WIDTH-1):0] in;
output wire [(WIDTH-1):0] out;   // also "present state"

parameter WIDTH = 1;

reg [(WIDTH-1):0] d1 = 0;
reg [(WIDTH-1):0] d2 = 0;

always @ (posedge clk) begin
	if (~nrst) begin
		d1[(WIDTH-1):0] <= 0;
		d2[(WIDTH-1):0] <= 0;
	end
	else begin
		if (en) begin
			d1[(WIDTH-1):0] <= d2[(WIDTH-1):0];
			d2[(WIDTH-1):0] <= in[(WIDTH-1):0];
		end;	// if
	end		// else
end

wire [(WIDTH-1):0] switch_hi = (d2[(WIDTH-1):0] & d1[(WIDTH-1):0]);
wire [(WIDTH-1):0] n_switch_lo = (d2[(WIDTH-1):0] | d1[(WIDTH-1):0]);

SetReset SR (
	.clk(clk),
	.nrst(nrst),
	.s(switch_hi[(WIDTH-1):0]),
	.r(~n_switch_lo[(WIDTH-1):0]),
	.q(out[(WIDTH-1):0]),
	.nq()
	);
defparam SR.WIDTH = WIDTH;

endmodule