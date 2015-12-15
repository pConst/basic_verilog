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

// 40 in 66 out 
// baeckler - 07-21-2010

module gearbox_40_66 (
	input clk,
	input slip_to_frame,  // look for the least significant 2 bits being opposite
	input [39:0] din,     // lsbit first
	output [65:0] dout,
	output reg dout_valid,
	
	output reg slipping,	// pulses on position change
	output reg word_locked	// lock detect with history
);

initial dout_valid = 1'b0;
	
reg [5:0] gbstate = 0 /* synthesis preserve */;
reg [103:0] stor = 0 /* synthesis preserve */;
assign dout = stor[65:0];
reg [39:0] din_r = 0;
reg din_extra = 0;

// framing acquisition controls
reg odd = 1'b0 /* synthesis preserve */;	// select a 1 bit shift of the input data
reg drop40 = 1'b0 /* synthesis preserve */;	// slip by 1 input word

always @(posedge clk) begin
	din_extra <= din[39];
	din_r <= odd ? {din[38:0],din_extra} : din[39:0];
	
	gbstate <= drop40 ? gbstate : (gbstate[5] ? 6'h0 : (gbstate + 1'b1));
	dout_valid <= 1'b0;
	   
	if (gbstate[5]) begin 
		stor[65:26] <= din_r[39:0]; stor[25:0] <= stor[91:66]; dout_valid <= 1'b1; 
	end    //  now holding 0
	else begin	
		case (gbstate[4:0])
			5'h0 : begin stor[39:0] <= din_r[39:0]; end     //  now holding 40
			5'h1 : begin stor[79:40] <= din_r[39:0]; dout_valid <= 1'b1; end    //  now holding 14
			5'h2 : begin stor[53:14] <= din_r[39:0]; stor[13:0] <= stor[79:66]; end     //  now holding 54
			5'h3 : begin stor[93:54] <= din_r[39:0]; dout_valid <= 1'b1; end    //  now holding 28
			5'h4 : begin stor[67:28] <= din_r[39:0]; stor[27:0] <= stor[93:66]; dout_valid <= 1'b1; end    //  now holding 2
			5'h5 : begin stor[41:2] <= din_r[39:0]; stor[1:0] <= stor[67:66]; end     //  now holding 42
			5'h6 : begin stor[81:42] <= din_r[39:0]; dout_valid <= 1'b1; end    //  now holding 16
			5'h7 : begin stor[55:16] <= din_r[39:0]; stor[15:0] <= stor[81:66]; end     //  now holding 56
			5'h8 : begin stor[95:56] <= din_r[39:0]; dout_valid <= 1'b1; end    //  now holding 30
			5'h9 : begin stor[69:30] <= din_r[39:0]; stor[29:0] <= stor[95:66]; dout_valid <= 1'b1; end    //  now holding 4
			5'ha : begin stor[43:4] <= din_r[39:0]; stor[3:0] <= stor[69:66]; end     //  now holding 44
			5'hb : begin stor[83:44] <= din_r[39:0]; dout_valid <= 1'b1; end    //  now holding 18
			5'hc : begin stor[57:18] <= din_r[39:0]; stor[17:0] <= stor[83:66]; end     //  now holding 58
			5'hd : begin stor[97:58] <= din_r[39:0]; dout_valid <= 1'b1; end    //  now holding 32
			5'he : begin stor[71:32] <= din_r[39:0]; stor[31:0] <= stor[97:66]; dout_valid <= 1'b1; end    //  now holding 6
			5'hf : begin stor[45:6] <= din_r[39:0]; stor[5:0] <= stor[71:66]; end     //  now holding 46
			5'h10 : begin stor[85:46] <= din_r[39:0]; dout_valid <= 1'b1; end    //  now holding 20
			5'h11 : begin stor[59:20] <= din_r[39:0]; stor[19:0] <= stor[85:66]; end     //  now holding 60
			5'h12 : begin stor[99:60] <= din_r[39:0]; dout_valid <= 1'b1; end    //  now holding 34
			5'h13 : begin stor[73:34] <= din_r[39:0]; stor[33:0] <= stor[99:66]; dout_valid <= 1'b1; end    //  now holding 8
			5'h14 : begin stor[47:8] <= din_r[39:0]; stor[7:0] <= stor[73:66]; end     //  now holding 48
			5'h15 : begin stor[87:48] <= din_r[39:0]; dout_valid <= 1'b1; end    //  now holding 22
			5'h16 : begin stor[61:22] <= din_r[39:0]; stor[21:0] <= stor[87:66]; end     //  now holding 62
			5'h17 : begin stor[101:62] <= din_r[39:0]; dout_valid <= 1'b1; end    //  now holding 36
			5'h18 : begin stor[75:36] <= din_r[39:0]; stor[35:0] <= stor[101:66]; dout_valid <= 1'b1; end    //  now holding 10
			5'h19 : begin stor[49:10] <= din_r[39:0]; stor[9:0] <= stor[75:66]; end     //  now holding 50
			5'h1a : begin stor[89:50] <= din_r[39:0]; dout_valid <= 1'b1; end    //  now holding 24
			5'h1b : begin stor[63:24] <= din_r[39:0]; stor[23:0] <= stor[89:66]; end     //  now holding 64
			5'h1c : begin stor[103:64] <= din_r[39:0]; dout_valid <= 1'b1; end    //  now holding 38
			5'h1d : begin stor[77:38] <= din_r[39:0]; stor[37:0] <= stor[103:66]; dout_valid <= 1'b1; end    //  now holding 12
			5'h1e : begin stor[51:12] <= din_r[39:0]; stor[11:0] <= stor[77:66]; end     //  now holding 52
			5'h1f : begin stor[91:52] <= din_r[39:0]; dout_valid <= 1'b1; end    //  now holding 26
		endcase
	end
