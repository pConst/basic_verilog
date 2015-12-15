// Copyright 2010 Altera Corporation. All rights reserved.  
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

`timescale 1 ps / 1 ps
// baeckler - 12-15-2009

// clk   _|^|_|^|_|^|_|^|_|^|
// rdreq _|^^^|________
// data  <old    ><new 

module mlab_dcfifo #
(
	parameter LABS_WIDE = 4,
	parameter SIM_DELAYS = 1'b0  // insert sim delays to emulate some clock crossing chatter
)
(
	// neither domain
	input arst,
	
	// write domain
	input wrclk,
	input [LABS_WIDE*20-1:0] wrdata,
	input wrreq,
	output reg wrfull,
	output reg [5:0] wrused,
	
	// read domain
	input rdclk,
	output [LABS_WIDE*20-1:0] rddata,
	input rdreq,	
	output reg rdempty,
	output reg [5:0] rdused,
	output parity_err
);

localparam RAM_ADDR_WIDTH = 5;
localparam SYNC_STAGES = 3;

wire rdarst, wrarst;

//////////////////////////////////////////
// reset distribution
//////////////////////////////////////////
reg [1:0] wrfilter = 0 /* synthesis preserve */;
always @(posedge wrclk or posedge arst) begin
	if (arst) wrfilter <= 2'b00;
	else wrfilter <= {wrfilter[0],1'b1};
end
assign wrarst = ~wrfilter[1];

reg [1:0] rdfilter = 0 /* synthesis preserve */;
always @(posedge rdclk or posedge arst) begin
	if (arst) rdfilter <= 2'b00;
	else rdfilter <= {rdfilter[0],1'b1};
end
assign rdarst = ~rdfilter[1];

//////////////////////////////////////////
// read pointers
//////////////////////////////////////////

reg [RAM_ADDR_WIDTH:0] rdgray = 0 /* synthesis preserve */
/* synthesis ALTERA_ATTRIBUTE = "-name SDC_STATEMENT \"set_false_path -from [get_keepers *mlab_dcfifo*rdgray\[*\]]\" " */;

reg [RAM_ADDR_WIDTH:0] rdbin = 0 /* synthesis preserve */;
initial rdempty = 1'b1;
wire [RAM_ADDR_WIDTH:0] rdbin_next = rdbin + (rdreq & ~rdempty);
wire [RAM_ADDR_WIDTH:0] rdgray_next = (rdbin_next >> 1'b1) ^ rdbin_next;
wire [RAM_ADDR_WIDTH:0] sync_wrptr;

always @(posedge rdclk or posedge rdarst) begin
	if (rdarst) begin
		rdbin <= 0;
		rdgray <= 0;
	end
	else begin
		rdbin <= rdbin_next;
		rdgray <= rdgray_next;		
	end
end

always @(posedge rdclk) begin
	rdempty <= (rdgray_next == sync_wrptr);	
end


//////////////////////////////////////////
// write pointers
//////////////////////////////////////////

reg [RAM_ADDR_WIDTH:0] wrgray = 0, wrbin = 0 /* synthesis preserve */;
initial wrfull = 1'b1;

//timing modification 
//wire [RAM_ADDR_WIDTH:0] wrbin_next = wrbin + (wrreq & ~wrfull);
wire [RAM_ADDR_WIDTH:0] wrbin_plus = wrbin + 1'b1 /* synthesis keep */; 
wire [RAM_ADDR_WIDTH:0] wrbin_next = (~wrfull & wrreq) ? wrbin_plus : wrbin;

wire [RAM_ADDR_WIDTH:0] wrgray_next = (wrbin_next >> 1'b1) ^ wrbin_next /* synthesis keep */;
wire [RAM_ADDR_WIDTH:0] sync_rdptr;

always @(posedge wrclk or posedge wrarst) begin
	if (wrarst) begin
		wrbin <= 0;
		wrgray <= 0;
		wrfull <= 1'b1;
	end
	else begin
		wrbin <= wrbin_next;
		wrgray <= wrgray_next;
		wrfull <= (wrgray_next == 
				{sync_rdptr[RAM_ADDR_WIDTH] ^ 1'b1,
				sync_rdptr[RAM_ADDR_WIDTH-1] ^ 1'b1,
				sync_rdptr[RAM_ADDR_WIDTH-2:0]});
	end
end

//////////////////////////////////////////
// domain synchronizers
//////////////////////////////////////////

// stall the write a little more to give it time to settle in the RAM
// before reporting over to the read side
reg [RAM_ADDR_WIDTH:0] wrgray_rr;
reg [RAM_ADDR_WIDTH:0] wrgray_r /* synthesis preserve */
/* synthesis ALTERA_ATTRIBUTE = "-name SDC_STATEMENT \"set_false_path -from [get_keepers *mlab_dcfifo*wrgray_r\[*\]]\" " */;

always @(posedge wrclk or posedge wrarst) begin
	if (wrarst) begin
		wrgray_r <= 0;
		wrgray_rr <= 0;
	end
	else begin
		wrgray_rr <= wrgray;		
		wrgray_r <= wrgray_rr;
	end
end

// stall the pointers randomly for faux domain crossing chatter
wire [RAM_ADDR_WIDTH:0] wrgray_r_late, rdgray_late;
generate if (SIM_DELAYS) begin
	random_delay rd0 (
		.din(rdgray),
		.dout(rdgray_late)
	);
	defparam rd0 .D_INCREMENT = 2;   // stall by 0..7 increments
	defparam rd0 .WIDTH = RAM_ADDR_WIDTH+1;

	random_delay rd1 (
		.din(wrgray_r),
		.dout(wrgray_r_late)
	);
	defparam rd1 .D_INCREMENT = 20;
	defparam rd1 .WIDTH = RAM_ADDR_WIDTH+1;
end
else begin
	assign wrgray_r_late = wrgray_r;
	assign rdgray_late = rdgray;
end
endgenerate

reg [SYNC_STAGES * (RAM_ADDR_WIDTH+1)-1:0] syn0 = 0 /* synthesis preserve */;
always @(posedge wrclk or posedge wrarst) begin
	if (wrarst) syn0 <= 0;
	else syn0 <= {syn0[(SYNC_STAGES-1) * (RAM_ADDR_WIDTH+1)-1:0], rdgray};		
end

reg [SYNC_STAGES * (RAM_ADDR_WIDTH+1)-1:0] syn1 = 0 /* synthesis preserve */;
always @(posedge rdclk or posedge rdarst) begin
	if (rdarst) syn1 <= 0;
	else syn1 <= {syn1[(SYNC_STAGES-1) * (RAM_ADDR_WIDTH+1)-1:0], wrgray_r};		
end

assign sync_rdptr = syn0[SYNC_STAGES * (RAM_ADDR_WIDTH+1)-1 :
						(SYNC_STAGES-1) * (RAM_ADDR_WIDTH+1)];
assign sync_wrptr = syn1[SYNC_STAGES * (RAM_ADDR_WIDTH+1)-1 :
						(SYNC_STAGES-1) * (RAM_ADDR_WIDTH+1)];


//////////////////////////////////////////
// storage array
//////////////////////////////////////////

wire [LABS_WIDE-1:0] pein, peout;
assign {parity_err,pein} = {peout,1'b0};

reg wer = 1'b0;
//always @(posedge wrclk or posedge wrarst) begin
//	if (wrarst) wer <= 1'b0;
//	else wer <= wrreq & !wrfull;
//end

always @(*) begin
	wer = wrreq & !wrfull;
end

genvar i;
generate 
	for (i=0; i<LABS_WIDE; i=i+1) begin : st
		mlab_fifo_cells mc (
			.din_clk(wrclk),
			.din(wrdata[(i+1)*20-1:i*20]),
			.we(wer),
			.wraddr(wrbin[4:0]),
			
			.dout_clk(rdclk),
			.rdaddr(rdbin[4:0]),
			.dout(rddata[(i+1)*20-1:i*20]),
			.parity_err_in(pein[i]),
			.parity_err_out(peout[i])	
		);
	end
endgenerate

//////////////////////////////////////////
// used words
//////////////////////////////////////////

wire [RAM_ADDR_WIDTH:0] sync_rdptr_bin_w;
reg [RAM_ADDR_WIDTH:0] sync_rdptr_bin;
gray_to_bin gb (.gray(sync_rdptr),.bin(sync_rdptr_bin_w));
defparam gb .WIDTH = RAM_ADDR_WIDTH + 1'b1;

always @(posedge wrclk or posedge wrarst) begin
	if (wrarst) begin
		wrused <= 0;
		sync_rdptr_bin <= 0;
	end
	else begin
		sync_rdptr_bin <= sync_rdptr_bin_w;
		wrused <= wrbin - sync_rdptr_bin;
	end		
end

wire [RAM_ADDR_WIDTH:0] sync_wrptr_bin_w;
reg [RAM_ADDR_WIDTH:0] sync_wrptr_bin;
gray_to_bin gb2 (.gray(sync_wrptr),.bin(sync_wrptr_bin_w));
defparam gb2 .WIDTH = RAM_ADDR_WIDTH + 1'b1;

always @(posedge rdclk or posedge rdarst) begin
	if (rdarst) begin
		rdused <= 0;
		sync_wrptr_bin <= 0;
	end
	else begin
		sync_wrptr_bin <= sync_wrptr_bin_w;
		rdused <= sync_wrptr_bin - rdbin;
	end		
end



endmodule