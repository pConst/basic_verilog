//--------------------------------------------------------------------------------
// ResetSet.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  SR trigger variant
//  No metastable state. SET dominates here


/* ResetSet RS1 (
	.clk(),
	.nrst(),
	.s(),
	.r(),
	.q(),
	.nq()
	);
defparam RS1.WIDTH = 1; */


module ResetSet(clk,nrst,s,r,q,nq);

input wire clk;
input wire nrst;
input wire [(WIDTH-1):0] s;
input wire [(WIDTH-1):0] r;
output reg [(WIDTH-1):0] q = 0;   // also "present state"
output wire [(WIDTH-1):0] nq;

parameter WIDTH = 1;

assign 
    nq[(WIDTH-1):0] = ~q[(WIDTH-1):0];
    
integer i;

always @ (posedge clk) begin
	if (~nrst) begin
		q <= 0;
	end
	else begin
        for (i=0; i<WIDTH; i=i+1) begin
            if (r[i]) q[i] = 0;
            if (s[i]) q[i] = 1;
        end
	end // else
end

endmodule