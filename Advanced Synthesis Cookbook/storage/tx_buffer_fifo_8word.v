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

// baeckler - 11-12-2008
// 8 word FIFO
module tx_buffer_fifo_8word #(
	parameter WIDTH = 20*20
)
(
	input clk, arst,
	
	input [WIDTH-1:0] din,
	input din_valid,
	output reg din_ready,
	
	output [WIDTH-1:0] dout,
	input dout_ready,
	
	output reg hungry,		
	output reg underflow	
);

reg [WIDTH-1:0] store_a, store_b, store_c, store_d,
				store_e, store_f, store_g, store_h;

/* synthesis translate off */
initial begin
	store_a = 0;
	store_b = 0;
	store_c = 0;
	store_d = 0;
	store_e = 0;
	store_f = 0;
	store_g = 0;
	store_h = 0;
end
/* synthesis translate on */

wire [WIDTH-1:0] store_aw, store_bw, store_cw, store_dw,
				store_ew, store_fw, store_gw, store_hw /* synthesis keep */;

reg [3:0] wr_ptr, rd_ptr /* synthesis preserve */ 
/* synthesis ALTERA_ATTRIBUTE = "ALLOW_SYNCH_CTRL_USAGE=OFF ; AUTO_CLOCK_ENABLE_RECOGNITION = OFF" */;

//////////////////////////////////////////
// when DIN is valid accept it into appro
// storage slot
//////////////////////////////////////////
wire write_now = din_valid & din_ready;

reg [7:0] wr_ptr_dec /* synthesis keep */;
always @(*) begin
	wr_ptr_dec = 0;
	wr_ptr_dec[wr_ptr[2:0]] = write_now; 
end

assign store_aw = wr_ptr_dec[0] ? din : store_a;
assign store_bw = wr_ptr_dec[1] ? din : store_b;
assign store_cw = wr_ptr_dec[2] ? din : store_c;
assign store_dw = wr_ptr_dec[3] ? din : store_d;
assign store_ew = wr_ptr_dec[4] ? din : store_e;
assign store_fw = wr_ptr_dec[5] ? din : store_f;
assign store_gw = wr_ptr_dec[6] ? din : store_g;
assign store_hw = wr_ptr_dec[7] ? din : store_h;

always @(posedge clk or posedge arst) begin
	if (arst) begin
		wr_ptr <= 4'b0;
		store_a <= 0;
		store_b <= 0;
		store_c <= 0;
		store_d <= 0;
		store_e <= 0;
		store_f <= 0;
		store_g <= 0;
		store_h <= 0;
	end
	else begin
		if (write_now) begin
			
			// make it clear that these are not intended to be a carry chain
			case (wr_ptr)
				4'b0000 : wr_ptr <= 4'b0001;
				4'b0001 : wr_ptr <= 4'b0010;
				4'b0010 : wr_ptr <= 4'b0011;
				4'b0011 : wr_ptr <= 4'b0100;
				4'b0100 : wr_ptr <= 4'b0101;
				4'b0101 : wr_ptr <= 4'b0110;
				4'b0110 : wr_ptr <= 4'b0111;
				4'b0111 : wr_ptr <= 4'b1000;
				4'b1000 : wr_ptr <= 4'b1001;
				4'b1001 : wr_ptr <= 4'b1010;
				4'b1010 : wr_ptr <= 4'b1011;
				4'b1011 : wr_ptr <= 4'b1100;
				4'b1100 : wr_ptr <= 4'b1101;
				4'b1101 : wr_ptr <= 4'b1110;
				4'b1110 : wr_ptr <= 4'b1111;
				4'b1111 : wr_ptr <= 4'b0000;				
			endcase					
		end
	
		store_a <= store_aw;
		store_b <= store_bw;
		store_c <= store_cw;
		store_d <= store_dw;
		store_e <= store_ew;
		store_f <= store_fw;
		store_g <= store_gw;
		store_h <= store_hw;			
	
	end
end
			
//////////////////////////////////////////
// Read ptr and data out...
//////////////////////////////////////////

reg [WIDTH-1:0] rdmux /* synthesis preserve */ 
/* synthesis ALTERA_ATTRIBUTE = "ALLOW_SYNCH_CTRL_USAGE=OFF ; AUTO_CLOCK_ENABLE_RECOGNITION = OFF" */;

reg read_now;
reg last_read_now /* synthesis preserve */;
reg [WIDTH-1:0] last_dout /* synthesis preserve */ ;

always @(posedge clk or posedge arst) begin
	if (arst) begin
		rdmux <= 0;
		last_read_now <= 0;
		last_dout <= 0;
	end
	else begin
		case (rd_ptr[2:0])
			3'b000 : rdmux <= store_a;
			3'b001 : rdmux <= store_b;
			3'b010 : rdmux <= store_c;
			3'b011 : rdmux <= store_d;
			3'b100 : rdmux <= store_e;
			3'b101 : rdmux <= store_f;
			3'b110 : rdmux <= store_g;
			3'b111 : rdmux <= store_h;				
		endcase
		last_read_now <= read_now;
		last_dout <= dout;
	end
end
	
assign dout = last_read_now ? rdmux : last_dout;

always @(posedge clk or posedge arst) begin
	if (arst) begin
		rd_ptr <= 4'b0000;
	end
	else begin
		if (read_now) begin
			
			case (rd_ptr)
				4'b0000 : rd_ptr <= 4'b0001;
				4'b0001 : rd_ptr <= 4'b0010;
				4'b0010 : rd_ptr <= 4'b0011;
				4'b0011 : rd_ptr <= 4'b0100;
				4'b0100 : rd_ptr <= 4'b0101;
				4'b0101 : rd_ptr <= 4'b0110;
				4'b0110 : rd_ptr <= 4'b0111;
				4'b0111 : rd_ptr <= 4'b1000;
				4'b1000 : rd_ptr <= 4'b1001;
				4'b1001 : rd_ptr <= 4'b1010;
				4'b1010 : rd_ptr <= 4'b1011;
				4'b1011 : rd_ptr <= 4'b1100;
				4'b1100 : rd_ptr <= 4'b1101;
				4'b1101 : rd_ptr <= 4'b1110;
				4'b1110 : rd_ptr <= 4'b1111;
				4'b1111 : rd_ptr <= 4'b0000;				
			endcase									
		end
	end
end	
		
//////////////////////////////////////////
// Decide when to read
//////////////////////////////////////////
assign full = (wr_ptr[3] ^ rd_ptr[3]) && (wr_ptr[2:0] == rd_ptr[2:0]);
wire empty = (wr_ptr[3] ~^ rd_ptr[3]) && (wr_ptr[2:0] == rd_ptr[2:0]);

always @(*) begin
	read_now = 1'b0;
	
	// read if caller wants a read and data is available
	if (dout_ready & !empty) read_now = 1'b1;
	
	// read when you are overflowing to stay semi consistent
	if (write_now & full) read_now = 1'b1;
end

//////////////////////////////////////////
// Backpressure / error detect
//////////////////////////////////////////
wire [3:0] words_used = wr_ptr-rd_ptr;
wire almost_full = words_used[3] | (&words_used[2:0]);

always @(posedge clk or posedge arst) begin
	if (arst) begin
		underflow <= 1'b0;		
		hungry <= 1'b1;
		din_ready <= 1'b1;
	end
	else begin
		// oops.  No data to back read request means underflow
		underflow <= 1'b0;
		if (dout_ready & empty) underflow <= 1'b1;
		
		hungry <= ~|words_used[3:2];		
		din_ready <= ~almost_full;
	end
end

endmodule