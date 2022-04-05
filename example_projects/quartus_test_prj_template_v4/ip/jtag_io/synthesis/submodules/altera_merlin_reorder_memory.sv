// (C) 2001-2020 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files from any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License Subscription 
// Agreement, Intel FPGA IP License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Intel and sold by 
// Intel or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


// $Id: //acds/rel/20.1std/ip/merlin/altera_merlin_traffic_limiter/altera_merlin_reorder_memory.sv#1 $
// $Revision: #1 $
// $Date: 2019/10/06 $
// $Author: psgswbuild $

// ------------------------------------------------------------------
// Merlin Order Memory: this stores responses from slave
// and do reorder. The memory structure is normal memory
// with many segments for different responses that master
// can handle.
// The number of segment is the number of MAX_OUTSTANDING_RESPONSE
// ------------------------------------------------------------------

`timescale 1 ns / 1 ns
module altera_merlin_reorder_memory 
#(
   parameter  DATA_W         = 32,
              ADDR_H_W       = 4, // width to represent how many segments
              ADDR_L_W       = 4,
              VALID_W        = 4,
              NUM_SEGMENT    = 4,
              DEPTH          = 16

)
    
(
    // -------------------
    // Clock
    // -------------------
    input                       clk,
    input                       reset,
    // -------------------
    // Signals
    // -------------------
    input [DATA_W - 1 : 0]      in_data,
    input                       in_valid,
    output                      in_ready,
 
    output reg [DATA_W - 1 : 0] out_data,
    output reg                  out_valid,
    input                       out_ready,
    // --------------------------------------------
    // wr_segment: select write portion of memory
    // rd_segment: select read portion of memory
    // --------------------------------------------
    input [ADDR_H_W - 1 : 0]    wr_segment,
    input [ADDR_H_W - 1 : 0]    rd_segment
 
);

    // -------------------------------------
    // Local parameter
    // -------------------------------------
    localparam SEGMENT_W  = ADDR_H_W;
    
    wire [ADDR_H_W + ADDR_L_W - 1 : 0] mem_wr_addr;
    reg [ADDR_H_W + ADDR_L_W - 1 : 0]  mem_rd_addr;
    wire [ADDR_L_W - 1 : 0]            mem_wr_ptr;
    wire [ADDR_L_W - 1 : 0]            mem_rd_ptr;
    reg [ADDR_L_W - 1 : 0]             mem_next_rd_ptr;
    reg [DATA_W - 1 : 0]               out_payload;
    
    wire [NUM_SEGMENT - 1 : 0]         pointer_ctrl_in_ready;
    wire [NUM_SEGMENT - 1 : 0]         pointer_ctrl_in_valid;
    wire [NUM_SEGMENT - 1 : 0]         pointer_ctrl_out_valid;
    wire [NUM_SEGMENT - 1 : 0]         pointer_ctrl_out_ready;
    wire [ADDR_L_W - 1 : 0]            pointer_ctrl_wr_ptr [NUM_SEGMENT];
    wire [ADDR_L_W - 1 : 0]            pointer_ctrl_rd_ptr [NUM_SEGMENT];
    wire [ADDR_L_W - 1 : 0]            pointer_ctrl_next_rd_ptr [NUM_SEGMENT];
    
    // ---------------------------------
    // Memory storage
    // ---------------------------------
    (* ramstyle="no_rw_check" *) reg [DATA_W - 1 : 0]               mem [DEPTH - 1 : 0];
	always @(posedge clk) begin
		if (in_valid && in_ready)
			mem[mem_wr_addr] = in_data;
        out_payload = mem[mem_rd_addr];
	end
    //assign mem_rd_addr  = {rd_segment, mem_next_rd_ptr};
    
    always_comb
       begin
           out_data  = out_payload;
           out_valid = pointer_ctrl_out_valid[rd_segment];
       end
    // ---------------------------------
    // Memory addresses
    // ---------------------------------
    assign mem_wr_ptr       = pointer_ctrl_wr_ptr[wr_segment];
    //assign mem_rd_ptr       = pointer_ctrl_rd_ptr[rd_segment];
    //assign mem_next_rd_ptr  = pointer_ctrl_next_rd_ptr[rd_segment];

    assign mem_wr_addr  = {wr_segment, mem_wr_ptr};

    // ---------------------------------------------------------------------------
    // Bcos want, empty latency, mean assert read the data will appear on out_data. 
    // And need to jump around different segment of the memory. 
    // So when seeing endofpacket for this current segment, the read address
    // will jump to next segment at first read address, so that the data will be ready
    // it is okay to jump to next segment as this is the sequence of all transaction
    // and they just increment. (standing at segment 0, then for sure next segment 1)
    // ----------------------------------------------------------------------------
    wire endofpacket;
    assign endofpacket  = out_payload[0];
    wire [ADDR_H_W - 1: 0] next_rd_segment;
    assign next_rd_segment  = ((rd_segment + 1'b1) == NUM_SEGMENT) ? '0 : rd_segment + 1'b1;

    always_comb
        begin
            if (out_valid && out_ready && endofpacket)
                begin
                    mem_next_rd_ptr  = pointer_ctrl_rd_ptr[next_rd_segment];
                    //mem_rd_addr      = {rd_segment + 1'b1, mem_next_rd_ptr};
					mem_rd_addr      = {next_rd_segment, mem_next_rd_ptr};
					
                end
            else
                begin
                    mem_next_rd_ptr  = pointer_ctrl_next_rd_ptr[rd_segment];
                    mem_rd_addr      = {rd_segment, mem_next_rd_ptr};
                end
        end
    
    
    // ---------------------------------
    // Output signals
    // ---------------------------------
    assign in_ready  = pointer_ctrl_in_ready[wr_segment];
    
    // ---------------------------------
    // Control signals for each segment
    // ---------------------------------
    genvar j;
    generate
        for (j = 0; j < NUM_SEGMENT; j = j + 1)
            begin : pointer_signal
                assign pointer_ctrl_in_valid[j]  = (wr_segment == j) && in_valid;
                assign pointer_ctrl_out_ready[j]  = (rd_segment == j) && out_ready;
                
            end
    endgenerate
    
    // ---------------------------------
    // Seperate write and read pointer
    // for each segment in memory
    // ---------------------------------
    genvar i;
    generate
        for (i = 0; i < NUM_SEGMENT; i = i + 1)
            begin : each_segment_pointer_controller
	            memory_pointer_controller 
                 #(
                   .ADDR_W   (ADDR_L_W)
                   ) reorder_memory_pointer_controller
                 (
                  .clk              (clk),
                  .reset            (reset),                  
                  .in_ready         (pointer_ctrl_in_ready[i]),
                  .in_valid         (pointer_ctrl_in_valid[i]),
                  .out_ready        (pointer_ctrl_out_ready[i]),
                  .out_valid    	(pointer_ctrl_out_valid[i]),                  
		          .wr_pointer    	(pointer_ctrl_wr_ptr[i]),
                  .rd_pointer       (pointer_ctrl_rd_ptr[i]),
                  .next_rd_pointer  (pointer_ctrl_next_rd_ptr[i])
                  );
            end // block: each_segment_pointer_controller
    endgenerate
endmodule


module memory_pointer_controller 
#(
    parameter ADDR_W   = 4
)
(
    // -------------------
    // Clock
    // -------------------
    input                   clk,
    input                   reset,
    // -------------------
    // Signals
    // -------------------
    output reg              in_ready,
	input                   in_valid,
    input                   out_ready,
    output reg              out_valid,
	// -------------------------------
    // Output write and read pointer
    // -------------------------------
	output [ADDR_W - 1 : 0] wr_pointer,
	output [ADDR_W - 1 : 0] rd_pointer,
    output [ADDR_W - 1 : 0] next_rd_pointer
);

	reg [ADDR_W - 1 : 0]      	incremented_wr_ptr;
	reg [ADDR_W - 1 : 0]      	incremented_rd_ptr;
	reg [ADDR_W - 1 : 0]      	wr_ptr;
	reg [ADDR_W - 1 : 0]      	rd_ptr;
	reg [ADDR_W - 1 : 0]		next_wr_ptr;
	reg [ADDR_W - 1 : 0]		next_rd_ptr;
	reg full, empty, next_full, next_empty;
	reg read, write, internal_out_ready, internal_out_valid;
	
	assign incremented_wr_ptr = wr_ptr + 1'b1;
	assign incremented_rd_ptr = rd_ptr + 1'b1;
	assign next_wr_ptr =  write ?  incremented_wr_ptr : wr_ptr;
	assign next_rd_ptr = read ? incremented_rd_ptr : rd_ptr;
	assign wr_pointer  = wr_ptr;
    assign rd_pointer  = rd_ptr;
    assign next_rd_pointer  = next_rd_ptr;
    
	// -------------------------------
    // Define write and read signals
    // --------------------------------
    // internal read, if it has any valid data
    // and output are ready to accepts data then a read will be performed.
    // -------------------------------
	//assign read  = internal_out_ready && internal_out_valid;
    assign read  = internal_out_ready && !empty;
	assign write = in_ready && in_valid;

	always_ff @(posedge clk or posedge reset) 
        begin
		    if (reset) 
                begin
			        wr_ptr <= 0;
			        rd_ptr <= 0;
		        end 
            else 
                begin
			        wr_ptr <= next_wr_ptr;
			        rd_ptr <= next_rd_ptr;
		        end
	    end
    // ---------------------------------------------------------------------------
	// Generate full/empty signal for memory
    // if read and next read pointer same as write, set empty, write will clear empty
    // if write and next write pointer same as read, set full, read will clear full
    // -----------------------------------------------------------------------------
	always_comb 
        begin
            next_full = full;
            next_empty = empty;
		    if (read && !write) 
                begin
			        next_full = 1'b0;
			        if (incremented_rd_ptr == wr_ptr)
				        next_empty = 1'b1;
                end
		    if (write && !read) 
                begin
                    next_empty = 1'b0;
                    if (incremented_wr_ptr == rd_ptr)
                        next_full = 1'b1;
		        end
	    end // always_comb
    
    always_ff @(posedge clk or posedge reset) 
        begin
            if (reset) 
                begin
                    empty <= 1;
                    full  <= 0;
                end
            else 
                begin 
                    empty <= next_empty;
                    full  <= next_full;
                end
        end

	// --------------------
    // Control signals
    // --------------------
    always_comb
        begin
            in_ready            = !full;
            out_valid           = !empty;
            internal_out_ready  = out_ready;
		end // always_comb
endmodule

