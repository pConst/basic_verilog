//--------------------------------------------------------------------------------
// ActionBurst2.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  Module is designed to generate one-shot trigger pulses on multiple channels (default is 8)
//  Every output channel is triggered only once
//  Channels get triggered in sequense from out[0] to out[8]
//  That is useful when you need to start some tasks in exact order, but there are no convinient signals to line them up.
//  Instance of ActionBurst() is started by high level on start input and the only way to stop generation before all channels get triggered is to reset the instance
//  This version of ActionBurst features different step widths


/* --- INSTANTIATION TEMPLATE BEGIN ---

ActionBurst2 AB1 (
    .clk(  ),
    .nrst( 1'b1 ),
	.step_wdths( {32'h00000001,32'h00000002,32'h00000003,32'h00000004,32'h00000005,32'h00000006,32'h00000007,32'h00000008} ),
	.start(  ),
	.busy(  ),
    .out(  )
    );
defparam AB1.WIDTH = 8;

--- INSTANTIATION TEMPLATE END ---*/


module ActionBurst2(clk,nrst,step_wdths,start,busy,out);

parameter WIDTH = 8;

input wire clk;
input wire nrst;
input wire [(WIDTH*32-1):0] step_wdths;
input wire start;
output reg busy = 0;
output wire [(WIDTH-1):0] out;

wire PgOut;
reg [31:0] state = 0;

wire [31:0] lw;

genvar j;
generate
	for(j=0; j<32; j=j+1) begin : LW_FOR
		assign lw[j] = step_wdths[state[31:0]*32+j];
	end
endgenerate

PulseGen PG(
    .clk( clk ),
    .nrst( start || busy ),
    .low_wdth( lw[31:0] ),
    .high_wdth( 32'b1 ),
    .rpt( 1'b0 ),
    .start( busy ),
    .busy(  ),
    .out( PgOut )
    );
	
always @ (posedge clk) begin
	if (~nrst) begin
		state[31:0] <= 0;
	end	else begin
		if (~busy) begin
			if (start) begin  // buffering input values
                state[31:0] <= 0;
				//step_wdth_buf[31:0] <= step_wdth[31:0]; 	// buffering is done in PG
				busy <= 1;
			end	// start
		end else begin
		    if (PgOut) begin
                if (state != (WIDTH-1)) begin
                    state[31:0] <= state[31:0] + 1'b1;
                end else begin
					busy <= 0;
                end // state
		    end // PgOut
		end   // busy
	end // nrst
end

genvar i;
generate
	for (i=0; i<WIDTH; i=i+1) begin : AB_GEN_FOR
		assign out[i] = PgOut && ( i == state[31:0] );
	end
endgenerate

endmodule