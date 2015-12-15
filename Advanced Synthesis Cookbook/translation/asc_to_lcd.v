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

// baeckler - 04-29-2008
//
// LCD driver, 2 rows of 16 chars.
// e.g. Crystalfontz displays on Altera DE / Nios series boards.
//

module	asc_to_lcd (
	clk,rst,
	lcd_data,	
	lcd_rnw,
	lcd_en,
	lcd_rs,
	disp_text
);

`include "log2.inc"

input clk,rst;
output reg [7:0] lcd_data;
output lcd_rnw;
output reg lcd_en;
output reg lcd_rs;
input [32*8-1:0] disp_text;

parameter CLOCK_MHZ = 50;

// The "busy" flag doesn't seem to work
// reliably.  Definitely a headache meeting
// the tristate timing.   This uses internal
// timer instead of asking the display.
assign lcd_rnw = 1'b0;

////////////////////////////////////////////
// Generate enable pulse at microsecond interval
////////////////////////////////////////////
localparam CLOCK_HZ = CLOCK_MHZ * 1_000_000;
localparam TICKS_PER_US = CLOCK_MHZ;
localparam US_CNTR_BITS = log2(TICKS_PER_US-1);

reg [US_CNTR_BITS-1:0] us_cntr;
reg us_pulse;
always @(posedge clk) begin
	if (rst) begin
		us_pulse <= 1'b0;
		us_cntr <= 0;
	end
	else begin
		if (us_pulse) begin
			us_cntr <= 0;
			us_pulse <= 0;
		end
		else begin
			us_cntr <= us_cntr + 1'b1;
			if (us_cntr == (TICKS_PER_US-2)) us_pulse <= 1'b1;
		end
	end
end

/////////////////////////////////////////////////
// Generate enable pulse at 50ns interval (or a bit more)
/////////////////////////////////////////////////
localparam APPROX_TICKS_PER_50_NS = 50 * CLOCK_MHZ / 1000;
localparam TICKS_PER_50_NS = 
	((APPROX_TICKS_PER_50_NS * 1000 / CLOCK_MHZ) < 50) ? 
		APPROX_TICKS_PER_50_NS + 1 :
		APPROX_TICKS_PER_50_NS;
localparam NS_CNTR_BITS = log2(TICKS_PER_50_NS-1);

reg ns_pulse;
generate 
	if (TICKS_PER_50_NS == 1) begin
		always @(*) ns_pulse = 1'b1;
	end
	else if (TICKS_PER_50_NS == 2) begin
		always @(posedge clk) begin
			if (rst) ns_pulse <= 1'b0;
			else ns_pulse <= ~ns_pulse;
		end
	end
	else begin
		reg [NS_CNTR_BITS-1:0] ns_cntr;
		always @(posedge clk) begin
			if (rst) begin
				ns_pulse <= 1'b0;
				ns_cntr <= 0;
			end
			else begin
				if (ns_pulse) begin
					ns_cntr <= 0;
					ns_pulse <= 0;
				end
				else begin
					ns_cntr <= ns_cntr + 1'b1;
					if (ns_cntr == (TICKS_PER_50_NS-2)) ns_pulse <= 1'b1;
				end
			end
		end
	end
endgenerate

/////////////////////////////////////////////////
// Character select
/////////////////////////////////////////////////
reg [4:0] char_ptr; // 0 = line 1 leftmost, 16 = line 2 leftmost
wire [7:0] char_mux_w;
reg [7:0] char_mux;

genvar i,k;
generate
    for (k=0;k<8;k=k+1)
    begin : out
        wire [31:0] tmp;
        for (i=0;i<32;i=i+1)
        begin : mx
            assign tmp [i] = disp_text[k+(31-i)*8];
        end
        assign char_mux_w[k] = tmp[char_ptr];
    end
endgenerate

// the select happens to be stable for more than one cycle 
// before the data is needed.  Register it.

always @(posedge clk) begin
	if (rst) char_mux <= 0;
	else char_mux <= char_mux_w;
end

/////////////////////////////////////////////////
// Control machine
/////////////////////////////////////////////////
reg [14:0] timer;
reg timer_expire;
reg init_complete;

reg [4:0] state /* synthesis preserve */;
reg [4:0] return_state;

parameter 
	ST_INIT = 5'd0,
	ST_INIT1 = 5'd1,
	ST_INIT2 = 5'd2,
	ST_INIT3 = 5'd3,
	ST_INIT4 = 5'd4,
	ST_INIT5 = 5'd5,
	ST_INIT6 = 5'd6,
	ST_INIT7 = 5'd7,
	ST_INIT8 = 5'd8,
	ST_INIT9 = 5'd9,
	ST_INIT10 = 5'd10,
	ST_INIT11 = 5'd11,
	ST_INIT12 = 5'd12,
	ST_INIT13 = 5'd13,
	ST_INIT14 = 5'd14,
	ST_LINE_ONE = 5'd15,
	ST_LINE_ONE_CHARS = 5'd16,
	ST_LINE_TWO = 5'd17,
	ST_LINE_TWO_CHARS = 5'd18,
	ST_WRITE = 5'd19,
	ST_WRITE1 = 5'd20,
	ST_WRITE2 = 5'd21,
	ST_WRITE3 = 5'd22,
	ST_WRITE4 = 5'd23,
	ST_WRITE5 = 5'd24,
	ST_WRITE6 = 5'd25,
	ST_WRITE7 = 5'd26,
	ST_WRITE8 = 5'd27,
	ST_WRITE9 = 5'd28,
	ST_BUSY_WAIT = 5'd29,
	ST_BUSY_WAIT1 = 5'd30,
	ST_BUSY_WAIT2 = 5'd31;

always @(posedge clk) begin
	if (rst) begin
		timer <= 0;
		timer_expire <= 0;
		state <= ST_INIT;
		lcd_data <= 8'h0;
		lcd_rs <= 1'b0;
		lcd_en <= 1'b0;
		return_state <= 0;
		char_ptr <= 5'b0;
		init_complete <= 1'b0;		
	end
	else begin
		// rough timer for init phase
		timer_expire <= (~|timer);
		if (!timer_expire) timer <= timer - us_pulse;
		
		case (state)
			// wait 15ms then write 
			ST_INIT : begin
					timer <= 14'h3a98; // 15ms
					state <= ST_INIT1;
				end
			ST_INIT1 : begin
					state <= ST_INIT2;	
					lcd_data <= 8'h38;
					lcd_rs <= 1'b0;
				end
			ST_INIT2 : if (timer_expire) state <= ST_INIT3;	
			ST_INIT3 : begin
					// first init write
					return_state <= ST_INIT4;
					state <= ST_WRITE;					
				end
			
			// wait 4.1ms then write 
			ST_INIT4 : begin
					timer <= 14'h1004; // 4.1ms
					state <= ST_INIT5;
				end
			ST_INIT5 : state <= ST_INIT6;	
			ST_INIT6 : if (timer_expire) state <= ST_INIT7;	
			ST_INIT7 : begin
					// second init write
					return_state <= ST_INIT8;
					state <= ST_WRITE;					
				end
					
			// wait 100 us then write	
			ST_INIT8 : begin
					timer <= 14'h0064; // 100us
					state <= ST_INIT9;
				end
			ST_INIT9 : state <= ST_INIT10;	
			ST_INIT10 : if (timer_expire) state <= ST_INIT11;	
			ST_INIT11 : begin
					// second init write
					return_state <= ST_INIT12;
					state <= ST_WRITE;					
				end
			
			// finish up initial settings
			ST_INIT12 : begin
					lcd_data <= 8'hc;	// display on
					return_state <= ST_INIT13;
					state <= ST_WRITE;
				end
			ST_INIT13 : begin
					lcd_data <= 8'h1;	// display clr
					return_state <= ST_INIT14;
					state <= ST_WRITE;
				end
			ST_INIT14 : begin
					lcd_data <= 8'h6;	// cursor inc
					return_state <= ST_LINE_ONE;
					state <= ST_WRITE;
				end
			
			ST_LINE_ONE : begin
					init_complete <= 1'b1;
					lcd_data <= 8'h80; // line 1
					lcd_rs <= 1'b0;
					char_ptr <= 0;
					return_state <= ST_LINE_ONE_CHARS;
					state <= ST_WRITE;
				end

			ST_LINE_ONE_CHARS : begin
					lcd_rs <= 1'b1;
					lcd_data <= char_mux;
					if (char_ptr[3:0] == 4'd15)
						return_state <= ST_LINE_TWO;
					char_ptr <= char_ptr + 1'b1;
					state <= ST_WRITE;
				end
			
			ST_LINE_TWO : begin
					lcd_data <= 8'hc0; // line 2
					lcd_rs <= 1'b0;
					return_state <= ST_LINE_TWO_CHARS;
					state <= ST_WRITE;
				end

			ST_LINE_TWO_CHARS : begin
					lcd_rs <= 1'b1;
					lcd_data <= char_mux;
					if (char_ptr[3:0] == 4'd15)
						return_state <= ST_LINE_ONE;
					char_ptr <= char_ptr + 1'b1;
					state <= ST_WRITE;
				end

			// subroutine : write a character / cmd to LCD
			ST_WRITE : begin
					// align with 50ns pulse
					if (ns_pulse) state <= ST_WRITE1;
				end
			ST_WRITE1 : begin
					// Block 1 : satisfy data setup
					if (ns_pulse) begin
						lcd_en <= 1'b1;
						state <= ST_WRITE2;
					end
				end
			// blocks 2..6 ENA active
			ST_WRITE2 : if (ns_pulse) state <= ST_WRITE3;
			ST_WRITE3 : if (ns_pulse) state <= ST_WRITE4;
			ST_WRITE4 : if (ns_pulse) state <= ST_WRITE5;
			ST_WRITE5 : if (ns_pulse) state <= ST_WRITE6;
			ST_WRITE6 : begin
					if (ns_pulse) begin
						state <= ST_WRITE7;
						lcd_en <= 1'b0;
					end
				end
			
			// block 7 : satisfy data hold					
			ST_WRITE7 : if (ns_pulse) state <= ST_WRITE8;
			
			// blocks 8 and 9 - satisfy ena cycle time
			ST_WRITE8 : if (ns_pulse) state <= ST_WRITE9;
			ST_WRITE9 : begin
					if (ns_pulse) begin
						state <= ST_BUSY_WAIT;
					end					
				end

			ST_BUSY_WAIT : begin
					if (!init_complete) 
						timer <= 14'h05dc; // 1.5ms
					else
						timer <= 14'h002b; // 43us
					state <= ST_BUSY_WAIT1;		
				end
			ST_BUSY_WAIT1 : state <= ST_BUSY_WAIT2;
			ST_BUSY_WAIT2 : if (timer_expire) state <= return_state;
			
		endcase
	end
end
endmodule
