//--------------------------------------------------------------------------------
// EdgeDetect.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  Детектор перепада уровня. 
//  Выдает единичный импульс по фронту, спаду и комбинированный
//  Задержка на один такт

module EdgeDetect(clk, nrst, rising, falling, in, out);

input wire clk;
input wire nrst;

input wire [(WIDTH-1):0] in;
output reg [(WIDTH-1):0] rising = 0;
output reg [(WIDTH-1):0] falling = 0;
output wire [(WIDTH-1):0] out;

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
    out[(WIDTH-1):0] = rising[(WIDTH-1):0] | falling[(WIDTH-1):0];

endmodule
