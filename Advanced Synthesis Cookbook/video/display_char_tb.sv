// Copyright 2011 Altera Corporation. All rights reserved.  
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

module display_char_tb ();

parameter RASTER_ADDR_WIDTH = 18;
parameter RASTER_LINE_WIDTH = 640;
parameter RASTER_DATA_WIDTH = 16;
parameter FONT_DATA_WIDTH = 24;
parameter FONT_HEIGHT = 27;
parameter FONT_ADDR_WIDTH = 12;
parameter WRITE_DATA = 16'h1234;

reg clk,arst;

reg [9:0] raster_x = 20;
reg [9:0] raster_y = 20;
reg [7:0] char_select = 8'h1;
wire busy;
reg start_write = 1'b1;

wire [RASTER_ADDR_WIDTH-1:0] raster_addr;
wire [RASTER_DATA_WIDTH-1:0] raster_data;
reg [15:0] wdata = 16'h1234;
wire raster_we;

display_char dut 
(
	.*
);

////////////////////////////////
// faux raster
////////////////////////////////
reg [RASTER_LINE_WIDTH * 100: 0 ] raster;
always @(posedge clk or posedge arst) begin
	if (arst) raster <= 0;
	else begin
		if (raster_we) raster [raster_addr] <= |raster_data;
	end
end

integer fil,x,y;
always @(negedge busy) begin
	$display ("Frame dump...");
	fil =$fopen ("frame.bin");
	for (y=0; y<100; y=y+1) begin
		for (x=0; x<RASTER_LINE_WIDTH; x=x+1) begin
			$fwriteh (fil,raster[y*RASTER_LINE_WIDTH+x]);
		end
		$fwrite (fil,"\n");		
	end
	$fclose (fil);	
end

////////////////////////////////
// clock driver
////////////////////////////////

initial begin
	clk = 0;
	arst = 0;
	#1 arst = 1'b1;
	@(negedge clk);
	arst = 0;
end

always begin 
	#5 clk = ~clk;
end

endmodule

