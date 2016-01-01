//--------------------------------------------------------------------------------
// DeBounce.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  Работает по двум отсчетам (медленного) клока. 
//  Переключается в оба состояния с задержкой на два (медленных) клока


/* DeBounce DB1 (
	.clk(),
	.nrst(),
	.in(),
	.out()
	);
defparam DB1.WIDTH = 1;*/


module DeBounce(clk,nrst,in,out);

input wire clk;
input wire nrst;
input wire [(WIDTH-1):0] in;
output wire [(WIDTH-1):0] out;   // also "present state"

parameter WIDTH = 1;

reg [(WIDTH-1):0] prev = 0;

always @ (posedge clk) begin
	if (~nrst) begin
		prev <= 0;
	end
	else begin
		prev[(WIDTH-1):0] <= in[(WIDTH-1):0];
	end
end

wire [(WIDTH-1):0] switch_hi = (prev[(WIDTH-1):0] & in[(WIDTH-1):0]);
wire [(WIDTH-1):0] n_switch_lo = (prev[(WIDTH-1):0] | in[(WIDTH-1):0]);

SetReset SR(clk,nrst,switch_hi[(WIDTH-1):0],~n_switch_lo[(WIDTH-1):0],out[(WIDTH-1):0]);
defparam SR.WIDTH = WIDTH;

endmodule