// Copyright 2009 Altera Corporation. All rights reserved.  
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

module quad_stream_grabber #(
	parameter DAT_WIDTH = 72, // multiple of 8
	parameter ADDR_BITS = 8  // depth of the sample memory
)
(
	// streams to observe - independently clocked
	input [3:0] clk_str, arst_str,
	input [DAT_WIDTH*4-1:0] data_in,
	input [3:0] data_in_valid,
	
	// system clk / ctrl
	input clk_sys, arst_sys,
	input start_harvest,
	
	// combined output
	output [7:0] dout,
	input dout_ready,
	output dout_valid,
	output reporting	
);

localparam NUM_STREAMS = 4;

wire [NUM_STREAMS*8-1:0] byte_out_str ;
wire [NUM_STREAMS-1:0] byte_out_ready_str, byte_out_valid_str;
wire [NUM_STREAMS*8-1:0] rdata_sys;
wire [NUM_STREAMS-1:0] rdata_ready_sys, rdata_valid_sys;
wire [NUM_STREAMS-1:0] start_harvest_str;

// register the harvest start signal on sys domain	
reg start_harvest_r /* synthesis preserve */;
always @(posedge clk_sys or posedge arst_sys) begin
	if (arst_sys) start_harvest_r <= 0;
	else start_harvest_r <= start_harvest;
end

wire [NUM_STREAMS-1:0] reporting_str,reporting_sys;
reg [NUM_STREAMS-1:0] reporting_str_r;

genvar i;
generate
	for (i=0;i<NUM_STREAMS;i=i+1) 
	begin : fl
		///////////////////////////////////////////
		// move harvest to this stream domain
		///////////////////////////////////////////
		reg [1:0] hsync /* synthesis preserve */;
		always @(posedge clk_str[i] or posedge arst_str[i]) begin
			if (arst_str[i]) hsync <= 0;
			else hsync <= {hsync[0],start_harvest_r};
		end
		assign start_harvest_str[i] = hsync[1];
		
		///////////////////////////////////////////
		// move reporting out of this stream domain
		///////////////////////////////////////////
		always @(posedge clk_str[i] or posedge arst_str[i]) begin
			if (arst_str[i]) reporting_str_r[i] <= 0;
			else reporting_str_r[i] <= reporting_str[i];			
		end
		
		reg [1:0] rsync /* synthesis preserve */;
		always @(posedge clk_sys or posedge arst_sys) begin
			if (arst_sys) rsync <= 0;
			else rsync <= {rsync[0],reporting_str_r[i]};
		end
		assign reporting_sys[i] = rsync[1];
				
		///////////////////////////////////////////
		// capture and byte serializer per stream
		///////////////////////////////////////////
		stream_grabber sg (
			.clk(clk_str[i]),
			.arst(arst_str[i]),
			.data_in(data_in[DAT_WIDTH*(i+1)-1:DAT_WIDTH*i]),
			.data_in_valid(data_in_valid[i]),
			.start_harvest(start_harvest_str[i]),
			.reporting(reporting_str[i]),
	
			.byte_out(byte_out_str[8*(i+1)-1:8*i]),
			.byte_out_valid(byte_out_valid_str[i]),
			.byte_out_ready(byte_out_ready_str[i])
		);
		defparam sg .INITIAL_SR_CONTENT = {"Stream 0" | i,8'h0};
		defparam sg .INITIAL_HOLDING = 8;
		defparam sg .DAT_WIDTH = DAT_WIDTH;
		defparam sg .ADDR_BITS = ADDR_BITS;
		
		///////////////////////////////////////////
		// cross to the system domain per stream
		///////////////////////////////////////////
		
		clock_crossing_fifo ccf
		(
			.wrclk(clk_str[i]),
			.wdata_valid(byte_out_valid_str[i]),
			.wdata(byte_out_str[8*(i+1)-1:8*i]),
			.wdata_ready(byte_out_ready_str[i]),
			
			.rdclk(clk_sys),
			.rdata_ready(rdata_ready_sys[i]),
			.rdata(rdata_sys[8*(i+1)-1:8*i]),
			.rdata_valid(rdata_valid_sys[i])	
		);
		defparam ccf .DAT_WIDTH = 8;
		defparam ccf .WORDS = 8;		
	end	
endgenerate

/////////////////////////
// combine streams 0,1
/////////////////////////
wire [7:0] dout0;
wire dout_ready0,dout_valid0,reporting0;

stream_mux sm0 (	
	.clk(clk_sys), .arst(arst_sys),
	
	.din_a(rdata_sys[8*(0+1)-1:8*0]),
	.din_ready_a(rdata_ready_sys[0]),
	.din_valid_a(rdata_valid_sys[0]),
	.reporting_a(reporting_sys[0]),

	.din_b(rdata_sys[8*(1+1)-1:8*1]),
	.din_ready_b(rdata_ready_sys[1]),
	.din_valid_b(rdata_valid_sys[1]),
	.reporting_b(reporting_sys[1]),

	.start_harvest(start_harvest),
	.reporting(reporting0),
	.dout_ready(dout_ready0),
	.dout_valid(dout_valid0),
	.dout(dout0)
);
defparam sm0 .WIDTH = 8;

/////////////////////////
// combine streams 2,3
/////////////////////////
wire [7:0] dout1;
wire dout_ready1,dout_valid1,reporting1;

stream_mux sm1 (	
	.clk(clk_sys), .arst(arst_sys),
	
	.din_a(rdata_sys[8*(2+1)-1:8*2]),
	.din_ready_a(rdata_ready_sys[2]),
	.din_valid_a(rdata_valid_sys[2]),
	.reporting_a(reporting_sys[2]),

	.din_b(rdata_sys[8*(3+1)-1:8*3]),
	.din_ready_b(rdata_ready_sys[3]),
	.din_valid_b(rdata_valid_sys[3]),
	.reporting_b(reporting_sys[3]),

	.start_harvest(start_harvest),
	.reporting(reporting1),
	.dout_ready(dout_ready1),
	.dout_valid(dout_valid1),
	.dout(dout1)
);
defparam sm1 .WIDTH = 8;

/////////////////////////
// combine pairs 01,23
/////////////////////////

stream_mux sm2 (	
	.clk(clk_sys), .arst(arst_sys),
	
	.din_a(dout0),
	.din_ready_a(dout_ready0),
	.din_valid_a(dout_valid0),
	.reporting_a(reporting0),

	.din_b(dout1),
	.din_ready_b(dout_ready1),
	.din_valid_b(dout_valid1),
	.reporting_b(reporting1),
	
	.start_harvest(start_harvest),
	.reporting(reporting),
	.dout_ready(dout_ready),
	.dout_valid(dout_valid),
	.dout(dout)
);
defparam sm2 .WIDTH = 8;

endmodule