//--------------------------------------------------------------------------------
// ActionBurst.v
// Konstantin Pavlov, pavlovconst@gmail.com
//--------------------------------------------------------------------------------

// INFO --------------------------------------------------------------------------------
//  Module is designed to generate one-shot trigger pulses on multiple channels (default is 8)
//  Every output channel is triggered only once
//  Channels get triggered in sequense with mutual delay of step_wdth[] clock cycles
//  That is useful when you need to start some tasks in exact order, but there are no convinient signals to line them up.
//  Instance of ActionBurst() is started by high level on start input and the only way to stop generation before all channels get triggered is to reset the instance


/* --- INSTANTIATION TEMPLATE BEGIN ---

wire [7:0] actions;
ActionBurst AB1 (
    .clk(),
    .nrst(),
	.step_wdth(),
	.start(),
	.busy(),
    .out()
    );
defparam AB1.WIDTH = 8;

--- INSTANTIATION TEMPLATE END ---*/


module ActionBurst(clk,nrst,step_wdth,start,busy,out);

parameter WIDTH = 8;

input wire clk;
input wire nrst;
input wire [31:0] step_wdth;	// Module buffers step_wdth in PG instance on the SECOND cycle ater start applyed!
input wire start;
output reg busy = 0;
output wire [(WIDTH-1):0] out;

wire PgOut;

PulseGen PG(
    .clk(clk),
    .nrst(busy),
    .low_wdth(step_wdth[31:0]),
    .high_wdth(32'b1),
    .rpt(1'b1),
    .start(1'b1),
    .busy(),
    .out(PgOut)
    );
	
reg [31:0] state = 0;
//reg [31:0] step_wdth_buf = 0; 	// buffering is done in PG

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