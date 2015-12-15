// Copyright 2007 Altera Corporation. All rights reserved.  
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

// baeckler - 04-07-2006
// compare 8b10b encoder / decoders

module encoder_tb ();

reg fail ;

reg       clk;
reg       rst_n;
reg       kin_ena;
reg       ein_ena;
reg [7:0] ein_dat;
reg       ein_rd;

wire      eout_val_a,eout_val_b;
wire [9:0] eout_dat_a,eout_dat_b;
wire      eout_rdcomb_a,eout_rdcomb_b;
wire      eout_rdreg_a,eout_rdreg_b;

wire valid,kerr;

///////////////////////////////////
// Encoder units
///////////////////////////////////
encoder_8b10b ea (
    .clk(clk),
    .rst(!rst_n),
    .kin_ena(kin_ena),
    .ein_ena(ein_ena),
    .ein_dat(ein_dat),
    .ein_rd(ein_rd),
    .eout_val(eout_val_a),
    .eout_dat(eout_dat_a),
    .eout_rdcomb(eout_rdcomb_a),
    .eout_rdreg(eout_rdreg_a)
);
defparam ea .METHOD = 0;

encoder_8b10b eb (
    .clk(clk),
    .rst(!rst_n),
    .kin_ena(kin_ena),
    .ein_ena(ein_ena),
    .ein_dat(ein_dat),
    .ein_rd(ein_rd),
    .eout_val(eout_val_b),
    .eout_dat(eout_dat_b),
    .eout_rdcomb(eout_rdcomb_b),
    .eout_rdreg(eout_rdreg_b)
);
defparam eb .METHOD = 1;

/////////////////////////////////////////
//Lag some signals for decoder checking
/////////////////////////////////////////
reg [7:0] late_data;
reg [7:0] late_late_data;
reg late_ein_rd;

always @(posedge clk) begin
	late_late_data <= late_data;
	late_data <= ein_dat;
	late_ein_rd <= ein_rd;
end

///////////////////////////////////
// Decoder units
///////////////////////////////////

wire [7:0] dat_de,dat_df;
wire kerr_de,kerr_df;
wire rderr_de,rderr_df;
wire k_de,k_df;
wire rdreg_de,rdreg_df;

// fake some errors
reg inject_rd_error;
reg [63:0] inject_k_error;

decoder_8b10b de (  
    .clk(clk),
    .rst(!rst_n),
    .din_ena(1'b1),
    .din_dat(eout_dat_a ^ inject_k_error[9:0]),
    .din_rd(late_ein_rd ^ inject_rd_error),
    .dout_val(),
    .dout_dat(dat_de),
    .dout_k(k_de),
    .dout_kerr(kerr_de),
    .dout_rderr(rderr_de),
    .dout_rdcomb(),
    .dout_rdreg(rdreg_de)
);
defparam de .METHOD = 0;

decoder_8b10b df (
	.clk(clk),
    .rst(!rst_n),
    .din_ena(1'b1),
    .din_dat(eout_dat_a ^ inject_k_error[9:0]),
    .din_rd(late_ein_rd ^ inject_rd_error),
    .dout_val(),
    .dout_dat(dat_df),
    .dout_k(k_df),
    .dout_kerr(kerr_df),
    .dout_rderr(rderr_df),
    .dout_rdcomb(),
    .dout_rdreg(rdreg_df)
);
defparam df .METHOD = 1;

initial begin
	clk = 0;
	rst_n = 1;
	kin_ena = 0;
	ein_ena = 0;
	ein_dat = 0;
	ein_rd = 0;
	fail = 0;
	inject_rd_error = 0;
	inject_k_error = 1;

	#10 rst_n = 0;
	#10 rst_n = 1;
	#2000000
	if (!fail) $display ("PASS");
	$stop();
end

always begin
	#100 clk = ~clk;
end

///////////////////////////////////////////
// not all data for transmit is legal.
///////////////////////////////////////////
reg [3:0] tmp;
always @(negedge clk or negedge rst_n) begin
	ein_ena = $random;
	kin_ena = !ein_ena;
	tmp = $random % 4'hd;

	if (kin_ena) begin
		case (tmp)	
			// valid K signals
			4'h0 : ein_dat = 8'b000_11100;
			4'h1 : ein_dat = 8'b000_11100;
			4'h2 : ein_dat = 8'b001_11100;
			4'h3 : ein_dat = 8'b010_11100;
			4'h4 : ein_dat = 8'b011_11100;
			4'h5 : ein_dat = 8'b100_11100;
			4'h6 : ein_dat = 8'b101_11100;
			4'h7 : ein_dat = 8'b110_11100;
			4'h8 : ein_dat = 8'b111_11100;
			4'h9 : ein_dat = 8'b111_10111;
			4'ha : ein_dat = 8'b111_11011;
			4'hb : ein_dat = 8'b111_11101;
			4'hc : ein_dat = 8'b111_11110;
		//	4'hd : ein_dat = 8'b111_11111;
			default : ein_dat = 0;
		endcase
	end
	else
		ein_dat = $random;
end
                
// random inputs
always @(negedge clk) begin

	// TX rd is completely random
	ein_rd = $random;	

	// tell the RX the wrong RD sometimes, data
	// should be OK
	inject_rd_error = $random;

	inject_k_error = (inject_k_error << 1) | inject_k_error[63];
end

always @(posedge clk) begin
	#10

	///////////////////////////////////
	// compare encoders A and B
	///////////////////////////////////
	if (eout_val_a != eout_val_b ||
		eout_dat_a != eout_dat_b ||
		eout_rdcomb_a != eout_rdcomb_b || 
		eout_rdreg_a != eout_rdreg_b
		)
	begin
		$display ("Mismatch between A and B at time %d",$time);
		fail = 1;
	end
		
	///////////////////////////////////
	// compare decoder E to encoded data 
	///////////////////////////////////
	if (dat_de != late_late_data) begin
		// make sure it isn't an error that was injected intentionally
		if (~|inject_k_error[10:0]) begin
			$display ("Decoded data mismatch at time %d",$time);
			fail = 1;
		end
	end	

	///////////////////////////////////
	// compare decoders E and F 
	///////////////////////////////////
	if (dat_de != dat_df ||
		kerr_de != kerr_df ||
		rderr_de != rderr_df ||
		k_de != k_df ||
		rdreg_de != rdreg_df)
	begin
		$display ("Mismatch between E and F at time %d",$time);
		fail = 1;
	end
end

endmodule