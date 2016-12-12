//--------------------------------------------------------------------------------
// EdgeDetect.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  Simply edge detector
//  One tick propagation time


/*EdgeDetect ED1 (
    .clk(),
    .nrst(),
    .in(),
    .rising(),
    .falling(),
    .both()
    );
defparam ED1.WIDTH = 1;*/


module EdgeDetect(clk, nrst, in, rising, falling, both);

input wire clk;
input wire nrst;

input wire [(WIDTH-1):0] in;
output reg [(WIDTH-1):0] rising = 0;
output reg [(WIDTH-1):0] falling = 0;
output wire [(WIDTH-1):0] both;

parameter WIDTH = 1;

reg [(WIDTH-1):0] in_prev = 0;
		    
always @ (posedge clk) begin
	if (~nrst) begin
	    in_prev <= 0;
	    
		rising <= 0;
		falling <= 0;
	end
	else begin
		in_prev <= in;
		
        rising[(WIDTH-1):0] <= in[(WIDTH-1):0] & ~in_prev[(WIDTH-1):0];
        falling[(WIDTH-1):0] <= ~in[(WIDTH-1):0] & in_prev[(WIDTH-1):0];
	end
end

assign
    both[(WIDTH-1):0] = rising[(WIDTH-1):0] | falling[(WIDTH-1):0];

endmodule
