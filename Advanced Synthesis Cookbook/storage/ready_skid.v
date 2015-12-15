// Copyright 2008 Altera Corporation. All rights reserved.  
// Altera products are protected under numerous U.S. and foreign patents, 
// maskwork rights, copyrights and other intellectual property laws.  
//
// This reference design file, and your use thereof, is subject to and governed
// by the terms and conditions of the applicable Altera Reference Design 
// License Agreement (either as signed by you or found at www.altera.com).  By
// using this reference design file, you indicate your acceptance of such terms
// and conditions between you and Altera Corporation.  In the event that you do
// not agree with such terms and conditions, you may not use the reference 
// design file and please promptly destroy any copies you have made.
//
// This reference design file is being provided on an "as-is" basis and as an 
// accommodation and therefore all warranties, representations or guarantees of 
// any kind (whether express, implied or statutory) including, without 
// limitation, warranties of merchantability, non-infringement, or fitness for
// a particular purpose, are specifically disclaimed.  By making this reference
// design file available, Altera expressly does not recommend, suggest or 
// require that this reference design file be used in combination with any 
// other product not provided by Altera.
/////////////////////////////////////////////////////////////////////////////

// baeckler - 11-06-2008
// pipeline for ready / valid data

module ready_skid #(
	parameter WIDTH = 16
)
(
	input clk,arst,
	
	input valid_i,
	input [WIDTH-1:0] dat_i,
	output reg ready_i,
	
	output reg valid_o,
	output reg [WIDTH-1:0] dat_o,
	input ready_o	
);

reg [WIDTH-1:0] backup_storage;
reg backup_valid;

// duplicate control registers to mitigate
// high fanout loading.
reg internal_valid_o /* synthesis preserve */;
reg internal_ready_i /* synthesis preserve */;

// simulation only sanity check
always @(posedge clk) begin
	if ((ready_i != internal_ready_i) || 
		(valid_o != internal_valid_o)) begin
		$display ("Error: Duplicate internal regs out of sync");	
	end
end

always @(posedge clk or posedge arst) begin
	if (arst) begin
		ready_i <= 1'b0;
		internal_ready_i <= 1'b0;
		valid_o <= 1'b0;
		internal_valid_o <= 1'b0;
		dat_o <= 0;
		backup_storage <= 0;
		backup_valid <= 1'b0;
	end
	else begin
		ready_i <= ready_o;
		internal_ready_i <= ready_o;
		
		if (internal_valid_o & ready_o) begin
			// main data is leaving to the sink
			if (backup_valid) begin
				// dump the backup word to main storage
				backup_valid <= 1'b0;
				dat_o <= backup_storage;
				valid_o <= 1'b1;	
				internal_valid_o <= 1'b1;	
				if (ready_i && valid_i) begin
					$display ("ERROR: data lost in skid buffer");
				end
			end
			else begin
				// if not overwritten below, you are done.
				valid_o <= 1'b0;
				internal_valid_o <= 1'b0;
			end
		end
		
		if (internal_ready_i && valid_i) begin
			// must accept data from source
			if (ready_o || !internal_valid_o) begin
				// accept to main registers
				valid_o <= 1'b1;
				internal_valid_o <= 1'b1;
				dat_o <= dat_i;
			end
			else begin
				// accept to backup storage
				backup_valid <= 1'b1;
				backup_storage <= dat_i;
				ready_i <= 1'b0; // stop stop!
				internal_ready_i <= 1'b0;
			end
		end			
	end
end

endmodule
