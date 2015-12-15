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

// baeckler - 12-05-2008
// compare against sample data in Annex74a doc

module annex74_tb ();

`include "reverse_32.inc"

wire [0 : (64+2) * 32-1] sample =
{ 
	2'b10,64'h40ea1e77eed301ec,2'b10,64'had5a3bf86d9acf5c,2'b10,64'hde55cb85df0f7ca0,2'b10,64'he6ccff8e8212b1c6,
	2'b10,64'hd63bc6c309000638,2'b10,64'h70e3b0ce30e0497d,2'b10,64'hdc8df31ec3ab4491,2'b10,64'h66fb9139c81cd37b,
	2'b10,64'hb57477d4f05e3602,2'b10,64'h8cfd495012947a31,2'b10,64'he7777cf0c6d06280,2'b10,64'h44529cf4b4900528,
	2'b10,64'h85ce1d27750ad61b,2'b10,64'h456d5c71743f5c69,2'b10,64'hc1bf62e5dc5464b5,2'b10,64'hdc6011be7ea1ed54,
	2'b10,64'h1cf92c450042a75f,2'b10,64'hcc4b940eaf3140db,2'b10,64'h77bb612a7abf401f,2'b10,64'hc22d341e90545d98,
	2'b10,64'hce6daf1f248bbd6d,2'b10,64'hdd22d0b3f9551ed6,2'b10,64'h574686c3f9e93898,2'b10,64'h2e52628f4a1282ce,
	2'b10,64'hf20c86d71944aab1,2'b10,64'h55133c9333808a2c,2'b10,64'h1aa825d8b817db4d,2'b10,64'h637959989f3021eb,
	2'b10,64'h976806641b26aae9,2'b10,64'h6a37d4531b7ed5f2,2'b10,64'h53c3e96d3b12fb46,2'b10,64'h528c7eb8481bc969 
};

wire [0 : (64+1) * 32-1] sample_xcode =
{ 
	1'b1,64'h40ea1e77eed301ec,1'b0,64'had5a3bf86d9acf5c,1'b0,64'hde55cb85df0f7ca0,1'b1,64'he6ccff8e8212b1c6,
	1'b0,64'hd63bc6c309000638,1'b1,64'h70e3b0ce30e0497d,1'b1,64'hdc8df31ec3ab4491,1'b1,64'h66fb9139c81cd37b,
	1'b0,64'hb57477d4f05e3602,1'b1,64'h8cfd495012947a31,1'b0,64'he7777cf0c6d06280,1'b0,64'h44529cf4b4900528,
	1'b1,64'h85ce1d27750ad61b,1'b0,64'h456d5c71743f5c69,1'b1,64'hc1bf62e5dc5464b5,1'b0,64'hdc6011be7ea1ed54,
	1'b1,64'h1cf92c450042a75f,1'b0,64'hcc4b940eaf3140db,1'b1,64'h77bb612a7abf401f,1'b0,64'hc22d341e90545d98,
	1'b0,64'hce6daf1f248bbd6d,1'b0,64'hdd22d0b3f9551ed6,1'b0,64'h574686c3f9e93898,1'b0,64'h2e52628f4a1282ce,
	1'b0,64'hf20c86d71944aab1,1'b0,64'h55133c9333808a2c,1'b1,64'h1aa825d8b817db4d,1'b0,64'h637959989f3021eb,
	1'b0,64'h976806641b26aae9,1'b0,64'h6a37d4531b7ed5f2,1'b1,64'h53c3e96d3b12fb46,1'b1,64'h528c7eb8481bc969 
};

wire [0 : 64 * 33-1] sample_scram =
{ 
	64'h5f8af0c4083cd5b6, 64'h2b57dbab4e33e17d, 64'hb1354680bbe0bac1, 64'h4193315242cb81b6,
	64'hcc1ba1c9f7b7fe64, 64'h90838ec46d969470, 64'ha913b019c27f5689, 64'h7633f46ec762b6d9,
	64'hd1e410905587d0e4, 64'hf9b66a42540af04a, 64'h9909b64535a725b8, 64'h5005107c48b4a6aa,
	64'hf9d684ce4396f7a9, 64'h1b26e0a025c5d0fd, 64'ha4f2c62bc4611217, 64'h3638dc7504ea755e,
	64'h13fe232e3cdd2a84, 64'h5c5118ed10f6ffd8, 64'h5077fba23970c87d, 64'h52ec1279d355fc57,
	64'h48263899cc6652da, 64'hf746ec8b31bd6b40, 64'h006f5809784c86a7, 64'h989b9bd1aab70f0f,
	64'h57d99a87b9a9cc74, 64'h09ffb2754f318f33, 64'hca8fce7654fb1e57, 64'h03a9c3acc87e6cdd,
	64'hb2574be1e93fcc9a, 64'h26c4fde242df5ca6, 64'hc645fd2bf2d3d525, 64'h5b25e6d7f9d78153,
	64'hbd49683cd87b293a
};

reg clk,arst;

// cut up the transcoded data and expected
// scrambled result into 32 bit words
integer n=0, k=0;
reg [31:0] xcode_word = 0;
reg [31:0] scram_word = 0;
always @(posedge clk or posedge arst) begin
	if (arst) k = 65;
	else begin
		#1
		for (n=0; n<32; n++) begin
			if (k == 65) xcode_word[n] = 0;
			else xcode_word[n] = sample_xcode [k*32+n];					
			scram_word[n] = sample_scram [k*32+n];					
		end	
		k = (k + 1) % 66;
	end
end

// delay the expected result to match the generator latency
reg [31:0] scram_word_d;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		scram_word_d <= 0;		
	end
	else begin
		scram_word_d <= scram_word;		
	end
end

wire parity_sel = (k == 0);
wire [31:0] dout;

fec_gen dut (
	.clk,.arst,
	.din (xcode_word),
	.parity_sel,	
	.dout
);

reg first_check;
reg fail = 0;
always @(posedge clk or posedge arst) begin
	if (arst) begin
		first_check = 1;
	end
	else begin
		#1 if (!first_check && scram_word_d !== dout) begin
			$display ("Mismatch at time %d",$time);
			fail = 1'b1;
		end	
		
		if (parity_sel) begin
			@(negedge clk);
			if (first_check) begin
				@(negedge clk);
				@(negedge clk);
				first_check = 0;
			end
		end	
	end
end

// make it slightly easier to follow the bit order in sim.
wire [31:0] rev_din = reverse_32(xcode_word);
wire [31:0] rev_dout = reverse_32(dout);
wire [31:0] rev_expected = reverse_32(scram_word_d);

/////////////////////////////////
// clock driver

initial begin
	clk = 0;
	arst = 0;
	#1 arst = 1'b1;
	@(negedge clk) arst = 1'b0;
end
 
always #5 clk = ~clk;

endmodule