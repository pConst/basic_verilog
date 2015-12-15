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

// baeckler - 09-19-2008

module gearbox_67_20_tb ();

reg clk,arst,late_arst;
reg [66:0] din;
reg din_valid;
wire [19:0] dout;
wire [66:0] recovered;
wire recovered_valid;

gearbox_67_20 dut (
	.*
);

gearbox_20_67 dut_b (
	.clk,
	.arst(late_arst),
	.din(dout),
	.slip_to_frame(1'b1),
	.dout(recovered),
	.dout_valid(recovered_valid)	
);

initial begin
	clk = 0;
	#1 arst = 1'b1; late_arst = 1'b1;
	@(negedge clk) arst = 1'b0;
	@(negedge clk) late_arst = 1'b0;
	
end

always begin
	#5 clk = ~clk;
end

reg [20*67-1:0] data_stream = {
	3'b010, 64'h1234167812345670,
	3'b010, 64'h2bcd2f12abcdef12,
	3'b010, 64'h3234367812345679,
	3'b010, 64'h4bcd4f12abcdef13,
	3'b010, 64'h5234567812345670,
	3'b010, 64'h6bcd6f12abcdef11,
	3'b010, 64'h7234767812345674,
	3'b010, 64'h8bcd8f12abcdef13,
	3'b010, 64'h9234967812345670,
	3'b010, 64'habcdaf12abcdef11,
	3'b010, 64'hb234b67812345679,
	3'b010, 64'hcbcdcf12abcdef13,
	3'b010, 64'hd234d67812345670,
	3'b010, 64'hebcdef12abcdef11,
	3'b010, 64'hf234f67812345679,
	3'b010, 64'h0bcd0f12abcdef13,
	3'b010, 64'h1234167812345670,
	3'b010, 64'h2bcd2f12abcdef11,
	3'b010, 64'h3234367812345679,
	3'b010, 64'h4234467812345679	
};

reg [20*67-1:0] data_stream_readback;

reg [66:0] schedule = 67'b1001001000100100100010010010001001001000100100100010010010001001000;

//////////////////////////////
// Loop the sample data in
//////////////////////////////
integer n = 0;
always begin
	#2 if (!arst) begin
		din = 0;
		for (n=0;n<67;n=n+1) begin
			din = data_stream[66:0];
			din_valid = schedule[66-n];
			@(negedge clk);
			if (din_valid) data_stream = 
				{data_stream[66:0],data_stream[20*67-1:67]};
		end
	end
end

//////////////////////////////
// verify recovery
//////////////////////////////
reg fail = 0;
always @(posedge clk or posedge arst) begin
	if (arst) data_stream_readback = data_stream;
	else begin
		#1 if (recovered_valid) begin
			if (recovered !== data_stream_readback[66:0]) begin
				$display ("Mismatch at time %d",$time);
				fail = 1;
			end
			data_stream_readback = 
				{data_stream_readback[66:0],data_stream_readback[20*67-1:67]};
		end
	end
end

initial begin
	#1000000 if (!fail) $display ("PASS");
	$stop();
end

endmodule