end

// out pattern [32:0] 110110101101011010110101101011010

/////////////////////////////////////////////
// handle the details of slipping

reg [3:0] grace = 0 /* synthesis preserve */;
wire bad_frame = ~^dout[1:0];

always @(posedge clk) begin
	drop40 <= 1'b0;
	slipping <= 1'b0;
	
	if (slip_to_frame && bad_frame && !grace[3]) begin
		slipping <= 1'b1;
		if (odd) begin
			odd <= 1'b0;
			drop40 <= 1'b1;
		end
		else begin
			odd <= 1'b1;
		end
		grace <= 4'b1111;
	end
	else begin
		grace <= {grace[2:0],1'b0};
	end
end

/////////////////////////////////////////////
// word alignment control

reg [4:0] err_cnt = 1'b0;
reg [5:0] wrd_cnt = 1'b0;
reg wrd_cnt_max = 1'b0;
initial word_locked = 1'b0;

always @(posedge clk) begin
	wrd_cnt_max <= &wrd_cnt;
	
	if (word_locked) begin
		if (dout_valid) begin
			wrd_cnt <= wrd_cnt + 1'b1;
			if (bad_frame) begin
				// count bad frames, saturate at 16
				if (!err_cnt[4]) err_cnt <= err_cnt + 1'b1;
			end					
			if (wrd_cnt_max) begin
				// if there are more than 16 per 64 wrong lose lock
				if (err_cnt[4]) word_locked <= 1'b0;
				else err_cnt <= 0;
			end
		end	
	end	
	else begin
		err_cnt <= 0;
		if (dout_valid) begin
			if (bad_frame) begin
				wrd_cnt <= 0;
			end
			else begin
				// if there are 64 good frames acquire lock
				wrd_cnt <= wrd_cnt + 1'b1;
				if (wrd_cnt_max) word_locked <= 1'b1;
			end
		end	
	end
end

endmodule
