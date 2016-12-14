//--------------------------------------------------------------------------------
// NDivide.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  Primitive integer divider
//  Unsigned inputs, y should be < or == x


/* --- INSTANTIATION TEMPLATE BEGIN ---

NDivide ND1 (
    .clk(  ),
    .nrst( 1'b1 ),
	.d_start(  ),
	.d_busy(  ),
	.d_done(  ),
	.x(  ),
	.y(  ),
	.q(  ),
	.r(  )
    );
defparam ND1.XBITS = 32;
defparam ND1.YBITS = 32;

--- INSTANTIATION TEMPLATE END ---*/


module NDivide(clk,nrst,d_start,d_busy,d_done,x,y,q,r);

parameter XBITS = 32;
parameter YBITS = 32;

input wire clk;
input wire nrst;

input wire d_start;
output reg d_busy = 0;
output wire d_done;

input wire [(XBITS-1):0] x;
input wire [(YBITS-1):0] y;
output reg [(XBITS-1):0] q = 0;
output wire [(YBITS-1):0] r;

reg [(XBITS+YBITS-1):0] x_buf = 0;
reg [(YBITS-1):0] y_buf = 0;
reg [31:0] i = 0;

wire [(YBITS+XBITS-1):0] shift_y;
wire [(YBITS+XBITS-1):0] x_buf_sub_shift_y;
assign
	shift_y[(YBITS+XBITS-1):0] = y_buf[(YBITS-1):0] << i[31:0],
	x_buf_sub_shift_y[(YBITS+XBITS-1):0] = x_buf[(YBITS+XBITS-1):0] - shift_y[(YBITS+XBITS-1):0];

always @ (posedge clk) begin
	if (~nrst) begin
		q[(XBITS-1):0] <= 0;
		
		i[31:0] <= 0;	
		x_buf[(XBITS+YBITS-1):0] <= 0;
		y_buf[(YBITS-1):0] <= 0;
		d_busy <= 0;		
	end else begin
		if (~d_busy) begin
			if (d_start) begin
				i[31:0] <= (XBITS-1);
				x_buf[(XBITS+YBITS-1):0] <= x[(XBITS-1):0];
				y_buf[(YBITS-1):0] <= y[(YBITS-1):0];
				d_busy <= 1;
			end // d_start
		end else begin
		
			// this condition means crossing of zero boundary
			if (x_buf_sub_shift_y[(YBITS+XBITS-1):0] > x_buf[(XBITS+YBITS-1):0]) begin
				q[i[31:0]] <= 0;
			end else begin
				q[i[31:0]] <= 1;
				x_buf[(XBITS+YBITS-1):0] <= x_buf_sub_shift_y[(YBITS+XBITS-1):0];
			end
			
			if (i[31:0] != 0) begin
				i[31:0] <= i[31:0] - 1;
			end else begin
				d_busy <= 0;
			end
			
		end	// ~d_busy
	end // ~nrst
end

assign
	d_done = d_busy && ( i[31:0] == 0 ),
	r[(XBITS-1):0] = x_buf[(XBITS+YBITS-1):0];

endmodule
